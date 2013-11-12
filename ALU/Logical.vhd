--------------------------------------------------------------------------
-- Logical
--------------------------------------------------------------------------
-- 0,00,000 NOP
-- 0,00,001 AND
-- 0,00,010 OR
-- 0,00,011 XOR
-- 0,00,100 NOR
--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.ALL;

entity logic is
Port (  
		Control     : in	STD_LOGIC_VECTOR ( 2 downto 0);
		Operand1    : in	STD_LOGIC_VECTOR (31 downto 0);
		Operand2    : in	STD_LOGIC_VECTOR (31 downto 0);
		Result1     : out	STD_LOGIC_VECTOR (31 downto 0);
		Result2     : out	STD_LOGIC_VECTOR (31 downto 0);
		Debug       : out	STD_LOGIC_VECTOR (27 downto 0));
end logic;

architecture beh_logic of logic is
begin

process (Control, Operand1, Operand2)
    variable temp : STD_LOGIC_VECTOR (31 downto 0);
begin
    case Control is
    when "000" => -- NOP
       Result1 <= Operand1;
       Result2 <= Operand2;
       Debug   <= X"0000000";
    when "001" => -- AND
       Result1 <= Operand1 and Operand2;
       Result2 <= X"00000000";
       Debug   <= X"0000000";
    when "010" => -- OR
       Result1 <= Operand1 or Operand2;
       Result2 <= X"00000000";
       Debug   <= X"0000000";
    when "011" => -- XOR
       Result1 <= Operand1 xor Operand2;
       Result2 <= X"00000000";
       Debug   <= X"0000000";
    when "100" => -- NOR
       Result1 <= Operand1 nor Operand2;
       Result2 <= X"00000000";
       Debug   <= X"0000000";
    when others =>
       Result1 <= X"FFFFFFFF";
       Result2 <= X"FFFFFFFF";
       Debug   <= X"FFFFFFF";
    end case;
end process;

end beh_logic;
