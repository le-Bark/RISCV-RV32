----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/13/2020 07:23:35 PM
-- Design Name: 
-- Module Name: registers - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity registers is
	port (
		clk : in std_logic;
		reg_write : in std_logic;
		read_reg_1 : in std_logic_vector(4 downto 0);
		read_reg_2 : in std_logic_vector(4 downto 0);
		write_reg  : in std_logic_vector(4 downto 0);
		write_data : in std_logic_vector(31 downto 0);
		read_data_1: out std_logic_vector(31 downto 0);
		read_data_2: out std_logic_vector(31 downto 0)
	);
end registers;

	architecture reg of registers is
	type ramtype is array (31 downto 0) of std_logic_vector(31 downto 0);
	signal reg_mem : ramtype;

	begin

	process(clk)
	begin
	if (rising_edge(clk)) then
		if reg_write = '1' then
			reg_mem(to_integer(unsigned(write_reg))) <= write_data;
		end if;
	end if;
	end process;

	read_data_1 <= (others => '0') when to_integer(unsigned(read_reg_1)) = 0 else
					write_data when ( (reg_write = '1') and (write_reg = read_reg_1)) else
					reg_mem(to_integer(unsigned(read_reg_1)));

	read_data_2 <= (others => '0') when to_integer(unsigned(read_reg_2)) = 0 else
					write_data when ( (reg_write = '1') and (write_reg = read_reg_2)) else
					reg_mem(to_integer(unsigned(read_reg_2)));
	
	end architecture reg;
