library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity RegisterFile is
	Port (
		CLK      : in STD_LOGIC;
		RESET    : in STD_LOGIC;
		RegWrite : in STD_LOGIC;
		RegWriteAddr : in STD_LOGIC_VECTOR(4 downto 0);
		RegWriteData : in STD_LOGIC_VECTOR(31 downto 0);
		RegAddr_1  : in STD_LOGIC_VECTOR(4 downto 0);
		RegAddr_2  : in STD_LOGIC_VECTOR(4 downto 0);
		RegData_1  : out STD_LOGIC_VECTOR(31 downto 0);
		RegData_2  : out STD_LOGIC_VECTOR(31 downto 0)
	);
end RegisterFile;

architecture beh of RegisterFile is
	TYPE rf is array (0 to 31) of std_logic_vector (31 downto 0);
	signal rf_array: rf;
begin
-- write data from falling_edge
process(CLK, RESET, RegWrite, RegWriteAddr, RegWriteData)
	variable index_write : integer range 0 to 31;
begin
	if (RESET='1') then
		for i in 0 to 31 loop
			rf_array(i) <= (others => '0');
		end loop;
	elsif falling_edge(CLK) then
		index_write := to_integer(unsigned(RegWriteAddr));	
		if (RegWrite='1') then
			rf_array(index_write) <= RegWriteData;
		end if;
	end if;
end process;

-- read data from rising edge
process(CLK, RESET, RegAddr_1, RegAddr_2)
	variable index_1 : integer range 0 to 31;
	variable index_2 : integer range 0 to 31;
begin
	if (RESET='1') then
		RegData_1 <= (others => 'Z');
		RegData_2 <= (others => 'Z');
	elsif rising_edge(CLK) then
		index_1 := to_integer(unsigned(RegAddr_1));
		index_2 := to_integer(unsigned(RegAddr_2));
		RegData_1 <= rf_array(index_1);
		RegData_2 <= rf_array(index_2);
	end if;
end process;
end beh;
