----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:23:47 10/31/2013 
-- Design Name: 
-- Module Name:    if_id_reg - Behavioral 
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
----------------------------------------------------------------------------------library IEEE; 
Library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.numeric_std.all; 

entity IF_ID_REG is 
	 port( 
	 Clk : in STD_LOGIC; 
	 Reset : in STD_LOGIC; 
	 PC_ADDR_IN: in STD_LOGIC_VECTOR(31 downto 0); 
	 INST_REG_IN : in STD_LOGIC_VECTOR(31 downto 0); 
	 PC_ADDR_OUT : out STD_LOGIC_VECTOR(31 downto 0); 
	 INST_REG_OUT : out STD_LOGIC_VECTOR(31 downto 0) 
	 ); 
end IF_ID_REG; 

architecture IF_ID_REG_ARC of IF_ID_REG is 

begin 
 process(Clk,Reset,PC_ADDR_IN,INST_REG_IN) 
 begin 
	 if RESET = '1' then 
	  PC_ADDR_OUT <= (others => '0'); 
	  INST_REG_OUT <= (others => '0'); 
	 elsif rising_edge(CLK) then 
	  PC_ADDR_OUT <= PC_ADDR_IN; 
	  INST_REG_OUT <= INST_REG_IN; 
    end if; 
 end process; 
end IF_ID_REG_ARC; 