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
		In_stall_if: in std_logic;
		
		Instruction : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
		PC_out : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
		
		BEQ_PC : IN STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
		PCSrc : IN STD_LOGIC; 
		
		Jump : IN STD_LOGIC; 
		JumpPC : IN STD_LOGIC_VECTOR( 31 DOWNTO 0 );	-- JUmp address
		
		IF_ID_Flush: out std_logic
		
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
		PC_out <= incPC;
		read_addr <= "00"&PC(31 downto 2);
		IF_ID_Flush <='1' when (Jump = '1' or PCSrc = '1')				-- in case Jump and Branch, flush the IF_ID
							else '0'; 
	process (Clk,Reset)
	begin
		if (Reset = '1') then 
				PC <= X"00000000"; -- currently start from 0 for test
		elsif rising_edge (Clk) then
			if(In_stall_if = '0') then	
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
   DATA : out std_logic_vector(31 downto 0)
);
end ram_instr;

architecture syn of ram_instr is
    type rom_type is array (0 to 63) of std_logic_vector (31 downto 0);  
    
	 -- currently, set 0-6 for test purpose
    CONSTANT ROM : rom_type := (
       x"35090001",x"350a0002",x"01494820",x"00000000",
       x"00000000",x"00000000",x"00000000",x"00000000",
       x"00000000",x"00000000",x"00000000",x"00000000",
       x"00000000",x"00000000",x"00000000",x"00000000",
       x"00000000",x"00000000",x"00000000",x"00000000",
       x"00000000",x"00000000",x"00000000",x"00000000",
       x"00000000",x"00000000",x"00000000",x"00000000",
       x"00000000",x"00000000",x"00000000",x"00000000",
       x"00000000",x"00000000",x"00000000",x"00000000",
       x"00000000",x"00000000",x"00000000",x"00000000",
       X"00000000",x"00000000",x"00000000",x"00000000",
       x"00000000",x"00000000",x"00000000",x"00000000",
       x"00000000",x"00000000",x"00000000",x"00000000",
       x"00000000",x"00000000",x"00000000",x"00000000",
       x"00000000",x"00000000",x"00000000",x"00000000",
       x"00000000",x"00000000",x"00000000",x"00000000"
    );

begin
	 DATA <= ROM(conv_integer(ADDR(5 downto 0)));
end syn;