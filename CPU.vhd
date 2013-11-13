library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CPU is
    port (
        -- debug
        Control    : IN  std_logic_vector( 5 downto 0);
        Operand1   : IN  std_logic_vector(31 downto 0);
        Operand2   : IN  std_logic_vector(31 downto 0);
        Result1    : OUT std_logic_vector(31 downto 0);
        Result2    : OUT std_logic_vector(31 downto 0);
        Debug      : OUT std_logic_vector(31 downto 0);
        -- cpu
		  REG1					  : out std_logic_vector(31 downto 0);
		  REG2					  : out std_logic_vector(31 downto 0);
		  REG3					  : out std_logic_vector(31 downto 0);
		  REG4					  : out std_logic_vector(31 downto 0);
		  REG5					  : out std_logic_vector(31 downto 0);
		  REG6					  : out std_logic_vector(31 downto 0);
		  REG7					  : out std_logic_vector(31 downto 0);
		  REG8					  : out std_logic_vector(31 downto 0);
		  ALU_OP					  : out std_logic_vector(2 downto 0);
        Clk, Reset : IN  std_logic
    );
end CPU;

architecture Behavioral of CPU is

-- IFetch
component Fetch
    PORT(
        Clk         : in std_logic;
        Reset       : in std_logic;

        In_stall_if : in std_logic;
        BEQ_PC      : IN STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        PCSrc       : IN STD_LOGIC;
        Jump        : IN STD_LOGIC;
        JumpPC      : IN STD_LOGIC_VECTOR( 31 DOWNTO 0 );

        Instruction : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        PC_out      : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        IF_ID_Flush : out std_logic
    ); 
end component;

-- IF_ID_BUFF
component IF_ID_REG
    port( 
        Clk          : in STD_LOGIC;
        Reset        : in STD_LOGIC;

        IF_ID_FLUSH  : in std_logic;
        PC_ADDR_IN   : in STD_LOGIC_VECTOR(31 downto 0);
        INST_REG_IN  : in STD_LOGIC_VECTOR(31 downto 0);

        PC_ADDR_OUT  : out STD_LOGIC_VECTOR(31 downto 0);
        INST_REG_OUT : out STD_LOGIC_VECTOR(31 downto 0)
    ); 
end component; 

-- IDecode
component Decoder
    Port ( 
        Clk                  : in std_logic;
        Reset                : in std_logic;

        In_PC                : in std_logic_vector (31 downto 0);
        In_Instr             : in STD_LOGIC_VECTOR(31 downto 0);

        -- Register Write In
        Write_Address        : in std_logic_vector(4 downto 0);
        WriteData1           : in STD_LOGIC_VECTOR(31 downto 0);
        WriteData2           : in STD_LOGIC_VECTOR(31 downto 0);
        Mul_or_Div           : in std_logic;
        RegWrite_in          : in std_logic;

        -- Data Hazzard
        ID_EX_MEM_READ       : in std_logic;
        ID_EX_REG_RT         : in std_logic_vector(4 downto 0);
        ID_STALL             : out std_logic;

        --WB
        RegWrite             : out std_logic;
        MemtoReg             : out std_logic;
        --MEM
        MemRead              : OUT STD_LOGIC;
        MemWrite             : OUT STD_LOGIC;
        --EX
        RegDst               : OUT STD_LOGIC;
        ALUop                : OUT STD_LOGIC_VECTOR(2 DOWNTO 0 );
        ALUSrc               : OUT STD_LOGIC;
        --JUMP
        Jump                 : OUT STD_LOGIC;
        JumpPC               : OUT STD_LOGIC_VECTOR(31 DOWNTO 0 );
        --Decode
        EX_MEM_REG_RD        : in std_logic_vector(4 downto 0);
        Branch_Sign_Extended : out std_logic_vector(31 downto 0);
        PCSrc                : OUT STD_LOGIC;
        Read_data_1          : out std_logic_vector(31 downto 0);
        Read_data_2          : out std_logic_vector(31 downto 0);

        -- Check Registers
        Reg_S1               : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        Reg_S2               : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        Reg_S3               : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        Reg_S4               : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        Reg_S5               : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        Reg_S6               : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        Reg_S7               : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        Reg_S8               : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );

        Instr_25to21         : out std_logic_vector(4 downto 0);
        Instr_20to16         : out std_logic_vector(4 downto 0);
        Instr_15to11         : out std_logic_vector(4 downto 0)
    );
end component;

-- ID_EX_BUFF
component ID_EX_BUFF
    Port (
        CLK                   : in STD_LOGIC;
        RESET                 : in STD_LOGIC;

        -- IN --
        IN_ID_ALUOp           : in STD_LOGIC_VECTOR(2 downto 0);
        IN_ID_SignExtended    : in STD_LOGIC_VECTOR(31 downto 0);
        IN_ID_ALUSrc          : in STD_LOGIC;
        IN_ID_Data1           : in STD_LOGIC_VECTOR(31 downto 0);
        IN_ID_Data2           : in STD_LOGIC_VECTOR(31 downto 0);

        -- register writeback
        IN_ID_RegDst          : in STD_LOGIC;
        IN_ID_Instr_25_21     : in STD_LOGIC_VECTOR(4 downto 0);
        IN_ID_Instr_20_16     : in STD_LOGIC_VECTOR(4 downto 0);
        IN_ID_Instr_15_11     : in STD_LOGIC_VECTOR(4 downto 0);

        -- states received
        IN_ID_MemWrite        : in STD_LOGIC;
        IN_ID_MemToReg        : in STD_LOGIC;
        IN_ID_MemRead         : in STD_LOGIC;
        IN_ID_RegWrite        : in STD_LOGIC;

        -- OUT --
        OUT_EX_ALUOp          : out STD_LOGIC_VECTOR(2 downto 0);
        OUT_EX_SignExtended   : out STD_LOGIC_VECTOR(31 downto 0);
        OUT_EX_ALUSrc         : out STD_LOGIC;
        OUT_EX_Data1          : out STD_LOGIC_VECTOR(31 downto 0);
        OUT_EX_Data2          : out STD_LOGIC_VECTOR(31 downto 0);

        -- register writeback
        OUT_EX_RegDst         : out STD_LOGIC;
        OUT_EX_Instr_25_21    : out STD_LOGIC_VECTOR(4 downto 0);
        OUT_EX_Instr_20_16    : out STD_LOGIC_VECTOR(4 downto 0);
        OUT_EX_Instr_15_11    : out STD_LOGIC_VECTOR(4 downto 0);

        -- states received
        OUT_EX_MemWrite       : out STD_LOGIC;
        OUT_EX_MemToReg       : out STD_LOGIC;
        OUT_EX_MemRead        : out STD_LOGIC;
        OUT_EX_RegWrite       : out STD_LOGIC
    );
end component;

-- IExecute
component Execute
    Port (
        IN_ID_EX_ALUOp         : in  STD_LOGIC_VECTOR(2 downto 0);
        IN_ID_EX_SignExtended  : in STD_LOGIC_VECTOR(31 downto 0);
        IN_ID_EX_ALUSrc        : in STD_LOGIC;
        IN_ID_EX_Data1         : in  STD_LOGIC_VECTOR(31 downto 0);
        IN_ID_EX_Data2         : in  STD_LOGIC_VECTOR(31 downto 0);

        IN_ID_EX_RegDst        : in STD_LOGIC;
        IN_ID_EX_Instr_25_21   : in STD_LOGIC_VECTOR(4 downto 0);
        IN_ID_EX_Instr_20_16   : in STD_LOGIC_VECTOR(4 downto 0);
        IN_ID_EX_Instr_15_11   : in STD_LOGIC_VECTOR(4 downto 0);

        -- forward unit
        IN_EX_MM_RegWrite      : in STD_LOGIC;
        IN_EX_MM_RD            : in STD_LOGIC_VECTOR(4 downto 0);
        IN_EX_MM_ALU_Result    : in STD_LOGIC_VECTOR(31 downto 0);
        IN_MM_WB_RegWrite      : in STD_LOGIC;
        IN_MM_WB_RD            : in STD_LOGIC_VECTOR(4 downto 0);
        IN_WB_Reg_Data         : in STD_LOGIC_VECTOR(31 downto 0);

        -- alu related
        OUT_EX_MM_OVF          : out STD_LOGIC;
        OUT_EX_MM_Zero         : out STD_LOGIC;
        OUT_EX_MM_ALU_Result_1 : out STD_LOGIC_VECTOR(31 downto 0);
        OUT_EX_MM_ALU_Result_2 : out STD_LOGIC_VECTOR(31 downto 0);
        OUT_EX_MM_MULDIV       : out STD_LOGIC;

        OUT_EX_MM_RegWriteAddr : out STD_LOGIC_VECTOR(4 downto 0)
    );
end component;

-- EX_MEM_BUFF
component EX_MEM_BUFF
    Port ( 
        CLK                        : in STD_LOGIC;
        RESET                      : in STD_LOGIC;

        -- states received from EX
        -- state registers
        IN_EX_MemWrite             : in STD_LOGIC;
        IN_EX_MemToReg             : in STD_LOGIC;
        IN_EX_MemRead              : in STD_LOGIC;
        IN_EX_RegWrite             : in STD_LOGIC;

        -- alu related
        IN_EX_OVF                  : in STD_LOGIC;
        IN_EX_Zero                 : in STD_LOGIC;
        IN_EX_ALU_Result           : in STD_LOGIC_VECTOR(31 downto 0);
        IN_EX_ALU_Result_2         : in STD_LOGIC_VECTOR(31 downto 0);
        IN_EX_MULDIV               : in STD_LOGIC;

        IN_EX_Data2                : in STD_LOGIC_VECTOR(31 downto 0);
        IN_EX_REG_WriteAddr        : in STD_LOGIC_VECTOR(4 downto 0);

        OUT_MEM_MemWrite           : out STD_LOGIC;
        OUT_MEM_MemToReg           : out STD_LOGIC;
        OUT_MEM_MemRead            : out STD_LOGIC;
        OUT_MEM_RegWrite           : out STD_LOGIC;

        -- alu related
        OUT_MEM_OVF                : out STD_LOGIC;
        OUT_MEM_Zero               : out STD_LOGIC;
        OUT_MEM_ALU_Result         : out STD_LOGIC_VECTOR(31 downto 0);
        OUT_MEM_ALU_Result_2       : out STD_LOGIC_VECTOR(31 downto 0);
        OUT_MEM_MULDIV             : out STD_LOGIC;

        OUT_MEM_Data2              : out STD_LOGIC_VECTOR(31 downto 0);
        OUT_MEM_REG_WriteAddr      : out STD_LOGIC_VECTOR(4 downto 0)
    );
end component;

-- MEM
component DataMemory
    Port ( 
        CLK                        : in STD_LOGIC;
        RESET                      : in STD_LOGIC;

        -- state registers
        IN_EX_MM_MemWrite          : in STD_LOGIC;
        IN_EX_MM_MemRead           : in STD_LOGIC;

        -- alu related
        IN_EX_MM_ALU_Result        : in STD_LOGIC_VECTOR(31 downto 0);
        IN_EX_MM_Data2             : in STD_LOGIC_VECTOR(31 downto 0);

        OUT_MM_WB_Data             : out  STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

-- MEM_WB_BUFF
component MEM_WB_BUFF
    Port (
        Clk, Reset            : in std_logic;

        IN_MemToReg           : in STD_LOGIC;
        IN_DataMemory_Result  : in STD_LOGIC_VECTOR(31 downto 0);
        IN_ALU_Result         : in STD_LOGIC_VECTOR(31 downto 0);
        IN_ALU_Result_2       : in STD_LOGIC_VECTOR(31 downto 0);
        IN_MUL_DIV            : in STD_LOGIC;
        IN_REG_WriteAddr      : in STD_LOGIC_VECTOR(4 downto 0);
        IN_RegWrite           : in STD_LOGIC;

        OUT_MemToReg          : out STD_LOGIC;
        OUT_DataMemory_Result : out STD_LOGIC_VECTOR(31 downto 0);
        OUT_ALU_Result        : out STD_LOGIC_VECTOR(31 downto 0);
        OUT_ALU_Result_2      : out STD_LOGIC_VECTOR(31 downto 0);
        OUT_MUL_DIV           : out STD_LOGIC;
        OUT_REG_WriteAddr     : out STD_LOGIC_VECTOR(4 downto 0);
        OUT_RegWrite          : out STD_LOGIC
    );
end component;

-- WB
component WriteBack
    Port (
        IN_DataMemory_Result : in  STD_LOGIC_VECTOR(31 downto 0);
        IN_ALU_Result        : in  STD_LOGIC_VECTOR(31 downto 0);
        IN_MemToReg          : in  STD_LOGIC;
        IN_Reg_WriteAddr     : in  STD_LOGIC_VECTOR(4 downto 0);

        OUT_Reg_WriteAddr    : out STD_LOGIC_VECTOR(4 downto 0);
        OUT_Reg_Data         : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component;

-- Signals

-- IF
signal IFO_Instr        : std_logic_vector(31 downto 0);
signal IFO_PC_Addr      : std_logic_vector(31 downto 0);
signal IFO_Flush        : std_logic;

-- IF/ID
signal DBO_IDI_Instr    : std_logic_vector(31 downto 0);
signal DBO_IDI_PC_Addr  : std_logic_vector(31 downto 0);

-- ID
signal IDO_BEI_RegWrite      : std_logic;
signal IDO_BEI_MemToReg      : std_logic;
signal IDO_BEI_Branch        : std_logic;
signal IDO_BEI_MemRead       : std_logic;
signal IDO_BEI_MemWrite      : std_logic;
signal IDO_BEI_RegDst        : std_logic;
signal IDO_BEI_ALU_Op        : std_logic_vector(2 downto 0);
signal IDO_BEI_ALU_Src       : std_logic;
signal IDO_IFI_Jump          : std_logic;
signal IDO_IFI_Jump_Addr     : std_logic_vector(31 downto 0);
signal IDO_BEI_Branch_Extend : std_logic_vector(31 downto 0);
signal IDO_BEI_PCSrc         : std_logic;
signal IDO_BEI_Data_1        : std_logic_vector (31 downto 0);
signal IDO_BEI_Data_2        : std_logic_vector (31 downto 0);
signal IDO_BEI_Instr_25_21   : std_logic_vector(4 downto 0);
signal IDO_BEI_Instr_20_16   : std_logic_vector(4 downto 0);
signal IDO_BEI_Instr_15_11   : std_logic_vector (4 downto 0);
signal IDO_IFI_STALL         : std_logic;
signal ID_REG1					  : std_logic_vector(31 downto 0);
signal ID_REG2					  : std_logic_vector(31 downto 0);
signal ID_REG3					  : std_logic_vector(31 downto 0);
signal ID_REG4					  : std_logic_vector(31 downto 0);
signal ID_REG5					  : std_logic_vector(31 downto 0);
signal ID_REG6					  : std_logic_vector(31 downto 0);
signal ID_REG7				  : std_logic_vector(31 downto 0);
signal ID_REG8					  : std_logic_vector(31 downto 0);

-- ID/EX
signal BEO_EXI_ALU_Op        : STD_LOGIC_VECTOR(2 downto 0);
signal BEO_EXI_ALU_Src       : STD_LOGIC;
signal BEO_EXI_Data_1        : STD_LOGIC_VECTOR(31 downto 0);
signal BEO_EXI_Data_2        : STD_LOGIC_VECTOR(31 downto 0);
signal BEO_EXI_RegDst        : STD_LOGIC;
signal BEO_EXI_Instru_25_21  : STD_LOGIC_VECTOR(4 downto 0);
signal BEO_EXI_Instru_20_16  : STD_LOGIC_VECTOR(4 downto 0);
signal BEO_EXI_Instru_15_11  : STD_LOGIC_VECTOR(4 downto 0);
signal BEO_EXI_PC_Addr       : STD_LOGIC_VECTOR(31 downto 0);
signal BEO_EXI_Branch_Extend : STD_LOGIC_VECTOR(31 downto 0);
signal BEO_EXI_MemWrite      : STD_LOGIC;
signal BEO_EXI_MemToReg      : STD_LOGIC;
signal BEO_EXI_MemRead       : STD_LOGIC;
signal BEO_BMI_RegWrite      : STD_LOGIC;

-- EX
signal EXO_BMI_Overflow      : STD_LOGIC;
signal EXO_BMI_Zero          : STD_LOGIC;
signal EXO_BMI_Alu_Result    : STD_LOGIC_VECTOR(31 downto 0);
signal EXO_BMI_Alu_Result_2  : STD_LOGIC_VECTOR(31 downto 0);
signal EXO_BMI_MULDIV        : STD_LOGIC;
signal EXO_BMI_WriteAddr     : STD_LOGIC_VECTOR( 4 downto 0);

-- EX/MEM
signal BMO_MMI_MemWrite      : STD_LOGIC;
signal BMO_MMI_MemToReg      : STD_LOGIC;
signal BMO_MMI_MemRead       : STD_LOGIC;
signal BMO_BWI_RegWrite      : STD_LOGIC;
signal BMO_MMI_Alu_Result    : STD_LOGIC_VECTOR(31 downto 0);
signal BMO_BWI_Alu_Result_2  : STD_LOGIC_VECTOR(31 downto 0);
signal BMO_BWI_MULDIV        : STD_LOGIC;
signal BMO_MMI_Data          : STD_LOGIC_VECTOR(31 downto 0);
signal BMO_MMI_Reg_WriteAddr : STD_LOGIC_VECTOR(4 downto 0);

-- MEM
signal MMO_BWI_Data          : STD_LOGIC_VECTOR(31 downto 0);

-- MEM/WB
signal BWO_WBI_MemToReg      : STD_LOGIC;
signal BWO_WBI_Data          : STD_LOGIC_VECTOR(31 downto 0);
signal BWO_WBI_ALU_Result    : STD_LOGIC_VECTOR(31 downto 0);
signal BWO_WBI_ALU_Result_2  : STD_LOGIC_VECTOR(31 downto 0);
signal BWO_WBI_MUL_DIV       : std_logic;
signal BWO_WBI_Reg_WriteAddr : STD_LOGIC_VECTOR(4 downto 0);
signal BWO_IDI_RegWrite      : std_logic;

-- WB
signal WBO_IDI_WriteAddr     : std_logic_vector( 4 downto 0);
signal WBO_IDI_WriteData     : std_logic_vector(31 downto 0);

begin

-- IFetch
IFF: Fetch Port MAP (
        Clk             => Clk,
        Reset           => Reset,

        In_stall_if     => IDO_IFI_STALL,

        BEQ_PC          => IDO_BEI_Branch_Extend,
        PCSrc           => IDO_BEI_PCSrc,

		  Jump            => IDO_IFI_Jump,
        JumpPC          => IDO_IFI_Jump_Addr,

        Instruction     => IFO_Instr,
        PC_out          => IFO_PC_Addr,
        --PC_out_4        => Result1,
        IF_ID_Flush     => IFO_Flush
    );

-- IF_ID_BUFF
IFID: IF_ID_REG Port MAP ( 
        Clk            => Clk,
        Reset          => Reset,

        IF_ID_FLUSH    => IFO_Flush,
        PC_ADDR_IN     => IFO_PC_Addr,
        INST_REG_IN    => IFO_Instr,

        PC_ADDR_OUT    => DBO_IDI_PC_Addr,
        INST_REG_OUT   => DBO_IDI_Instr
    ); 

-- IDecode
ID: Decoder Port MAP ( 
        Clk                  => Clk,
        Reset                => Reset,

        In_PC                => DBO_IDI_PC_Addr,
        In_Instr             => DBO_IDI_Instr,

        Write_Address        => WBO_IDI_WriteAddr,
        WriteData1           => WBO_IDI_WriteData,
        WriteData2           => BWO_WBI_ALU_Result_2,
        Mul_or_Div           => BWO_WBI_MUL_DIV,
        RegWrite_in          => BWO_IDI_RegWrite,

        -- Data Hazzard Detection
        ID_EX_MEM_READ       => BEO_EXI_MemRead,
        ID_EX_REG_RT         => BEO_EXI_Instru_20_16,
        ID_STALL             => IDO_IFI_STALL,

        -- WB
        RegWrite             => IDO_BEI_RegWrite,
        MemtoReg             => IDO_BEI_MemToReg,
        --MEM
        MemRead              => IDO_BEI_MemRead,
        MemWrite             => IDO_BEI_MemWrite,
        --EX
        RegDst               => IDO_BEI_RegDst,
        ALUop                => IDO_BEI_ALU_Op,
        ALUSrc               => IDO_BEI_ALU_Src,
        --JUMP
        Jump                 => IDO_IFI_Jump,
        JumpPC               => IDO_IFI_Jump_Addr,

        EX_MEM_REG_RD        => BMO_MMI_Reg_WriteAddr,
        Branch_Sign_Extended => IDO_BEI_Branch_Extend,
        PCSrc                => IDO_BEI_PCSrc,
        read_data_1          => IDO_BEI_Data_1,
        read_data_2          => IDO_BEI_Data_2,

        Reg_S1               => ID_REG1,
        Reg_S2               => ID_REG2,
        Reg_S3               => ID_REG3,
        Reg_S4               => ID_REG4,
        Reg_S5               => ID_REG5,
        Reg_S6               => ID_REG6,
        Reg_S7               => ID_REG7,
        Reg_S8               => ID_REG8,

        Instr_25to21         => IDO_BEI_Instr_25_21,
        Instr_20to16         => IDO_BEI_Instr_20_16,
        Instr_15to11         => IDO_BEI_Instr_15_11
    );

-- ID_EX_BUFF
IDEX: ID_EX_BUFF Port Map (
        CLK                   => Clk,
        RESET                 => Reset,
        -- IN --
        IN_ID_ALUOp           => IDO_BEI_ALU_Op,
        IN_ID_SignExtended    => IDO_BEI_Branch_Extend,
        IN_ID_ALUSrc          => IDO_BEI_ALU_Src,
        IN_ID_Data1           => IDO_BEI_Data_1,
        IN_ID_Data2           => IDO_BEI_Data_2,

        -- register writeback
        IN_ID_RegDst          => IDO_BEI_RegDst,
        IN_ID_Instr_25_21     => IDO_BEI_Instr_25_21,
        IN_ID_Instr_20_16     => IDO_BEI_Instr_20_16,
        IN_ID_Instr_15_11     => IDO_BEI_Instr_15_11,

        -- states received
        IN_ID_MemWrite        => IDO_BEI_MemWrite,
        IN_ID_MemToReg        => IDO_BEI_MemToReg,
        IN_ID_MemRead         => IDO_BEI_MemRead,
        IN_ID_RegWrite        => IDO_BEI_RegWrite,

        -- OUT --
        OUT_EX_ALUOp          => BEO_EXI_ALU_Op,
        OUT_EX_SignExtended   => BEO_EXI_Branch_Extend,
        OUT_EX_ALUSrc         => BEO_EXI_ALU_Src,
        OUT_EX_Data1          => BEO_EXI_Data_1,
        OUT_EX_Data2          => BEO_EXI_Data_2,

        -- register writeback
        OUT_EX_RegDst         => BEO_EXI_RegDst,
        OUT_EX_Instr_25_21    => BEO_EXI_Instru_25_21,
        OUT_EX_Instr_20_16    => BEO_EXI_Instru_20_16,
        OUT_EX_Instr_15_11    => BEO_EXI_Instru_15_11,

        -- states received
        OUT_EX_MemWrite       => BEO_EXI_MemWrite,
        OUT_EX_MemToReg       => BEO_EXI_MemToReg,
        OUT_EX_MemRead        => BEO_EXI_MemRead,
        OUT_EX_RegWrite       => BEO_BMI_RegWrite
    );

-- IExecute
IE: Execute Port Map (
        IN_ID_EX_ALUOp         => BEO_EXI_ALU_Op,
        IN_ID_EX_SignExtended  => BEO_EXI_Branch_Extend,
        IN_ID_EX_ALUSrc        => BEO_EXI_ALU_Src,
        IN_ID_EX_Data1         => BEO_EXI_Data_1,
        IN_ID_EX_Data2         => BEO_EXI_Data_2,

        -- register writeback
        IN_ID_EX_RegDst        => BEO_EXI_RegDst,
        IN_ID_EX_Instr_25_21   => BEO_EXI_Instru_25_21,
        IN_ID_EX_Instr_20_16   => BEO_EXI_Instru_20_16,
        IN_ID_EX_Instr_15_11   => BEO_EXI_Instru_15_11,

        -- forward unit
        IN_EX_MM_RegWrite      => BMO_BWI_RegWrite,
        IN_EX_MM_RD            => BMO_MMI_Reg_WriteAddr,
        IN_EX_MM_ALU_Result    => BMO_MMI_Alu_Result,
        IN_MM_WB_RegWrite      => BWO_IDI_RegWrite,
        IN_MM_WB_RD            => BWO_WBI_Reg_WriteAddr,
        IN_WB_Reg_Data         => WBO_IDI_WriteData,

        -- alu related
        OUT_EX_MM_OVF          => EXO_BMI_Overflow,
        OUT_EX_MM_Zero         => EXO_BMI_Zero,
        OUT_EX_MM_ALU_Result_1 => EXO_BMI_Alu_Result,
        OUT_EX_MM_ALU_Result_2 => EXO_BMI_Alu_Result_2,
        OUT_EX_MM_MULDIV       => EXO_BMI_MULDIV,

        OUT_EX_MM_RegWriteAddr => EXO_BMI_WriteAddr
    );

-- EX_MEM_BUFF
EXMM: EX_MEM_BUFF Port Map ( 
        CLK                   => Clk,
        RESET                 => Reset,

        -- state registers
        IN_EX_MemWrite       => BEO_EXI_MemWrite,
        IN_EX_MemToReg       => BEO_EXI_MemToReg,
        IN_EX_MemRead        => BEO_EXI_MemRead,
        IN_EX_RegWrite       => BEO_BMI_RegWrite,

        -- alu related
        IN_EX_OVF            => EXO_BMI_Overflow,
        IN_EX_Zero           => EXO_BMI_Zero,
        IN_EX_ALU_Result     => EXO_BMI_Alu_Result,
        IN_EX_ALU_Result_2   => EXO_BMI_Alu_Result_2,
        IN_EX_MULDIV         => EXO_BMI_MULDIV,

        IN_EX_Data2          => BEO_EXI_Data_2,
        IN_EX_REG_WriteAddr  => EXO_BMI_WriteAddr,

        OUT_MEM_MemWrite      => BMO_MMI_MemWrite,
        OUT_MEM_MemToReg      => BMO_MMI_MemToReg,
        OUT_MEM_MemRead       => BMO_MMI_MemRead,
        OUT_MEM_RegWrite      => BMO_BWI_RegWrite,

        -- alu related
        OUT_MEM_ALU_Result    => BMO_MMI_Alu_Result,
        OUT_MEM_ALU_Result_2  => BMO_BWI_Alu_Result_2,
        OUT_MEM_MULDIV        => BMO_BWI_MULDIV,

        OUT_MEM_Data2         => BMO_MMI_Data,
        OUT_MEM_REG_WriteAddr => BMO_MMI_Reg_WriteAddr
    );

-- MEM
MM: DataMemory Port Map ( 
        CLK               => Clk,
        RESET             => Reset,

        IN_EX_MM_MemWrite => BMO_MMI_MemWrite,
        IN_EX_MM_MemRead  => BMO_MMI_MemRead,

        IN_EX_MM_ALU_Result    => BMO_MMI_Alu_Result,
        IN_EX_MM_Data2         => BMO_MMI_Data,

        OUT_MM_WB_Data           => MMO_BWI_Data
    );

-- MEM_WB_BUFF
MMWB: MEM_WB_BUFF Port Map (
        Clk                   => Clk,
        Reset                 => Reset,

        IN_MemToReg           => BMO_MMI_MemToReg,
        IN_DataMemory_Result  => MMO_BWI_Data,
        IN_ALU_Result         => BMO_MMI_Alu_Result,
        IN_ALU_Result_2       => BMO_BWI_Alu_Result_2,
        IN_MUL_DIV            => BMO_BWI_MULDIV,
        IN_REG_WriteAddr      => BMO_MMI_Reg_WriteAddr,
        IN_RegWrite           => BMO_BWI_RegWrite,

        OUT_MemToReg          => BWO_WBI_MemToReg,
        OUT_DataMemory_Result => BWO_WBI_Data,
        OUT_ALU_Result        => BWO_WBI_Alu_Result,
        OUT_ALU_Result_2      => BWO_WBI_ALU_Result_2,
        OUT_MUL_DIV           => BWO_WBI_MUL_DIV,
        OUT_REG_WriteAddr     => BWO_WBI_Reg_WriteAddr,
        OUT_RegWrite          => BWO_IDI_RegWrite
   );

-- WB
WB: WriteBack Port Map (
        IN_DataMemory_Result => BWO_WBI_Data,
        IN_ALU_Result        => BWO_WBI_Alu_Result,
        IN_MemToReg          => BWO_WBI_MemToReg,
        IN_Reg_WriteAddr     => BWO_WBI_Reg_WriteAddr,

        OUT_Reg_WriteAddr    => WBO_IDI_WriteAddr,
        OUT_Reg_Data         => WBO_IDI_WriteData
   );
--
	result1 <= IFO_Instr;
	result2<= IFO_PC_Addr;
	ALU_op <= IDO_BEI_ALU_Op;
	REG1	<= ID_REG1;
	REG2	<= ID_REG2;				  
	REG3	<= ID_REG3;				  
   REG4 <= ID_REG4;
   REG5	<=ID_REG5;				 
   REG6	 <= ID_REG6;				  
   REG7	<=ID_REG7;		 
  	REG8<=ID_REG8;

end Behavioral;
