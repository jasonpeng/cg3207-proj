--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   03:43:44 11/13/2013
-- Design Name:   
-- Module Name:   C:/Users/Jason/Documents/GitHub/cg3207-proj/ALU/ALU_TEST.vhd
-- Project Name:  Lab3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu
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
 
ENTITY ALU_TEST IS
END ALU_TEST;
 
ARCHITECTURE behavior OF ALU_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu
    PORT(
         Control : IN  std_logic_vector(5 downto 0);
         Operand1 : IN  std_logic_vector(31 downto 0);
         Operand2 : IN  std_logic_vector(31 downto 0);
         Result1 : OUT  std_logic_vector(31 downto 0);
         Result2 : OUT  std_logic_vector(31 downto 0);
         Debug : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Control : std_logic_vector(5 downto 0) := (others => '0');
   signal Operand1 : std_logic_vector(31 downto 0) := (others => '0');
   signal Operand2 : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal Result1 : std_logic_vector(31 downto 0);
   signal Result2 : std_logic_vector(31 downto 0);
   signal Debug : std_logic_vector(31 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu PORT MAP (
          Control => Control,
          Operand1 => Operand1,
          Operand2 => Operand2,
          Result1 => Result1,
          Result2 => Result2,
          Debug => Debug
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- insert stimulus here 
		Control <= "000001";
		Operand1 <= X"00000007";
		Operand2 <= X"00000003";
		
		wait for 100 ns;
		Control <= "010000";
		
		wait for 100 ns;
		Control <= "011000";
		
		wait for 100 ns;
		Control <= "011010";
		
		wait for 100 ns;
		Operand1 <= X"00000009";
		Operand2 <= X"00000002";
      wait;
   end process;

END;
