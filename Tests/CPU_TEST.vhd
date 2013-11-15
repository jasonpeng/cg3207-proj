--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:02:35 11/13/2013
-- Design Name:   
-- Module Name:   Y:/cg3207-proj/CPU_test.vhd
-- Project Name:  Lab3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CPU
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
 
ENTITY CPU_test IS
END CPU_test;
 
ARCHITECTURE behavior OF CPU_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CPU
    PORT(
         Control : IN  std_logic_vector(5 downto 0);
         Operand1 : IN  std_logic_vector(31 downto 0);
         Operand2 : IN  std_logic_vector(31 downto 0);
         Result1 : OUT  std_logic_vector(31 downto 0);
         Result2 : OUT  std_logic_vector(31 downto 0);
         Debug : OUT  std_logic_vector(31 downto 0);
         REG1 : OUT  std_logic_vector(31 downto 0);
         REG2 : OUT  std_logic_vector(31 downto 0);
         REG3 : OUT  std_logic_vector(31 downto 0);
         REG4 : OUT  std_logic_vector(31 downto 0);
         REG5 : OUT  std_logic_vector(31 downto 0);
         REG6 : OUT  std_logic_vector(31 downto 0);
         REG7 : OUT  std_logic_vector(31 downto 0);
         REG8 : OUT  std_logic_vector(31 downto 0);
         ALU_OP : OUT  std_logic_vector(2 downto 0);
         Clk : IN  std_logic;
         Reset : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Control : std_logic_vector(5 downto 0) := (others => '0');
   signal Operand1 : std_logic_vector(31 downto 0) := (others => '0');
   signal Operand2 : std_logic_vector(31 downto 0) := (others => '0');
   signal Clk : std_logic := '0';
   signal Reset : std_logic := '0';

 	--Outputs
   signal Result1 : std_logic_vector(31 downto 0);
   signal Result2 : std_logic_vector(31 downto 0);
   signal Debug : std_logic_vector(31 downto 0);
   signal REG1 : std_logic_vector(31 downto 0);
   signal REG2 : std_logic_vector(31 downto 0);
   signal REG3 : std_logic_vector(31 downto 0);
   signal REG4 : std_logic_vector(31 downto 0);
   signal REG5 : std_logic_vector(31 downto 0);
   signal REG6 : std_logic_vector(31 downto 0);
   signal REG7 : std_logic_vector(31 downto 0);
   signal REG8 : std_logic_vector(31 downto 0);
   signal ALU_OP : std_logic_vector(2 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CPU PORT MAP (
          Control => Control,
          Operand1 => Operand1,
          Operand2 => Operand2,
          Result1 => Result1,
          Result2 => Result2,
          Debug => Debug,
          REG1 => REG1,
          REG2 => REG2,
          REG3 => REG3,
          REG4 => REG4,
          REG5 => REG5,
          REG6 => REG6,
          REG7 => REG7,
          REG8 => REG8,
          ALU_OP => ALU_OP,
          Clk => Clk,
          Reset => Reset
        );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		Reset <='1';
		wait for 100 ns;
		Reset <='0';
      wait for Clk_period*100;

      -- insert stimulus here 

      wait;
   end process;

END;
