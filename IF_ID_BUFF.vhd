
Library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.numeric_std.all;
use CUSTOM_TYPES.ALL;

entity IF_ID_BUFF is 
	 port( 
       Clk         : in STD_LOGIC; 
       Reset       : in STD_LOGIC; 
       IN_PI       : in TYPE_PI;
       OUT_PI      : out TYPE_PI
	 ); 
end IF_ID_BUFF;

architecture IF_ID_BUFF_ARC of IF_ID_BUFF is 

begin
process (Clk,Reset,IN_PI) 
begin 
   if Reset = '1' then
      OUT_PI.PC <= (others => '0');
      OUT_PI.Instr <= (others => '0');
   elsif rising_edge(CLK) then
      OUT_PI <= IN_PI;
   end if;
end process; 

end IF_ID_BUFF_ARC; 