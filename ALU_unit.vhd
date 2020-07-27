----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/21/2020 09:54:37 AM
-- Design Name: 
-- Module Name: ALU_unit - Behavioral
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

entity ALU_unit is
	generic(
		constant register_size : integer := 32
		);
  Port ( 
  src_A          : in  std_logic_vector(register_size-1 downto 0);
	src_B          : in  std_logic_vector(register_size-1 downto 0);
  funct_3        : in std_logic_vector(2 downto 0);
  funct_7        : in std_logic_vector(6 downto 0);
  decoded_opcode : in  std_logic_vector(3 downto 0);
  alu_result     : out std_logic_vector(register_size-1 downto 0)
	);
end ALU_unit;

architecture rtl of ALU_unit is
  component ALU_control is
    port (
  		funct_3        : in std_logic_vector(2 downto 0);
		funct_7        : in std_logic_vector(6 downto 0);
		decoded_opcode : in  std_logic_vector(3 downto 0);
		alu_control    : out  std_logic_vector(4 downto 0)
    );
  end component ALU_control;
 
  component ALU is
    port (
			src_A       : in  std_logic_vector(register_size-1 downto 0);
			src_B       : in  std_logic_vector(register_size-1 downto 0);
			alu_control : in std_logic_vector(4 downto 0);
			alu_result  : out std_logic_vector(register_size-1 downto 0)
    );
  end component ALU;

signal alu_control_sig : std_logic_vector(4 downto 0);

begin
  alu_control_1 : ALU_control
  port map(
    	funct_3 => funct_3,
    	funct_7 => funct_7,
			decoded_opcode => decoded_opcode,
			alu_control => alu_control_sig
			);
			
  alu_1 : ALU
  port map(
			src_A => src_A,
			src_B => src_B,
			alu_control => alu_control_sig,
			alu_result => alu_result
			);

end rtl;
