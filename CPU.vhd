library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CPU is
    port (
        -- debug
        Control    : in    std_logic_vector ( 5 downto 0);
        Operand1   : in    std_logic_vector (31 downto 0);
        Operand2   : in    std_logic_vector (31 downto 0);
        Result1    : out   std_logic_vector (31 downto 0);
        Result2    : out   std_logic_vector (31 downto 0);
        Debug      : out   std_logic_vector (31 downto 0);
        --
         PC_OUT : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
         Reg_S1 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
         Reg_S2 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
         Reg_S3 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
         Reg_S4 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
         Reg_S5 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
         Reg_S6 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
         Reg_S7 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
         Reg_S8 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        -- cpu
        Clk, Reset : in    std_logic
    );
end CPU;

architecture Behavioral of CPU is

-- IFetch
component Fetch
    PORT(
        clk         : in std_logic;
        reset       : in std_logic;

        Instruction : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        PC_out      : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        PC_out_4    : out std_logic_vector(31 downto 0);
        BEQ_PC      : IN STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        PCSrc       : IN STD_LOGIC;
        Jump        : IN STD_LOGIC;
        JumpPC      : IN STD_LOGIC_VECTOR( 31 DOWNTO 0 )
    ); 
end component;

-- IF_ID_BUFF
component IF_ID_REG
    port( 
        Clk          : in STD_LOGIC;
        Reset        : in STD_LOGIC;
        PC_ADDR_IN   : in STD_LOGIC_VECTOR(31 downto 0);
        INST_REG_IN  : in STD_LOGIC_VECTOR(31 downto 0);
        PC_ADDR_OUT  : out STD_LOGIC_VECTOR(31 downto 0);
        INST_REG_OUT : out STD_LOGIC_VECTOR(31 downto 0)
    ); 
end component; 

-- IDecode
component Decoder
    Port ( 
        Clk,Reset            : in std_logic;
        In_PC                : in std_logic_vector (31 downto 0);
        In_Instr             : in STD_LOGIC_VECTOR(31 downto 0);

        write_address        : in std_logic_vector(4 downto 0);
        WriteData            : in  STD_LOGIC_VECTOR(31 downto 0);
        RegWrite_in          : in std_logic;

        -- wb
        RegWrite             : out std_logic;
        MemtoReg             : out std_logic;
        --Mem
        --MEM
        Branch               : OUT STD_LOGIC;
        MemRead              : OUT STD_LOGIC;
        MemWrite             : OUT STD_LOGIC;
        --EX
        RegDst               : OUT STD_LOGIC;
        ALUop                : OUT STD_LOGIC_VECTOR(2 DOWNTO 0 );
        ALUSrc               : OUT STD_LOGIC;
        --JUMP
        Jump                 : OUT STD_LOGIC;
        JumpPC               : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );

        Branch_Sign_Extended : out std_logic_vector(31 downto 0);
        read_data_1          : out std_logic_vector (31 downto 0);
        read_data_2          : out std_logic_vector (31 downto 0);
        -- Check Registers
        Reg_S1               : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        Reg_S2               : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        Reg_S3               : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        Reg_S4               : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        Reg_S5               : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        Reg_S6               : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        Reg_S7               : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        Reg_S8               : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );

        Instr_20to16         : out std_logic_vector(4 downto 0);
        Instr_15to11         : out std_logic_vector (4 downto 0)
    );
end component;

-- ID_EX_BUFF
component ID_EX_BUFF
    Port (
        CLK                   : in STD_LOGIC;
        RESET                 : in STD_LOGIC;

        -- IN --
        IN_EX_ALUOp           : in STD_LOGIC_VECTOR(2 downto 0);
        IN_EX_SignExtended    : in STD_LOGIC_VECTOR(31 downto 0);
        IN_EX_ALUSrc          : in STD_LOGIC;
        IN_EX_Data1           : in STD_LOGIC_VECTOR(31 downto 0);
        IN_EX_Data2           : in STD_LOGIC_VECTOR(31 downto 0);

        -- register writeback
        IN_EX_RegDst          : in STD_LOGIC;
        IN_EX_Instr_20_16     : in STD_LOGIC_VECTOR(4 downto 0);
        IN_EX_Instr_15_11     : in STD_LOGIC_VECTOR(4 downto 0);

        -- states received
        IN_EX_PC              : in STD_LOGIC_VECTOR(31 downto 0);
        IN_EX_MemWrite        : in STD_LOGIC;
        IN_EX_MemToReg        : in STD_LOGIC;
        IN_EX_MemRead         : in STD_LOGIC;
        IN_EX_Branch          : in STD_LOGIC;
         IN_EX_RegWrite : in STD_LOGIC;
        -- OUT --
        OUT_EX_ALUOp          : out STD_LOGIC_VECTOR(2 downto 0);
        OUT_EX_SignExtended   : out STD_LOGIC_VECTOR(31 downto 0);
        OUT_EX_ALUSrc         : out STD_LOGIC;
        OUT_EX_Data1          : out STD_LOGIC_VECTOR(31 downto 0);
        OUT_EX_Data2          : out STD_LOGIC_VECTOR(31 downto 0);

        -- register writeback
        OUT_EX_RegDst         : out STD_LOGIC;
        OUT_EX_Instr_20_16    : out STD_LOGIC_VECTOR(4 downto 0);
        OUT_EX_Instr_15_11    : out STD_LOGIC_VECTOR(4 downto 0);

        -- states received
        OUT_EX_PC             : out STD_LOGIC_VECTOR(31 downto 0);
        OUT_EX_MemWrite       : out STD_LOGIC;
        OUT_EX_MemToReg       : out STD_LOGIC;
        OUT_EX_MemRead        : out STD_LOGIC;
        OUT_EX_RegWrite : out STD_LOGIC;
        OUT_EX_Branch         : out STD_LOGIC
    );
end component;

-- IExecute
component Execute
    Port (
        CLK                   : in STD_LOGIC;
        RESET                 : in STD_LOGIC;

        ALUOp                 : in  STD_LOGIC_VECTOR(2 downto 0);
        SignExtended          : in STD_LOGIC_VECTOR(31 downto 0);
        ALUSrc                : in STD_LOGIC;
        Data1                 : in  STD_LOGIC_VECTOR(31 downto 0);
        Data2                 : in  STD_LOGIC_VECTOR(31 downto 0);

        -- register writeback
        RegDst                : in STD_LOGIC;
        Instr_20_16           : in STD_LOGIC_VECTOR(4 downto 0);
        Instr_15_11           : in STD_LOGIC_VECTOR(4 downto 0);

        -- states received
        EX_PC                 : in STD_LOGIC_VECTOR(31 downto 0);
        EX_MemWrite           : in STD_LOGIC;
        EX_MemToReg           : in STD_LOGIC;
        EX_MemRead            : in STD_LOGIC;
        EX_Branch             : in STD_LOGIC;

        -- states passed
        -- state registers
        MEM_MemWrite          : out STD_LOGIC;
        MEM_MemToReg          : out STD_LOGIC;
        MEM_MemRead           : out STD_LOGIC;
        MEM_Branch            : out STD_LOGIC;

        -- alu related
        MEM_OVF               : out STD_LOGIC;
        MEM_Zero              : out STD_LOGIC;
        MEM_ALU_Result        : out STD_LOGIC_VECTOR(31 downto 0);

        MEM_BEQ_Addr          : out STD_LOGIC_VECTOR(31 downto 0);
        MEM_Data2             : out STD_LOGIC_VECTOR(31 downto 0);
        MEM_REG_WriteAddr     : out STD_LOGIC_VECTOR(4 downto 0)
    );
end component;

-- EX_MEM_BUFF
component EX_MEM_BUFF
    Port ( 
        CLK                        : in STD_LOGIC;
        RESET                      : in STD_LOGIC;

        -- states received from EX
        -- state registers
        IN_MEM_MemWrite            : in STD_LOGIC;
        IN_MEM_MemToReg            : in STD_LOGIC;
        IN_MEM_MemRead             : in STD_LOGIC;
        IN_MEM_Branch              : in STD_LOGIC;

        -- alu related
        IN_MEM_OVF                 : in STD_LOGIC;
        IN_MEM_Zero                : in STD_LOGIC;
        IN_MEM_ALU_Result          : in STD_LOGIC_VECTOR(31 downto 0);

        IN_MEM_BEQ_Addr            : in STD_LOGIC_VECTOR(31 downto 0);
        IN_MEM_Data2               : in STD_LOGIC_VECTOR(31 downto 0);
        IN_MEM_REG_WriteAddr       : in STD_LOGIC_VECTOR(4 downto 0);

        OUT_MEM_MemWrite           : out STD_LOGIC;
        OUT_MEM_MemToReg           : out STD_LOGIC;
        OUT_MEM_MemRead            : out STD_LOGIC;
        OUT_MEM_Branch             : out STD_LOGIC;
         IN_MEM_RegWrite : in STD_LOGIC;
         OUT_MEM_RegWrite : out STD_LOGIC;
        -- alu related
        OUT_MEM_OVF                : out STD_LOGIC;
        OUT_MEM_Zero               : out STD_LOGIC;
        OUT_MEM_ALU_Result         : out STD_LOGIC_VECTOR(31 downto 0);

        OUT_MEM_BEQ_Addr           : out STD_LOGIC_VECTOR(31 downto 0);
        OUT_MEM_Data2              : out STD_LOGIC_VECTOR(31 downto 0);
        OUT_MEM_REG_WriteAddr      : out STD_LOGIC_VECTOR(4 downto 0)
    );
end component;

-- MEM
component DataMemory
    Port ( 
        CLK                        : in STD_LOGIC;
        RESET                      : in STD_LOGIC;

        -- states received from EX
        -- state registers
        MEM_MemWrite               : in STD_LOGIC;
        MEM_MemToReg               : in STD_LOGIC;
        MEM_MemRead                : in STD_LOGIC;
        MEM_Branch                 : in STD_LOGIC;

        -- alu related
        MEM_OVF                    : in STD_LOGIC;
        MEM_Zero                   : in STD_LOGIC;
        MEM_ALU_Result             : in STD_LOGIC_VECTOR(31 downto 0);

        MEM_BEQ_Addr               : in STD_LOGIC_VECTOR(31 downto 0);
        MEM_Data2                  : in STD_LOGIC_VECTOR(31 downto 0);
        MEM_REG_WriteAddr          : in STD_LOGIC_VECTOR(4 downto 0);

        WB_PCSrc                   : out STD_LOGIC;
        WB_Data                    : out  STD_LOGIC_VECTOR(31 downto 0);
        WB_ALU_Result              : out STD_LOGIC_VECTOR(31 downto 0);
        WB_BEQ_Addr                : out STD_LOGIC_VECTOR(31 downto 0);
        WB_REG_WriteAddr           : out STD_LOGIC_VECTOR(4 downto 0)
    );
end component;

-- MEM_WB_BUFF
component MEM_WB_BUFF
   Port (
        IN_MemToReg           : in  STD_LOGIC;
        IN_DataMemory_Result  : in  STD_LOGIC_VECTOR(31 downto 0);
        IN_ALU_Result         : in  STD_LOGIC_VECTOR(31 downto 0);
        IN_REG_WriteAddr      : in  STD_LOGIC_VECTOR(4 downto 0);
        IN_RegWrite : in STD_LOGIC;
        OUT_MemToReg          : out  STD_LOGIC;
        OUT_DataMemory_Result : out  STD_LOGIC_VECTOR(31 downto 0);
        OUT_ALU_Result        : out STD_LOGIC_VECTOR(31 downto 0);
        OUT_REG_WriteAddr     : out STD_LOGIC_VECTOR(4 downto 0);
        OUT_RegWrite : out STD_LOGIC;
        Clk, Reset            : in std_logic
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
        OUT_Reg_Data         : out STD_LOGIC_VECTOR(31 downto 0);
        OUT_Reg_RegWrite     : out STD_LOGIC
    );
end component;

-- Signals

-- IF
signal IFO_Instr        : std_logic_vector(31 downto 0);
signal IFO_PC_Addr      : std_logic_vector(31 downto 0);
--signal IFO_PC_4_Addr    : std_logic_vector(31 downto 0);

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
signal IDO_BEI_Data_1        : std_logic_vector (31 downto 0);
signal IDO_BEI_Data_2        : std_logic_vector (31 downto 0);
signal IDO_BEI_Instr_20_16   : std_logic_vector(4 downto 0);
signal IDO_BEI_Instr_15_11   : std_logic_vector (4 downto 0);

-- ID/EX
signal BEO_EXI_ALU_Op        : STD_LOGIC_VECTOR(2 downto 0);
signal BEO_EXI_ALU_Src       : STD_LOGIC;
signal BEO_EXI_Data_1        : STD_LOGIC_VECTOR(31 downto 0);
signal BEO_EXI_Data_2        : STD_LOGIC_VECTOR(31 downto 0);
signal BEO_EXI_RegDst        : STD_LOGIC;
signal BEO_EXI_Instru_20_16  : STD_LOGIC_VECTOR(4 downto 0);
signal BEO_EXI_Instru_15_11  : STD_LOGIC_VECTOR(4 downto 0);
signal BEO_EXI_PC_Addr       : STD_LOGIC_VECTOR(31 downto 0);
signal BEO_EXI_Branch_Extend : STD_LOGIC_VECTOR(31 downto 0);
signal BEO_EXI_MemWrite      : STD_LOGIC;
signal BEO_EXI_MemToReg      : STD_LOGIC;
signal BEO_EXI_MemRead       : STD_LOGIC;
signal BEO_EXI_MemBranch     : STD_LOGIC;
signal BEO_BMI_RegWrite      : STD_LOGIC;

-- EX
signal EXO_BMI_MemWrite      : STD_LOGIC;
signal EXO_BMI_MemToReg      : STD_LOGIC;
signal EXO_BMI_MemRead       : STD_LOGIC;
signal EXO_BMI_MemBranch     : STD_LOGIC;
signal EXO_BMI_Overflow      : STD_LOGIC;
signal EXO_BMI_Zero          : STD_LOGIC;
signal EXO_BMI_Alu_Result    : STD_LOGIC_VECTOR(31 downto 0);
signal EXO_BMI_Beq_Addr      : STD_LOGIC_VECTOR(31 downto 0);
signal EXO_BMI_Data          : STD_LOGIC_VECTOR(31 downto 0);
signal EXO_BMI_WriteAddr     : STD_LOGIC_VECTOR( 4 downto 0) ;

-- EX/MEM
signal BMO_MMI_MemWrite      : STD_LOGIC;
signal BMO_MMI_MemToReg      : STD_LOGIC;
signal BMO_MMI_MemRead       : STD_LOGIC;
signal BMO_MMI_Branch        : STD_LOGIC;
signal BMO_MMI_Overflow      : STD_LOGIC;
signal BMO_MMI_Zero          : STD_LOGIC;
signal BMO_BWI_RegWrite      : STD_LOGIC;
signal BMO_MMI_Alu_Result    : STD_LOGIC_VECTOR(31 downto 0);
signal BMO_MMI_Beq_Addr      : STD_LOGIC_VECTOR(31 downto 0);
signal BMO_MMI_Data          : STD_LOGIC_VECTOR(31 downto 0);
signal BMO_MMI_Reg_WriteAddr : STD_LOGIC_VECTOR(4 downto 0);

-- MEM
signal MMO_IFI_PC_Src        : STD_LOGIC;
signal MMO_BWI_Data          : STD_LOGIC_VECTOR(31 downto 0);
signal MMO_BWI_Alu_Result    : STD_LOGIC_VECTOR(31 downto 0);
signal MMO_IFI_Beq_Addr      : STD_LOGIC_VECTOR(31 downto 0);
signal MMO_BWI_Reg_WriteAddr : STD_LOGIC_VECTOR(4 downto 0);

-- MEM/WB
signal BWO_WBI_MemToReg      : STD_LOGIC;
signal BWO_WBI_Data          : STD_LOGIC_VECTOR(31 downto 0);
signal BWO_WBI_ALU_Result    : STD_LOGIC_VECTOR(31 downto 0);
signal BWO_WBI_Reg_WriteAddr : STD_LOGIC_VECTOR(4 downto 0);
signal BWO_IDI_RegWrite      : std_logic;

-- WB
signal WBO_IDI_WriteAddr     : std_logic_vector( 4 downto 0);
signal WBO_IDI_WriteData     : std_logic_vector(31 downto 0);


-- Debug Register
--TYPE register_file is array (0 to 7) of std_logic_vector (31 downto 0);
--    signal REG_ARR: register_file;

begin

-- IFetch
IFF: Fetch Port MAP (
        clk             => Clk,
        reset           => Reset,

        Instruction     => IFO_Instr,
        PC_out          => IFO_PC_Addr,
        PC_out_4        => PC_OUT,

        BEQ_PC          => MMO_IFI_Beq_Addr,
        PCSrc           => MMO_IFI_PC_Src,
        Jump            => IDO_IFI_Jump,
        JumpPC          => IDO_IFI_Jump_Addr
    );

-- IF_ID_BUFF
IFID: IF_ID_REG Port MAP ( 
        Clk            => Clk,
        Reset          => Reset,

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

        write_address        => WBO_IDI_WriteAddr,
        WriteData            => WBO_IDI_WriteData,
        RegWrite_in          => BWO_IDI_RegWrite,
        -- WB
        RegWrite             => IDO_BEI_RegWrite,
        MemtoReg             => IDO_BEI_MemToReg,
        --MEM
        Branch               => IDO_BEI_Branch,
        MemRead              => IDO_BEI_MemRead,
        MemWrite             => IDO_BEI_MemWrite,
        --EX
        RegDst               => IDO_BEI_RegDst,
        ALUop                => IDO_BEI_ALU_Op,
        ALUSrc               => IDO_BEI_ALU_Src,
        --JUMP
        Jump                 => IDO_IFI_Jump,
        JumpPC               => IDO_IFI_Jump_Addr,

        Branch_Sign_Extended => IDO_BEI_Branch_Extend,
        read_data_1          => IDO_BEI_Data_1,
        read_data_2          => IDO_BEI_Data_2,

        Reg_S1               => Reg_S1, --REG_ARR(0),
        Reg_S2               => Reg_S2, --REG_ARR(1),
        Reg_S3               => Reg_S3, --REG_ARR(2),
        Reg_S4               => Reg_S4, --REG_ARR(3),
        Reg_S5               => Reg_S5, --REG_ARR(4),
        Reg_S6               => Reg_S6, --REG_ARR(5),
        Reg_S7               => Reg_S7, --REG_ARR(6),
        Reg_S8               => Reg_S8, --REG_ARR(7),

        Instr_20to16         => IDO_BEI_Instr_20_16,
        Instr_15to11         => IDO_BEI_Instr_15_11
    );

-- ID_EX_BUFF
IDEX: ID_EX_BUFF Port Map (
        CLK                   => Clk,
        RESET                 => Reset,
        -- IN --
        IN_EX_ALUOp           => IDO_BEI_ALU_Op,
        IN_EX_SignExtended    => IDO_BEI_Branch_Extend,
        IN_EX_ALUSrc          => IDO_BEI_ALU_Src,
        IN_EX_Data1           => IDO_BEI_Data_1,
        IN_EX_Data2           => IDO_BEI_Data_2,

        -- register writeback
        IN_EX_RegDst          => IDO_BEI_RegDst,
        IN_EX_Instr_20_16     => IDO_BEI_Instr_20_16,
        IN_EX_Instr_15_11     => IDO_BEI_Instr_15_11,

        -- states received
        IN_EX_PC              => DBO_IDI_PC_Addr,
        IN_EX_MemWrite        => IDO_BEI_MemWrite,
        IN_EX_MemToReg        => IDO_BEI_MemToReg,
        IN_EX_MemRead         => IDO_BEI_MemRead,
        IN_EX_Branch          => IDO_BEI_Branch,
         IN_EX_RegWrite       => IDO_BEI_RegWrite,
        -- OUT --
        OUT_EX_ALUOp          => BEO_EXI_ALU_Op,
        OUT_EX_ALUSrc         => BEO_EXI_ALU_Src,
        OUT_EX_Data1          => BEO_EXI_Data_1,
        OUT_EX_Data2          => BEO_EXI_Data_2,
        OUT_EX_SignExtended   => BEO_EXI_Branch_Extend,

        -- register writeback
        OUT_EX_RegDst         => BEO_EXI_RegDst,
        OUT_EX_Instr_20_16    => BEO_EXI_Instru_20_16,
        OUT_EX_Instr_15_11    => BEO_EXI_Instru_15_11,

        -- states received
        OUT_EX_PC             => BEO_EXI_PC_Addr,
        OUT_EX_MemWrite       => BEO_EXI_MemWrite,
        OUT_EX_MemToReg       => BEO_EXI_MemToReg,
        OUT_EX_MemRead        => BEO_EXI_MemRead,
        OUT_EX_RegWrite       => BEO_BMI_RegWrite,
        OUT_EX_Branch         => BEO_EXI_MemBranch
    );

-- IExecute
IE: Execute Port Map (
        CLK                   => Clk,
        RESET                 => Reset,

        ALUOp                 => BEO_EXI_ALU_Op,
        SignExtended          => BEO_EXI_Branch_Extend,
        ALUSrc                => BEO_EXI_ALU_Src,
        Data1                 => BEO_EXI_Data_1,
        Data2                 => BEO_EXI_Data_2,

        -- register writeback
        RegDst                => BEO_EXI_RegDst,
        Instr_20_16           => BEO_EXI_Instru_20_16,
        Instr_15_11           => BEO_EXI_Instru_15_11,

        -- states received
        EX_PC                 => BEO_EXI_PC_Addr,
        EX_MemWrite           => BEO_EXI_MemWrite,
        EX_MemToReg           => BEO_EXI_MemToReg,
        EX_MemRead            => BEO_EXI_MemRead,
        EX_Branch             => BEO_EXI_MemBranch,

        -- states passed
        -- state registers
        MEM_MemWrite          => EXO_BMI_MemWrite,
        MEM_MemToReg          => EXO_BMI_MemToReg,
        MEM_MemRead           => EXO_BMI_MemRead,
        MEM_Branch            => EXO_BMI_MemBranch,

        -- alu related
        MEM_OVF               => EXO_BMI_Overflow,
        MEM_Zero              => EXO_BMI_Zero,
        MEM_ALU_Result        => EXO_BMI_Alu_Result,

        MEM_BEQ_Addr          => EXO_BMI_Beq_Addr,
        MEM_Data2             => EXO_BMI_Data,
        MEM_REG_WriteAddr     => EXO_BMI_WriteAddr
    );

-- EX_MEM_BUFF
EXMM: EX_MEM_BUFF Port Map ( 
        CLK                   => Clk,
        RESET                 => Reset,

        -- state registers
        IN_MEM_MemWrite       => EXO_BMI_MemWrite,
        IN_MEM_MemToReg       => EXO_BMI_MemToReg,
        IN_MEM_MemRead        => EXO_BMI_MemRead,
        IN_MEM_Branch         => EXO_BMI_MemBranch,

        -- alu related
        IN_MEM_OVF            => EXO_BMI_Overflow,
        IN_MEM_Zero           => EXO_BMI_Zero,
        IN_MEM_ALU_Result     => EXO_BMI_Alu_Result,

        IN_MEM_BEQ_Addr       => EXO_BMI_Beq_Addr,
        IN_MEM_Data2          => EXO_BMI_Data,
        IN_MEM_REG_WriteAddr  => EXO_BMI_WriteAddr,
        IN_MEM_RegWrite       => BEO_BMI_RegWrite,
        OUT_MEM_MemWrite      => BMO_MMI_MemWrite,
        OUT_MEM_MemToReg      => BMO_MMI_MemToReg,
        OUT_MEM_MemRead       => BMO_MMI_MemRead,
        OUT_MEM_Branch        => BMO_MMI_Branch,
        OUT_MEM_RegWrite      => BMO_BWI_RegWrite,
        
        -- alu related
        OUT_MEM_OVF           => BMO_MMI_Overflow,
        OUT_MEM_Zero          => BMO_MMI_Zero,
        OUT_MEM_ALU_Result    => BMO_MMI_Alu_Result,

        OUT_MEM_BEQ_Addr      => BMO_MMI_Beq_Addr,
        OUT_MEM_Data2         => BMO_MMI_Data,
        OUT_MEM_REG_WriteAddr => BMO_MMI_Reg_WriteAddr
    );

-- MEM
MM: DataMemory Port Map ( 
        CLK               => Clk,
        RESET             => Reset,

        MEM_MemWrite      => BMO_MMI_MemWrite,
        MEM_MemToReg      => BMO_MMI_MemToReg,
        MEM_MemRead       => BMO_MMI_MemRead,
        MEM_Branch        => BMO_MMI_Branch,
        MEM_OVF           => BMO_MMI_Overflow,
        MEM_Zero          => BMO_MMI_Zero,
        MEM_ALU_Result    => BMO_MMI_Alu_Result,
        MEM_BEQ_Addr      => BMO_MMI_Beq_Addr,
        MEM_Data2         => BMO_MMI_Data,
        MEM_REG_WriteAddr => BMO_MMI_Reg_WriteAddr,

        WB_PCSrc          => MMO_IFI_PC_Src,
        WB_Data           => MMO_BWI_Data,
        WB_ALU_Result     => MMO_BWI_Alu_Result,
        WB_BEQ_Addr       => MMO_IFI_Beq_Addr,
        WB_REG_WriteAddr  => MMO_BWI_Reg_WriteAddr
    );

-- MEM_WB_BUFF
MMWB: MEM_WB_BUFF Port Map (
        Clk                   => Clk,
        Reset                 => Reset,

        IN_MemToReg           => BMO_MMI_MemToReg,
        IN_DataMemory_Result  => MMO_BWI_Data,
        IN_ALU_Result         => MMO_BWI_Alu_Result,
        IN_REG_WriteAddr      => MMO_BWI_Reg_WriteAddr,
        IN_RegWrite           => BMO_BWI_RegWrite,
         
        OUT_MemToReg          => BWO_WBI_MemToReg,
        OUT_DataMemory_Result => BWO_WBI_Data,
        OUT_ALU_Result        => BWO_WBI_Alu_Result,
        OUT_RegWrite          => BWO_IDI_RegWrite,
        OUT_REG_WriteAddr     => BWO_WBI_Reg_WriteAddr
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

end Behavioral;
