library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Multiply is
	port(
       Control_a		: in	STD_LOGIC_VECTOR ( 2 downto 0);
		 Operand1_a	: in	STD_LOGIC_VECTOR (31 downto 0);
		 Operand2_a	: in	STD_LOGIC_VECTOR (31 downto 0);
		 Result1_a		: out	STD_LOGIC_VECTOR (31 downto 0);
		 Result2_a		: out	STD_LOGIC_VECTOR (31 downto 0);
		 --Debug		: out	STD_LOGIC_VECTOR (27 downto 0);
       Done_a        : out   STD_LOGIC
	);
end Multiply;

architecture beh of multiply is
	signal prod: std_logic_vector(63 downto 0);
begin

Result2_a <= prod(63 downto 32);
Result1_a <= prod(31 downto 0);
	
process(Operand1_a,Operand2_a,Control_a)
	variable sign: std_logic;
	variable tmp: std_logic_vector(63 downto 0);
	variable a_in: std_logic_vector(31 downto 0);
	variable b_in: std_logic_vector(31 downto 0);
begin
	if (Control_a(0)='0') then
		prod <= std_logic_vector(signed(Operand1_a) * signed(Operand2_a));
	elsif (Control_a(0)='1') then
		prod <= std_logic_vector(unsigned(Operand1_a) * unsigned(Operand2_a));
	else
		prod <= (others => 'Z');
	end if;
end process;
end beh;