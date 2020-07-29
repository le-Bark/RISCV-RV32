----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/21/2020 10:13:27 AM
-- Design Name: 
-- Module Name: ALU_control - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU_control is
	Port (
		funct_3        : in  std_logic_vector(2 downto 0);
		funct_7        : in  std_logic_vector(6 downto 0);
		decoded_opcode : in  std_logic_vector(3 downto 0);
		alu_control    : out std_logic_vector(4 downto 0)
	);
end ALU_control;

architecture rtl of ALU_control is

begin
	alu_control <= "00000" when decoded_opcode = "0001" or decoded_opcode = "0010" or decoded_opcode = "0101" or 
								decoded_opcode = "0110" or (decoded_opcode = "0011" and funct_3 = "000") or
								(decoded_opcode = "0111" and funct_3 = "000") or
								(decoded_opcode = "1000" and funct_3 = "000" and funct_7 = "0000000") else
								"00001" when decoded_opcode = "1000" and funct_3 = "000" and funct_7 = "0100000" else
								"00010" when decoded_opcode = "1000" and funct_3 = "000" and funct_7 = "0000001" else
								"00011" when decoded_opcode = "1000" and funct_3 = "001" and funct_7 = "0000001" else
								"00100" when decoded_opcode = "1000" and funct_3 = "010" and funct_7 = "0000001" else
								"00101" when decoded_opcode = "1000" and funct_3 = "011" and funct_7 = "0000001" else
								"00110" when decoded_opcode = "1000" and funct_3 = "100" and funct_7 = "0000001" else
								"00111" when decoded_opcode = "1000" and funct_3 = "101" and funct_7 = "0000001" else
								"01000" when decoded_opcode = "1000" and funct_3 = "110" and funct_7 = "0000001" else
								"01001" when decoded_opcode = "1000" and funct_3 = "111" and funct_7 = "0000001" else
								"01010" when (decoded_opcode = "0111" and funct_3 = "100") or
								(decoded_opcode = "1000" and funct_3 = "100" and funct_7 = "0000000") else
								"01011" when (decoded_opcode = "0111" and funct_3 = "110") or
								(decoded_opcode = "1000" and funct_3 = "110" and funct_7 = "0000000") else
								"01100" when (decoded_opcode = "0111" and funct_3 = "111") or
								(decoded_opcode = "1000" and funct_3 = "111" and funct_7 = "0000000") else
								"01101" when (decoded_opcode = "0111" and funct_3 = "001" and funct_7 = "0000000") or 
								(decoded_opcode = "1000" and funct_3 = "001" and funct_7 = "0000000") else
								"01110" when ((decoded_opcode = "0111" or decoded_opcode = "1000") and
									funct_3 = "101" and funct_7 = "0000000") else
								"01111" when ((decoded_opcode = "0111" or decoded_opcode = "1000") and
									funct_3 = "101" and funct_7 = "0100000") else
								"10000" when (decoded_opcode = "0111" and funct_3 = "010") or
								(decoded_opcode = "1000" and funct_3 = "010" and funct_7 = "0000000") else
								"10001" when (decoded_opcode = "0111" and funct_3 = "011") or
								(decoded_opcode = "1000" and funct_3 = "011" and funct_7 = "0000000") else
								"11111";
end rtl;
