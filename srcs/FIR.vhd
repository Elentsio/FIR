----------------------------------------------------------------------------------
-- Company: NTUA
-- Engineer: Elena & David 
-- Create Date: 03/23/2026 08:24:12 PM 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity FIR is
Port (
clk: in std_logic;
rst: in std_logic;
valid_in: in std_logic;
x: in std_logic_vector(7 downto 0);
y: out std_logic_vector(18 downto 0);
valid_out: out std_logic;
valid_y: out std_logic_vector(18 downto 0)
);
end FIR;

architecture Structural of FIR is
--Multiplier Accumulator Unit
component MAC
port(
clk: in std_logic;
rom_out: in std_logic_vector(7 downto 0);
mac_init: in std_logic;
ram_out: in std_logic_vector(7 downto 0);
mac_out: out std_logic_vector(18 downto 0)
);
end component;
--RAM
component mlab_ram
	 generic (
		data_width : integer :=8  				--- width of data (bits)
	 );
    port (clk  : in std_logic;
          we   : in std_logic;						--- memory write enable
	      en   : in std_logic;				--- operation enable
          addr : in std_logic_vector(2 downto 0);			-- memory address
          di   : in std_logic_vector(data_width-1 downto 0);		-- input data
          do   : out std_logic_vector(data_width-1 downto 0));		-- output data
end component;
--ROM
component mlab_rom
generic (
		coeff_width : integer :=8  				--- width of coefficients (bits)
	 );
    Port ( clk : in  STD_LOGIC;
		   en : in  STD_LOGIC;				--- operation enable
           addr : in  STD_LOGIC_VECTOR (2 downto 0);			-- memory address
           rom_out : out  STD_LOGIC_VECTOR (coeff_width-1 downto 0));	-- output data
end component;
--Control Unit
component CU
Port (
clk: in std_logic; --clock
rst: in std_logic; --reset signal
valid_in: in std_logic; --signal of valid input
rom_address: out std_logic_vector(2 downto 0); --address for rom
mac_init: out std_logic; --mac initialization signal
ram_address: out std_logic_vector(2 downto 0); --address for ram
valid_out: out std_logic; --signal of valid output
rom_en: out std_logic; --enable rom
ram_en: out std_logic; --enable ram
ram_wen: out std_logic --enable write to ram
);
end component;
signal sig_rom_address : std_logic_vector(2 downto 0);
signal sig_ram_address : std_logic_vector(2 downto 0);
signal sig_mac_init    : std_logic;
signal sig_rom_en      : std_logic;
signal sig_ram_en      : std_logic;
signal sig_ram_we      : std_logic;
signal sig_rom_data    : std_logic_vector(7 downto 0);
signal sig_ram_data    : std_logic_vector(7 downto 0);
signal val_out         : std_logic;
signal sig_y           : std_logic_vector(18 downto 0);
begin
U_MAC: MAC port map (
        clk      => clk,
        rom_out  => sig_rom_data,       
        mac_init => sig_mac_init,      
        ram_out  => sig_ram_data,       
        mac_out  => sig_y                   
    );
U_RAM: mlab_ram 
    generic map (data_width => 8)
    port map (
        clk  => clk,
        we   => sig_ram_we,             
        en   => sig_ram_en,
        addr => sig_ram_address,        
        di   => x,              
        do   => sig_ram_data   
    );
U_ROM: mlab_rom 
    generic map (coeff_width => 8)
    port map (
        clk     => clk,
        en      => sig_rom_en,
        addr    => sig_rom_address,   
        rom_out => sig_rom_data        
    );
U_CU: CU port map ( 
        clk         => clk,
        rst         => rst,
        valid_in    => valid_in,
        rom_address => sig_rom_address, 
        mac_init    => sig_mac_init,    
        ram_address => sig_ram_address, 
        valid_out   => val_out,       
        rom_en      => sig_rom_en,
        ram_en      => sig_ram_en,
        ram_wen     => sig_ram_we
    );
valid_out <= val_out;
y <= sig_y;
process(clk, rst)
begin
    if rst = '1' then
        valid_y <= (others => '0');
    elsif rising_edge(clk) then
        if val_out = '1' then
            valid_y <= sig_y;
        end if;
    end if;
end process;
end Structural;
