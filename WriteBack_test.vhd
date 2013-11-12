--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   05:23:41 11/13/2013
-- Design Name:   
-- Module Name:   D:/Programming/gitHub/cg3207-proj/wb_test.vhd
-- Project Name:  Lab3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: WriteBack
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY wb_test IS
END wb_test;
 
ARCHITECTURE behavior OF wb_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT WriteBack
    PORT(
         IN_DataMemory_Result : IN  std_logic_vector(31 downto 0);
         IN_ALU_Result : IN  std_logic_vector(31 downto 0);
         IN_MemToReg : IN  std_logic;
         IN_Reg_WriteAddr : IN  std_logic_vector(4 downto 0);
         OUT_Reg_WriteAddr : OUT  std_logic_vector(4 downto 0);
         OUT_Reg_Data : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal IN_DataMemory_Result : std_logic_vector(31 downto 0) := (others => '0');
   signal IN_ALU_Result : std_logic_vector(31 downto 0) := (others => '0');
   signal IN_MemToReg : std_logic := '0';
   signal IN_Reg_WriteAddr : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal OUT_Reg_WriteAddr : std_logic_vector(4 downto 0);
   signal OUT_Reg_Data : std_logic_vector(31 downto 0);

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: WriteBack PORT MAP (
          IN_DataMemory_Result => IN_DataMemory_Result,
          IN_ALU_Result => IN_ALU_Result,
          IN_MemToReg => IN_MemToReg,
          IN_Reg_WriteAddr => IN_Reg_WriteAddr,
          OUT_Reg_WriteAddr => OUT_Reg_WriteAddr,
          OUT_Reg_Data => OUT_Reg_Data
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 10 ns;
      
      -- insert stimulus here 
      IN_DataMemory_Result <= X"00001111";
      IN_ALU_Result <= X"11110000";
      IN_MemToReg <= '1';
      IN_Reg_WriteAddr <= "01111";
      -- expect DataMem_Result
      
      wait for 10 ns;
      
      IN_DataMemory_Result <= X"00001110";
      IN_ALU_Result <= X"11100000";
      IN_MemToReg <= '0';
      IN_Reg_WriteAddr <= "01100";
      -- expect ALU_Result
      
      wait;
   end process;

END;
