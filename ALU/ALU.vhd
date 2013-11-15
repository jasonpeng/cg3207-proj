--------------------------------------------------------------------------
-- Multiplexer
--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity multiplexer is
Port (  I0	: in	STD_LOGIC_VECTOR ( 31 downto 0);
        I1	: in	STD_LOGIC_VECTOR ( 31 downto 0);
        I2	: in	STD_LOGIC_VECTOR ( 31 downto 0);
        I3	: in	STD_LOGIC_VECTOR ( 31 downto 0);
        I4	: in	STD_LOGIC_VECTOR ( 31 downto 0);
        I5	: in	STD_LOGIC_VECTOR ( 31 downto 0);
        I6	: in	STD_LOGIC_VECTOR ( 31 downto 0);
        I7	: in	STD_LOGIC_VECTOR ( 31 downto 0);
		CH	: in	STD_LOGIC_VECTOR (  2 downto 0);
        OPT : out   STD_LOGIC_VECTOR ( 31 downto 0));
end multiplexer;

architecture beh_multiplexer of multiplexer is
begin

with CH select
OPT <= I0 when "000",
       I1 when "001",
       I2 when "010",
       I3 when "011",
       I4 when "100",
       I5 when "101",
       I6 when "110",
       I7 when others;

end beh_multiplexer;

--------------------------------------------------------------------------
-- Arithmetic
--------------------------------------------------------------------------
-- 0,10,000 ADD
-- 0,10,001 ADDU
-- 0,10,010 SUB
-- 0,10,011 SUBU
-- 0,10,110 SLT (set less than)
--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity arithmetic is
Port (  Control		: in	STD_LOGIC_VECTOR ( 2 downto 0);
		Operand1	: in	STD_LOGIC_VECTOR (31 downto 0);
		Operand2	: in	STD_LOGIC_VECTOR (31 downto 0);
		Result1		: out	STD_LOGIC_VECTOR (31 downto 0);
		Result2		: out	STD_LOGIC_VECTOR (31 downto 0);
		Debug		: out	STD_LOGIC_VECTOR (27 downto 0));
end arithmetic;

architecture beh_arithmetic of arithmetic is
    component addsub_lookahead
    Port (  Control		: in	STD_LOGIC_VECTOR ( 2 downto 0);
            Operand1	: in	STD_LOGIC_VECTOR (31 downto 0);
            Operand2	: in	STD_LOGIC_VECTOR (31 downto 0);
            Result1		: out	STD_LOGIC_VECTOR (31 downto 0);
            Result2		: out	STD_LOGIC_VECTOR (31 downto 0);
            Debug		: out	STD_LOGIC_VECTOR (27 downto 0));
    end component;
   
    signal Output1 : STD_LOGIC_VECTOR (31 downto 0);
    signal Output2 : STD_LOGIC_VECTOR (31 downto 0);
    signal Oflags  : STD_LOGIC_VECTOR (27 downto 0);
begin

ADDSUB: addsub_lookahead port map (Control, Operand1, Operand2, Output1, Output2, Oflags);

Result1 <= Output1;
           
Result2 <= Output2 when Control(2) = '0' else X"00000000";

Debug   <= Oflags when Control(2) = '0' else X"0000000";

end beh_arithmetic;

--------------------------------------------------------------------------
-- Complex Op
--------------------------------------------------------------------------
-- 0,11,000 MULT
-- 0,11,001 MULTU
-- 0,11,010 DIV
-- 0,11,011 DIVU
--------------------------------------------------------------------------
--library ieee;
--use ieee.std_logic_1164.all;
--
--entity complexop is
--Port (
--      Control		: in	STD_LOGIC_VECTOR ( 2 downto 0);
--		Operand1	: in	STD_LOGIC_VECTOR (31 downto 0);
--		Operand2	: in	STD_LOGIC_VECTOR (31 downto 0);
--		Result1		: out	STD_LOGIC_VECTOR (31 downto 0);
--		Result2		: out	STD_LOGIC_VECTOR (31 downto 0);
--		Debug		: out	STD_LOGIC_VECTOR (27 downto 0);
--      Done        : out   STD_LOGIC);
--end complexop;
--
--architecture beh_complexop of complexop is
--	component Multiply is
--	port(
--       Control_a	: in	STD_LOGIC_VECTOR ( 2 downto 0);
--		 Operand1_a	: in	STD_LOGIC_VECTOR (31 downto 0);
--		 Operand2_a	: in	STD_LOGIC_VECTOR (31 downto 0);
--		 Result1_a	: out	STD_LOGIC_VECTOR (31 downto 0);
--		 Result2_a	: out	STD_LOGIC_VECTOR (31 downto 0);
--       Done_a     : out   STD_LOGIC
--	);
--    end component;
--
--	component divider is
--	port (
--		  Control_a: in std_logic_vector(2 downto 0);
--        dividend_i	: in  std_logic_vector(31 downto 0);
--        divisor_i	: in  std_logic_vector(31 downto 0);
--        quotient_o	: out std_logic_vector(31 downto 0); 
--        remainder_o	: out std_logic_vector(31 downto 0);
--        done_b		: out std_logic;
--        debug_b :	out std_logic_vector(27 downto 0)
--    );	
--    end component;
--
--    signal mul_result1 :  std_logic_vector (31 downto 0);
--    signal mul_result2 : std_logic_vector (31 downto 0);
--    signal div_quotient: std_logic_vector (31 downto 0);
--    signal div_remainder: std_logic_vector (31 downto 0);
--
--    signal done_mul: std_logic;
--    signal done_div: std_logic;
--    signal debug_s : std_logic_vector(27 downto 0);
--begin
--	MULTIPLIER: multiply port map (Control,Operand1,Operand2,mul_result1,mul_result2,done_mul);
--	DIVIDER_part: divider port map (Control,Operand1, Operand2, div_quotient, div_remainder, done_div,debug_s);
--	
--	Result1 <= mul_result1 when (Control(1)='0')
--				 else div_quotient when (Control(1) ='1' and done_div ='1')
--				 else (others => 'Z');
--	Result2 <= mul_result2 when (Control(1)='0')
--				 else div_remainder when (Control(1) ='1' and done_div ='1')
--				 else (others => 'Z');
--   Debug <= debug_s when (Control(1) = '1')
--		else (others => '0');
--	Done <=  done_mul when (Control(1) ='0')
--				else done_div when(Control(1) ='1')
--            else '0';
--
--end beh_complexop;

--------------------------------------------------------------------------
-- ALU main
--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.ALL;

entity alu is
Port (
		Control		: in	STD_LOGIC_VECTOR ( 5 downto 0);
		Operand1		: in	STD_LOGIC_VECTOR (31 downto 0);
		Operand2		: in	STD_LOGIC_VECTOR (31 downto 0);
		Result1		: out	STD_LOGIC_VECTOR (31 downto 0);
		Result2		: out	STD_LOGIC_VECTOR (31 downto 0);
		Debug			: out	STD_LOGIC_VECTOR (31 downto 0));
end alu;

architecture Behavioral of alu is
    component multiplexer
    Port (  I0	: in	STD_LOGIC_VECTOR ( 31 downto 0);
            I1	: in	STD_LOGIC_VECTOR ( 31 downto 0);
            I2	: in	STD_LOGIC_VECTOR ( 31 downto 0);
            I3	: in	STD_LOGIC_VECTOR ( 31 downto 0);
            I4	: in	STD_LOGIC_VECTOR ( 31 downto 0);
            I5	: in	STD_LOGIC_VECTOR ( 31 downto 0);
            I6	: in	STD_LOGIC_VECTOR ( 31 downto 0);
            I7	: in	STD_LOGIC_VECTOR ( 31 downto 0);
            CH	: in	STD_LOGIC_VECTOR (  2 downto 0);
            OPT : out   STD_LOGIC_VECTOR ( 31 downto 0));
    end component;

    component logic
    Port (  Control		: in	STD_LOGIC_VECTOR ( 2 downto 0);
            Operand1	: in	STD_LOGIC_VECTOR (31 downto 0);
            Operand2	: in	STD_LOGIC_VECTOR (31 downto 0);
            Result1		: out	STD_LOGIC_VECTOR (31 downto 0);
            Result2		: out	STD_LOGIC_VECTOR (31 downto 0);
            Debug		: out	STD_LOGIC_VECTOR (27 downto 0));
    end component;
        
    component shift
    Port (  Control		: in	STD_LOGIC_VECTOR ( 2 downto 0);
            Operand1	: in	STD_LOGIC_VECTOR (31 downto 0);
            Operand2	: in	STD_LOGIC_VECTOR (31 downto 0);
            Result1		: out	STD_LOGIC_VECTOR (31 downto 0);
            Result2		: out	STD_LOGIC_VECTOR (31 downto 0);
            Debug		: out	STD_LOGIC_VECTOR (27 downto 0));
    end component;
    
    component arithmetic
    Port (  Control		: in	STD_LOGIC_VECTOR ( 2 downto 0);
            Operand1	: in	STD_LOGIC_VECTOR (31 downto 0);
            Operand2	: in	STD_LOGIC_VECTOR (31 downto 0);
            Result1		: out	STD_LOGIC_VECTOR (31 downto 0);
            Result2		: out	STD_LOGIC_VECTOR (31 downto 0);
            Debug		: out	STD_LOGIC_VECTOR (27 downto 0));
    end component;

--    component complexop
--    Port (
--            Control		: in	STD_LOGIC_VECTOR ( 2 downto 0);
--            Operand1	: in	STD_LOGIC_VECTOR (31 downto 0);
--            Operand2	: in	STD_LOGIC_VECTOR (31 downto 0);
--            Result1		: out	STD_LOGIC_VECTOR (31 downto 0);
--            Result2		: out	STD_LOGIC_VECTOR (31 downto 0);
--            Debug		: out	STD_LOGIC_VECTOR (27 downto 0);
--            Done        : out   STD_LOGIC);
--    end component;
    
    signal OpDone : std_logic;    
    signal OpType : std_logic_vector(2 downto 0);
    signal OpCode : std_logic_vector(2 downto 0);
    signal OpFlag : std_logic_vector(3 downto 0);
    -- inputs
    signal Input1 : std_logic_vector(31 downto 0);
    signal Input2 : std_logic_vector(31 downto 0);
    -- logic
    signal LOutput1: std_logic_vector(31 downto 0);
    signal LOutput2: std_logic_vector(31 downto 0);
    signal LFlags  : std_logic_vector(27 downto 0);
    signal OLFlags : std_logic_vector(31 downto 0);
    -- shift
    signal SOutput1: std_logic_vector(31 downto 0);
    signal SOutput2: std_logic_vector(31 downto 0);
    signal SFlags  : std_logic_vector(27 downto 0);
    signal OSFlags : std_logic_vector(31 downto 0);
    -- aritchmetic
    signal AOutput1: std_logic_vector(31 downto 0);
    signal AOutput2: std_logic_vector(31 downto 0);
    signal AFlags  : std_logic_vector(27 downto 0);
    signal OAFlags : std_logic_vector(31 downto 0);
    -- complexop
--    signal COutput1: std_logic_vector(31 downto 0);
--    signal COutput2: std_logic_vector(31 downto 0);
--    signal CFlags  : std_logic_vector(27 downto 0);
--    signal OCFlags : std_logic_vector(31 downto 0);
begin

--------------------------------------------------------------------------
-- Control Definitions
--
-- **Positions**
-- Control(5)   : Reset Bit, Triggered when = 1;
-- Control(4,3) : Operation Type
--     00: Logical: NOP, AND, OR, XOR, NOR
--     01: Shift: SLL, SRL, SRA
--     10: Arithmetics: ADD, ADDU, SUB, SUBU, BEQ, BNE, SLT
--     11: Complex Long Cycles: MULT, MULTU, DIV, DIVU
-- Control(2,0) : Individual Ops in Each Type
--
-- **Ops**
------------------
-- 1,xx,xxx RESET
------------------ Logical
-- 0,00,000 NOP
-- 0,00,001 AND
-- 0,00,010 OR
-- 0,00,011 XOR
-- 0,00,100 NOR
------------------ Shift
-- 0,01,000 SLL (Shift Left logical)
-- 0,01,010 SRL (Shift Right logical)
-- 0,01,011 SRA (Shift Right arithmetic)
------------------ Arithmetic
-- 0,10,000 ADD
-- 0,10,001 ADDU
-- 0,10,010 SUB
-- 0,10,011 SUBU
-- 0,10,100 BEQ (equality check only)
-- 0,10,101 BNE (inequality check only)
-- 0,10,110 SLT (set less than)
------------------ ComplexOp
-- 0,11,000 MULT
-- 0,11,001 MULTU
-- 0,11,010 DIV
-- 0,11,011 DIVU
--------------------------------------------------------------------------

-- logical operations
LG: logic port map(OpCode, Input1, Input2, LOutput1, LOutput2, LFlags);
-- shift operations
SF: shift port map(OpCode, Input1, Input2, SOutput1, SOutput2, SFlags);
-- arithmetics operations
AR: arithmetic port map(OpCode, Input1, Input2, AOutput1, AOutput2, AFlags);
-- complex operations
--CO: complexop port map(OpCode, Input1, Input2, COutput1, COutput2, CFlags, OpDone);

-- multiplex output
R1: multiplexer port map(X"00000000", -- reset
                         LOutput1, -- logic
                         SOutput1, -- shift
                         AOutput1, -- arithmetic
                         --COutput1, -- long cycles
                         X"00000000",
                         X"00000000", X"00000000", X"00000000", 
                         OpType, Result1);
R2: multiplexer port map(X"00000000", -- reset
                         LOutput2, -- logic
                         SOutput2, -- shift
                         AOutput2, -- arithmetic
                         --COutput2, -- long cycles
                         X"00000000",
                         X"00000000", X"00000000", X"00000000", 
                         OpType, Result2);
-- concatentae flags
OLFlags <= OpFlag & LFlags;
OSFlags <= OpFlag & SFlags;
OAFlags <= OpFlag & AFlags;
--OCFlags <= OpFlag & CFlags;
DB: multiplexer port map(X"00000000", -- reset
                         OLFlags, -- logic
                         OSFlags, -- shift
                         OAFlags, -- arithmetic
                         --OCFlags, -- complex
                         X"00000000",
                         X"00000000", X"00000000", X"00000000", 
                         OpType, Debug);

process (Control, Operand1, Operand2)
begin
	if Control(5) = '1' then -- reset
		OpType <= "000";
		OpCode <= "000";
		OpFlag <= (others => '0');
		Input1 <= (others => '0');
		Input2 <= (others => '0');
	else	
		OpCode <= Control(2 downto 0);
		Input1 <= Operand1;
		Input2 <= Operand2;
		case (Control(4 downto 3)) is 
		  when "00" => -- logical
			  OpType <= "001";
		  when "01" => -- shift
			  OpType <= "010";
		  when "10" => -- arithmetics
			  OpType <= "011";
		  when others => -- complex op
			  OpType <= "100";
		end case;
		
		OpFlag <= '0' & OpType;
	end if;
end process;

end Behavioral;