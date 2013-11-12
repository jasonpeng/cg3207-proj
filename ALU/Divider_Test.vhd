--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   05:29:39 11/13/2013
-- Design Name:   
-- Module Name:   C:/Users/Jason/Documents/GitHub/cg3207-proj/ALU/Divider_Test.vhd
-- Project Name:  Lab3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: divider
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
 
ENTITY Divider_Test IS
END Divider_Test;
 
ARCHITECTURE behavior OF Divider_Test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT divider
    PORT(
         enable : IN  std_logic;
         Control_a : IN  std_logic_vector(2 downto 0);
         dividend_i : IN  std_logic_vector(31 downto 0);
         divisor_i : IN  std_logic_vector(31 downto 0);
         quotient_o : OUT  std_logic_vector(31 downto 0);
         remainder_o : OUT  std_logic_vector(31 downto 0);
         done_b : OUT  std_logic;
         debug_b : OUT  std_logic_vector(27 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal enable : std_logic := '0';
   signal Control_a : std_logic_vector(2 downto 0) := (others => '0');
   signal dividend_i : std_logic_vector(31 downto 0) := (others => '0');
   signal divisor_i : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal quotient_o : std_logic_vector(31 downto 0);
   signal remainder_o : std_logic_vector(31 downto 0);
   signal done_b : std_logic;
   signal debug_b : std_logic_vector(27 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: divider PORT MAP (
          enable => enable,
          Control_a => Control_a,
          dividend_i => dividend_i,
          divisor_i => divisor_i,
          quotient_o => quotient_o,
          remainder_o => remainder_o,
          done_b => done_b,
          debug_b => debug_b
        );

 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		enable <= '1';
      Control_a <= "010";
		dividend_i <= X"00000007";
		divisor_i <= X"00000004";

		wait for 100 ns;
		Control_a <= "011";
      -- insert stimulus here 

      wait;
   end process;

END;
