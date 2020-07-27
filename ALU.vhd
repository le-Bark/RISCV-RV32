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
	signal uns_src_A_sig        : unsigned(register_size-1 downto 0);
	signal uns_src_B_sig        : unsigned(register_size-1 downto 0);
	signal sign_src_A_sig       : signed(register_size-1 downto 0);
	signal sign_src_B_sig       : signed(register_size-1 downto 0);
	signal MUL_sig              : unsigned((2*register_size)-1 downto 0);
	signal MULHSU_sig           : unsigned((2*register_size)-1 downto 0);
	signal MULHU_sig            : unsigned((2*register_size)-1 downto 0);
	signal compare_signed_sig   : unsigned(1 downto 0);
	signal compare_unsigned_sig : unsigned(1 downto 0);
	signal unsigned_div_sig     : unsigned(register_size-1 downto 0);
	signal signed_div_sig       : signed(register_size-1 downto 0);

begin
	uns_src_A_sig        <= unsigned(src_A);
	uns_src_B_sig        <= unsigned(src_B);
	sign_src_A_sig       <= signed(src_A);
	sign_src_B_sig       <= signed(src_B);
	MUL_sig              <= unsigned(sign_src_A_sig * sign_src_B_sig);
	MULHSU_sig           <= unsigned(sign_src_A_sig * to_integer(uns_src_B_sig));
	MULHU_sig            <= uns_src_A_sig * uns_src_B_sig;
	compare_signed_sig   <= "01" when (sign_src_A_sig < sign_src_B_sig) else "00";
	compare_unsigned_sig <= "01" when (uns_src_A_sig < uns_src_B_sig) else "00";
	unsigned_div_sig     <= (others => '0') when (uns_src_B_sig = 0) else uns_src_A_sig / uns_src_B_sig;
	signed_div_sig       <= (others => '0') when (sign_src_B_sig = 0) else sign_src_A_sig / sign_src_B_sig;

	process(src_A, src_B, alu_control, uns_src_A_sig, uns_src_B_sig, sign_src_A_sig, sign_src_B_sig, 
	        MUL_sig, MULHSU_sig, MULHU_sig, compare_signed_sig, compare_unsigned_sig, unsigned_div_sig, signed_div_sig)
	begin
		case alu_control is
			when "00000" => --Addition
				alu_result <= std_logic_vector(uns_src_A_sig + uns_src_B_sig);
			when "00001" => --Subtraction
				alu_result <= std_logic_vector(uns_src_A_sig - uns_src_B_sig);
			when "00010" => --Multiplication
				alu_result <= std_logic_vector(resize(MUL_sig, register_size));
			when "00011" => --Multiplication upper half
				alu_result <= std_logic_vector(MUL_sig((2*register_size)-1 downto register_size));
			when "00100" => --Multiplication half signed/unsigned
				alu_result <= std_logic_vector(MULHSU_sig((2*register_size)-1 downto register_size));
			when "00101" => --Multiplication half unsigned
				alu_result <= std_logic_vector(MULHU_sig((2*register_size)-1 downto register_size));
			when "00110" => --Division
				alu_result <= std_logic_vector(unsigned(signed_div_sig));
			when "00111" => --Division unsigned
				alu_result <= std_logic_vector(unsigned_div_sig);
			when "01000" => --Remainder
				alu_result <= std_logic_vector(unsigned(resize(sign_src_A_sig - (signed_div_sig * sign_src_B_sig), register_size)));
			when "01001" => --Remainder unsigned
				alu_result <= std_logic_vector(resize(uns_src_A_sig - (unsigned_div_sig * uns_src_B_sig), register_size));
			when "01010" => --XOR
				alu_result <= src_A XOR src_B;
			when "01011" => --OR
				alu_result <= src_A OR src_B;
			when "01100" => --AND
				alu_result <= src_A AND src_B;
			when "01101" => --Shift left
				alu_result <= std_logic_vector(shift_left(uns_src_A_sig, to_integer(uns_src_B_sig)));
			when "01110" => --Shift right logical
				alu_result <= std_logic_vector(shift_right(uns_src_A_sig, to_integer(uns_src_B_sig)));
			when "01111" => --Shift right arithmetic
				alu_result <= std_logic_vector(shift_right(signed(uns_src_A_sig), to_integer(uns_src_B_sig)));
			when "10000" => --Set < (signed)
				alu_result <= std_logic_vector(resize(compare_signed_sig, register_size));
			when "10001" => --Set < (unsigned)
				alu_result <= std_logic_vector(resize(compare_unsigned_sig, register_size));
			when others =>
				alu_result <= (others => '-');
		end case;
	end process;
end architecture rtl;