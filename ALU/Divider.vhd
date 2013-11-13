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
use ieee.numeric_std.all;

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

	signal counter: integer range 0 to 33;
	signal start : std_logic;

begin  

process(Control_a, dividend_i, divisor_i, counter)
	variable divident:std_logic_vector(31 downto 0);
	variable divisor: std_logic_vector(31 downto 0);
	variable tmp_rem: std_logic_vector(31 downto 0);
	variable tmp_quo: std_logic_vector (31 downto 0);
	variable rem_sign: std_logic;
	variable quo_sign: std_logic;
	variable divisor_check:std_logic;
	constant MAX_COUNT : integer := 33;
	constant TRI_STATE : std_logic_vector(31 downto 0) := (others => 'Z');
begin
	if(start = '0') then
		start <= '1';
		counter <= MAX_COUNT;
		done_b <= '0';
		debug_b <= (others => '0');
		quotient_o <= TRI_STATE;
		remainder_o <= TRI_STATE;
	elsif(counter = MAX_COUNT) then		--initialize
		tmp_rem := X"00000000";
		tmp_quo := X"00000000";
		rem_sign := '0';
		quo_sign := '0';
		divident := dividend_i;
		divisor := divisor_i;
		
		if (divisor=X"00000000") then
			divisor_check := '0';
		else
			divisor_check := '1';
		end if;
		
		if(control_a = "010") then
			rem_sign := divident(31);
			quo_sign := divident(31) xor divisor(31);
			if(divident(31) = '1') then
				divident := std_logic_vector(unsigned(not divident) + 1);
			end if;
			if(divisor(31) = '1') then
				divisor := std_logic_vector(unsigned(not divisor) + 1);
			end if;
		end if;
		
		start <= '1';
		counter <= counter - 1;
		done_b <= '0';
		debug_b <= (others => '0');
		quotient_o <= TRI_STATE;
		remainder_o <= TRI_STATE;
	elsif (counter = 0) then
		if(divisor_check='1') then
			if(rem_sign = '1') then
				remainder_o <= std_logic_vector(unsigned(not tmp_rem) + 1);
			else 
				remainder_o <= tmp_rem;
			end if;
			if(quo_sign = '1') then
				quotient_o <= std_logic_vector(unsigned(not tmp_quo) + 1);
			else 
				quotient_o <= tmp_quo;
			end if;
			
			debug_b <= X"0000000";
		else
			quotient_o <= X"00000000";
			remainder_o<= X"00000000";
			debug_b <= X"FFFFFFF";
		end if;
		
		start <= '0';
		done_b<= '1';
		counter <= 0;
	else
		tmp_rem(31 downto 1):= tmp_rem(30 downto 0);
		tmp_rem(0) := divident(31);
		tmp_quo(31 downto 1):= tmp_quo(30 downto 0);

		if(tmp_rem >= divisor) then
			tmp_rem := std_logic_vector(unsigned(tmp_rem) - unsigned(divisor));
			tmp_quo(0):= '1';
			debug_b <= X"0000010";
		else
			tmp_quo(0):='0';
			debug_b <= X"0000000";
		end if;
		divident(31 downto 1) := divident(30 downto 0);
		
		start <= '1';
		counter <= counter - 1;
		done_b <= '0';
		quotient_o <= TRI_STATE;
		remainder_o <= TRI_STATE;
	end if;
end process;
end rtl;
