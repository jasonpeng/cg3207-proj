library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Decoder is
    Port ( 
			  Clk : in std_logic;
			  Reset : in std_logic;
			  In_PC : in std_logic_vector (31 downto 0); --input PC, instruction position
			  In_Instr : in STD_LOGIC_VECTOR(31 downto 0);
			 
			  write_address: in std_logic_vector(4 downto 0);
			  WriteData1 : in  STD_LOGIC_VECTOR(31 downto 0);
			  WriteData2: in std_logic_vector(31 downto 0);		-- in case it is a multiplication or division.
			  
			  Mul_or_Div: in std_logic;									-- to detect if it is a mul or div;
			  RegWrite_in  : in std_logic;
			  
			  -- Data Hazzard Detection
			  ID_EX_MEM_READ: in std_logic;
			  ID_EX_REG_RT: in std_logic_vector(4 downto 0);		-- ID EX Register RT
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
			  EX_MEM_REG_RD : in std_logic_vector(4 downto 0);
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
		ALUOp: out std_logic_vector(2 downto 0));
 end component;-- RegWrite internal signal
 
 component RegisterFile
	Port (
		CLK      : in STD_LOGIC;
		RESET    : in STD_LOGIC;
		RegWrite : in STD_LOGIC;
		RegWriteAddr : in STD_LOGIC_VECTOR(4 downto 0);
		RegWriteData : in STD_LOGIC_VECTOR(31 downto 0);
		RegAddr_1  : in STD_LOGIC_VECTOR(4 downto 0);
		RegAddr_2  : in STD_LOGIC_VECTOR(4 downto 0);
		RegData_1  : out STD_LOGIC_VECTOR(31 downto 0);
		RegData_2  : out STD_LOGIC_VECTOR(31 downto 0)
	);
 end component;
 
--	Registers 
	--TYPE register_file is array (0 to 31) of std_logic_vector (31 downto 0);
	--signal register_array: register_file;
	alias opcode: std_logic_vector(5 downto 0) is In_Instr(31 downto 26);
	alias reg_rs: std_logic_vector(4 downto 0) is In_Instr(25 downto 21);
	alias reg_rt: std_logic_vector(4 downto 0) is In_Instr(20 downto 16);
	alias reg_rd: std_logic_vector(4 downto 0) is In_Instr(15 downto 11);
	alias funct: std_logic_vector(5 downto 0) is In_Instr(5 downto 0);
	signal register_low: std_logic_vector(31 downto 0);
	signal register_high: std_logic_vector(31 downto 0);
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
-- for control branch
	signal Branch_PC:std_logic_vector(31 downto 0);
   signal Branch: std_logic;
	signal Forward_c: std_logic;
	signal Forward_d: std_logic;
	signal cmp_A: std_logic_vector(31 downto 0);
	signal cmp_B: std_logic_vector(31 downto 0);
	signal cmp_result: std_logic;
	
	signal RegAddr_1_buff : std_logic_vector(4 downto 0);
	signal RegAddr_2_buff : std_logic_vector(4 downto 0);
	signal RegData_1_buff : std_logic_vector(31 downto 0);
	signal RegData_2_buff : std_logic_vector(31 downto 0);
begin

	imm_value <= In_Instr(15 downto 0);
	-- Read Register 1 Operation
	Branch_PC <= X"0000" & imm_value when imm_value(15)= '0' 
							else	X"FFFF" & imm_value; 

	-- JumpPC = calculated address when JUMP is JAL or J	I type
	Jump <= '1' when (Opcode = "000010" or Opcode = "000011" or (Opcode = "000000" and funct = "001000") or (Opcode ="000000" and funct = "001001"))-- case for jump
				else '0';
	--JumpPC <= register_array(to_integer(unsigned(reg_rs))) when (Opcode= "000000")
	--	 else  In_PC(31 downto 28) & In_Instr (25 DOWNTO 0) & "00";
	JumpPC <= In_PC(31 downto 28) & In_Instr (25 DOWNTO 0) & "00";
--	-- for mul & div cases
	register_low <= writedata1 when (Mul_or_Div = '1')
					else x"00000000";
	register_high <= writedata2 when (Mul_or_Div = '1')
					else x"00000000";
	
-- Branch Control hazards

	--control signal branch is 1 when BEQ, BGEZ,BGEZAL
   Branch <= '1' when (Opcode= "000100" or Opcode="000001")								
					 else '0';
	-- for Branch cases, Forward_d is only valid in BEQ case,
	Forward_c <= '1' when (Branch = '1' and (EX_MEM_REG_RD /= "00000")and (EX_MEM_REG_RD = reg_rs))
					else '0';
	Forward_d <= '1' when (Opcode ="000100" and (EX_MEM_REG_RD /= "00000")and (EX_MEM_REG_RD = reg_rt))
					else '0';

--	register_array(31) <= (In_PC + X"0000004") when ((cmp_result ='1' and Branch ='1' and (reg_rt = "10001"))
--								or Opcode= "000011");	-- case JAL and BGEZAL, store PC+8 into register 31	
	--	register_array(to_integer(unsigned(reg_rd)) <= (In_PC + 4) when (Opcode = "000000" and funct = "001001") 	-- case jalr
--												else register_low when (Opcode="000000" and funct= "010010")	-- case mvlo
--												else register_high when (Opcode= "000000" and funct= "010000"); -- case mvhi

	read_data_1 <= RegData_1_buff;
	read_data_2 <= RegData_1_buff;

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
				
	RF0 : RegisterFile port map (
		CLK      => CLK,
		RESET    => reset,
		RegWrite => RegWrite_in,
		RegWriteAddr => write_address,
		RegWriteData => WriteData1,
		RegAddr_1  => RegAddr_1_buff,
		RegAddr_2  => RegAddr_2_buff,
		RegData_1  => RegData_1_buff,
		RegData_2  => RegData_2_buff
	);

RF_READ : process (CLK, Reset)
begin
	if (Reset='1') then
		null;
	elsif rising_edge(CLK) then
		-- CMP_A and CMP_B IN BEQ CASE
		if (Forward_c = '1') then
			RegAddr_1_buff <= EX_MEM_REG_RD;
		else 
			RegAddr_1_buff <= reg_rs;
		end if;
		
		if (Forward_d = '1') then
			RegAddr_2_buff <= EX_MEM_REG_RD;
		else
			RegAddr_2_buff <= reg_rt;
		end if;
		
		if ((Opcode= "000100" and (RegData_1_buff = RegData_2_buff))		-- case for BEQ
				or (In_Instr(31 downto 26)="000001" and (RegData_1_buff(31) ='0')))  then --case for BGEZ & BGEZAL
			cmp_result <= '1';
		else
			cmp_result <= '0';
		end if;
		
		PCSrc <= cmp_result and Branch;
	end if;
end process;

pipeline_control: process (
			  Reset,
			  In_PC,
			  In_Instr,
			  write_address,
			  WriteData1,
			  WriteData2,
			  Mul_or_Div,
			  RegWrite_in,
			  ID_EX_MEM_READ,
			  ID_EX_REG_RT)
	variable hd_stall: std_logic; 
begin
	if Reset = '1' then
		RegWrite <= '0';
		MemtoReg <= '0';
		MemRead <='0'; 
		MemWrite <='0'; 
		RegDst <='0'; 
		ALUop <="000"; 
		ALUSrc <='0'; 
	else
		if(ID_EX_MEM_READ = '1' and ((ID_EX_REG_RT = reg_rs) or (ID_EX_REG_RT = reg_rt))) then
			hd_stall:='1';
			
			RegWrite <= '0';
			MemtoReg <= '0';
			MemRead <='0'; 
			MemWrite <='0'; 
			RegDst <='0'; 
			ALUop <="000"; 
			ALUSrc <='0'; 
			Instr_25to21 <= "00000";
			Instr_20to16 <= "00000";
			Instr_15to11 <= "00000";
			Branch_Sign_extended <= X"00000000"; 	
		else
			hd_stall := '0';
			
			RegWrite <= RegWrite_out;
			MemtoReg <= MemtoReg_out;
			MemRead <= MemRead_out; 
			MemWrite <= MemWrite_out;
			RegDst <= RegDst_out; 
			ALUOp <= ALUOp_out;
			ALUSrc <= ALUSrc_out;
			Instr_25to21 <= reg_rs;
			Instr_20to16 <= reg_rt;
			Instr_15to11 <= reg_rd;
			Branch_Sign_extended <= Branch_PC;
		end if;
		
		ID_Stall <= hd_stall;
	end if;
end process;
end Behavioral_Decoder;

