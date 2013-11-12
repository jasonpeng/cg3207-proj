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
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
  
entity divider is  
  port (
  	clk_b		: in  std_logic;
  	dividend_i	: in  std_logic_vector(31 downto 0);
   divisor_i	: in  std_logic_vector(31 downto 0);
   quotient_o	: out std_logic_vector(31 downto 0); 
   remainder_o	: out std_logic_vector(31 downto 0);
	done_b		: out std_logic;
	debug_b :	out std_logic_vector(27 downto 0)
  );
      
end divider;

architecture rtl of divider is
  signal i			: integer range 0 to 31;
  signal ended		: std_logic;
  signal dividend_shift	: std_logic_vector(31 downto 0);
  signal divisor		: std_logic_vector(31 downto 0);
  signal next_quotient	: std_logic_vector(31 downto 0);
  signal next_remainder	: std_logic_vector(31 downto 0);    
  signal quotient		: std_logic_vector(31 downto 0);
  signal remainder	: std_logic_vector(31 downto 0);    
  signal olddividend_i	: std_logic_vector(31 downto 0);  
  signal olddivisor_i	: std_logic_vector(31 downto 0);  
begin  -- rtl
  -- purpose: Divide dividend through divisor and deliver the result to quotient
  --          and the remainder to remainder.
  -- Performs a synchronous tail division.
  check0:process (divisor_i)
	begin
	if(divisor_i = X"00000000") then 
		debug_b <= X"0000001";
	end if;
	end process check0;

  p_divide: process (dividend_shift, divisor, quotient, remainder, i)
  	variable v_quo : std_logic_vector(31 downto 0);
  	variable v_rem : std_logic_vector(31 downto 0);
  begin  -- process p_divide
	-- initialization	
	v_quo := quotient;
	v_rem := remainder;
	
	-- shift in new bit from dividend
	v_rem(31 downto 1) := remainder(30 downto 0);
	v_rem(0) := dividend_shift(31);
				
	-- if divisor can be subtracted from current remainder, do it and set
	-- current quotient bit to '1'
	if v_rem >= divisor then
       		v_quo(0) := '1';
       		v_rem := conv_std_logic_vector (unsigned (v_rem) - unsigned (divisor), 32);
       	else
       		v_quo(0) := '0';
       	end if;
 	
 	next_quotient <= v_quo;
 	next_remainder <= v_rem;
  end process p_divide;
 
  process (clk_b)
  begin
  	if (clk_b'event and clk_b = '1') then
  		remainder <= next_remainder;
  		quotient(31 downto 1) <= next_quotient(30 downto 0);
  		dividend_shift(31 downto 1) <= dividend_shift(30 downto 0);
  		
  		if (dividend_i /= olddividend_i or divisor_i /= olddivisor_i) then
  			i <= 31;
  			done_b <= '0';
  			ended <= '0';
  			remainder <= (others => '0');
  			quotient <= (others => '0');
  			dividend_shift <= dividend_i;
  			divisor <= divisor_i;
			olddividend_i <= dividend_i;
			olddivisor_i <= divisor_i;
  		elsif (i > 0) then
  			i <= i - 1;
  		elsif (ended = '0') then
  			remainder_o <= next_remainder;
  			quotient_o <= next_quotient;
  			done_b <= '1';
  			ended <= '1';
  		end if;
  	end if;
  end process;

end rtl;
