library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instruction_mem_strlen is
	port (
		pc          : in  std_logic_vector(31 downto 0);
		instruction : out std_logic_vector(31 downto 0)
	);

end instruction_mem_strlen;

architecture mem_strlen of instruction_mem_strlen is
	constant mem_size : positive := 64;
	TYPE romtype is array (0 to mem_size) of std_logic_vector(31 downto 0);

		constant instruction_rom : romtype := (
			0 => X"00400597" ,
			1 => X"00058593" ,
			2 => X"00c000ef" ,
			3 => X"00050093" ,
			4 => X"0200006f" ,
			5 => X"00000513" ,
			6 => X"00058283" ,
			7 => X"00028863" ,
			8 => X"00150513" ,
			9 => X"00158593" ,
			10 => X"fe0008e3" ,
			11 => X"00008067" ,
			12 => X"00000073" ,
			13 => X"00000000" ,
			14 => X"00000000" ,
			15 => X"00000000" ,
			16 => X"00000000" ,
			17 => X"00000000" ,
			18 => X"00000000" ,
			19 => X"00000000" ,
			20 => X"00000000" ,
			21 => X"00000000" ,
			22 => X"00000000" ,
			23 => X"00000000" ,
			24 => X"00000000" ,
			25 => X"00000000" ,
			26 => X"00000000" ,
			27 => X"00000000" ,
			28 => X"00000000" ,
			29 => X"00000000" ,
			30 => X"00000000" ,
			31 => X"00000000" ,
			32 => X"00000000" ,
			33 => X"00000000" ,
			34 => X"00000000" ,
			35 => X"00000000" ,
			36 => X"00000000" ,
			37 => X"00000000" ,
			38 => X"00000000" ,
			39 => X"00000000" ,
			40 => X"00000000" ,
			41 => X"00000000" ,
			42 => X"00000000" ,
			43 => X"00000000" ,
			44 => X"00000000" ,
			45 => X"00000000" ,
			46 => X"00000000" ,
			47 => X"00000000" ,
			48 => X"00000000" ,
			49 => X"00000000" ,
			50 => X"00000000" ,
			51 => X"00000000" ,
			52 => X"00000000" ,
			53 => X"00000000" ,
			54 => X"00000000" ,
			55 => X"00000000" ,
			56 => X"00000000" ,
			57 => X"00000000" ,
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
	end  mem_strlen;


