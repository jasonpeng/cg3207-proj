
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity HazardUnit is
   Port (
      ID_EX_MemRead   : in std_logic;
      ID_EX_RegRt     : in std_logic_vector(4 downto 0);
      IF_ID_RegRs     : in std_logic_vector(4 downto 0);
      IF_ID_RegRt     : in std_logic_vector(4 downto 0);
      
      STALL           : out std_logic
   );
end HazardUnit;

architecture Behavioral of HazardUnit is

begin

   -- Load-use Hazard
   STALL <= '1' when ID_EX_MemRead = '1' and 
                   ((ID_EX_RegRt = IF_ID_RegRs) or (ID_EX_RegRt = IF_ID_RegRt))
                else '0';

end Behavioral;