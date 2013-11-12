library IEEE;
use IEEE.STD_LOGIC_1164.all;

package CUSTOM_TYPES is
    -- 32 bits
    subtype SLV_32 is std_logic_vector(31 downto 0);
    subtype SLV_6  is std_logic_vector( 5 downto 0);
    subtype SLV_4  is std_logic_vector( 4 downto 0);
    type R32 is range 31 downto 0;
    -- R-type
    type Op     is range 31 downto 26;
    type Rs     is range 25 downto 21;
    type Rt     is range 20 downto 16;
    type Rd     is range 15 downto 11;
    type Shamt  is range 10 downto 6;
    type Funct  is range 5 downto 0;
    -- I-type
    type Offset is range 15 downto 0;
    -- J-type
    type Target is range 25 downto 0;

    type PCINSTR is
        record
            PC    : SLV_32;
            Instr : SLV_32;
        end record;

    type JUMP is
        record
            Jump      : std_logic;
            JumpPC    : SLV_32;
        end record;

    type ID_DATA is
        record
            Data_1 : SLV_32;
            Data_2 : SLV_32;
        end record;

    type EX_Stage is
        record
            RegDst : std_logic;
            ALUOp  : std_logic_vector(2 downto 0);
            ALUSrc : std_logic;
        end record;

    type ALU_Data is
        record
            OVF    : std_logic;
            Zero   : std_logic;
            Data_1 : SLV_32;
            Data_2 : SLV_32;
            MULDIV : std_logic;
        end record;

    type MEM_Stage is
        record
            Branch   : std_logic;
            MemRead  : std_logic;
            MemWrite : std_logic;
        end record;

    type MEM_Control is
        record
            MemRead  : std_logic;
            MemWrite : std_logic;
        end record;

    type WB_Stage is
        record
            RegWrite  : std_logic;
            MemToReg  : std_logic;
        end record;

    type WB_Write is
        record
            RegAddr   : std_logic;
            RegWrite  : std_logic;
            RegData1  : SLV_32;
            RegData2  : SLV_32;
        end record;

end CUSTOM_TYPES;