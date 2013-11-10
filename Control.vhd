----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:07:34 10/30/2013 
-- Design Name: 
-- Module Name:    control - Behavioral 
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

entity Control is
	port(
		Instr: in std_logic_vector(31 downto 0);
		RegDst: out std_logic;
		ALUSrc:out std_logic;
		MemtoReg: out std_logic;
		RegWrite:out std_logic;
		MemRead:out std_logic;
		MemWrite:out std_logic;
		Branch: out std_logic;
		Jump: out std_logic;
		ALUOp: out std_logic_vector(2 downto 0));	-- input instruction after fetch
end Control;

architecture Behavioral of Control is
alias InstrOp : std_logic_vector(5 downto 0) is Instr(31 downto 26);
alias Instrbit20: std_logic is Instr(20);
alias Funct: std_logic_vector(5 downto 0) is Instr(5 downto 0);
begin
			RegDst <= '1' when (InstrOp = "000000" )		-- case R format
				  else '0';											-- other cases, like lw, lui, ori
			ALUSrc <= '1' when (InstrOp = "100011" or InstrOp = "101011" 
								or InstrOp = "001101" or InstrOp = "001111"
								or InstrOp = "001000" or InstrOp = "001010")
						-- case for lw and sw,lui,ori, addi, slti
				  else '0';																  -- case R-format and beq
			MemtoReg <= '1' when (InstrOp = "100011")							  -- case lw
					 else '0';																-- case for others
			RegWrite <= '1' when (InstrOp = "000000" or InstrOp = "100011" 	-- case R format or case LW
										or InstrOp = "001101" or InstrOp = "001111"	-- case for ori or case LUI
										or InstrOp = "001010"							 -- case for slti
										or InstrOp = "001000" or (InstrOp="000001" and Instrbit20 = '1')	 -- case for addi or begzal
										or InstrOp = "000011" or (InstrOp = "000000" and Funct = "001001")) -- case for jal or jalr
					 else '0';-- case SW and BEQ
					 
			MemRead  <= '1' when (InstrOp = "100011")								-- case for lw
					 else '0';
			MemWrite <= '1' when (InstrOp = "101011")								-- case for sw
					 else '0';		
			Branch <= '1' when (InstrOp = "000100" or InstrOp ="000001")								-- case for beq,beqz,beqzal
					 else '0';
			Jump <= '1' when (InstrOp = "000010" or InstrOp = "000011" or (InstrOp = "000000" and Funct = "001000") or (InstrOp = "000000" and Funct = "001001"))									-- case for jump
				else '0';																	-- case jump,jr,jarl,jal
			
		
			ALUOp <= "000" when (InstrOp = "000000")							
-- case for R-format(ADD,SUB,DIV, DIVU, MUL and/or MULT, MULU, MFHI, MFLO,AND,NOR,OR,XOR,SLL,SLLV,SRL,SRLV,SRA,SRAV,SLT)																								
				 else "001" when (InstrOp = "001000" or InstrOp = "100011" or InstrOp ="101011")	-- case for Addi,LW,SW
				 else "010" when (InstrOp = "001010")								-- case for slti
				 else "011" when (InstrOp = "001111")								-- case for LUI
				 else "100" when (InstrOp = "000100")								-- case for BEQ
				 else "101" when (InstrOp = "000001" and Instrbit20 = '0')		-- case for BEGZ
				 else "110" when (InstrOp = "000001" and Instrbit20 = '1')		-- case for Begzal
				 else "111";																-- case for ORI
end Behavioral;

