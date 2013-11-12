----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:24:29 10/11/2013 
-- Design Name: 
-- Module Name:    multiply sign/unsign - Behavioral 
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
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
signal Count: std_logic_vector(7 downto 0) :=X"04";
signal prod: std_logic_vector(63 downto 0);
begin
process(Operand1_a,Operand2_a,Control_a)
	variable sign: std_logic;
	variable tmp: std_logic_vector(63 downto 0);
	variable a_in: std_logic_vector(31 downto 0);
	variable b_in: std_logic_vector(31 downto 0);
	begin
		a_in := Operand1_a;
		b_in := Operand2_a;
		sign :=a_in(31) xnor b_in(31);
		if(control_a ="001") then
			tmp := a_in * b_in;
		elsif (control_a = "000" ) then
			if(a_in(31) = '1') then
				a_in:= not(a_in)+1;
			end if;
			if(b_in(31)='1') then
				b_in := not (b_in) + 1;
			end if;
			tmp:= a_in * b_in;
			if(sign = '0') then
				tmp := not(tmp) + 1;
			end if;
		end if;
		prod <= tmp;
		tmp:=X"0000000000000000";		
		Result2_a <= prod(63 downto 32);
		Result1_a <= prod(31 downto 0);
	end process;
end beh;