library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity MAC is
Port (
clk: in std_logic;
rom_out: in std_logic_vector(7 downto 0);
mac_init: in std_logic;
ram_out: in std_logic_vector(7 downto 0);
mac_out: out std_logic_vector(18 downto 0)
);
end MAC;

architecture Behavioral of MAC is
signal accum: std_logic_vector(18 downto 0);
begin
    process(clk,mac_init)
        begin
            if rising_edge(clk) then
                if mac_init = '1' then
                    accum <= "000" & ram_out*rom_out;
                else
                    accum <= accum + ("000" & ram_out*rom_out);
                end if;
            end if;
        end process;
    mac_out <= accum;
end Behavioral;
