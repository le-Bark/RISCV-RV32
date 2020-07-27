----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/13/2020 07:27:06 PM
-- Design Name: 
-- Module Name: instruction_mem - Behavioral
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

entity instruction_mem is
	port (
		pc          : in  std_logic_vector(31 downto 0);
		instruction : out std_logic_vector(31 downto 0)
	);

end instruction_mem;

architecture mem of instruction_mem is
	constant mem_size : positive := 30;
	TYPE romtype is array (0 to mem_size) of std_logic_vector(31 downto 0);

		constant instruction_rom : romtype := (
				0  => X"00400597" , 
				1  => X"00058593" , 
				2  => X"00c000ef" , 
				3  => X"00050093" ,  
				4  => X"0200006f" , 
				5  => X"00000513" , 
				6  => X"00058283" , 
				7  => X"00028863" ,
				8  => X"00150513" ,
				9  => X"00158593" ,
				10 => X"fe0008e3" ,
				11 => X"00008067" ,
				12 => X"00000073" ,
				13 => "00000000000000000000000000110011" ,
				14 => "00000000000000000000000000110011" ,
				15 => "00000000000000000000000000110011" ,
				16 => "00000000000000000000000000110011" ,
				17 => "00000000000000000000000000110011" ,
				18 => "00000000000000000000000000110011" ,
				19 => "00000000000000000000000000110011" ,
				20 => "00000000000000000000000000110011" ,
				21 => "00000000000000000000000000110011" ,
				22 => "00000000000000000000000000110011" ,
				23 => "00000000000000000000000000110011" ,
				24 => "00000000000000000000000000110011" ,
				25 => "00000000000000000000000000110011" ,
				26 => "00000000000000000000000000110011" ,
				27 => "00000000000000000000000000110011" ,
				28 => "00000000000000000000000000110011" ,
				29 => "00000000000000000000000000110011" ,
				30 => "00000000000000000000000000110011"
			);

	begin
		process(pc)
		begin
			instruction <= instruction_rom(to_integer(shift_right(unsigned(pc),2)));
		end process;
	end  mem;


