----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:11:02 10/11/2013 
-- Design Name: 
-- Module Name:    Divider - Behavioral 
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
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;   

entity divider is  
  port (
		  Control_a: in std_logic_vector(2 downto 0);
        dividend_i	: in  std_logic_vector(31 downto 0);
        divisor_i	: in  std_logic_vector(31 downto 0);
        quotient_o	: out std_logic_vector(31 downto 0); 
        remainder_o	: out std_logic_vector(31 downto 0);
        done_b		: out std_logic;
        debug_b :	out std_logic_vector(27 downto 0)  );
      
end divider;

architecture rtl of divider is

signal counter: std_logic_vector (5 downto 0);
signal start : std_logic := '0';
signal done : std_logic;
begin  

process(Control_a, dividend_i, divisor_i, counter)
variable divident:std_logic_vector(31 downto 0);
variable divisor: std_logic_vector(31 downto 0);
variable tmp_rem: std_logic_vector(31 downto 0) := (others=>'0');
variable tmp_quo: std_logic_vector (31 downto 0):=(others =>'0');
variable rem_sign: std_logic := '0';
variable quo_sign: std_logic := '0';
variable divisor_check:std_logic;
begin
	if(start = '0') then
		done_b <= '0';
		counter <= "100001";
		start <= '1';
	elsif(counter = "100001") then		--initialize
			tmp_rem := X"00000000";
			tmp_quo := X"00000000";
			done_b <= '0';
			rem_sign := '0';
			quo_sign := '0';
			divident := dividend_i;
			divisor := divisor_i;
			if(divisor =X"00000000") then
				divisor_check := '0';
			else
				divisor_check := '1';
			end if;
			if(control_a = "010") then
				rem_sign := divident(31);
				quo_sign := divident(31) xor divisor(31);
				if(divident(31) = '1') then
					divident := (not divident) + 1;
				end if;
				if(divisor(31) = '1') then
					divisor := (not divisor) + 1;
				end if;
			end if;
			counter <= counter -1 ;
	elsif (counter ="000000") then
		if(divisor_check='1') then
				if(rem_sign = '1') then
					remainder_o <= (not tmp_rem) + 1;
				else 
					remainder_o <= tmp_rem;
				end if;
				if(quo_sign = '1') then
					quotient_o <= (not tmp_quo) + 1;	
				else 
					quotient_o <= tmp_quo;
				end if;
				debug_b <= X"0000000";
			else
				quotient_o <= X"00000000";
				remainder_o<= X"00000000";
				debug_b <= X"fffffff";
			end if;
				done_b<= '1';
				start <= '0';
	else
			tmp_rem(31 downto 1):= tmp_rem(30 downto 0);
			tmp_rem(0) := divident(31);
			tmp_quo(31 downto 1):= tmp_quo(30 downto 0);

			if(tmp_rem >= divisor) then
				tmp_rem  :=conv_std_logic_vector (unsigned (tmp_rem) - unsigned (divisor), 32);
				tmp_quo(0):= '1';
				debug_b <= X"0000010";
			else
				debug_b<=X"0000000";
				tmp_quo(0):='0';
			end if;
			divident(31 downto 1) := divident(30 downto 0);
			counter <= counter - 1;
		end if;
	end process;
end rtl;
