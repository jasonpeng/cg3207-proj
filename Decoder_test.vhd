--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:14:14 10/31/2013
-- Design Name:   
-- Module Name:   C:/Documents and Settings/Administrator/My Documents/Dropbox/CG3207/Lab3 Code/id_test.vhd
-- Project Name:  Lab3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Decoder
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
 
ENTITY id_test IS
END id_test;
 
ARCHITECTURE behavior OF id_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Decoder
    PORT(
         Clk : IN  std_logic;
         Reset : IN  std_logic;
         In_PC : IN  std_logic_vector(31 downto 0);
         In_Instr : IN  std_logic_vector(31 downto 0);
         write_address : IN  std_logic_vector(4 downto 0);
         WriteData : IN  std_logic_vector(31 downto 0);
         RegWrite_in : IN  std_logic;
         RegWrite : OUT  std_logic;
         MemtoReg : OUT  std_logic;
         Branch : OUT  std_logic;
         MemRead : OUT  std_logic;
         MemWrite : OUT  std_logic;
         RegDst : OUT  std_logic;
         ALUop : OUT  std_logic_vector(2 downto 0);
         ALUSrc : OUT  std_logic;
         Jump : OUT  std_logic;
         JumpPC : OUT  std_logic_vector(31 downto 0);
         Branch_Sign_Extended : OUT  std_logic_vector(31 downto 0);
         read_data_1 : OUT  std_logic_vector(31 downto 0);
         read_data_2 : OUT  std_logic_vector(31 downto 0);
         Reg_S1 : OUT  std_logic_vector(31 downto 0);
         Reg_S2 : OUT  std_logic_vector(31 downto 0);
         Reg_S3 : OUT  std_logic_vector(31 downto 0);
         Reg_S4 : OUT  std_logic_vector(31 downto 0);
         Reg_S5 : OUT  std_logic_vector(31 downto 0);
         Reg_S6 : OUT  std_logic_vector(31 downto 0);
         Reg_S7 : OUT  std_logic_vector(31 downto 0);
         Reg_S8 : OUT  std_logic_vector(31 downto 0);
         Instr_20to16 : OUT  std_logic_vector(4 downto 0);
         Instr_15to11 : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal Reset : std_logic := '0';
   signal In_PC : std_logic_vector(31 downto 0) := (others => '0');
   signal In_Instr : std_logic_vector(31 downto 0) := (others => '0');
   signal write_address : std_logic_vector(4 downto 0) := (others => '0');
   signal WriteData : std_logic_vector(31 downto 0) := (others => '0');
   signal RegWrite_in : std_logic := '0';

 	--Outputs
   signal RegWrite : std_logic;
   signal MemtoReg : std_logic;
   signal Branch : std_logic;
   signal MemRead : std_logic;
   signal MemWrite : std_logic;
   signal RegDst : std_logic;
   signal ALUop : std_logic_vector(2 downto 0);
   signal ALUSrc : std_logic;
   signal Jump : std_logic;
   signal JumpPC : std_logic_vector(31 downto 0);
   signal Branch_Sign_Extended : std_logic_vector(31 downto 0);
   signal read_data_1 : std_logic_vector(31 downto 0);
   signal read_data_2 : std_logic_vector(31 downto 0);
   signal Reg_S1 : std_logic_vector(31 downto 0);
   signal Reg_S2 : std_logic_vector(31 downto 0);
   signal Reg_S3 : std_logic_vector(31 downto 0);
   signal Reg_S4 : std_logic_vector(31 downto 0);
   signal Reg_S5 : std_logic_vector(31 downto 0);
   signal Reg_S6 : std_logic_vector(31 downto 0);
   signal Reg_S7 : std_logic_vector(31 downto 0);
   signal Reg_S8 : std_logic_vector(31 downto 0);
   signal Instr_20to16 : std_logic_vector(4 downto 0);
   signal Instr_15to11 : std_logic_vector(4 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Decoder PORT MAP (
          Clk => Clk,
          Reset => Reset,
          In_PC => In_PC,
          In_Instr => In_Instr,
          write_address => write_address,
          WriteData => WriteData,
          RegWrite_in => RegWrite_in,
          RegWrite => RegWrite,
          MemtoReg => MemtoReg,
          Branch => Branch,
          MemRead => MemRead,
          MemWrite => MemWrite,
          RegDst => RegDst,
          ALUop => ALUop,
          ALUSrc => ALUSrc,
          Jump => Jump,
          JumpPC => JumpPC,
          Branch_Sign_Extended => Branch_Sign_Extended,
          read_data_1 => read_data_1,
          read_data_2 => read_data_2,
          Reg_S1 => Reg_S1,
          Reg_S2 => Reg_S2,
          Reg_S3 => Reg_S3,
          Reg_S4 => Reg_S4,
          Reg_S5 => Reg_S5,
          Reg_S6 => Reg_S6,
          Reg_S7 => Reg_S7,
          Reg_S8 => Reg_S8,
          Instr_20to16 => Instr_20to16,
          Instr_15to11 => Instr_15to11
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
		wait for 100 ns;
		Reset <= '0';
			IN_PC <= X"10000000";
			In_Instr <= X"34010064";
			write_address <= "00001";
			Writedata <= X"00000008";
			RegWrite_in <= '1';
		wait for 100 ns;
			IN_PC <= X"10000004";
			In_Instr <= X"34020014";
			write_address <= "00010";
			Writedata <= X"0000000A";
			RegWrite_in <= '1';
		wait for 100 ns;
			IN_PC <= X"10000008";
			In_Instr <= X"00221827";
			write_address <= "00011";
			Writedata <= X"00000010";
			RegWrite_in <= '1';
      -- insert stimulus here 
		wait for 100 ns;
			IN_PC <= X"1000000C";
			In_Instr <= X"34080064";
			write_address <= "00100";
			Writedata <= X"0000000C";
			RegWrite_in <= '1';


      -- insert stimulus here 

      wait;
   end process;

END;
