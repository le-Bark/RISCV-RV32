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
				0  => "00100111100000000000111111110000" , -- ADDI 3,0,FF
				1  => "01100110000000000000000000000000" , -- ADD  0,0,0
				2  => "01100110000000000000000000000000" , -- ADD  0,0,0
				3  => "01100110000000000000000000000000" , -- ADD  0,0,0
				4  => "01100110000000000000000000000000" , -- ADD  0,0,0
				5  => "01100110000000000000000000000000" , -- ADD  0,0,0
				6  => "01100110000000000000000000000000" , -- ADD  0,0,0
				7  => X"00000007" ,
				8  => X"00000008" ,
				9  => X"00000009" ,
				10 => X"00000001",
				11 => X"0000000A" ,
				12 => X"0000000B" ,
				13 => X"0000000C" ,
				14 => X"0000000D" ,
				15 => X"0000000E" ,
				16 => X"0000000F" ,
				17 => X"00000010" ,
				18 => X"00000011" ,
				19 => X"00000012" ,
				20 => X"00000013" ,
				21 => X"00000014" ,
				22 => X"00000015" ,
				23 => X"00000016" ,
				24 => X"00000017" ,
				25 => X"00000018" ,
				26 => X"00000019" ,
				27 => X"0000001A" ,
				28 => X"0000001B" ,
				29 => X"0000001C" ,
				30 => X"0000001D"
			);

	begin
		process(pc)
		begin
			instruction <= instruction_rom(to_integer(shift_right(unsigned(pc),2)));
		end process;
	end  mem;


