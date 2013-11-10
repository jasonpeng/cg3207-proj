----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:04:21 10/29/2013 
-- Design Name: 
-- Module Name:    ALU - Behavioral_ALU 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 0.02 - Implemented Execute with naive ALU
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

entity Execute is
    Port (
	        CLK : in STD_LOGIC; -- clock signal for synchronization
			  RESET : in STD_LOGIC;
	 
	        ALUOp : in  STD_LOGIC_VECTOR(2 downto 0);
           SignExtended : in STD_LOGIC_VECTOR(31 downto 0); -- extended signed immediate value; also used for ALU opcode
			  ALUSrc : in STD_LOGIC; -- selects second operand for ALU
           Data1 : in  STD_LOGIC_VECTOR(31 downto 0); -- data1 from register
           Data2 : in  STD_LOGIC_VECTOR(31 downto 0); -- data2 from register
			  
			  -- register writeback
			  RegDst : in STD_LOGIC; --selects writeback address
			  Instr_20_16 : in STD_LOGIC_VECTOR(4 downto 0);
			  Instr_15_11 : in STD_LOGIC_VECTOR(4 downto 0);
			  Instr_10_6  : in STD_LOGIC_VECTOR(4 downto 0);
			  
			  -- states received from the previous stage
			  EX_PC : in STD_LOGIC_VECTOR(31 downto 0);
			  EX_MemWrite : in STD_LOGIC;
			  EX_MemToReg : in STD_LOGIC;
			  EX_MemRead : in STD_LOGIC;
			  EX_Branch : in STD_LOGIC;
			  
			  -- states passed to the next stage
			  -- state registers
			  MEM_MemWrite : out STD_LOGIC;
			  MEM_MemToReg : out STD_LOGIC;
			  MEM_MemRead : out STD_LOGIC;
			  MEM_Branch : out STD_LOGIC;
			  
			  -- alu related
			  MEM_OVF : out STD_LOGIC;
           MEM_Zero : out STD_LOGIC;
           MEM_ALU_Result : out STD_LOGIC_VECTOR(31 downto 0);
			  MEM_ALU_Result_2 : out STD_LOGIC_VECTOR(31 downto 0);
			  MEM_MUL_DIV : out STD_LOGIC;
			  
			  MEM_BEQ_Addr : out STD_LOGIC_VECTOR(31 downto 0); -- computed BEQ address
			  MEM_Data2 : out STD_LOGIC_VECTOR(31 downto 0); -- for MEM Write Data
			  MEM_REG_WriteAddr : out STD_LOGIC_VECTOR(4 downto 0) -- register address
			  );
end Execute;

architecture Behavioral of Execute is

begin
	
process(CLK, Reset, ALUOp, SignExtended, ALUSrc, Data1, Data2, RegDst, Instr_20_16, Instr_15_11,
	EX_PC, EX_MemWrite, EX_MemRead, EX_MemToReg, EX_Branch)
	variable A : STD_LOGIC_VECTOR(31 downto 0); -- op1 for ALU
	variable B : STD_LOGIC_VECTOR(31 downto 0); -- op2 for ALU
	variable C : STD_LOGIC_VECTOR(31 downto 0); -- result
	variable D : STD_LOGIC_VECTOR(63 downto 0); -- for mul and div
	variable Q : STD_LOGIC_VECTOR(31 downto 0);
	variable R : STD_LOGIC_VECTOR(31 downto 0);
	variable regWriteAddr : STD_LOGIC_VECTOR(4 downto 0); -- address for register writeback
	variable shiftLeft2 : STD_LOGIC_VECTOR(31 downto 0); -- SignExtended shifted left by 2
	variable R_funct : STD_LOGIC_VECTOR(5 downto 0); -- ALU R type funct (Instr[5-0])
begin

	case ALUSrc is 
		when '0' => B := Data2;
		when '1' => B := SignExtended;
		when others => B := (others => 'X');
	end case;
	
	-- ALU --
	A := Data1;
	if (ALUOp = "000") then -- R type
		R_funct := SignExtended(5 downto 0);
		case R_funct is
			when "000000" => C := std_logic_vector(shift_left(unsigned(B), to_integer(unsigned(instr_10_6)))); -- sll
			when "000100" => C := std_logic_vector(shift_left(unsigned(B), to_integer(unsigned(A)))); -- sllv
			when "000011" => C := std_logic_vector(shift_right(signed(B), to_integer(unsigned(instr_10_6)))); -- sra
			when "000111" => C := std_logic_vector(shift_right(signed(B), to_integer(unsigned(A)))); -- srav
			when "000010" => C := std_logic_vector(shift_right(unsigned(B), to_integer(unsigned(instr_10_6)))); -- srl
			when "000110" => C := std_logic_vector(shift_right(unsigned(B), to_integer(unsigned(A)))); -- srlv
			-- TODO set DM_OVF
			when "100000" => C := std_logic_vector(signed(A) + signed(B)); -- add, with overflow;
			when "100001" => C := std_logic_vector(unsigned(A) + unsigned(B)); -- addu
			when "100010" => C := std_logic_vector(signed(A) - signed(B)); -- sub
			when "100011" => C := std_logic_vector(unsigned(A) - unsigned(B)); -- subu
			when "011000" => D := std_logic_vector(signed(A) * signed(B)); -- mult
				C := D(31 downto 0);
				MEM_ALU_Result_2 <= D(63 downto 32);
			when "011001" => D := std_logic_vector(unsigned(A) * unsigned(B)); -- multu
				C := D(31 downto 0);
				MEM_ALU_Result_2 <= D(63 downto 32);
			when "011010" => Q := std_logic_vector(signed(A) / signed(B)); -- div
				R := std_logic_vector(signed(A) rem signed(B));
				C := Q;
				MEM_ALU_Result_2 <= R;
			when "011011" => Q := std_logic_vector(unsigned(A) / unsigned(B)); -- divu
				R := std_logic_vector(unsigned(A) rem unsigned(B));
				C := Q;
				MEM_ALU_Result_2 <= R;
			when "101010" => if (A < B) then C := X"00000001"; else C:= X"00000000"; end if; -- slt, set less than
			--when "101011" => ; -- sltu
			when "100100" => C := A AND B; -- and, logical and
			when "100101" => C := A OR B; -- or
			when "100111" => C := A NOR B; -- nor
			when "100110" => C := A XOR B; -- xor			
			when others => C := (others => 'Z');
		end case;
	elsif (ALUOp = "001") then -- LW, SW, ADDI
		C := std_logic_vector(to_unsigned(
			to_integer(unsigned(A)) + to_integer(signed(B)),
			32
		));
	elsif (ALUOp = "010")  then -- SLTI
		if (A < B) then C := X"00000001"; else C:= X"00000000"; end if;
	elsif (ALUOp = "011") then -- LUI
		C := std_logic_vector(unsigned(B) sll 16);
	elsif (ALUOp = "100") then -- BEQ
		C := std_logic_vector(unsigned(A) - unsigned(B));
	elsif (ALUOp = "101") then -- BGEZ
		C := A;
	elsif (ALUOp = "110") then -- BGEZAL
		C := A;
	elsif (ALUOp = "111") then -- ORI
		C := A OR B;
	else
		C := (others => 'Z');
	end if;
	
	if (ALUOp = "000") then
		if (R_funct="011000" OR R_funct="011001" OR R_funct="011010" OR R_funct="011011") then
			MEM_MUL_DIV <= '1';
		else
			MEM_MUL_DIV <= '0';
		end if;
	else
		MEM_MUL_DIV <= '0';
	end if;
	
	-- Set MEM_ALU_Result
	MEM_ALU_Result <= C;
	
	-- Set MEM_Zero
	if ( (C = X"00000000" AND ALUOp = "100") OR (C(31)='0' AND ALUOp = "101") ) then
		MEM_Zero <= '1';
	else
		MEM_Zero <= '0';
	end if;
	
	-- Select Register Write Address
	case RegDst is
		when '0' => regWriteAddr := Instr_20_16;
		when '1' => regWriteAddr := Instr_15_11;
		when others => regWriteAddr := "XXXXX";
	end case;
	-- BGEZAL
	if (C(31) = '0' AND ALUop = "101") then
		MEM_REG_WriteAddr <= std_logic_vector(unsigned(EX_PC) + X"4");
	else
		MEM_REG_WriteAddr <= regWriteAddr;
	end if;
	
	-- Computer BEQ next PC value	
	shiftLeft2 := SignExtended(29 downto 0) & "00";
	MEM_BEQ_Addr <= 
	std_logic_vector(to_unsigned(
		to_integer(unsigned(EX_PC)) + to_integer(signed(shiftLeft2)),
		32
	));
	
	-- Pass on state registers
	MEM_MemWrite <= EX_MemWrite;
	MEM_MemToReg <= EX_MemToReg;
	MEM_MemRead  <= EX_MemRead;
	MEM_Branch   <= EX_Branch;
	MEM_Data2    <= Data2;
end process;

end Behavioral;

