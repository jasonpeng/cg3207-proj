--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   06:45:36 11/13/2013
-- Design Name:   
-- Module Name:   D:/Programming/gitHub/cg3207-proj/DataMemory_test.vhd
-- Project Name:  Lab3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DataMemory
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
 
ENTITY MEM_test IS
END MEM_test;
 
ARCHITECTURE behavior OF MEM_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DataMemory
    PORT(
         CLK : IN  std_logic;
         RESET : IN  std_logic;
         IN_EX_MM_MemWrite : IN  std_logic;
         IN_EX_MM_MemRead : IN  std_logic;
         IN_EX_MM_ALU_Result : IN  std_logic_vector(31 downto 0);
         IN_EX_MM_Data2 : IN  std_logic_vector(31 downto 0);
         OUT_MM_WB_Data : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal IN_EX_MM_MemWrite : std_logic := '0';
   signal IN_EX_MM_MemRead : std_logic := '0';
   signal IN_EX_MM_ALU_Result : std_logic_vector(31 downto 0) := (others => '0');
   signal IN_EX_MM_Data2 : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal OUT_MM_WB_Data : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DataMemory PORT MAP (
          CLK => CLK,
          RESET => RESET,
          IN_EX_MM_MemWrite => IN_EX_MM_MemWrite,
          IN_EX_MM_MemRead => IN_EX_MM_MemRead,
          IN_EX_MM_ALU_Result => IN_EX_MM_ALU_Result,
          IN_EX_MM_Data2 => IN_EX_MM_Data2,
          OUT_MM_WB_Data => OUT_MM_WB_Data
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin
      -- hold reset state for 100 ns.
wait for 100 ns;

-- no read nor write, expect Data = "ZZZZZZZZ"
IN_EX_MM_MemWrite <= '0';
IN_EX_MM_MemRead  <= '0';
IN_EX_MM_ALU_Result <= X"00000000";
IN_EX_MM_Data2 <= X"11111111";
wait for 100 ns;

-- read, expect Data = "0000000a"
IN_EX_MM_MemWrite <= '0';
IN_EX_MM_MemRead  <= '1';
IN_EX_MM_ALU_Result <= X"00000000";
IN_EX_MM_Data2 <= X"11111111";
wait for 100 ns;

-- write
IN_EX_MM_MemWrite <= '1';
IN_EX_MM_MemRead  <= '0';
IN_EX_MM_ALU_Result <= X"00000000";
IN_EX_MM_Data2 <= X"CCCCCCCC";
wait for 100 ns;

-- read, expect Data = "CCCCCCCC"
IN_EX_MM_MemWrite <= '0';
IN_EX_MM_MemRead  <= '1';
IN_EX_MM_ALU_Result <= X"00000000";
IN_EX_MM_Data2 <= X"11111111";
wait for 100 ns;

-- read, expect Data = "0000000b"
IN_EX_MM_MemWrite <= '0';
IN_EX_MM_MemRead  <= '1';
IN_EX_MM_ALU_Result <= X"00000004";
IN_EX_MM_Data2 <= X"11111111";
wait for 100 ns;

      wait;
   end process;

END;
