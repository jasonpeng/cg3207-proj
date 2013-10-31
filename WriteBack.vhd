----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:33:27 10/29/2013 
-- Design Name: 
-- Module Name:    WriteBack - Behavioral 
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

entity WriteBack is
   Port (
      IN_DataMemory_Result : in  STD_LOGIC_VECTOR(31 downto 0);
      IN_ALU_Result        : in  STD_LOGIC_VECTOR(31 downto 0);
      IN_MemToReg          : in  STD_LOGIC;
      IN_Reg_WriteAddr     : in  STD_LOGIC_VECTOR(4 downto 0);
      OUT_Reg_WriteAddr    : out STD_LOGIC_VECTOR(4 downto 0);
      OUT_Reg_Data         : out STD_LOGIC_VECTOR(31 downto 0)
   );
end WriteBack;

architecture Behavioral of WriteBack is
begin

OUT_Reg_Data <= IN_DataMemory_Result when IN_MemToReg = '1' else
                IN_ALU_Result;

OUT_Reg_WriteAddr <= IN_Reg_WriteAddr;

end Behavioral;

