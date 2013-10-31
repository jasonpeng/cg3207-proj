----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:16:08 10/29/2013 
-- Design Name: 
-- Module Name:    Registers - Behavioral_Registers 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decoder is
    Port ( 
			  Clk : in std_logic;
			  Reset : in std_logic;
			  In_PC : in std_logic_vector (31 downto 0); --input PC, instruction position
			  In_Instr : in STD_LOGIC_VECTOR(31 downto 0);
			 
			  write_address: in std_logic_vector(4 downto 0);
			  WriteData : in  STD_LOGIC_VECTOR(31 downto 0);
			  RegWrite_in  : in std_logic;
			  			  	  
			  -- wb
			  RegWrite: out std_logic;
			  MemtoReg: out std_logic;
			  --Mem
			  --MEM 
			  Branch : OUT STD_LOGIC; 
           MemRead : OUT STD_LOGIC; 
			  MemWrite : OUT STD_LOGIC; 
			  --EX 
           RegDst : OUT STD_LOGIC; 
			  ALUop : OUT STD_LOGIC_VECTOR( 2 DOWNTO 0 ); 
           ALUSrc : OUT STD_LOGIC; 
           --JUMP 
			  Jump : OUT STD_LOGIC; 
           JumpPC : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
			 
			  Branch_Sign_Extended: out std_logic_vector(31 downto 0);
			  read_data_1: out std_logic_vector (31 downto 0);
			  read_data_2: out std_logic_vector (31 downto 0);
-- Check Registers
				Reg_S1 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
				Reg_S2 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
				Reg_S3 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
				Reg_S4 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
				Reg_S5 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
				Reg_S6 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
				Reg_S7 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
				Reg_S8 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			  
			  Instr_20to16 : out std_logic_vector(4 downto 0);
			  Instr_15to11: out std_logic_vector (4 downto 0)
			  
			  );
end Decoder;

architecture Behavioral_Decoder of Decoder is
 component Control
	port(
		InstrOp: in std_logic_vector(5 downto 0);
		RegDst: out std_logic;
		ALUSrc:out std_logic;
		MemtoReg: out std_logic;
		RegWrite:out std_logic;
		MemRead:out std_logic;
		MemWrite:out std_logic;
		Branch: out std_logic;
		Jump: out std_logic;
		ALUOp: out std_logic_vector(2 downto 0));
 end component;-- RegWrite internal signal
 
--	Registers 
	TYPE register_file is array (0 to 31) of std_logic_vector (31 downto 0);
		signal register_array: register_file;
	
	signal read_addr1: std_logic_vector(4 downto 0);
	signal read_addr2: std_logic_vector(4 downto 0);
	signal write_addr: std_logic_vector(4 downto 0);
	signal imm_value : std_logic_vector (15 downto 0);
	
	SIGNAL ALUSrc_out : STD_LOGIC; 
	SIGNAL Branch_out : STD_LOGIC; 
	SIGNAL RegDst_out : STD_LOGIC; 
	SIGNAL Regwrite_out : STD_LOGIC; 
	SIGNAL MemWrite_out : STD_LOGIC; 
	SIGNAL MemtoReg_out : STD_LOGIC; 
	SIGNAL MemRead_out : STD_LOGIC; 
	SIGNAL ALUop_out : STD_LOGIC_VECTOR( 2 DOWNTO 0 ); 
	SIGNAL Jump_out : STD_LOGIC; 

begin

	read_addr1 <= In_Instr(25 downto 21);
	read_addr2 <= In_Instr(20 downto 16);
	imm_value <= In_Instr(15 downto 0);
	-- Read Register 1 Operation
	read_data_1 <= register_array(CONV_INTEGER(read_addr1));
	read_data_2 <= register_array(CONV_INTEGER(read_addr2));

	Branch_Sign_extended <= X"0000" & imm_value when imm_value(15)= '0' 
							else	X"FFFF" & imm_value; 
	JumpPC <= In_PC(31 downto 28) & In_Instr (25 DOWNTO 0) & "00";
	
	Jump <= Jump_out; 
	RegDst <= RegDst_out; 
	ALUSrc <= ALUSrc_out; 
	MemtoReg <= MemtoReg_out; 
	RegWrite <= RegWrite_out; 
	MemRead <= MemRead_out; 
	MemWrite <= MemWrite_out;
	Branch <= Branch_out;
	ALUOp <= ALUOp_out;
	Instr_20to16 <= In_Instr(20 downto 16);
	Instr_15to11 <= In_Instr(15 downto 11);

-- check registers;
	Reg_S1 <= register_array(1); 
	Reg_S2 <= register_array(2); 
	Reg_S3 <= register_array(3); 
	Reg_S4 <= register_array(4); 
	Reg_S5 <= register_array(5); 
	Reg_S6 <= register_array(6); 
	Reg_S7 <= register_array(7); 	
	Reg_S8 <= register_array(8);
	
	
	ctrl: control port map
		(
				InstrOp => In_Instr(31 downto 26),
				RegDst =>RegDst_out,
				ALUSrc => ALUSrc_out,
				MemtoReg => MemtoReg_out,
				RegWrite => RegWrite_out,
				MemRead => MemRead_out,
				MemWrite => MemWrite_out,
				Branch => Branch_out,
				Jump => Jump_out,
				ALUOp => ALUOp_out);
	
	process (Clk,Reset)
	begin
		if(Clk'event and Clk = '1') then
			if (Reset = '1') then
				for i in 0 to 31 loop
					register_array(i) <= CONV_STD_LOGIC_VECTOR('0',32);
				end loop;
			elsif (RegWrite_in = '1' and write_address /= 0 )then
				register_array(conv_integer(write_address)) <= Writedata;
			end if;
		end if;
	end process;
end Behavioral_Decoder;

