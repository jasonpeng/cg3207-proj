
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use CUSTOM_TYPES.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Fetch is
    PORT( 
		Clk         : in std_logic;
		Reset       : in std_logic;
		In_stall_if : in std_logic;
		BEQ_PC      : IN STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
		PCSrc       : IN STD_LOGIC;
      IN_Jump     : in TYPE_Jump;
      
      OUT_PI      : out TYPE_PI;
      PC_out_4    : out std_logic_vector(31 downto 0);
		IF_ID_Flush : out std_logic
 ); 
end Fetch;

architecture Behavioral of Fetch is
	component ram_instr 
		port (      
         ADDR : in std_logic_vector(31 downto 0);
         DATA : out std_logic_vector(31 downto 0)
      );
	end component;
		
   signal PC: std_logic_vector (31 downto 0); -- fetched instruction
   signal nextPC: std_logic_vector(31 downto 0); -- Next PC
   signal read_addr: std_logic_vector(31 downto 0);
   signal IncPC: std_logic_vector (31 downto 0); -- PC + 4
begin
	
instr_mem: ram_instr port map (ADDR => read_addr, DATA => OUT_PI.Instr);

-- multiplex next PC
nextPC <= IN_Jump.PC when (IN_Jump.EN = '1') 
         else BEQ_PC when (PCSrc = '1')
         else incPC;
incPC <= PC + X"00000004";			-- incPC = PC +4 ;
OUT_PI.PC <= incPC;
read_addr <= "00" & PC(31 downto 2);
PC_out_4 <= read_addr;
IF_ID_Flush <= '1' when IN_Jump.EN = '1'
               else '0'; 
      
process (Clk,Reset)
begin
   if (Reset = '1') then 
      PC <= X"00000000"; -- currently start from 0 for test
   elsif rising_edge (Clk) then
      if(In_stall_if = '0') then	
         PC <= nextPC;
      end if;
   end if;
end process;
   
end Behavioral;

--------------------------------------------------------------------------
-- Instruction RAM
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ram_instr is
port (
      ADDR : in std_logic_vector(31 downto 0);
      DATA : out std_logic_vector(31 downto 0));
end ram_instr;

architecture syn of ram_instr is
    type rom_type is array (0 to 36) of std_logic_vector (31 downto 0);  
	 -- currently, set 0-6 for test purpose
    CONSTANT ROM : rom_type := (
	 x"34010000",
x"34010001",x"34020002",x"34030004",x"34040008",
x"00000000",x"00000000",x"00000000",x"00222827",
x"00000000",x"00223020",x"00000000",x"00643824",
x"00000000",x"00834022",x"00000000",x"ac050000",
x"00000000",x"00000000",x"00000000",x"8c080000",
x"00000000",x"00000000",x"00000000",x"0800001d",x"00000000",x"00000000",x"00000000",x"00000000",
x"0022402a",x"116cffe3",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000");

begin
 -- currently just 8 instructions, after conversion, the value of ADDR should not bigger than 7
	 DATA <= ROM(conv_integer(ADDR));
end syn;

