library IEEE;
use IEEE.STD_LOGIC_1164.all;

package CUSTOM_TYPES is
    -- 32 bits
    type Full is range 31 downto 0;
    -- R-type
    type Op is range 31 downto 26;
    type Rs is range 25 downto 21;
    type Rt is range 20 downto 16;
    type Rd is range 15 downto 11;
    type shamt is range 10 downto 6;
    type funct is range 5 downto 0;
    -- I-type
    type offset is range 15 downto 0;
    -- J-type
    type target is range 25 downto 0;

    type EX_Stage is
        record
            RegDst : std_logic;
            ALUOp  : std_logic_vector(2 downto 0);
            ALUSrc : std_logic;
        end record;

    type MEM_Stage is
        record
            Branch   : std_logic;
            MemRead  : std_logic;
            MemWrite : std_logic;
        end record;

    type WB_Stage is
        record
            RegWrite  : std_logic;
            MemToReg  : std_logic;
        end record;

end CUSTOM_TYPES;

package body CUSTOM_TYPES is

end CUSTOM_TYPES;
