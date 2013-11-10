----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:30:58 10/31/2013 
-- Design Name: 
-- Module Name:    MEM_WB_Register - Behavioral 
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

entity MEM_WB_BUFF is
   Port (
      IN_MemToReg           : in  STD_LOGIC;
      IN_DataMemory_Result  : in  STD_LOGIC_VECTOR(31 downto 0);
      IN_ALU_Result         : in  STD_LOGIC_VECTOR(31 downto 0);
		IN_ALU_Result_2       : in  STD_LOGIC_VECTOR(31 downto 0);
		IN_MUL_DIV            : in  STD_LOGIC;
      IN_REG_WriteAddr      : in  STD_LOGIC_VECTOR(4 downto 0);
		IN_RegWrite : in STD_LOGIC;
      
      OUT_MemToReg          : out  STD_LOGIC;
      OUT_DataMemory_Result : out  STD_LOGIC_VECTOR(31 downto 0);
      OUT_ALU_Result        : out STD_LOGIC_VECTOR(31 downto 0);
		OUT_ALU_Result_2      : out STD_LOGIC_VECTOR(31 downto 0);
		OUT_MUL_DIV           : out STD_LOGIC;
      OUT_REG_WriteAddr     : out STD_LOGIC_VECTOR(4 downto 0);
		OUT_RegWrite : out STD_LOGIC;

      Clk, Reset            : in std_logic
   );
end MEM_WB_BUFF;

architecture Behavioral of MEM_WB_BUFF is
begin

process (Clk, Reset)
begin

   if (Clk'event and Clk = '1') then
      if (Reset = '1') then
         OUT_MemToReg           <= '0';
         OUT_DataMemory_Result  <= (others => '0');
         OUT_ALU_Result         <= (others => '0');
			OUT_ALU_Result_2       <= (others => '0');
			OUT_MUL_DIV            <= '0';
         OUT_REG_WriteAddr      <= (others => '0');
			OUT_RegWrite           <= '0';
      else
         OUT_MemToReg           <= IN_MemToReg;
         OUT_DataMemory_Result  <= IN_DataMemory_Result;
         OUT_ALU_Result         <= IN_ALU_Result;
			OUT_ALU_Result_2       <= IN_ALU_Result_2;
			OUT_MUL_DIV            <= IN_MUL_DIV;
         OUT_REG_WriteAddr      <= IN_REG_WriteAddr;
			OUT_RegWrite           <= IN_RegWrite;
      end if;
   end if;
end process;

end Behavioral;
