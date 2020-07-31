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
	constant mem_size : positive := 64;
	TYPE romtype is array (0 to mem_size) of std_logic_vector(31 downto 0);

		constant instruction_rom : romtype := (
			0 => X"00400517" ,
			1 => X"00052503" ,
			2 => X"00400597" ,
			3 => X"ffc5a583" ,
			4 => X"004000ef" ,
			5 => X"00050663" ,
			6 => X"00058463" ,
			7 => X"00059663" ,
			8 => X"00000513" ,
			9 => X"00008067" ,
			10 => X"00400397" ,
			11 => X"fe03a383" ,
			12 => X"00400417" ,
			13 => X"fdc42403" ,
			14 => X"007571b3" ,
			15 => X"0171d193" ,
			16 => X"0075f233" ,
			17 => X"01725213" ,
			18 => X"008572b3" ,
			19 => X"0085f333" ,
			20 => X"00140413" ,
			21 => X"0082e2b3" ,
			22 => X"00836333" ,
			23 => X"004181b3" ,
			24 => X"f8118193" ,
			25 => X"0ff00213" ,
			26 => X"fa324ce3" ,
			27 => X"fa01cae3" ,
			28 => X"0102d393" ,
			29 => X"01029413" ,
			30 => X"01045413" ,
			31 => X"01035493" ,
			32 => X"01031613" ,
			33 => X"01065613" ,
			34 => X"029383b3" ,
			35 => X"02c40433" ,
			36 => X"01039393" ,
			37 => X"01045413" ,
			38 => X"0083e2b3" ,
			39 => X"40000313" ,
			40 => X"01531313" ,
			41 => X"0062f233" ,
			42 => X"00021a63" ,
			43 => X"00129293" ,
			44 => X"fff18193" ,
			45 => X"f601c6e3" ,
			46 => X"fe0216e3" ,
			47 => X"0082d293" ,
			48 => X"40000413" ,
			49 => X"00d41413" ,
			50 => X"408282b3" ,
			51 => X"00657533" ,
			52 => X"0065f5b3" ,
			53 => X"00b54533" ,
			54 => X"01719193" ,
			55 => X"00556533" ,
			56 => X"00356533" ,
			57 => X"00000073" ,
			58 => X"00000000" ,
			59 => X"00000000" ,
			60 => X"00000000" ,
			61 => X"00000000" ,
			62 => X"00000000" ,
			63 => X"00000000" ,
			64 => X"00000000" 			
						);

	begin
		process(pc)
		begin
			instruction <= instruction_rom(to_integer(shift_right(unsigned(pc),2)));
		end process;
	end  mem;


