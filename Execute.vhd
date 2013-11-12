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

-----------------------------
-------- FORWARDING UNIT ----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Forwarding_Unit is
	Port(
		ID_EX_RS : in STD_LOGIC_VECTOR(4 downto 0);
		ID_EX_RT : in STD_LOGIC_VECTOR(4 downto 0);
		EX_MM_RegWrite : in STD_LOGIC;
		EX_MM_RD : in STD_LOGIC_VECTOR(4 downto 0);
		MM_WB_RegWrite : in STD_LOGIC;
		MM_WB_RD : in STD_LOGIC_VECTOR(4 downto 0);

		FW_A : out STD_LOGIC_VECTOR(1 downto 0);
		FW_B : out STD_LOGIC_VECTOR(1 downto 0)
	);
end Forwarding_Unit;

architecture Behavioral of Forwarding_Unit is
begin
process(ID_EX_RS, ID_EX_RT,
	EX_MM_RegWrite, EX_MM_RD,
	MM_WB_RegWrite, MM_WB_RD )
begin
	if ( EX_MM_RegWrite = '1' 
		AND (EX_MM_RD /= "00000")
		AND (EX_MM_RD = ID_EX_RS)
		) then
		FW_A <= "10";
	elsif ( MM_WB_RegWrite = '1'	
		AND (MM_WB_RD /= "00000")
		AND (NOT (EX_MM_RegWrite = '1' AND (EX_MM_RD /= "00000")))
			AND (EX_MM_RD /= ID_EX_RS)
		AND (MM_WB_RD = ID_EX_RS)
		) then
		FW_A <= "01";
	else
		FW_A <= "00";
	end if;
	
	if ( EX_MM_RegWrite = '1' 
		AND (EX_MM_RD /= "00000")
		AND (EX_MM_RD = ID_EX_RT)
		) then
		FW_B <= "10";
	elsif ( MM_WB_RegWrite = '1'	
		AND (MM_WB_RD /= "00000")
		AND (NOT (EX_MM_RegWrite = '1' AND (EX_MM_RD /= "00000")))
			AND (EX_MM_RD /= ID_EX_RT)
		AND (MM_WB_RD = ID_EX_RT)
		) then
		FW_B <= "01";
	else
		FW_B <= "00";
	end if;
	
end process;
end Behavioral;

-----------------------------
-------- EXECUTE ------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity Execute is
    Port (
		IN_ID_EX_ALUOp : in  STD_LOGIC_VECTOR(2 downto 0);
		IN_ID_EX_SignExtended : in STD_LOGIC_VECTOR(31 downto 0); 
			-- extended signed immediate value; also used for ALU opcode
		IN_ID_EX_ALUSrc : in STD_LOGIC; -- selects second operand for ALU
		IN_ID_EX_Data1 : in  STD_LOGIC_VECTOR(31 downto 0); -- data1 from register
		IN_ID_EX_Data2 : in  STD_LOGIC_VECTOR(31 downto 0); -- data2 from register

		IN_ID_EX_RegDst : in STD_LOGIC; --selects writeback address
		IN_ID_EX_Instr_25_21 : in STD_LOGIC_VECTOR(4 downto 0);
		IN_ID_EX_Instr_20_16 : in STD_LOGIC_VECTOR(4 downto 0);
		IN_ID_EX_Instr_15_11 : in STD_LOGIC_VECTOR(4 downto 0);
		IN_ID_EX_Instr_10_6  : in STD_LOGIC_VECTOR(4 downto 0);

		-- forward unit 
		IN_EX_MM_RegWrite : in STD_LOGIC;
		IN_EX_MM_RD : in STD_LOGIC_VECTOR(4 downto 0);
		IN_EX_MM_ALU_Result : in STD_LOGIC_VECTOR(31 downto 0);
		IN_MM_WB_RegWrite : in STD_LOGIC;
		IN_MM_WB_RD : in STD_LOGIC_VECTOR(4 downto 0);
		IN_WB_Reg_Data : in STD_LOGIC_VECTOR(31 downto 0);

		-- alu related
		OUT_EX_MM_OVF : out STD_LOGIC;
		OUT_EX_MM_Zero : out STD_LOGIC;
		OUT_EX_MM_ALU_Result : out STD_LOGIC_VECTOR(31 downto 0);
		OUT_EX_MM_ALU_Result_2 : out STD_LOGIC_VECTOR(31 downto 0);
		OUT_EX_MM_MULDIV : out STD_LOGIC;  -- asserts for mul/div results

		OUT_EX_MM_RegWriteAddr : out STD_LOGIC_VECTOR(4 downto 0) -- register address
		);
end Execute;

architecture Behavioral of Execute is

-- Forwarding Unit Component --
component Forwarding_Unit
	Port(
		ID_EX_RS : in STD_LOGIC_VECTOR(4 downto 0);
		ID_EX_RT : in STD_LOGIC_VECTOR(4 downto 0);
		EX_MM_RegWrite : in STD_LOGIC;
		EX_MM_RD : in STD_LOGIC_VECTOR(4 downto 0);
		MM_WB_RegWrite : in STD_LOGIC;
		MM_WB_RD : in STD_LOGIC_VECTOR(4 downto 0);

		FW_A : out STD_LOGIC_VECTOR(1 downto 0);
		FW_B : out STD_LOGIC_VECTOR(1 downto 0)
	);
end component;
--

-- Fowarding Unit Signals --
signal FWU_A : STD_LOGIC_VECTOR(1 downto 0);
signal FWU_B : STD_LOGIC_VECTOR(1 downto 0);
--

begin

-- Forwarding Unit Port Map --
FWU : Forwarding_Unit Port Map (
	ID_EX_RS => IN_ID_EX_Instr_25_21,
	ID_EX_RT => IN_ID_EX_Instr_20_16,
	EX_MM_RegWrite => IN_EX_MM_RegWrite,
	EX_MM_RD => IN_EX_MM_RD,
	MM_WB_RegWrite => IN_MM_WB_RegWrite,
	MM_WB_RD => IN_MM_WB_RD,
	FW_A => FWU_A,
	FW_B => FWU_B
);
--
	
process(IN_ID_EX_ALUOp,
		IN_ID_EX_SignExtended,
		IN_ID_EX_ALUSrc,
		IN_ID_EX_Data1,
		IN_ID_EX_Data2,

		IN_ID_EX_RegDst,
		IN_ID_EX_Instr_25_21,
		IN_ID_EX_Instr_20_16,
		IN_ID_EX_Instr_15_11,
		IN_ID_EX_Instr_10_6,

		IN_EX_MM_RegWrite,
		IN_EX_MM_RD,
		IN_EX_MM_ALU_Result,
		IN_MM_WB_RegWrite,
		IN_MM_WB_RD,
		IN_WB_Reg_Data
		)
	
	variable A : STD_LOGIC_VECTOR(31 downto 0); -- op1 for ALU
	variable B : STD_LOGIC_VECTOR(31 downto 0); -- op2 for ALU
	variable C : STD_LOGIC_VECTOR(31 downto 0); -- result
	variable D : STD_LOGIC_VECTOR(63 downto 0); -- for mul
	variable Q : STD_LOGIC_VECTOR(31 downto 0); -- div q
	variable R : STD_LOGIC_VECTOR(31 downto 0); -- div r
	variable R_funct : STD_LOGIC_VECTOR(5 downto 0); -- ALU R type funct (Instr[5-0])
begin
	-- forwarding mux for A and B (op1 and op2)
	case FWU_A is 
		when "00" => A := IN_ID_EX_Data1;
		when "01" => A := IN_EX_MM_ALU_Result;
		when "10" => A := IN_WB_Reg_Data;
		when others => A := (others => 'X');
	end case;
	
	case FWU_B is 
		when "00" =>
			case IN_ID_EX_ALUSrc is 
				when '0' => B := IN_ID_EX_Data2;
				when '1' => B := IN_ID_EX_SignExtended;
				when others => B := (others => 'X');
			end case;
		when "01" => B := IN_EX_MM_ALU_Result;
		when "10" => B := IN_WB_Reg_Data;
		when others => B := (others => 'X');
	end case;
	
	-- mux for ALUOp
	case IN_ID_EX_ALUOp is
	when "000" => -- R type
		R_funct := IN_ID_EX_SignExtended(5 downto 0);
		case R_funct is
			when "000000" => C := std_logic_vector(shift_left(unsigned(B), to_integer(unsigned(IN_ID_EX_Instr_10_6)))); -- sll
			when "000100" => C := std_logic_vector(shift_left(unsigned(B), to_integer(unsigned(A)))); -- sllv
			when "000011" => C := std_logic_vector(shift_right(signed(B), to_integer(unsigned(IN_ID_EX_Instr_10_6)))); -- sra
			when "000111" => C := std_logic_vector(shift_right(signed(B), to_integer(unsigned(A)))); -- srav
			when "000010" => C := std_logic_vector(shift_right(unsigned(B), to_integer(unsigned(IN_ID_EX_Instr_10_6)))); -- srl
			when "000110" => C := std_logic_vector(shift_right(unsigned(B), to_integer(unsigned(A)))); -- srlv
			-- TODO set DM_OVF
			when "100000" => C := std_logic_vector(signed(A) + signed(B)); -- add, with overflow;
			when "100001" => C := std_logic_vector(unsigned(A) + unsigned(B)); -- addu
			when "100010" => C := std_logic_vector(signed(A) - signed(B)); -- sub
			when "100011" => C := std_logic_vector(unsigned(A) - unsigned(B)); -- subu
			when "011000" => D := std_logic_vector(signed(A) * signed(B)); -- mult
				C := D(31 downto 0);
				OUT_EX_MM_ALU_Result_2 <= D(63 downto 32);
			when "011001" => D := std_logic_vector(unsigned(A) * unsigned(B)); -- multu
				C := D(31 downto 0);
				OUT_EX_MM_ALU_Result_2 <= D(63 downto 32);
			when "011010" => Q := std_logic_vector(signed(A) / signed(B)); -- div
				R := std_logic_vector(signed(A) rem signed(B));
				C := Q;
				OUT_EX_MM_ALU_Result_2 <= R;
			when "011011" => Q := std_logic_vector(unsigned(A) / unsigned(B)); -- divu
				R := std_logic_vector(unsigned(A) rem unsigned(B));
				C := Q;
				OUT_EX_MM_ALU_Result_2 <= R;
			when "101010" => if (A < B) then C := X"00000001"; else C:= X"00000000"; end if; -- slt, set less than
			--when "101011" => ; -- sltu
			when "100100" => C := A AND B; -- and, logical and
			when "100101" => C := A OR B; -- or
			when "100111" => C := A NOR B; -- nor
			when "100110" => C := A XOR B; -- xor			
			when others => C := (others => 'Z');
		end case;
	when "001" => -- LW, SW, ADDI
		C := std_logic_vector(to_unsigned(
			to_integer(unsigned(A)) + to_integer(signed(B)),
			32
		));
	when "010" => -- SLTI
		if (A < B) then C := X"00000001"; else C:= X"00000000"; end if;
	when "011" => -- LUI
		C := std_logic_vector(unsigned(B) sll 16);
	when "111" => -- ORI
		C := A OR B;
	when others =>
		C := (others => 'Z');
	end case;
	
	if ( IN_ID_EX_ALUOp = "000" 
		AND ( R_funct="011000" OR R_funct="011001" OR R_funct="011010" OR R_funct="011011")) then
		OUT_EX_MM_MULDIV <= '1';
	else
		OUT_EX_MM_MULDIV <= '0';
	end if;
	
	-- Set MEM_ALU_Result
	OUT_EX_MM_ALU_Result <= C;
	
	-- Set MEM_Zero
	if (C = X"00000000" AND IN_ID_EX_ALUOp = "100") then
		OUT_EX_MM_Zero <= '1';
	else
		OUT_EX_MM_Zero <= '0';
	end if;
	
	-- Select Register Write Address
	case IN_ID_EX_RegDst is
		when '0' => OUT_EX_MM_RegWriteAddr <= IN_ID_EX_Instr_20_16;
		when '1' => OUT_EX_MM_RegWriteAddr <= IN_ID_EX_Instr_15_11;
		when others => OUT_EX_MM_RegWriteAddr <= "XXXXX";
	end case;
	
end process;

end Behavioral;

