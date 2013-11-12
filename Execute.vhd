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

--use CUSTOM_TYPES.ALL;

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
		OUT_EX_MM_ALU_Result_1 : out STD_LOGIC_VECTOR(31 downto 0);
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

-- ALU Component --
component ALU
	Port (	
		Control		: in	STD_LOGIC_VECTOR ( 5 downto 0);
		Operand1		: in	STD_LOGIC_VECTOR (31 downto 0);
		Operand2		: in	STD_LOGIC_VECTOR (31 downto 0);
		Result1		: out	STD_LOGIC_VECTOR (31 downto 0);
		Result2		: out	STD_LOGIC_VECTOR (31 downto 0);
		Debug			: out	STD_LOGIC_VECTOR (31 downto 0)
		);
end component;
--

-- ALU Signals
signal ALU_Ctrl : STD_LOGIC_VECTOR(5  downto 0);
signal ALU_Op1  : STD_LOGIC_VECTOR(31 downto 0);
signal ALU_Op2  : STD_LOGIC_VECTOR(31 downto 0);
signal ALU_R1   : STD_LOGIC_VECTOR(31 downto 0);
signal ALU_R2   : STD_LOGIC_VECTOR(31 downto 0);
signal ALU_Debug: STD_LOGIC_VECTOR(31 downto 0);
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

ALU1 : ALU Port Map (
	Control => ALU_Ctrl,
	Operand1 => ALU_Op1, 
	Operand2 => ALU_Op2,
	Result1 => ALU_R1,
	Result2 => ALU_R2,
	Debug => ALU_Debug
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

		IN_EX_MM_RegWrite,
		IN_EX_MM_RD,
		IN_EX_MM_ALU_Result,
		IN_MM_WB_RegWrite,
		IN_MM_WB_RD,
		IN_WB_Reg_Data
		)
	
	variable A : STD_LOGIC_VECTOR(31 downto 0); -- op1 for ALU
	variable B : STD_LOGIC_VECTOR(31 downto 0); -- op2 for ALU
	variable shftamt : STD_LOGIC_VECTOR(31 downto 0); -- shift amount
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
	
	-- set ALU Op1 and Op2
	ALU_Op1 <= A;
	ALU_Op2 <= B;
	shftamt := X"000000" & "000" & IN_ID_EX_SignExtended(10 downto 6);
	
	-- mux for ALUOp
	case IN_ID_EX_ALUOp is
	when "100" => -- R type
		R_funct := IN_ID_EX_SignExtended(5 downto 0);
		case R_funct is
			when "000000" => -- sll
				ALU_Op1 <= B;
				ALU_Op2 <= shftamt;
				ALU_Ctrl <= "001000";
			when "000100" => -- sllv
				ALU_Op1 <= B;
				ALU_Op2 <= A;
				ALU_Ctrl <= "001000";
			when "000011" => -- sra
				ALU_Op1 <= B;
				ALU_Op2 <= shftamt;
				ALU_Ctrl <= "001011";
			when "000111" => -- srav
				ALU_Op1 <= B;
				ALU_Op2 <= A;
				ALU_Ctrl <= "001011";
			when "000010" => -- srl
				ALU_Op1 <= B;
				ALU_Op2 <= shftamt;
				ALU_Ctrl <= "001010";
			when "000110" => -- srlv
				ALU_Op1 <= B;
				ALU_Op2 <= A;
				ALU_Ctrl <= "001010";
			when "100000" => -- add, with overflow;
				ALU_Ctrl <= "010000";
			when "100001" => -- addu
				ALU_Ctrl <= "010001";
			when "100010" => -- sub
				ALU_Ctrl <= "010010";
			when "100011" => -- subu
				ALU_Ctrl <= "010011";
			when "011000" => -- mult
				ALU_Ctrl <= "011000";
			when "011001" => -- multu
				ALU_Ctrl <= "011001";
			when "011010" => -- div
				ALU_Ctrl <= "011010";
			when "011011" => -- divu
				ALU_Ctrl <= "011011";
			when "101010" => -- slt, set less than
				ALU_Ctrl <= "010110";
			when "100100" => -- logical and, logical and
				ALU_Ctrl <= "000001";
			when "100101" => -- logical or
				ALU_Ctrl <= "000010";
			when "100111" => -- nor
				ALU_Ctrl <= "000100";
			when "100110" => -- xor			
				ALU_Ctrl <= "000011";
			when others => -- undefined, nop
				ALU_Ctrl <= "000000";
		end case;
	when "000" => -- nop
		ALU_Ctrl <= "000000";
	when "001" => -- LW, SW, ADDI, use ALU 'add'
		ALU_Ctrl <= "010000";
	when "010" => -- SLTI
		ALU_Ctrl <= "010110";
	when "011" => -- LUI
		ALU_Op1 <= B;
		ALU_Op2 <= X"00000010";
		ALU_Ctrl <= "001000";
	when "111" => -- ORI
		ALU_Ctrl <= "000010";
	when others =>
		ALU_Ctrl <= "000000";
	end case;
	
	if ( IN_ID_EX_ALUOp = "100" 
		AND ( R_funct="011000" OR R_funct="011001" OR R_funct="011010" OR R_funct="011011")) then
		OUT_EX_MM_MULDIV <= '1';
	else
		OUT_EX_MM_MULDIV <= '0';
	end if;
	
	-- Set MEM_ALU_Result
	OUT_EX_MM_ALU_Result_1 <= ALU_R1;
	OUT_EX_MM_ALU_Result_2 <= ALU_R2;
	
	-- Set MEM_Zero
	if (ALU_R1 = X"00000000") then
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

