----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:20:35 10/31/2013 
-- Design Name: 
-- Module Name:    EX_MEM_BUFF - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX_MEM_BUFF is
    Port ( 
	        CLK : in STD_LOGIC;
			  RESET : in STD_LOGIC;
			  
			  -- states received from EX
			  -- state registers
			  IN_EX_MemWrite : in STD_LOGIC;
			  IN_EX_MemToReg : in STD_LOGIC;
			  IN_EX_MemRead : in STD_LOGIC;
           IN_EX_RegWrite : in STD_LOGIC;
						  
			  -- alu related
			  IN_EX_OVF : in STD_LOGIC;
           IN_EX_Zero : in STD_LOGIC;
           IN_EX_ALU_Result : in STD_LOGIC_VECTOR(31 downto 0);
			  IN_EX_ALU_Result_2 : in STD_LOGIC_VECTOR(31 downto 0);
			  IN_EX_MULDIV : in STD_LOGIC;
			  
			  IN_EX_Data2 : in STD_LOGIC_VECTOR(31 downto 0); -- for DM Write Data
			  IN_EX_REG_WriteAddr : in STD_LOGIC_VECTOR(4 downto 0); -- register address
           
			  OUT_MEM_MemWrite : out STD_LOGIC;
			  OUT_MEM_MemToReg : out STD_LOGIC;
			  OUT_MEM_MemRead : out STD_LOGIC;
			  OUT_MEM_RegWrite : out STD_LOGIC;
			  
			  -- alu related
			  OUT_MEM_OVF : out STD_LOGIC;
           OUT_MEM_Zero : out STD_LOGIC;
           OUT_MEM_ALU_Result : out STD_LOGIC_VECTOR(31 downto 0);
			  OUT_MEM_ALU_Result_2 : out STD_LOGIC_VECTOR(31 downto 0);
			  OUT_MEM_MULDIV : out STD_LOGIC;
			  
			  OUT_MEM_Data2 : out STD_LOGIC_VECTOR(31 downto 0); -- for DM Write Data
			  OUT_MEM_REG_WriteAddr : out STD_LOGIC_VECTOR(4 downto 0) -- register address
			  );
end EX_MEM_BUFF;

architecture Behavioral of EX_MEM_BUFF is
begin

process(CLK, RESET, 
	IN_EX_MemWrite, IN_EX_MemToReg, IN_EX_MemRead, 
	IN_EX_OVF, IN_EX_Zero, IN_EX_ALU_Result,
	IN_EX_Data2, IN_EX_REG_WriteAddr)
begin
	if (RESET = '1') then
	  OUT_MEM_MemWrite	<=		'0';
	  OUT_MEM_MemToReg	<=		'0';
	  OUT_MEM_MemRead		<=		'0';
	  OUT_MEM_RegWrite	<= 	'0';
	  
	  OUT_MEM_OVF 			<=		'0';
	  OUT_MEM_Zero			<=		'0';
	  OUT_MEM_ALU_Result <=		(others => '0');
	  OUT_MEM_ALU_Result_2 <=	(others => '0');
	  OUT_MEM_MULDIV		<=		'0';
	  
	  OUT_MEM_Data2		<=		(others => '0');
	  OUT_MEM_REG_WriteAddr <=	(others => '0');
	elsif rising_edge(CLK) then
	  OUT_MEM_MemWrite	<=		IN_EX_MemWrite;
	  OUT_MEM_MemToReg	<=		IN_EX_MemToReg;
	  OUT_MEM_MemRead		<=		IN_EX_MemRead;
     OUT_MEM_RegWrite	<=		IN_EX_RegWrite;
	  
	  OUT_MEM_OVF 			<=		IN_EX_OVF;
	  OUT_MEM_Zero			<=		IN_EX_Zero;
	  OUT_MEM_ALU_Result <=		IN_EX_ALU_Result;
	  OUT_MEM_ALU_Result_2 <=	IN_EX_ALU_Result_2;
	  OUT_MEM_MULDIV		<=		IN_EX_MULDIV;
	  
	  OUT_MEM_Data2		<=		IN_EX_Data2;
	  OUT_MEM_REG_WriteAddr <=	IN_EX_REG_WriteAddr;
	end if;
	
end process;

end Behavioral;

