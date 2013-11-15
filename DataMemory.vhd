----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:19:36 10/29/2013 
-- Design Name: 
-- Module Name:    DataMemory - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DataMemory is
    Port ( 
			  CLK : in STD_LOGIC;
			  RESET : in STD_LOGIC;
			  
			  -- state registers
			  IN_EX_MM_MemWrite : in STD_LOGIC;
			  IN_EX_MM_MemRead : in STD_LOGIC;
			  -- alu related
           IN_EX_MM_ALU_Result : in STD_LOGIC_VECTOR(31 downto 0);
			  IN_EX_MM_Data2 : in STD_LOGIC_VECTOR(31 downto 0); -- for Writing Data to RAM
			  
           OUT_MM_WB_Data : out  STD_LOGIC_VECTOR(31 downto 0)
		);
end DataMemory;

architecture Behavioral of DataMemory is
	type ram_type is array(0 to 31) of STD_LOGIC_VECTOR(7 downto 0);
	
	signal ram : ram_type := (
		x"00", x"00", x"00", x"00", 
		x"01", x"00", x"00", x"00", 
		x"02", x"00", x"00", x"00", 
		x"03", x"00", x"00", x"00", 
		x"04", x"00", x"00", x"00",
		x"05", x"00", x"00", x"00",
		x"06", x"00", x"00", x"00",
		x"07", x"00", x"00", x"00" );
begin

process(CLK)
	variable address : integer;
	variable data    : STD_LOGIC_VECTOR(31 downto 0);
	variable rw      : STD_LOGIC_VECTOR(1 downto 0);
begin
	rw := IN_EX_MM_MemRead & IN_EX_MM_MemWrite;
	address := to_integer(unsigned(IN_EX_MM_ALU_Result(4 downto 0)));
	
	case rw is
		when "01" => -- write
			ram(address+3) <= IN_EX_MM_Data2(31 downto 24);
			ram(address+2) <= IN_EX_MM_Data2(23 downto 16);
			ram(address+1) <= IN_EX_MM_Data2(15 downto 8);
			ram(address)   <= IN_EX_MM_Data2(7 downto 0);
			data := (others => 'Z');
		when "10" => -- read
			data := ram(address+3) & ram(address+2) & ram(address+1) & ram(address);
		when others =>
			data := (others => 'Z');
	end case;
	
	OUT_MM_WB_Data <= data;
end process;

end Behavioral;

