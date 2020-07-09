----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/04/2020 06:18:40 PM
-- Design Name: 
-- Module Name: ALU - rtl
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
use IEEE.NUMERIC_STD.ALL;

entity ALU is
	generic(
		constant register_size : integer := 32
		);
		port (
			src_A       : in  std_logic_vector(register_size-1 downto 0) ;
			src_B       : in  std_logic_vector(register_size-1 downto 0) ;
			alu_control : in  std_logic_vector(4 downto 0);
			alu_result  : out std_logic_vector(register_size-1 downto 0)
		);
end entity ALU;

architecture rtl of ALU is
	signal src_A_sig            : unsigned(register_size-1 downto 0);
	signal src_B_sig            : unsigned(register_size-1 downto 0);
	signal result_sig           : std_logic_vector(register_size-1 downto 0);
	signal MUL_sig              : unsigned((2*register_size)-1 downto 0);
	signal MULHSU_sig           : unsigned((2*register_size)-1 downto 0);
	signal MULHU_sig            : unsigned((2*register_size)-1 downto 0);
	signal compare_signed_sig   : unsigned(1 downto 0);
	signal compare_unsigned_sig : unsigned(1 downto 0);
	signal unsigned_div_sig     : unsigned(register_size-1 downto 0);
	signal signed_div_sig       : signed(register_size-1 downto 0);
    
begin
	src_A_sig            <= unsigned(src_A);
	src_B_sig            <= unsigned(src_B);
	MUL_sig              <= unsigned(signed(src_A) * signed(src_B));
	MULHSU_sig           <= unsigned(signed(src_A) * to_integer(unsigned(src_B)));
	MULHU_sig            <= src_A_sig * src_B_sig;
	compare_signed_sig   <= "01" when (signed(src_A) < signed(src_B)) else "00";
	compare_unsigned_sig <= "01" when (unsigned(src_A) < unsigned(src_B)) else "00";
	unsigned_div_sig     <= src_A_sig / src_B_sig;
	signed_div_sig       <= signed(src_A) / signed(src_B);

	process(src_A, src_B, alu_control, src_A_sig, src_B_sig, MUL_sig, MULHSU_sig, MULHU_sig, compare_signed_sig, 
			    compare_unsigned_sig, unsigned_div_sig, signed_div_sig)
	begin
		case alu_control is
			when "00000" => --Addition
				result_sig <= std_logic_vector(src_A_sig + src_B_sig);
			when "00001" => --Subtraction
				result_sig <= std_logic_vector(src_A_sig - src_B_sig);
			when "00010" => --Multiplication
				result_sig <= std_logic_vector(resize(MUL_sig, register_size));
			when "00011" => --Multiplication upper half
				result_sig <= std_logic_vector(MUL_sig((2*register_size)-1 downto register_size));
			when "00100" => --Multiplication half signed/unsigned
				result_sig <= std_logic_vector(MULHSU_sig((2*register_size)-1 downto register_size));
			when "00101" => --Multiplication half unsigned
				result_sig <= std_logic_vector(MULHU_sig((2*register_size)-1 downto register_size));
			when "00110" => --Division
				result_sig <= std_logic_vector(unsigned(signed_div_sig));
			when "00111" => --Division unsigned
				result_sig <= std_logic_vector(unsigned_div_sig);
			when "01000" => --Remainder
				result_sig <= std_logic_vector(unsigned(resize(signed(src_A) - (signed_div_sig * signed(src_B)), register_size)));
			when "01001" => --Remainder unsigned
				result_sig <= std_logic_vector(resize(src_A_sig - (unsigned_div_sig * src_B_sig), register_size));
			when "01010" => --XOR
				result_sig <= src_A XOR src_B;
			when "01011" => --OR
				result_sig <= src_A OR src_B;
			when "01100" => --AND
				result_sig <= src_A AND src_B;
			when "01101" => --Shift left
				result_sig <= std_logic_vector(shift_left(src_A_sig, to_integer(src_B_sig)));
			when "01110" => --Shift right logical
				result_sig <= std_logic_vector(shift_right(src_A_sig, to_integer(src_B_sig)));
			when "01111" => --Shift right arithmetic
				result_sig <= std_logic_vector(shift_right(signed(src_A_sig), to_integer(src_B_sig)));
			when "10000" => --Set < (signed)
				result_sig <= std_logic_vector(resize(compare_signed_sig, register_size));
			when "10001" => --Set < (unsigned)
				result_sig <= std_logic_vector(resize(compare_unsigned_sig, register_size));
			when others =>
				result_sig <= (others => 'X');
		end case;
	end process;
    
    alu_result <= result_sig;
end architecture rtl;