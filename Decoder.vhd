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
      
      IN_PCINSTR : in TYPE_PI;

      IN_WBWrite : in TYPE_WB_Write;
      
      Mul_or_Div: in std_logic;									-- to detect if it is a mul or div;
      
      -- Data Hazzard Detection
      ID_EX_MEM_READ: in std_logic;
      ID_EX_REG_RT: in std_logic_vector(5 downto 0);		-- ID EX Register RT
      ID_STALL: out std_logic;
      
      -- WB
      OUT_WB_Stage : out TYPE_WB_Stage;
      -- MEM
      OUT_MEM_Stage : out TYPE_MEM_Stage;
      -- EX
      OUT_EX_Stage : out TYPE_EX_Stage;
      -- JUMP
      OUT_Jump     : out TYPE_J;
      -- DATA
      OUT_DATA     : out TYPE_ID_Data;
      -- Branch
      Branch_Sign_Extended: out std_logic_vector(31 downto 0);

      -- Check Registers
      Reg_S1 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
      Reg_S2 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
      Reg_S3 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
      Reg_S4 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
      Reg_S5 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
      Reg_S6 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
      Reg_S7 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
      Reg_S8 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
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
      Branch: out std_logic;
      Jump: out std_logic;
      ALUOp: out std_logic_vector(2 downto 0));
   end component; -- RegWrite internal signal
 
   --	Registers 
	TYPE register_file is array (0 to 31) of std_logic_vector (31 downto 0);
	signal register_array: register_file;
	alias reg_rs: std_logic_vector(4 downto 0) is In_Instr(25 downto 21);
	alias reg_rt: std_logic_vector(4 downto 0) is In_Instr(20 downto 16);
	signal register_low: std_logic_vector(31 downto 0);
	signal register_high: std_logic_vector(31 downto 0);
	signal read_addr1: std_logic_vector(4 downto 0);
	signal read_addr2: std_logic_vector(4 downto 0);
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
begin

	read_addr1 <= In_Instr(25 downto 21);
	read_addr2 <= In_Instr(20 downto 16);
	imm_value <= In_Instr(15 downto 0);
	-- Read Register 1 Operation
	

	Branch_Sign_extended <= X"0000" & imm_value when imm_value(15)= '0' 
							else	X"FFFF" & imm_value; 
	-- JumpPC = rs -- JR,JALR		R type
	-- JumpPC = calculated address when JUMP is JAL or J	I type
	JumpPC <= register_array(CONV_INTEGER(In_Instr(25 downto 21))) when (In_Instr(31 downto 26) = "000000" )
				else  In_PC(31 downto 28) & In_Instr (25 DOWNTO 0) & "00" ;
	-- Reg(31) is 
	register_array(31) <= (In_PC + 4) when (In_Instr(31 downto 26)= "000011");	-- when instrop is JAL, store the jumpPC to register 31
	register_array(conv_integer(In_Instr(15 downto 11))) <= (In_PC + 4) when (In_Instr(31 downto 26) = "000000" and In_Instr(5 downto 0)  = "001001") 	-- case jalr
																				else register_low when (In_Instr(31 downto 26) ="000000" and In_Instr(5 downto 0) = "010010")	-- case mvlo
																				else register_high when (In_Instr(31 downto 26) = "000000" and In_Instr(5 downto 0) = "010000"); -- case mvhi
	
	--register_low <= writedata1 when (Mul_or_Div = '1')
		--				else x"00000000";
	--register_high <= writedata2 when (Mul_or_Div = '1')
			--			else x"00000000";
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
	ctrl: control port map
		(
				Instr => In_Instr,
				RegDst =>RegDst_out,
				ALUSrc => ALUSrc_out,
				MemtoReg => MemtoReg_out,
				RegWrite => RegWrite_out,
				MemRead => MemRead_out,
				MemWrite => MemWrite_out,
				Branch => Branch_out,
				Jump => Jump_out,
				ALUOp => ALUOp_out);
	
rf:process (Clk)
	begin
		if (Clk'event and Clk = '1') then		
			if(RegWrite_in = '1' and write_address /= 0 )then
				register_array(conv_integer(write_address)) <= Writedata1;
			end if;
		elsif(Clk'event and Clk = '0') then
			read_data_1 <= register_array(CONV_INTEGER(read_addr1));
			--read_data_2 <= register_array(CONV_INTEGER(read_addr2));
		end if;
	end process;
	
pipeline: process (Clk,Reset)
	begin
		if Reset = '1' then
			  RegWrite <= '0';
			  MemtoReg <= '0';
			  Branch <= '0';
           MemRead <='0'; 
			  MemWrite <='0'; 
           RegDst <='0'; 
			  ALUop <="000"; 
           ALUSrc <='0'; 
			  Jump <='0';
		elsif rising_edge (Clk) then
				if (Stall = '0') then
					Jump <= Jump_out; 
					RegDst <= RegDst_out; 
					ALUSrc <= ALUSrc_out; 
					MemtoReg <= MemtoReg_out; 
					RegWrite <= RegWrite_out; 
					MemRead <= MemRead_out; 
					MemWrite <= MemWrite_out;
					Branch <= Branch_out;
					ALUOp <= ALUOp_out;
				end if;
				
				if (hd_stall = '1') then
				-- if pipeline is stalled by hazzard detection, insert nop
				  RegWrite <= '0';
				  MemtoReg <= '0';
				  Branch <= '0';
				  MemRead <='0'; 
				  MemWrite <='0'; 
				  RegDst <='0'; 
				  ALUop <="000"; 
				  ALUSrc <='0'; 
				  Jump <='0'; 
				end if;
		end if;
	end process;
end Behavioral_Decoder;

