library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity tb_FIR is

end tb_FIR;

architecture Behavioral of tb_FIR is

    component FIR is
        Port (
            clk       : in std_logic;
            rst       : in std_logic;
            valid_in  : in std_logic;
            x         : in std_logic_vector(7 downto 0);
            y         : out std_logic_vector(18 downto 0);
            valid_out : out std_logic;
            valid_y   : out std_logic_vector(18 downto 0)
        );
    end component;

    signal tb_clk       : std_logic := '0';
    signal tb_rst       : std_logic := '0';
    signal tb_valid_in  : std_logic := '0';
    signal tb_x         : std_logic_vector(7 downto 0) := (others => '0');
    signal tb_y         : std_logic_vector(18 downto 0);
    signal tb_valid_out : std_logic;
    signal tb_valid_y   : std_logic_vector(18 downto 0);
    constant CLK_PERIOD : time := 10 ns;

    type test_array is array (0 to 19) of std_logic_vector(7 downto 0);
    constant test_data : test_array := (
        x"D0", x"E7", x"20", x"E9", x"A1", x"18", x"47", x"8C", x"F5", x"F7", x"28", x"F8", x"F5", x"7C",x"CC",x"24",x"6B",x"EA",x"CA",x"F5"
    );

begin

    UUT: FIR port map (
        clk       => tb_clk,
        rst       => tb_rst,
        valid_in  => tb_valid_in,
        x         => tb_x,
        y         => tb_y,
        valid_out => tb_valid_out,
        valid_y   => tb_valid_y
    );

    clk_process : process
    begin
        tb_clk <= '0';
        wait for CLK_PERIOD / 2;
        tb_clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    stim_process : process
    begin
        tb_rst <= '1';
        wait for 20 ns;
        tb_rst <= '0';
        wait for CLK_PERIOD;

        for i in 0 to 19 loop
            
            tb_valid_in <= '1';
            tb_x <= test_data(i);
            wait for CLK_PERIOD; 
            
            tb_valid_in <= '0';
            wait for 7 * CLK_PERIOD; 
            
        end loop;
        wait for 50 ns;
        wait;
    end process;
end Behavioral;
