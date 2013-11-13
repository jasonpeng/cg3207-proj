--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   03:07:46 11/13/2013
-- Design Name:   
-- Module Name:   C:/Users/Jason/Documents/GitHub/cg3207-proj/ALU/EX_TEST.vhd
-- Project Name:  Lab3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Execute
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
 
ENTITY EX_TEST IS
END EX_TEST;
 
ARCHITECTURE behavior OF EX_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Execute
    PORT(
         IN_ID_EX_ALUOp : IN  std_logic_vector(2 downto 0);
         IN_ID_EX_SignExtended : IN  std_logic_vector(31 downto 0);
         IN_ID_EX_ALUSrc : IN  std_logic;
         IN_ID_EX_Data1 : IN  std_logic_vector(31 downto 0);
         IN_ID_EX_Data2 : IN  std_logic_vector(31 downto 0);
         IN_ID_EX_RegDst : IN  std_logic;
         IN_ID_EX_Instr_25_21 : IN  std_logic_vector(4 downto 0);
         IN_ID_EX_Instr_20_16 : IN  std_logic_vector(4 downto 0);
         IN_ID_EX_Instr_15_11 : IN  std_logic_vector(4 downto 0);
         IN_EX_MM_RegWrite : IN  std_logic;
         IN_EX_MM_RD : IN  std_logic_vector(4 downto 0);
         IN_EX_MM_ALU_Result : IN  std_logic_vector(31 downto 0);
         IN_MM_WB_RegWrite : IN  std_logic;
         IN_MM_WB_RD : IN  std_logic_vector(4 downto 0);
         IN_WB_Reg_Data : IN  std_logic_vector(31 downto 0);
         OUT_EX_MM_OVF : OUT  std_logic;
         OUT_EX_MM_Zero : OUT  std_logic;
         OUT_EX_MM_ALU_Result_1 : OUT  std_logic_vector(31 downto 0);
         OUT_EX_MM_ALU_Result_2 : OUT  std_logic_vector(31 downto 0);
         OUT_EX_MM_MULDIV : OUT  std_logic;
         OUT_EX_MM_RegWriteAddr : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal IN_ID_EX_ALUOp : std_logic_vector(2 downto 0) := (others => '0');
   signal IN_ID_EX_SignExtended : std_logic_vector(31 downto 0) := (others => '0');
   signal IN_ID_EX_ALUSrc : std_logic := '0';
   signal IN_ID_EX_Data1 : std_logic_vector(31 downto 0) := (others => '0');
   signal IN_ID_EX_Data2 : std_logic_vector(31 downto 0) := (others => '0');
   signal IN_ID_EX_RegDst : std_logic := '0';
   signal IN_ID_EX_Instr_25_21 : std_logic_vector(4 downto 0) := (others => '0');
   signal IN_ID_EX_Instr_20_16 : std_logic_vector(4 downto 0) := (others => '0');
   signal IN_ID_EX_Instr_15_11 : std_logic_vector(4 downto 0) := (others => '0');
   signal IN_EX_MM_RegWrite : std_logic := '0';
   signal IN_EX_MM_RD : std_logic_vector(4 downto 0) := (others => '0');
   signal IN_EX_MM_ALU_Result : std_logic_vector(31 downto 0) := (others => '0');
   signal IN_MM_WB_RegWrite : std_logic := '0';
   signal IN_MM_WB_RD : std_logic_vector(4 downto 0) := (others => '0');
   signal IN_WB_Reg_Data : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal OUT_EX_MM_OVF : std_logic;
   signal OUT_EX_MM_Zero : std_logic;
   signal OUT_EX_MM_ALU_Result_1 : std_logic_vector(31 downto 0);
   signal OUT_EX_MM_ALU_Result_2 : std_logic_vector(31 downto 0);
   signal OUT_EX_MM_MULDIV : std_logic;
   signal OUT_EX_MM_RegWriteAddr : std_logic_vector(4 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Execute PORT MAP (
          IN_ID_EX_ALUOp => IN_ID_EX_ALUOp,
          IN_ID_EX_SignExtended => IN_ID_EX_SignExtended,
          IN_ID_EX_ALUSrc => IN_ID_EX_ALUSrc,
          IN_ID_EX_Data1 => IN_ID_EX_Data1,
          IN_ID_EX_Data2 => IN_ID_EX_Data2,
          IN_ID_EX_RegDst => IN_ID_EX_RegDst,
          IN_ID_EX_Instr_25_21 => IN_ID_EX_Instr_25_21,
          IN_ID_EX_Instr_20_16 => IN_ID_EX_Instr_20_16,
          IN_ID_EX_Instr_15_11 => IN_ID_EX_Instr_15_11,
          IN_EX_MM_RegWrite => IN_EX_MM_RegWrite,
          IN_EX_MM_RD => IN_EX_MM_RD,
          IN_EX_MM_ALU_Result => IN_EX_MM_ALU_Result,
          IN_MM_WB_RegWrite => IN_MM_WB_RegWrite,
          IN_MM_WB_RD => IN_MM_WB_RD,
          IN_WB_Reg_Data => IN_WB_Reg_Data,
          OUT_EX_MM_OVF => OUT_EX_MM_OVF,
          OUT_EX_MM_Zero => OUT_EX_MM_Zero,
          OUT_EX_MM_ALU_Result_1 => OUT_EX_MM_ALU_Result_1,
          OUT_EX_MM_ALU_Result_2 => OUT_EX_MM_ALU_Result_2,
          OUT_EX_MM_MULDIV => OUT_EX_MM_MULDIV,
          OUT_EX_MM_RegWriteAddr => OUT_EX_MM_RegWriteAddr
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- insert stimulus here 
		IN_ID_EX_Instr_25_21 <= "00000";
		IN_ID_EX_Instr_20_16 <= "00000";
		IN_EX_MM_RegWrite <= '0';
		IN_EX_MM_RD <= "00000";
		IN_MM_WB_RegWrite <= '0';
		IN_MM_WB_RD <= "00000";
		
		IN_ID_EX_ALUOp <= "100";
		IN_ID_EX_Data1 <= X"00000009";
		IN_ID_EX_Data2 <= X"00000002";
		IN_ID_EX_ALUSrc <= '0';
		
		
		-- multu
		IN_ID_EX_SignExtended <= X"00000029";
		
		wait for 50 ns;
		-- mult
		IN_ID_EX_SignExtended <= X"00000018";
		
		wait for 50 ns;
		-- add
		IN_ID_EX_SignExtended <= X"00000020";
		
		wait for 50 ns;
		-- sub
		IN_ID_EX_SignExtended <= X"00000022";
		
		wait for 50 ns;
		-- logical and
		IN_ID_EX_SignExtended <= X"00000024";
		
		wait for 50 ns;
		-- div
		IN_ID_EX_SignExtended <= X"0000001A";
      wait;
   end process;

END;
