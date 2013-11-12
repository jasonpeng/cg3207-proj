library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use CUSTOM_TYPES.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID_EX_BUFF is
   Port (
      CLK              : in STD_LOGIC; -- clock signal for synchronization
      RESET            : in STD_LOGIC;

      -- IN --
      IN_EX_Stage      : in TYPE_EX_Stage;
      IN_MEM_Stage     : in TYPE_MEM_Stage;
      IN_WB_Stage      : in TYPE_WB_Stage;
      IN_ID_Data       : in TYPE_ID_data;
      IN_SignExtended  : in STD_LOGIC_VECTOR(31 downto 0);

      -- OUT --
      OUT_EX_Stage     : out TYPE_EX_Stage;
      OUT_MEM_Stage    : out TYPE_MEM_Stage;
      OUT_WB_Stage     : out TYPE_WB_Stage;
      OUT_ID_Data      : out TYPE_ID_data;
      OUT_SignExtended : out STD_LOGIC_VECTOR(31 downto 0)
   );
end ID_EX_BUFF;

architecture Behavioral of ID_EX_BUFF is
begin
process(CLK, RESET, IN_EX_Stage, IN_MEM_Stage, IN_WB_Stage, IN_ID_Data, IN_SignExtended)
begin
    if (RESET = '1') then
        OUT_EX_Stage.ALUOp <= (others => '0');
        OUT_MEM_Stage    <= (others => '0');
        OUT_WB_Stage     <= (others => '0');
        OUT_ID_Data      <= (others => '0');
        OUT_SignExtended <= (others => '0');
    elsif rising_edge(CLK) then
        OUT_EX_Stage     <= IN_EX_Stage;
        OUT_MEM_Stage    <= IN_MEM_Stage;
        OUT_WB_Stage     <= IN_WB_Stage;
        OUT_ID_Data      <= IN_ID_Data;
        OUT_SignExtended <= IN_SignExtended;
    end if;
end process;

end Behavioral;

