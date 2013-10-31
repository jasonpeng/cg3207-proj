----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:07:34 10/30/2013 
-- Design Name: 
-- Module Name:    control - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Control is
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
		ALUOp: out std_logic_vector(2 downto 0));	-- input instruction after fetch
end Control;

architecture Behavioral of Control is
begin
			RegDst <= '1' when (InstrOp = "000000" )		-- case R format
				  else '0';											-- other cases, like lw, lui, ori
			ALUSrc <= '1' when (InstrOp = "100011" or InstrOp = "101011" or InstrOp = "001101" or InstrOp = "001111") -- case for lw and sw,lui,ori
				  else '0';																			 -- case R-format and beq
			MemtoReg <= '1' when (InstrOp = "100011")							  -- case R-format
					 else '0';																-- case lw
			RegWrite <= '1' when (InstrOp = "000000" or InstrOp = "100011" or InstrOp = "001101" or InstrOp = "001111") -- case R-format and lw, ORI,LUI
					 else '0';-- case SW and BEQ
					 
			MemRead  <= '1' when (InstrOp = "100011")								-- case for lw
					 else '0';
			MemWrite <= '1' when (InstrOp = "101011")								-- case for sw
					 else '0';		
			Branch <= '1' when (InstrOp = "000100")								-- case for beq
					 else '0';
			Jump <= '1' when (InstrOp = "000010")									-- case for jump
				 else '0';
			ALUOp <= "010" when (InstrOp = "000000")								-- case for R-format
				 else "001" when (InstrOp = "000100")								-- case for BEQ
				 else "011" when (InstrOp = "001101")								-- case for ORI
				 else "100" when (InstrOp = "001111")								-- case for LUI
				 else "000";																-- case for lw and sw,(JUMP can be ignored)
end Behavioral;

