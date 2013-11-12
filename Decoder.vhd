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
			  WriteData1 : in  STD_LOGIC_VECTOR(31 downto 0);
			--  WriteData2: in std_logic_vector(31 downto 0);		-- in case it is a multiplication or division.
			  
			  Mul_or_Div: in std_logic;									-- to detect if it is a mul or div;
			  RegWrite_in  : in std_logic;
			  
			  -- Data Hazzard Detection
			  ID_EX_MEM_READ: in std_logic;
			  ID_EX_REG_RT: in std_logic_vector(5 downto 0);		-- ID EX Register RT
			  ID_STALL: out std_logic;
			  -- wb
			  RegWrite: out std_logic;
			  MemtoReg: out std_logic;
			  --MEM 
           MemRead : OUT STD_LOGIC; 
			  MemWrite : OUT STD_LOGIC; 
			  --EX 
           RegDst : OUT STD_LOGIC; 
			  ALUop : OUT STD_LOGIC_VECTOR( 2 DOWNTO 0 ); 
           ALUSrc : OUT STD_LOGIC; 
           --JUMP 
			  Jump : OUT STD_LOGIC; 
           JumpPC : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
			  -- Branch Controls
			  EX_MEM_REG_RD : in std_logic_vector(5 downto 0);
			  Branch_Sign_Extended: out std_logic_vector(31 downto 0);
			  PCSrc : OUT STD_LOGIC; 

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
			  Instr_25to21: out std_logic_vector(4 downto 0);
			  Instr_20to16 : out std_logic_vector(4 downto 0);
			  Instr_15to11: out std_logic_vector (4 downto 0)
			  );
end Decoder;

architecture Behavioral_Decoder of Decoder is
 component Control
	port(
		Instr: in std_logic_vector(31 downto 0);
		RegDst: out std_logic;
		ALUSrc:out std_logic;
		MemtoReg: out std_logic;
		RegWrite:out std_logic;
		MemRead:out std_logic;
		MemWrite:out std_logic;
		Jump: out std_logic;
		ALUOp: out std_logic_vector(2 downto 0));
 end component;-- RegWrite internal signal
 
--	Registers 
	TYPE register_file is array (0 to 31) of std_logic_vector (31 downto 0);
	signal register_array: register_file;
	alias opcode: std_logic_vector(5 downto 0) is In_Instr(31 downto 26);
	alias reg_rs: std_logic_vector(4 downto 0) is In_Instr(25 downto 21);
	alias reg_rt: std_logic_vector(4 downto 0) is In_Instr(20 downto 16);
	alias reg_rd: std_logic_vector(4 downto 0) is In_Instr(15 downto 11);
	alias funct: std_logic_vector(5 downto 0) is In_Instr(5 downto 0);
	signal register_low: std_logic_vector(31 downto 0);
	signal register_high: std_logic_vector(31 downto 0);
	signal write_addr: std_logic_vector(4 downto 0);
	signal imm_value : std_logic_vector (15 downto 0);
	
-- 
	SIGNAL ALUSrc_out : STD_LOGIC; 
	SIGNAL Branch_out : STD_LOGIC; 
	SIGNAL RegDst_out : STD_LOGIC; 
	SIGNAL Regwrite_out : STD_LOGIC; 
	SIGNAL MemWrite_out : STD_LOGIC; 
	SIGNAL MemtoReg_out : STD_LOGIC; 
	SIGNAL MemRead_out : STD_LOGIC; 
	SIGNAL ALUop_out : STD_LOGIC_VECTOR( 2 DOWNTO 0 ); 
	SIGNAL Jump_out : STD_LOGIC; 
-- for data hazzard detection 
	SIGNAL STALL: std_logic;
	SIGNAL hd_stall: std_logic;
-- for control branch
   signal Branch: std_logic;
	signal Forward_c: std_logic;
	signal Forward_d: std_logic;
	signal cmp_A: std_logic_vector(31 downto 0);
	signal cmp_B: std_logic_vector(31 downto 0);
	signal cmp_result: std_logic;
begin

	imm_value <= In_Instr(15 downto 0);
	-- Read Register 1 Operation
	Branch_Sign_extended <= X"0000" & imm_value when imm_value(15)= '0' 
							else	X"FFFF" & imm_value; 
	-- JumpPC = calculated address when JUMP is JAL or J	I type
	Jump <= '1' when (Opcode = "000010" or Opcode = "000011" or Opcode = "000000")-- case for jump
				else '0';
	JumpPC <= register_array(CONV_INTEGER(reg_rs)) when (Opcode= "000000")
		 else  In_PC(31 downto 28) & In_Instr (25 DOWNTO 0) & "00";
	register_array(conv_integer(reg_rd)) <= (In_PC + 4) when (Opcode = "000000" and funct = "001001") 	-- case jalr
												else register_low when (Opcode="000000" and funct= "010010")	-- case mvlo
												else register_high when (Opcode= "000000" and funct= "010000"); -- case mvhi
	
	--register_low <= writedata1 when (Mul_or_Div = '1')
		--				else x"00000000";
	--register_high <= writedata2 when (Mul_or_Div = '1')
			--			else x"00000000";
	Instr_25to21 <= reg_rs;
	Instr_20to16 <= reg_rt;
	Instr_15to11 <= reg_rd;
-- check registers;
	Reg_S1 <= register_array(1); 
	Reg_S2 <= register_array(2); 
	Reg_S3 <= register_array(3); 
	Reg_S4 <= register_array(4); 
	Reg_S5 <= register_array(5); 
	Reg_S6 <= register_array(6); 
	Reg_S7 <= register_array(7); 	
	Reg_S8 <= register_array(8);

-- Data hazzard detection
	hd_stall <= '1' when (ID_EX_MEM_READ = '1' and 
						((ID_EX_REG_RT = reg_rs) or (ID_EX_REG_RT = reg_rt)))
			 else '0';
	ID_STALL <= hd_stall; 
	STALL <= hd_stall;
	
-- Branch Control hazards

	--control signal branch is 1 when BEQ, BGEZ,BGEZAL
   Branch <= '1' when (Opcode= "000100" or Opcode="000001")								
					 else '0';
	-- for Branch cases, Forward_d is only valid in BEQ case,
	Forward_c <= '1' when (Branch = '1' and (EX_MEM_REG_RD /=0)and (EX_MEM_REG_RD = reg_rs))
					else '0';
	Forward_d <= '1' when (Opcode ="000100" and (EX_MEM_REG_RD /=0)and (EX_MEM_REG_RD = reg_rt))
					else '0';
	-- CMP_A and CMP_B IN BEQ CASE
	cmp_A <= register_array(CONV_INTEGER(EX_MEM_REG_RD)) when (Forward_c = '1')
			else register_array(CONV_INTEGER(reg_rs));
	cmp_B <= register_array(CONV_INTEGER(EX_MEM_REG_RD)) when (Forward_c = '1')
			else register_array(CONV_INTEGER(reg_rt));
	cmp_result <= '1' when ((Opcode= "000100" and (cmp_A = cmp_B))		-- case for BEQ
							or (In_Instr(31 downto 26)="000001" and (cmp_A >= X"00000000"))) --case for BGEZ & BGEZAL
					else '0';
	PCSrc <= cmp_result and Branch; 
	register_array(31) <= (In_PC + X"0000004") when ((cmp_result ='1' and Branch ='1' and (reg_rt = "10001"))
								or Opcode= "000011");	-- case JAL and BGEZAL, store PC+8 into register 31	
	ctrl: control port map
		(
				Instr => In_Instr,
				RegDst =>RegDst_out,
				ALUSrc => ALUSrc_out,
				MemtoReg => MemtoReg_out,
				RegWrite => RegWrite_out,
				MemRead => MemRead_out,
				MemWrite => MemWrite_out,
				ALUOp => ALUOp_out);
	
rf:process (Clk)
	begin
		if (Clk'event and Clk = '1') then		
			if(RegWrite_in = '1' and write_address /= 0 )then
				register_array(conv_integer(write_address)) <= Writedata1;
			end if;
		elsif(Clk'event and Clk = '0') then
			read_data_1 <= register_array(CONV_INTEGER(reg_rs));
			read_data_2 <= register_array(CONV_INTEGER(reg_rt));
		end if;
	end process;
	
pipeline: process (Clk,Reset)
	begin
		if Reset = '1' then
			  RegWrite <= '0';
			  MemtoReg <= '0';
           MemRead <='0'; 
			  MemWrite <='0'; 
           RegDst <='0'; 
			  ALUop <="000"; 
           ALUSrc <='0'; 
		elsif rising_edge (Clk) then
				if (Stall = '0') then
					RegDst <= RegDst_out; 
					ALUSrc <= ALUSrc_out; 
					MemtoReg <= MemtoReg_out; 
					RegWrite <= RegWrite_out; 
					MemRead <= MemRead_out; 
					MemWrite <= MemWrite_out;
					ALUOp <= ALUOp_out;
				end if;
				
				if (hd_stall = '1') then
				-- if pipeline is stalled by hazzard detection, insert nop
				  RegWrite <= '0';
				  MemtoReg <= '0';
				  MemRead <='0'; 
				  MemWrite <='0'; 
				  RegDst <='0'; 
				  ALUop <="000"; 
				  ALUSrc <='0'; 
				end if;
		end if;
	end process;
end Behavioral_Decoder;

