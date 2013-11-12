--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   03:07:27 11/13/2013
-- Design Name:   
-- Module Name:   Y:/cg3207-proj/decoder_test.vhd
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
 
ENTITY decoder_test IS
END decoder_test;
 
ARCHITECTURE behavior OF decoder_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Decoder
    PORT(
         Clk : IN  std_logic;
         Reset : IN  std_logic;
         In_PC : IN  std_logic_vector(31 downto 0);
         In_Instr : IN  std_logic_vector(31 downto 0);
         write_address : IN  std_logic_vector(4 downto 0);
         
			WriteData1 : IN  std_logic_vector(31 downto 0);
         WriteData2 : IN  std_logic_vector(31 downto 0);
         
			Mul_or_Div : IN  std_logic;
         
			RegWrite_in : IN  std_logic;
         
			ID_EX_MEM_READ : IN  std_logic;
         ID_EX_REG_RT : IN  std_logic_vector(4 downto 0);
         ID_STALL : OUT  std_logic;
         
			RegWrite : OUT  std_logic;
         MemtoReg : OUT  std_logic;
         MemRead : OUT  std_logic;
         MemWrite : OUT  std_logic;
         RegDst : OUT  std_logic;
         ALUop : OUT  std_logic_vector(2 downto 0);
         ALUSrc : OUT  std_logic;
         
			Jump : OUT  std_logic;
         JumpPC : OUT  std_logic_vector(31 downto 0);
         
			EX_MEM_REG_RD : IN  std_logic_vector(4 downto 0);
         Branch_Sign_Extended : OUT  std_logic_vector(31 downto 0);
         
			PCSrc : OUT  std_logic;
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
         Instr_25to21 : OUT  std_logic_vector(4 downto 0);
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
   signal WriteData1 : std_logic_vector(31 downto 0) := (others => '0');
   signal WriteData2 : std_logic_vector(31 downto 0) := (others => '0');
   signal Mul_or_Div : std_logic := '0';
   signal RegWrite_in : std_logic := '0';
   signal ID_EX_MEM_READ : std_logic := '0';
   signal ID_EX_REG_RT : std_logic_vector(4 downto 0) := (others => '0');
   signal EX_MEM_REG_RD : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal ID_STALL : std_logic;
   signal RegWrite : std_logic;
   signal MemtoReg : std_logic;
   signal MemRead : std_logic;
   signal MemWrite : std_logic;
   signal RegDst : std_logic;
   signal ALUop : std_logic_vector(2 downto 0);
   signal ALUSrc : std_logic;
   signal Jump : std_logic;
   signal JumpPC : std_logic_vector(31 downto 0);
   signal Branch_Sign_Extended : std_logic_vector(31 downto 0);
   signal PCSrc : std_logic;
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
   signal Instr_25to21 : std_logic_vector(4 downto 0);
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
          WriteData1 => WriteData1,
          WriteData2 => WriteData2,
          Mul_or_Div => Mul_or_Div,
          RegWrite_in => RegWrite_in,
          ID_EX_MEM_READ => ID_EX_MEM_READ,
          ID_EX_REG_RT => ID_EX_REG_RT,
          ID_STALL => ID_STALL,
          RegWrite => RegWrite,
          MemtoReg => MemtoReg,
          MemRead => MemRead,
          MemWrite => MemWrite,
          RegDst => RegDst,
          ALUop => ALUop,
          ALUSrc => ALUSrc,
          Jump => Jump,
          JumpPC => JumpPC,
          EX_MEM_REG_RD => EX_MEM_REG_RD,
          Branch_Sign_Extended => Branch_Sign_Extended,
          PCSrc => PCSrc,
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
          Instr_25to21 => Instr_25to21,
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
      wait for 50 ns;	
		Reset <= '1';
		wait for 50 ns;
		Reset <= '0';
		In_PC <= X"00000001";
		In_Instr <= X"3c010064";	--lui $1,1
		RegWrite_in <='1';
		WriteData1 <= X"00000001";
		write_address <= "00001";
		wait for 100 ns;
		In_PC <= X"00000002";
		In_Instr <= X"3c030064";  --lui $2,1
		RegWrite_in <='1';
		WriteData1 <= X"00000001";
		write_address <= "00010";
		wait for 100 ns;
		In_PC <= X"00000002";
		In_Instr <= X"3c020064";  --lui $2,1
		RegWrite_in <='1';
		WriteData1 <= X"00000001";
		write_address <= "00010";
				wait for 100 ns;
		In_PC <= X"00000002";
		In_Instr <= X"3c020064";  --lui $2,1
		RegWrite_in <='1';
		WriteData1 <= X"00000001";
		write_address <= "00010";
		wait for 100 ns;
		In_PC <= X"00000002";
		In_Instr <= X"3c020064";  --lui $2,1
		RegWrite_in <='1';
		WriteData1 <= X"00000001";
		write_address <= "00010";
		wait for 100 ns;
		In_PC <= X"00000002";
		In_Instr <= X"3c020064";  --lui $2,1
		RegWrite_in <='1';
		WriteData1 <= X"00000001";
		write_address <= "00010";
		wait for 100 ns;
		In_PC <= X"00000002";
		In_Instr <= X"3c020064";  --lui $2,1
		RegWrite_in <='1';
		WriteData1 <= X"00000001";
		write_address <= "00010";






      -- insert stimulus here 

      wait;
   end process;

END;
