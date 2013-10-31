----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:51:54 10/29/2013 
-- Design Name: 
-- Module Name:    InstructionMemory - Behavioral_InstructionMemory 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Fetch is
    PORT( 
		clk: in std_logic;
		reset: in std_logic;
		
		Instruction : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
		PC_out : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
		--PC_plus_4_out : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
		--ADD_out : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 			-- to be defined
		PC_out_4: out std_logic_vector(31 downto 0);
		BEQ_PC : IN STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
		PCSrc : IN STD_LOGIC; 
		Jump : IN STD_LOGIC; 
		JumpPC : IN STD_LOGIC_VECTOR( 31 DOWNTO 0 )	-- JUmp address
 ); 
end Fetch;

architecture Behavioral of Fetch is
	component ram_instr 
		port (      
      ADDR : in std_logic_vector(31 downto 0);
      DATA : out std_logic_vector(31 downto 0));
	end component;

		
		signal PC: std_logic_vector (31 downto 0); -- fetched instruction
		signal nextPC: std_logic_vector(31 downto 0); -- Next PC
		signal read_addr: std_logic_vector(31 downto 0);
		signal IncPC: std_logic_vector (31 downto 0); -- PC + 4
begin
	
instr_mem: ram_instr port map (ADDR => read_addr, DATA => Instruction);
-- multiplex next PC
		nextPC <= JumpPC when (Jump = '1') 
				else BEQ_PC when (PCSrc = '1')
				else incPC;
		incPC <= PC + X"00000004";			-- incPC = PC +4 ;
		PC_out <= PC;
		read_addr <= "00"&PC(31 downto 2);
		PC_out_4 <= read_addr;
	process (Clk,Reset)
	begin
		if(Clk'event and Clk = '1') then
			if (Reset = '1') then
				PC <= X"00000000"; -- currently start from 0 for test
				Instruction <= (others =>'Z');
			else
				PC <= nextPC;
			
			end if;
		end if;
	end process;
end Behavioral;

--------------------------------------------------------------------------
-- Instruction RAM
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ram_instr is
port (
      ADDR : in std_logic_vector(31 downto 0);
      DATA : out std_logic_vector(31 downto 0));
end ram_instr;

architecture syn of ram_instr is
    type rom_type is array (0 to 7) of std_logic_vector (31 downto 0);  
	 -- currently, set 0-6 for test purpose
    CONSTANT ROM : rom_type := (x"34080064",x"340900c8",x"00000000",x"00000000",x"00000000",x"00000000",x"01285020",x"00000000");
		-- ori $8,$0, 100
		--	ori $9,$0, 200
		--	nop
		--	nop
		--	nop
		--	nop
		--	add $10,$9,$8
		-- nop

begin

 -- currently just 8 instructions, after conversion, the value of ADDR should not bigger than 7
	 DATA <= ROM(conv_integer(ADDR));
end syn;

