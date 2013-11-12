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
		 Clk_a         : in    STD_LOGIC;
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
	variable tmp: std_logic_vector(63 downto 0);
	variable a_in: std_logic_vector(31 downto 0);
	variable b_in: std_logic_vector(31 downto 0);
	begin
		a_in := Operand1_a;
		b_in := Operand2_a;
		if(Control_a = "001") then
			a_in := conv_std_logic_vector(unsigned(Operand1_a),32);
			b_in := conv_std_logic_vector(unsigned(Operand1_a),32);
		end if;
		tmp:= a_in*b_in;
		prod <= tmp;
	end process;

process(Clk_a)
begin
	if(Clk_a'event and Clk_a ='1') then
    if Count = X"00" then
        Done_a  <= '1';
			Result2_a <= prod(63 downto 32);
			Result1_a <= prod(31 downto 0);
			Count <= X"04";
    else
        Done_a  <= '0';
        Count <= Count - 1;
    end if;
	end if;
end process;
end beh;