----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/23/2020 06:00:35 PM
-- Design Name: 
-- Module Name: ADD_SUB - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ADD_SUB is
  generic(
    constant bus_size  : integer                       := 32;
    constant infini    : std_logic_vector(7 DOWNTO 0)  := "11111111";
    constant nul       : std_logic_vector(22 DOWNTO 0) := "00000000000000000000000";
    constant overflow  : std_logic_vector(22 DOWNTO 0) := "00000000000000000000001";
    constant underflow : std_logic_vector(22 DOWNTO 0) := "00000000000000000000010"
    );
    Port (
      clk,reset    : in  std_logic;
      inst         : in  std_logic_vector (1 downto 0);
      op_A         : in  std_logic_vector (bus_size-1 downto 0);
      op_B         : in  std_logic_vector (bus_size-1 downto 0);
      result_ready : out std_logic;
      result_OUT   : out std_logic_vector (bus_size-1 downto 0));
end ADD_SUB;

architecture rtl of ADD_SUB is
type mc_state_type is
(check_operation, check_equal_zero, adjust_exponent, significand_A_equal_zero, significand_B_equal_zero,
significant_equal_zero2, significand_overflow, exponent_overflow, exponent_underflow, normalize);
signal state_reg : mc_state_type := check_operation;

signal op_A_sig                   : unsigned (bus_size-1 downto 0);
signal op_B_sig                   : unsigned (bus_size-1 downto 0);
signal sign_op_A_sig              : std_logic := '0';
signal sign_op_B_sig              : std_logic := '0';
signal new_sign_sig               : std_logic := '0';
signal sel_exponent_sig           : std_logic_vector(1 DOWNTO 0);
signal sel_new_exponent_sig       : std_logic_vector(1 DOWNTO 0);
signal sel_aligned_sig            : std_logic_vector(1 DOWNTO 0);
signal sel_new_significand_sig    : std_logic_vector(1 DOWNTO 0);
signal exponent_op_A_sig          : signed(7 DOWNTO 0);
signal exponent_plus1_op_A_sig    : signed(7 DOWNTO 0);
signal exponent_op_B_sig          : signed(7 DOWNTO 0);
signal exponent_plus1_op_B_sig    : signed(7 DOWNTO 0);
signal new_exponent_sig           : signed(8 DOWNTO 0);
signal new_exponent_plus1_sig     : signed(8 DOWNTO 0);
signal new_exponent_minus1_sig    : signed(8 DOWNTO 0);
signal significand_op_A_sig       : unsigned(23 DOWNTO 0);
signal significand_shift_op_A_sig : unsigned(23 DOWNTO 0);
signal significand_op_B_sig       : unsigned(23 DOWNTO 0);
signal significand_shift_op_B_sig : unsigned(23 DOWNTO 0);
signal aligned_significand_A_sig  : unsigned(24 DOWNTO 0);
signal aligned_significand_B_sig  : unsigned(24 DOWNTO 0);
signal new_significand_sig        : unsigned(24 DOWNTO 0);
signal significand_normalized_sig : unsigned(23 DOWNTO 0);
signal new_shiftR_significand_sig : unsigned(24 DOWNTO 0);
signal new_shiftL_significand_sig : unsigned(24 DOWNTO 0);

begin
  op_B_sig <= unsigned(not op_B(bus_size-1) & op_B(bus_size-2 downto 0)) when inst = "10" else
              unsigned(op_B) when inst = "01" else (others => '0');
  op_A_sig      <= unsigned(op_A) when inst = "10" or inst = "01" else (others => '0');

  sign_op_A_sig <= op_A_sig(31);
  sign_op_B_sig <= op_B_sig(31);

  exponent_op_A_sig <= exponent_plus1_op_A_sig when sel_exponent_sig = "01" else
                       "10000010" when op_A_sig(30 DOWNTO 23) = "00000000" and sel_exponent_sig = "00" else
                       signed(op_A_sig(30 DOWNTO 23)-127);
  exponent_op_B_sig <= exponent_plus1_op_B_sig when sel_exponent_sig = "10" else
                       "10000010" when op_B_sig(30 DOWNTO 23) = "00000000" and sel_exponent_sig = "00" else
                      signed(op_B_sig(30 DOWNTO 23)-127);

  new_exponent_sig <= new_exponent_plus1_sig when sel_new_exponent_sig = "01" else
                      new_exponent_minus1_sig when sel_new_exponent_sig = "10" else
                      resize(exponent_op_A_sig, 9);

  significand_op_A_sig <= significand_shift_op_A_sig when sel_aligned_sig = "01" else
                          ('1' & op_A_sig(22 DOWNTO 0));
  significand_op_B_sig <= significand_shift_op_B_sig when sel_aligned_sig = "10" else
                          ('1' & op_B_sig(22 DOWNTO 0));

  aligned_significand_A_sig <= ((not('0' & significand_op_A_sig)) + 1) when sign_op_A_sig = '1' else
                               ('0' & significand_op_A_sig) when sign_op_A_sig = '0';
  aligned_significand_B_sig <= ((not('0' & significand_op_B_sig)) + 1) when sign_op_B_sig = '1' else
                               ('0' & significand_op_B_sig) when sign_op_B_sig = '0';

  new_significand_sig <= aligned_significand_A_sig + aligned_significand_B_sig when sel_new_significand_sig <= "00" else
                         new_shiftR_significand_sig   when sel_new_significand_sig <= "01" else
                         new_shiftL_significand_sig when sel_new_significand_sig <= "10" else
                        (others => '0');

  new_sign_sig <= new_significand_sig(24) when (sign_op_A_sig /= sign_op_B_sig) else sign_op_A_sig;

  significand_normalized_sig <= resize(((not new_significand_sig) + 1), 24) when ((sign_op_A_sig = '1' and sign_op_B_sig = '1') or
                                ((sign_op_A_sig = '1' or sign_op_B_sig = '1') and new_significand_sig(24) = '1')) else
                                resize(new_significand_sig, 24);


  process (clk)
  begin
    if rising_edge(clk) then
      result_ready <= '0';
      result_OUT   <= (others => '0');
      if reset = '1' then
        state_reg <= check_operation;
      elsif inst /= "00" then
        case state_reg is
          when check_operation =>
            sel_exponent_sig        <= "00";
            sel_aligned_sig         <= "00";
            sel_new_significand_sig <= "00";
            sel_new_exponent_sig    <= "00";
            if (inst = "11") then
              result_ready <= '1';
              result_OUT   <= '0' & infini & nul;
              state_reg    <= check_operation;
            else
              state_reg <= check_equal_zero;
            end if;

          when check_equal_zero =>
            if (unsigned(op_A_sig(bus_size-2 DOWNTO 0)) = 0) then
              result_ready <= '1';
              result_OUT   <= std_logic_vector(op_B_sig);
              state_reg    <= check_operation;
            elsif (unsigned(op_B_sig(bus_size-2 DOWNTO 0)) = 0) then
              result_ready <= '1';
              result_OUT   <= std_logic_vector(op_A_sig);
              state_reg    <= check_operation;
            else
              state_reg <= adjust_exponent;
            end if;

          when adjust_exponent =>
            if (exponent_op_A_sig /= exponent_op_B_sig) then
              if (exponent_op_A_sig > exponent_op_B_sig) then
                sel_exponent_sig           <= "10";
                sel_aligned_sig            <= "10";
                exponent_plus1_op_B_sig    <= exponent_op_B_sig +1;
                significand_shift_op_B_sig <= shift_right(significand_op_B_sig, 1);
                state_reg                  <= significand_B_equal_zero;
              else
                sel_exponent_sig           <= "01";
                sel_aligned_sig            <= "01";
                exponent_plus1_op_A_sig    <= exponent_op_A_sig +1;
                significand_shift_op_A_sig <= shift_right(significand_op_A_sig, 1);
                state_reg                  <= significand_A_equal_zero;
              end if;
            else
              state_reg <= significant_equal_zero2;
            end if;

          when significand_A_equal_zero =>
            if (significand_op_A_sig = 0) then
              result_ready <= '1';
              result_OUT   <= std_logic_vector(sign_op_B_sig & op_B_sig(30 DOWNTO 23) & significand_op_B_sig(22 DOWNTO 0));
              state_reg    <= check_operation;
            else
              state_reg <= adjust_exponent;
            end if;

          when significand_B_equal_zero =>
            if (significand_op_B_sig = 0) then
              result_ready <= '1';
              result_OUT   <= std_logic_vector(sign_op_A_sig & op_B_sig(30 DOWNTO 23) & significand_op_A_sig(22 DOWNTO 0));
              state_reg    <= check_operation;
            else
              state_reg <= adjust_exponent;
            end if;

          when significant_equal_zero2 =>
            if (new_significand_sig = 0) then
              result_ready <= '1';
              result_OUT   <= (others => '0');
              state_reg    <= check_operation;
            else
              state_reg <= significand_overflow;
            end if;

          when significand_overflow =>
            if ((new_significand_sig(24) = '0' and (sign_op_A_sig = '1' and sign_op_B_sig = '1')) or
                (new_significand_sig(24) = '1' and (sign_op_A_sig = '0' and sign_op_B_sig = '0'))) then
              sel_new_significand_sig    <= "01";
              sel_new_exponent_sig       <= "01";
              new_shiftR_significand_sig <= shift_right(new_significand_sig, 1);
              new_exponent_plus1_sig     <= new_exponent_sig + 1;
              state_reg                  <= exponent_overflow;
            else
              state_reg <= normalize;
            end if;

          when exponent_overflow =>
            if (new_exponent_sig(8) /= new_exponent_sig(7)) then
              result_ready <= '1';
              result_OUT   <= '0' & infini & overflow;
              state_reg    <= check_operation;
            else
              state_reg <= normalize;
            end if;

          when normalize =>
            if (significand_normalized_sig(23) = '1') then
              result_ready <= '1';
              result_OUT   <= new_sign_sig & std_logic_vector(new_exponent_sig(7 DOWNTO 0) + 127) &
                std_logic_vector(significand_normalized_sig(22 DOWNTO 0));
              state_reg <= check_operation;
            else
              sel_new_significand_sig    <= "10";
              sel_new_exponent_sig       <= "10";
              new_shiftL_significand_sig <= shift_left(new_significand_sig, 1);
              new_exponent_minus1_sig    <= new_exponent_sig - 1;
              state_reg                  <= exponent_underflow;
            end if;

          when exponent_underflow =>
            if (new_exponent_sig(8) /= new_exponent_sig(7)) then
              result_ready <= '1';
              result_OUT   <= '0' & infini & underflow;
              state_reg    <= check_operation;
            else
              state_reg <= normalize;
            end if;
        end case;
      end if;
    end if;
  end process;
end rtl;