--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   05:33:07 11/13/2013
-- Design Name:   
-- Module Name:   D:/Programming/gitHub/cg3207-proj/IF_test.vhd
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
         In_stall_if : IN  std_logic;
         Instruction : OUT  std_logic_vector(31 downto 0);
         PC_out : OUT  std_logic_vector(31 downto 0);
         PC_out_4 : OUT  std_logic_vector(31 downto 0);
         BEQ_PC : IN  std_logic_vector(31 downto 0);
         PCSrc : IN  std_logic;
         Jump : IN  std_logic;
         JumpPC : IN  std_logic_vector(31 downto 0);
         IF_ID_Flush : OUT  std_logic
        );
    END COMPONENT;

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal In_stall_if : std_logic := '0';
   signal BEQ_PC : std_logic_vector(31 downto 0) := (others => '0');
   signal PCSrc : std_logic := '0';
   signal Jump : std_logic := '0';
   signal JumpPC : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal Instruction : std_logic_vector(31 downto 0);
   signal PC_out : std_logic_vector(31 downto 0);
   signal PC_out_4 : std_logic_vector(31 downto 0);
   signal IF_ID_Flush : std_logic;

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Fetch PORT MAP (
          clk => clk,
          reset => reset,
          In_stall_if => In_stall_if,
          Instruction => Instruction,
          PC_out => PC_out,
          PC_out_4 => PC_out_4,
          BEQ_PC => BEQ_PC,
          PCSrc => PCSrc,
          Jump => Jump,
          JumpPC => JumpPC,
          IF_ID_Flush => IF_ID_Flush
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

        -- normal, expect PC_out = 00000000
        reset <= '0';
        In_stall_if <= '0';
        BEQ_PC <= X"00000002";
        PCSrc <= '0';
        Jump <= '0';
        JumpPC <= X"00000004";
        wait for 100 ns;

        -- normal, expect PC_out = 00000001
        BEQ_PC <= X"00000001";
        JUMPpC <= X"00000002";
        wait for 100 ns;

        -- jump, expect PC_out = 0000001C
        BEQ_PC <= X"00000003";
        Jump <= '1';
        JumpPC <= X"0000001C";
        wait for 100 ns;

        -- normal, expect PC_out = 00000020
        Jump <= '0';
        wait for 200 ns;

        -- beq, expect PC_out = 00000004
        PCSrc <= '1';
        BEQ_PC <= X"00000004";
        Jump <= '0';
        JumpPC <= X"00000004";
        wait for 100 ns;

        -- normal, expect PC_out = 00000005
        PCSrc <= '0';
        wait for 200 ns;

        -- stall, expect PC_out = 00000005
        In_stall_if <= '1';
        wait for 100 ns;

        -- normal, expect PC_out = 00000006
        In_stall_if <= '0';
        wait for 500 ns;

        wait;

   end process;

END;
