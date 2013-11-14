library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control is
	port(
		Instr: in std_logic_vector(31 downto 0);
		RegDst: out std_logic;
		ALUSrc:out std_logic;
		MemtoReg: out std_logic;
		RegWrite:out std_logic;
		MemRead:out std_logic;
		MemWrite:out std_logic;
		ALUOp: out std_logic_vector(2 downto 0));	-- input instruction after fetch
end Control;

architecture Behavioral of Control is
alias InstrOp : std_logic_vector(5 downto 0) is Instr(31 downto 26);
alias Instrbit20: std_logic is Instr(20);
alias Funct: std_logic_vector(5 downto 0) is Instr(5 downto 0);
begin
			RegDst <= '1' when (InstrOp = "000000" ) AND (Instr /= X"00000000")		-- case R format
				  else '0';											-- other cases, like lw, lui, ori
			ALUSrc <= '1' when (InstrOp = "100011" or InstrOp = "101011" 
								or InstrOp = "001101" or InstrOp = "001111"
								or InstrOp = "001000" or InstrOp = "001010")
						-- case for lw and sw,lui,ori, addi, slti
				  else '0';																  -- case R-format and beq
			MemtoReg <= '1' when (InstrOp = "100011")							  -- case lw
					 else '0';																-- case for others
			RegWrite <= '1' when ((InstrOp = "000000" or InstrOp = "100011" 	-- case R format or case LW
										or InstrOp = "001101" or InstrOp = "001111"	-- case for ori or case LUI
										or InstrOp = "001010"							 -- case for slti
										or InstrOp = "001000"						 -- case for addi
										) AND (Instr /= X"00000000"))
							else '0';-- case SW and BEQ
					 
			MemRead  <= '1' when (InstrOp = "100011")								-- case for lw
					 else '0';
			MemWrite <= '1' when (InstrOp = "101011")								-- case for sw
					 else '0';		
																				-- case jump,jr,jarl,jal
			
		
			ALUOp <= "100" when (InstrOp = "000000" and funct/= "000000")							
-- case for R-format(ADD,SUB,DIV, DIVU, MUL and/or MULT, MULU, MFHI, MFLO,AND,NOR,OR,XOR,SLL,SLLV,SRL,SRLV,SRA,SRAV,SLT)																								
				 else "001" when (InstrOp = "001000" or InstrOp = "100011" or InstrOp ="101011")	-- case for Addi,LW,SW
				 else "010" when (InstrOp = "001010")								-- case for slti
				 else "011" when (InstrOp = "001111")								-- case for LUI
				 else "111" when (InstrOp = "001101")								-- case for ORI
				 else "000" ;																-- case for nop
end Behavioral;

