library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity tb_MAC is
-- Ένα testbench δεν έχει ποτέ ports, γιατί είναι το ανώτερο επίπεδο (top-level) της προσομοίωσης!
end tb_MAC;

architecture Behavioral of tb_MAC is

    -- 1. Δήλωση του Component που θέλουμε να ελέγξουμε (UUT - Unit Under Test)
    component MAC is
        Port (
            clk      : in std_logic;
            rom_out  : in std_logic_vector(7 downto 0);
            mac_init : in std_logic;
            ram_out  : in std_logic_vector(7 downto 0);
            mac_out  : out std_logic_vector(18 downto 0) -- Υποθέτουμε τα 19 bits
        );
    end component;

    -- 2. Δήλωση σημάτων για τη σύνδεση με το Component
    signal tb_clk      : std_logic := '0';
    signal tb_rom_out  : std_logic_vector(7 downto 0) := (others => '0');
    signal tb_mac_init : std_logic := '0';
    signal tb_ram_out  : std_logic_vector(7 downto 0) := (others => '0');
    signal tb_mac_out  : std_logic_vector(18 downto 0);

    -- 3. Σταθερά για την περίοδο του ρολογιού
    constant CLK_PERIOD : time := 10 ns;

begin

    -- 4. Instantiation (Δημιουργία αντιγράφου) του MAC
    UUT: MAC port map (
        clk      => tb_clk,
        rom_out  => tb_rom_out,
        mac_init => tb_mac_init,
        ram_out  => tb_ram_out,
        mac_out  => tb_mac_out
    );

    -- 5. Δημιουργία του Ρολογιού (Clock Process)
    clk_process : process
    begin
        tb_clk <= '0';
        wait for CLK_PERIOD / 2;
        tb_clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- 6. Δημιουργία των Σεναρίων Ελέγχου (Stimulus Process)
    stimulus_process : process
    begin
        -- Αρχική αναμονή για να σταθεροποιηθεί το σύστημα
        wait for 20 ns;

        -- == ΚΥΚΛΟΣ 0: Αρχικοποίηση MAC και 1ος Πολλαπλασιασμός ==
        -- Υπολογισμός: 2 * 3 = 6
        tb_mac_init <= '1';
        tb_ram_out  <= x"02"; -- 2 στο δεκαδικό
        tb_rom_out  <= x"03"; -- 3 στο δεκαδικό
        wait for CLK_PERIOD;

        -- == ΚΥΚΛΟΣ 1: Συσσώρευση ==
        -- Υπολογισμός: 6 (προηγούμενο) + (4 * 5) = 26
        tb_mac_init <= '0';   -- Κατεβάζουμε το init για να κάνει συσσώρευση
        tb_ram_out  <= x"04"; -- 4 στο δεκαδικό
        tb_rom_out  <= x"05"; -- 5 στο δεκαδικό
        wait for CLK_PERIOD;

        -- == ΚΥΚΛΟΣ 2: Συσσώρευση ==
        -- Υπολογισμός: 26 + (10 * 2) = 46
        tb_ram_out  <= x"0A"; -- 10 στο δεκαδικό (A στο δεκαεξαδικό)
        tb_rom_out  <= x"02"; -- 2 στο δεκαδικό
        wait for CLK_PERIOD;

        -- == ΚΥΚΛΟΣ 3: Νέα Αρχικοποίηση (Τεστ ότι μηδενίζει σωστά) ==
        -- Υπολογισμός: Πρέπει να αγνοήσει το 46 και να βάλει απευθείας 7 * 2 = 14
        tb_mac_init <= '1';
        tb_ram_out  <= x"07"; -- 7
        tb_rom_out  <= x"02"; -- 2
        wait for CLK_PERIOD;

        -- Τέλος προσομοίωσης (αφήνουμε το σύστημα να τρέξει λίγο ακόμα)
        tb_mac_init <= '0';
        tb_ram_out  <= x"00";
        tb_rom_out  <= x"00";
        wait for 50 ns;
        
        -- Σταματάμε την προσομοίωση (δουλεύει σε VHDL-2008, εναλλακτικά αφήνεις το process να τελειώσει)
        wait; 
    end process;

end Behavioral;