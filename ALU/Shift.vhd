--------------------------------------------------------------------------
-- Shift
--------------------------------------------------------------------------
-- 0,01,000 SLL (Shift Left logical)
-- 0,01,010 SRL (Shift Right logical)
-- 0,01,011 SRA (Shift Right arithmetic)
--------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.ALL;

entity shift is
Port (  Control		: in	STD_LOGIC_VECTOR ( 2 downto 0);
		Operand1	: in	STD_LOGIC_VECTOR (31 downto 0);
		Operand2	: in	STD_LOGIC_VECTOR (31 downto 0);
		Result1		: out	STD_LOGIC_VECTOR (31 downto 0);
		Result2		: out	STD_LOGIC_VECTOR (31 downto 0);
		Debug		: out	STD_LOGIC_VECTOR (27 downto 0));
end shift;

architecture beh_shift of shift is
begin

process (Control, Operand1, Operand2)
    variable Temp : STD_LOGIC_VECTOR (31 downto 0);
begin
    Temp := Operand1;
    
    if Control(1) = '0' then -- left
        if Operand2(0) = '1' then
            Temp := Temp(30 downto 0) & '0';
        end if;
        if Operand2(1) = '1' then
            Temp := Temp(29 downto 0) & "00";
        end if;
        if Operand2(2) = '1' then
            Temp := Temp(27 downto 0) & X"0";
        end if;
        if Operand2(3) = '1' then
            Temp := Temp(23 downto 0) & X"00";
        end if;
        if Operand2(4) = '1' then
            Temp := Temp(15 downto 0) & X"0000";
        end if;
    end if;
    
    if Control(1) = '1' then -- right
        if Control(0) = '0' then -- logical
            if Operand2(0) = '1' then
                Temp := '0' & Temp(31 downto 1);
            end if;
            if Operand2(1) = '1' then
                Temp := "00" & Temp(31 downto 2);
            end if;
            if Operand2(2) = '1' then
                Temp := X"0" & Temp(31 downto 4);
            end if;
            if Operand2(3) = '1' then
                Temp := X"00" & Temp(31 downto 8);
            end if;
            if Operand2(4) = '1' then
                Temp := X"0000" & Temp(31 downto 16);
            end if;
        else -- arithmetic
            if Operand2(0) = '1' then
                Temp := '1' & Temp(31 downto 1);
            end if;
            if Operand2(1) = '1' then
                Temp := "11" & Temp(31 downto 2);
            end if;
            if Operand2(2) = '1' then
                Temp := X"F" & Temp(31 downto 4);
            end if;
            if Operand2(3) = '1' then
                Temp := X"FF" & Temp(31 downto 8);
            end if;
            if Operand2(4) = '1' then
                Temp := X"FFFF" & Temp(31 downto 16);
            end if;
        end if;
    end if;

    Result1 <= Temp;
    Result2 <= X"00000000";
    Debug   <= X"0000000";
end process;

end beh_shift;