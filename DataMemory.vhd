
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

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

	type ram_type is array(0 to 7) of STD_LOGIC_VECTOR(31 downto 0);
	
	signal ram : ram_type := (	x"0a000000", 
										x"0b000000", 
										x"0c000000", 
										x"0d000000", 
										x"0e000000",
										x"00000000",
										x"00000000",
										x"00000000" );
                              
   signal address: integer;
begin

address <= to_integer(unsigned(IN_EX_MM_ALU_Result(4 downto 0)));

OUT_MM_WB_Data <= ram(address) when IN_EX_MM_MemRead = '1' else (others => 'Z');

ram(address) <= IN_EX_MM_Data2 when IN_EX_MM_MemWrite = '1';

end Behavioral;
