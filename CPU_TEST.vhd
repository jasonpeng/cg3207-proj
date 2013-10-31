--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:34:46 11/01/2013
-- Design Name:   
-- Module Name:   C:/Users/Jason/Documents/GitHub/cg3207-proj/CPU_TEST.vhd
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
 
ENTITY CPU_TEST IS
END CPU_TEST;
 
ARCHITECTURE behavior OF CPU_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CPU
    PORT(
         Control : IN  std_logic_vector(5 downto 0);
         Operand1 : IN  std_logic_vector(31 downto 0);
         Operand2 : IN  std_logic_vector(31 downto 0);
         Result1 : OUT  std_logic_vector(31 downto 0);
         Result2 : OUT  std_logic_vector(31 downto 0);
         Debug : OUT  std_logic_vector(31 downto 0);
         Debug1 : OUT  std_logic_vector(31 downto 0);
         Debug2 : OUT  std_logic_vector(31 downto 0);
         Debug3 : OUT  std_logic_vector(31 downto 0);
         PC_OUT : OUT  std_logic_vector(31 downto 0);
         Reg_S1 : OUT  std_logic_vector(31 downto 0);
         Reg_S2 : OUT  std_logic_vector(31 downto 0);
         Reg_S3 : OUT  std_logic_vector(31 downto 0);
         Reg_S4 : OUT  std_logic_vector(31 downto 0);
         Reg_S5 : OUT  std_logic_vector(31 downto 0);
         Reg_S6 : OUT  std_logic_vector(31 downto 0);
         Reg_S7 : OUT  std_logic_vector(31 downto 0);
         Reg_S8 : OUT  std_logic_vector(31 downto 0);
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
   signal Debug1 : std_logic_vector(31 downto 0);
   signal Debug2 : std_logic_vector(31 downto 0);
   signal Debug3 : std_logic_vector(31 downto 0);
   signal PC_OUT : std_logic_vector(31 downto 0);
   signal Reg_S1 : std_logic_vector(31 downto 0);
   signal Reg_S2 : std_logic_vector(31 downto 0);
   signal Reg_S3 : std_logic_vector(31 downto 0);
   signal Reg_S4 : std_logic_vector(31 downto 0);
   signal Reg_S5 : std_logic_vector(31 downto 0);
   signal Reg_S6 : std_logic_vector(31 downto 0);
   signal Reg_S7 : std_logic_vector(31 downto 0);
   signal Reg_S8 : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CPU PORT MAP (
          Control => Control,
          Operand1 => Operand1,
          Operand2 => Operand2,
          Result1 => Result1,
          Result2 => Result2,
          Debug => Debug,
          Debug1 => Debug1,
          Debug2 => Debug2,
          Debug3 => Debug3,
          PC_OUT => PC_OUT,
          Reg_S1 => Reg_S1,
          Reg_S2 => Reg_S2,
          Reg_S3 => Reg_S3,
          Reg_S4 => Reg_S4,
          Reg_S5 => Reg_S5,
          Reg_S6 => Reg_S6,
          Reg_S7 => Reg_S7,
          Reg_S8 => Reg_S8,
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
		Reset <= '1';
      wait for Clk_period*2;
		Reset <= '0';
      -- insert stimulus here 
		wait for Clk_period * 40;
      wait;
   end process;

END;
