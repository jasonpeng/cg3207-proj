----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:19:27 10/31/2013 
-- Design Name: 
-- Module Name:    ID_EX_BUFF - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID_EX_BUFF is
    Port (
	        CLK : in STD_LOGIC; -- clock signal for synchronization
			  RESET : in STD_LOGIC;
	 
			  -- IN --
	        IN_EX_ALUOp : in  STD_LOGIC_VECTOR(2 downto 0);
           IN_EX_SignExtended : in STD_LOGIC_VECTOR(31 downto 0); -- extended signed immediate value; also used for ALU opcode
			  IN_EX_ALUSrc : in STD_LOGIC; -- selects second operand for ALU
           IN_EX_Data1 : in  STD_LOGIC_VECTOR(31 downto 0); -- data1 from register
           IN_EX_Data2 : in  STD_LOGIC_VECTOR(31 downto 0); -- data2 from register
			  
			  -- register writeback
			  IN_EX_RegDst : in STD_LOGIC; --selects writeback address
			  IN_EX_Instr_20_16 : in STD_LOGIC_VECTOR(4 downto 0);
			  IN_EX_Instr_15_11 : in STD_LOGIC_VECTOR(4 downto 0);
			  
			  -- states received from the previous stage
			  IN_EX_PC : in STD_LOGIC_VECTOR(31 downto 0);
			  IN_EX_MemWrite : in STD_LOGIC;
			  IN_EX_MemToReg : in STD_LOGIC;
			  IN_EX_MemRead : in STD_LOGIC;
			  IN_EX_Branch : in STD_LOGIC;
			  
			  -- OUT --
	        OUT_EX_ALUOp : out  STD_LOGIC_VECTOR(2 downto 0);
           OUT_EX_SignExtended : out STD_LOGIC_VECTOR(31 downto 0); -- extended signed immediate value; also used for ALU opcode
			  OUT_EX_ALUSrc : out STD_LOGIC; -- selects second operand for ALU
           OUT_EX_Data1 : out  STD_LOGIC_VECTOR(31 downto 0); -- data1 from register
           OUT_EX_Data2 : out  STD_LOGIC_VECTOR(31 downto 0); -- data2 from register
			  
			  -- register writeback
			  OUT_EX_RegDst : out STD_LOGIC; --selects writeback address
			  OUT_EX_Instr_20_16 : out STD_LOGIC_VECTOR(4 downto 0);
			  OUT_EX_Instr_15_11 : out STD_LOGIC_VECTOR(4 downto 0);
			  
			  -- states received from the previous stage
			  OUT_EX_PC : out STD_LOGIC_VECTOR(31 downto 0);
			  OUT_EX_MemWrite : out STD_LOGIC;
			  OUT_EX_MemToReg : out STD_LOGIC;
			  OUT_EX_MemRead : out STD_LOGIC;
			  OUT_EX_Branch : out STD_LOGIC
			  );
end ID_EX_BUFF;

architecture Behavioral of ID_EX_BUFF is
begin

process(CLK, RESET,
	IN_EX_ALUOp, IN_EX_SignExtended, IN_EX_ALUSrc, IN_EX_Data1, IN_EX_Data2,
	IN_EX_RegDst, IN_EX_Instr_20_16, IN_EX_Instr_15_11,
	IN_EX_PC, IN_EX_MemWrite, IN_EX_MemToReg, IN_EX_MemRead, IN_EX_Branch)
begin
	if (RESET = '1') then
	  OUT_EX_ALUOp 			<=		"000";
	  OUT_EX_SignExtended 	<=		(others => '0');
	  OUT_EX_ALUSrc 			<=		'0';
	  OUT_EX_Data1 			<=		(others => '0');
	  OUT_EX_Data2 			<=		(others => '0');
	  
	  OUT_EX_RegDst 			<=		'0';
	  OUT_EX_Instr_20_16		<=		(others => '0');
	  OUT_EX_Instr_15_11 	<=		(others => '0');
	  
	  OUT_EX_PC 				<=		(others => '0');
	  OUT_EX_MemWrite 		<=		'0';
	  OUT_EX_MemToReg			<=		'0';
	  OUT_EX_MemRead			<=		'0';
	  OUT_EX_Branch			<=		'0';
	elsif rising_edge(CLK) then
	  OUT_EX_ALUOp 			<=		IN_EX_ALUop;
	  OUT_EX_SignExtended 	<=		IN_EX_SignExtended;
	  OUT_EX_ALUSrc 			<=		IN_EX_ALUSrc;
	  OUT_EX_Data1 			<=		IN_EX_Data1;
	  OUT_EX_Data2 			<=		IN_EX_Data2;
	  
	  OUT_EX_RegDst 			<=		IN_EX_RegDst;
	  OUT_EX_Instr_20_16		<=		IN_EX_Instr_20_16;
	  OUT_EX_Instr_15_11 	<=		IN_EX_Instr_15_11;
	  
	  OUT_EX_PC 				<=		IN_EX_PC;
	  OUT_EX_MemWrite 		<=		IN_EX_MemWrite;
	  OUT_EX_MemToReg			<=		IN_EX_MemToReg;
	  OUT_EX_MemRead			<=		IN_EX_MemRead;
	  OUT_EX_Branch			<=		IN_EX_Branch;
	end if;
end process;

end Behavioral;

