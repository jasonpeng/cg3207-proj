--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:34:35 10/31/2013
-- Design Name:   
-- Module Name:   C:/Documents and Settings/Administrator/My Documents/Dropbox/CG3207/Lab3 Code/if_test.vhd
-- Project Name:  Lab3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Fetch
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
 
ENTITY if_test IS
END if_test;
 
ARCHITECTURE behavior OF if_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Fetch
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         Instruction : OUT  std_logic_vector(31 downto 0);
         PC_out : OUT  std_logic_vector(31 downto 0);
			PC_out_4: out std_logic_vector(31 downto 0);
         BEQ_PC : IN  std_logic_vector(31 downto 0);
         PCSrc : IN  std_logic;
         Jump : IN  std_logic;
         JumpPC : IN  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal BEQ_PC : std_logic_vector(31 downto 0) := (others => '0');
   signal PCSrc : std_logic := '0';
   signal Jump : std_logic := '0';
   signal JumpPC : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal Instruction : std_logic_vector(31 downto 0);
   signal PC_out : std_logic_vector(31 downto 0);
	signal PC_out_4: std_logic_vector(31 downto 0);
   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Fetch PORT MAP (
          clk => clk,
          reset => reset,
          Instruction => Instruction,
          PC_out => PC_out,
			 PC_out_4 => PC_out_4,
          BEQ_PC => BEQ_PC,
          PCSrc => PCSrc,
          Jump => Jump,
          JumpPC => JumpPC
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      
		wait for 100 ns;	
		reset <= '1';
		wait for 100 ns;
		reset <= '0';
		BEQ_PC <= X"00000002";
		JUMP <= '0';
		PCSrc <= '0';
		JUMPpC <= X"00000004";
		
		wait for 100 ns;			
		reset <= '0';
		BEQ_PC <= X"00000002";
		JUMP <= '0';
		PCSrc <= '0';
		JUMPpC <= X"00000004";
		wait for 100 ns;
	
		BEQ_PC <= X"00000003";
		JUMP <= '1';
		PCSrc <= '0';
		JUMPpC <= X"00000004";
		
		wait for 100 ns;

		BEQ_PC <= X"00000008";
		JUMP <= '0';
		PCSrc <= '1';
		JUMPpC <= X"00000002";
		wait for 100 ns;
      -- insert stimulus here 
		
		BEQ_PC <= X"0000000C";
		JUMP <= '1';
		PCSrc <= '1';
		JUMPpc <= X"00000008";
      wait for 100 ns;
		
		BEQ_PC <= X"0000000C";
		JUMP <= '0';
		PCSrc <= '1';
		JUMPpc <= X"00000008";
		wait;
   end process;

END;
