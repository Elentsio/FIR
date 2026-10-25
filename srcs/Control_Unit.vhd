library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity CU is
Port (
    clk       : in  std_logic;
    rst       : in  std_logic;
    valid_in  : in  std_logic;
    rom_address: out std_logic_vector(2 downto 0);
    mac_init  : out std_logic;
    ram_address: out std_logic_vector(2 downto 0);
    valid_out : out std_logic;
    rom_en    : out std_logic;
    ram_en    : out std_logic;
    ram_wen   : out std_logic
);
end CU;

architecture Behavioral of CU is
    type state_type is (IDLE, START_READ, CALC, CALC_LAST, DONE, WAIT_LOW);
    signal state   : state_type := IDLE;
    signal counter : std_logic_vector(2 downto 0) := "000";
begin
    ram_en      <= '1';
    rom_en      <= '1';
    ram_address <= counter;
    rom_address <= counter;

    process(clk, rst)
    begin
        if rst = '1' then
            state     <= IDLE;
            counter   <= "000";
            ram_wen   <= '0';
            mac_init  <= '0';
            valid_out <= '0';
        elsif rising_edge(clk) then
            valid_out <= '0';
            ram_wen   <= '0';
            mac_init  <= '0';

            case state is
                when IDLE =>
                    counter <= "000";
                    if valid_in = '1' then
                        ram_wen <= '1';        
                        state   <= START_READ;
                    end if;

                when START_READ =>
                    counter <= "001";          
                    state   <= CALC;           

                when CALC =>
                    if counter = "001" then
                        mac_init <= '1';       
                    end if;
                    if counter = "111" then
                        counter <= "000";
                        state   <= CALC_LAST;
                    else
                        counter <= counter + 1;
                    end if;

                when CALC_LAST =>
                    state <= DONE;

                when DONE =>
                    valid_out <= '1';     
                    state     <= WAIT_LOW;

                when WAIT_LOW =>
                    if valid_in = '0' then
                        state <= IDLE;
                    end if;
            end case;
        end if;
    end process;
end Behavioral;
