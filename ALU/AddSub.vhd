library ieee;
use ieee.std_logic_1164.all;

entity addsub_lookahead is
Port (  Control		: in	STD_LOGIC_VECTOR ( 2 downto 0);
		Operand1	: in	STD_LOGIC_VECTOR (31 downto 0);
		Operand2	: in	STD_LOGIC_VECTOR (31 downto 0);
		Result1		: out	STD_LOGIC_VECTOR (31 downto 0);
		Result2		: out	STD_LOGIC_VECTOR (31 downto 0);
		Debug		: out	STD_LOGIC_VECTOR (27 downto 0));
end addsub_lookahead;

architecture beh_addsub_lookahead of addsub_lookahead is
	component adder_lookahead_4
	Port (
		A	: in	STD_LOGIC_VECTOR (3 downto 0);
		B	: in	STD_LOGIC_VECTOR (3 downto 0);
		Cin : in  STD_LOGIC;
		SUM	: out	STD_LOGIC_VECTOR (3 downto 0);
		Cout: out STD_LOGIC
		);
    end component;

	signal Cin: STD_LOGIC;
	signal C: STD_LOGIC_VECTOR(7 downto 0);
	signal OP2: STD_LOGIC_VECTOR(31 downto 0);
	signal buffer1: STD_LOGIC_VECTOR(31 downto 0);

begin	
	L0: adder_lookahead_4 port map(Operand1(3 downto 0),   OP2(3 downto 0),   Cin,  buffer1(3 downto 0),   C(0));
	L1: adder_lookahead_4 port map(Operand1(7 downto 4),   OP2(7 downto 4),   C(0), buffer1(7 downto 4),   C(1));
	L2: adder_lookahead_4 port map(Operand1(11 downto 8),  OP2(11 downto 8),  C(1), buffer1(11 downto 8),  C(2));
	L3: adder_lookahead_4 port map(Operand1(15 downto 12), OP2(15 downto 12), C(2), buffer1(15 downto 12), C(3));
	L4: adder_lookahead_4 port map(Operand1(19 downto 16), OP2(19 downto 16), C(3), buffer1(19 downto 16), C(4));
	L5: adder_lookahead_4 port map(Operand1(23 downto 20), OP2(23 downto 20), C(4), buffer1(23 downto 20), C(5));
	L6: adder_lookahead_4 port map(Operand1(27 downto 24), OP2(27 downto 24), C(5), buffer1(27 downto 24), C(6));
	L7: adder_lookahead_4 port map(Operand1(31 downto 28), OP2(31 downto 28), C(6), buffer1(31 downto 28), C(7));
	
	Result1 <= buffer1;
	Result2 <= (others => '0');
	
	process (Control, Operand1, Operand2, C, buffer1)
		variable O : STD_LOGIC := '0';
		variable operand_same_sign : STD_LOGIC := '0';
		variable result_diff_sign : STD_LOGIC := '0';
	begin
		 if (Control(1) = '1') then
			Cin <= '1';
			OP2 <= NOT Operand2;
		 else	
			Cin <= '0';
			OP2 <= Operand2;
		 end if;
		
		if (Control(0) = '0') then
			operand_same_sign := NOT (Operand1(31) XOR Operand2(31));
			result_diff_sign := Operand1(31) XOR buffer1(31);
			O := operand_same_sign and result_diff_sign;
			Debug <= X"0000" & "000" & O & C; -- add, sub with overflow trap/flag
		else
			Debug <= X"00000" & C; --addu, subu
		end if;
	end process;

end beh_addsub_lookahead;

--- lookahead entity
library ieee;
use ieee.std_logic_1164.all;

entity adder_lookahead_4 is
Port (
		A	: in	STD_LOGIC_VECTOR (3 downto 0);
		B	: in	STD_LOGIC_VECTOR (3 downto 0);
		Cin: in  STD_LOGIC;
		SUM		: out	STD_LOGIC_VECTOR (3 downto 0);
		Cout		: out STD_LOGIC
		);
end adder_lookahead_4;

architecture beh_adder_lookahead_4 of adder_lookahead_4 is
begin
process (A, B, Cin)
		variable G : STD_LOGIC_VECTOR (3 downto 0);
		variable P : STD_LOGIC_VECTOR (3 downto 0);
		variable C: STD_LOGIC_VECTOR (4 downto 0);
begin
		G := A AND B;
		P := A OR B;
		C(0) := Cin;
		C(1) := G(0) OR (P(0) AND C(0));
		C(2) := G(1) OR (G(0) AND P(1)) OR (C(0) AND P(0) AND P(1));
		C(3) := G(2) OR (G(1) AND P(2)) OR (G(0) AND P(1) AND P(2)) OR (C(0) AND P(0) AND P(1) AND P(2));
		C(4) := G(3) OR (G(2) AND P(3)) OR (G(1) AND P(2) AND P(3)) OR (G(0) AND P(1) AND P(2) AND P(3)) OR (C(0) AND P(0) AND P(1) AND P(2) AND P(3));
		
		Sum  <= (A(3) xor B(3) xor C(3)) & (A(2) xor B(2) xor C(2)) & (A(1) xor B(1) xor C(1)) & (A(0) xor B(0) xor C(0));
		Cout <= C(4);
end process;		

end beh_adder_lookahead_4;