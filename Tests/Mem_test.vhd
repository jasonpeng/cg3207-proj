--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:19:59 10/31/2013
-- Design Name:   
-- Module Name:   D:/AY1314/CG3207/Lab3/MEM_TEST.vhd
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
 
ENTITY MEM_TEST IS
END MEM_TEST;
 
ARCHITECTURE behavior OF MEM_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DataMemory
    PORT(
         CLK : IN  std_logic;
         RESET : IN  std_logic;
         MEM_MemWrite : IN  std_logic;
         MEM_MemToReg : IN  std_logic;
         MEM_MemRead : IN  std_logic;
         MEM_Branch : IN  std_logic;
         MEM_OVF : IN  std_logic;
         MEM_Zero : IN  std_logic;
         MEM_ALU_Result : IN  std_logic_vector(31 downto 0);
         MEM_BEQ_Addr : IN  std_logic_vector(31 downto 0);
         MEM_Data2 : IN  std_logic_vector(31 downto 0);
         MEM_REG_WriteAddr : IN  std_logic_vector(4 downto 0);
         WB_PCSrc : OUT  std_logic;
         WB_Data : OUT  std_logic_vector(31 downto 0);
         WB_ALU_Result : OUT  std_logic_vector(31 downto 0);
         WB_BEQ_Addr : OUT  std_logic_vector(31 downto 0);
         WB_REG_WriteAddr : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal MEM_MemWrite : std_logic := '0';
   signal MEM_MemToReg : std_logic := '0';
   signal MEM_MemRead : std_logic := '0';
   signal MEM_Branch : std_logic := '0';
   signal MEM_OVF : std_logic := '0';
   signal MEM_Zero : std_logic := '0';
   signal MEM_ALU_Result : std_logic_vector(31 downto 0) := (others => '0');
   signal MEM_BEQ_Addr : std_logic_vector(31 downto 0) := (others => '0');
   signal MEM_Data2 : std_logic_vector(31 downto 0) := (others => '0');
   signal MEM_REG_WriteAddr : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal WB_PCSrc : std_logic;
   signal WB_Data : std_logic_vector(31 downto 0);
   signal WB_ALU_Result : std_logic_vector(31 downto 0);
   signal WB_BEQ_Addr : std_logic_vector(31 downto 0);
   signal WB_REG_WriteAddr : std_logic_vector(4 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DataMemory PORT MAP (
          CLK => CLK,
          RESET => RESET,
          MEM_MemWrite => MEM_MemWrite,
          MEM_MemToReg => MEM_MemToReg,
          MEM_MemRead => MEM_MemRead,
          MEM_Branch => MEM_Branch,
          MEM_OVF => MEM_OVF,
          MEM_Zero => MEM_Zero,
          MEM_ALU_Result => MEM_ALU_Result,
          MEM_BEQ_Addr => MEM_BEQ_Addr,
          MEM_Data2 => MEM_Data2,
          MEM_REG_WriteAddr => MEM_REG_WriteAddr,
          WB_PCSrc => WB_PCSrc,
          WB_Data => WB_Data,
          WB_ALU_Result => WB_ALU_Result,
          WB_BEQ_Addr => WB_BEQ_Addr,
          WB_REG_WriteAddr => WB_REG_WriteAddr
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

      wait for CLK_period;

      -- insert stimulus here 
		-- read from address 0x4
		MEM_MemRead <= '1';
		MEM_MemWrite <= '0';
		MEM_ALU_Result <= X"00000004";
		
		wait until rising_edge(CLK);
		-- write 0xe to address 0x4
		MEM_MemRead <= '0';
		MEM_MemWrite <= '1';
		MEM_ALU_Result <= X"00000004";
		MEM_Data2 <= X"0000000E";
		
		wait until rising_edge(CLK);
		-- read again from address 0x4
		MEM_MemRead <= '1';
		MEM_MemWrite <= '0';
		MEM_ALU_Result <= X"00000004";
		
      wait;
   end process;

END;
