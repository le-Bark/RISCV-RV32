-------------------------------------------------------------------------------
-- Title       : one hot encoder testbench
-- Project     : TRIUMF4 Benchmarks
-------------------------------------------------------------------------------
-- File        : one_hot_encoder_tb.vhd
-- Author      : Simon
-- Created     : Sun Dec  9 07:52:38 2018
-- Standard    : <VHDL-2008>
-------------------------------------------------------------------------------
-- Copyright (c) 2018 Simon Pichette
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

library demo_lib;

entity ALU_unit_tb is
  generic (runner_cfg : string);
end entity ALU_unit_tb;


architecture testbench of ALU_unit_tb is
  -- Testbench DUT generics as constants
    constant register_size : integer := 32;
  
  -- Testbench DUT ports as signals
  signal src_A          : std_logic_vector(register_size-1 downto 0);
  signal src_B          : std_logic_vector(register_size-1 downto 0);
  signal funct_3        : std_logic_vector(2 downto 0);
  signal funct_7        : std_logic_vector(6 downto 0);
  signal decoded_opcode : std_logic_vector(3 downto 0);
  signal alu_result     : std_logic_vector(register_size-1 downto 0);

  begin
    -----------------------------------------------------------
    -- Testbench Stimulus
    -----------------------------------------------------------
    main : process
    variable tmp : std_logic_vector(register_size-1 downto 0) := x"00000000";
    begin
      test_runner_setup(runner, runner_cfg);
      -- Additon
      decoded_opcode <= "0001";
      funct_3 <= "000";
      funct_7 <= "0000000";
      src_A <= x"00000001";
      src_B <= x"00000001";
      tmp := x"00000002";
      wait for 100 ns;
      check_equal(alu_result, tmp, "1 + 1 = 2");
      
      decoded_opcode <= "0010";
      funct_3 <= "000";
      funct_7 <= "0000000";
      src_A <= x"00000001";
      src_B <= x"00000001";
      tmp := x"00000002";
      wait for 100 ns;
      check_equal(alu_result, tmp, "1 + 1 = 2");
      
      decoded_opcode <= "0011";
      funct_3 <= "000";
      funct_7 <= "0000000";
      src_A <= x"00000001";
      src_B <= x"00000001";
      tmp := x"00000002";
      wait for 100 ns;
      check_equal(alu_result, tmp, "1 + 1 = 2");
      
      decoded_opcode <= "0101";
      funct_3 <= "000";
      funct_7 <= "0000000";
      src_A <= x"00000001";
      src_B <= x"00000001";
      tmp := x"00000002";
      wait for 100 ns;
      check_equal(alu_result, tmp, "1 + 1 = 2");
      
      decoded_opcode <= "0110";
      funct_3 <= "000";
      funct_7 <= "0000000";
      src_A <= x"80000001";
      src_B <= x"00000001";
      tmp := x"80000002";
      wait for 100 ns;
      check_equal(alu_result, tmp, "-2147483647 + 1 = -2147483646");
      
      decoded_opcode <= "0111";
      funct_3 <= "000";
      funct_7 <= "0000000";
      src_A <= x"00000001";
      src_B <= x"00000001";
      tmp := x"00000002";
      wait for 100 ns;
      check_equal(alu_result, tmp, "1 + 1 = 2");
      
      decoded_opcode <= "1000";
      funct_3 <= "000";
      funct_7 <= "0000000";
      src_A <= x"00000001";
      src_B <= x"00000001";
      tmp := x"00000002";
      wait for 100 ns;
      check_equal(alu_result, tmp, "1 + 1 = 2");
      
      --Subtraction
      decoded_opcode <= "1000";
      funct_3 <= "000";
      funct_7 <= "0100000";
      src_A <= x"80ffffff";
      src_B <= x"8fffffff";
      tmp := x"F1000000";
      wait for 100 ns;
      check_equal(alu_result, tmp, "-2130706433 - (-1879048193) = -251658240");
      
      decoded_opcode <= "1000";
      funct_3 <= "000";
      funct_7 <= "0100000";
      src_A <= x"07111111";
      src_B <= x"8000000F";
      tmp := x"87111102";
      wait for 100 ns;
      check_equal(alu_result, tmp, "118558993 - (-2147483633 = -2028924670");
      
      --Multiplication
      decoded_opcode <= "1000";
      funct_3 <= "000";
      funct_7 <= "0000001";
      src_A <= x"8000000F";
      src_B <= x"0000000E";
      tmp := x"000000D2";
      wait for 100 ns;
      check_equal(alu_result, tmp, "-2147483633 * 14 = 210");
      
      decoded_opcode <= "1000";
      funct_3 <= "000";
      funct_7 <= "0000001";
      src_A <= x"80000001";
      src_B <= x"80000001";
      tmp := x"00000001";
      wait for 100 ns;
      check_equal(alu_result, tmp, "(-1) * (-1) = 1");
      
      --Multiplication upper half
      decoded_opcode <= "1000";
      funct_3 <= "001";
      funct_7 <= "0000001";
      src_A <= x"8000000F";
      src_B <= x"0000000E";
      tmp := x"FFFFFFF9";
      wait for 100 ns;
      check_equal(alu_result, tmp, "-2147483633 * 14 = 4294967289");
      
      --Multiplication half signed/unsigned
      decoded_opcode <= "1000";
      funct_3 <= "010";
      funct_7 <= "0000001";
      src_A <= x"8000000F";
      src_B <= x"0000000E";
      tmp := x"FFFFFFF9";
      wait for 100 ns;
      check_equal(alu_result, tmp, "-2147483633 * 14 = 4294967289");
      
      --Multiplication half unsigned
      decoded_opcode <= "1000";
      funct_3 <= "011";
      funct_7 <= "0000001";
      src_A <= x"8000000F";
      src_B <= x"0000000E";
      wait for 100 ns;
      check_equal(alu_result, 7, "-2147483633 * 14 = 7");
      
      --Division
      decoded_opcode <= "1000";
      funct_3 <= "100";
      funct_7 <= "0000001";
      src_A <= x"80000001";
      src_B <= x"0000000F";
      tmp := x"F7777778";
      wait for 100 ns;
      check_equal(alu_result, tmp, "-2147483647 / 15 = -143165576");
      
      --Division unsigned
      decoded_opcode <= "1000";
      funct_3 <= "101";
      funct_7 <= "0000001";
      src_A <= x"80000001";
      src_B <= x"0000000F";
      tmp := x"08888888";
      wait for 100 ns;
      check_equal(alu_result, tmp, "2147483649 / 15 = 143165576");
      
      --Remainder
      decoded_opcode <= "1000";
      funct_3 <= "110";
      funct_7 <= "0000001";
      src_A <= x"8000000F";
      src_B <= x"0000000E";
      tmp := x"ffffffff";
      wait for 100 ns;
      check_equal(alu_result, tmp, "-2147483633 - ((-2147483633 / 14) * 14) = -1");
      
      --Remainder unsigned
      decoded_opcode <= "1000";
      funct_3 <= "111";
      funct_7 <= "0000001";
      src_A <= x"80000001";
      src_B <= x"0000000E";
      tmp := x"00000003";
      wait for 100 ns;
      check_equal(alu_result, tmp, "2147483649 - ((2147483649 / 14)* 14)= 3");
      
      --XOR
      decoded_opcode <= "0111";
      funct_3 <= "100";
      funct_7 <= "0000000";
      src_A <= x"FFFFFFFF";
      src_B <= x"EEEEEEEE";
      tmp := x"11111111";
      wait for 100 ns;
      check_equal(alu_result, tmp, "0xFFFFFFFF XOR 0xEEEEEEEE= 0x11111111");
      
      decoded_opcode <= "1000";
      funct_3 <= "100";
      funct_7 <= "0000000";
      src_A <= x"FFFFFFFF";
      src_B <= x"EEEEEEEE";
      tmp := x"11111111";
      wait for 100 ns;
      check_equal(alu_result, tmp, "0xFFFFFFFF XOR 0xEEEEEEEE= 0x11111111");
      
      --OR
      decoded_opcode <= "0111";
      funct_3 <= "110";
      funct_7 <= "0000000";
      src_A <= x"FFFFFFFF";
      src_B <= x"EEEEEEEE";
      tmp := x"FFFFFFFF";
      wait for 100 ns;
      check_equal(alu_result, tmp, "0xFFFFFFFF OR 0xEEEEEEEE= 0xFFFFFFFF");

      decoded_opcode <= "1000";
      funct_3 <= "110";
      funct_7 <= "0000000";
      src_A <= x"FFFFFFFF";
      src_B <= x"EEEEEEEE";
      tmp := x"FFFFFFFF";
      wait for 100 ns;
      check_equal(alu_result, tmp, "0xFFFFFFFF OR 0xEEEEEEEE= 0xFFFFFFFF");
      
      --AND
      decoded_opcode <= "0111";
      funct_3 <= "111";
      funct_7 <= "0000000";
      src_A <= x"FFFFFFFF";
      src_B <= x"EEEEEEEE";
      tmp := x"EEEEEEEE";
      wait for 100 ns;
      check_equal(alu_result, tmp, "0xFFFFFFFF AND 0xEEEEEEEE= 0xEEEEEEEE");
      
      decoded_opcode <= "1000";
      funct_3 <= "111";
      funct_7 <= "0000000";
      src_A <= x"FFFFFFFF";
      src_B <= x"EEEEEEEE";
      tmp := x"EEEEEEEE";
      wait for 100 ns;
      check_equal(alu_result, tmp, "0xFFFFFFFF AND 0xEEEEEEEE= 0xEEEEEEEE");
      
      --Shift left logical
      decoded_opcode <= "0111";
      funct_3 <= "001";
      funct_7 <= "0000000";
      src_A <= x"FFFFFFFF";
      src_B <= x"00000001";
      tmp := x"FFFFFFFE";
      wait for 100 ns;
      check_equal(alu_result, tmp, "0xFFFFFFFF << 1 = 0xFFFFFFE");
      
      decoded_opcode <= "1000";
      funct_3 <= "001";
      funct_7 <= "0000000";
      src_A <= x"FFFFFFFF";
      src_B <= x"00000001";
      tmp := x"FFFFFFFE";
      wait for 100 ns;
      check_equal(alu_result, tmp, "0xFFFFFFFF << 1 = 0xFFFFFFE");
      
      --Shift right logical
      decoded_opcode <= "0111";
      funct_3 <= "101";
      funct_7 <= "0000000";
      src_A <= x"80000001";
      src_B <= x"00000002";
      tmp := x"20000000";
      wait for 100 ns;
      check_equal(alu_result, tmp, "0x80000001 >> 2 = 0x20000000");
      
      decoded_opcode <= "1000";
      funct_3 <= "101";
      funct_7 <= "0000000";
      src_A <= x"80000001";
      src_B <= x"00000002";
      tmp := x"20000000";
      wait for 100 ns;
      check_equal(alu_result, tmp, "0x80000001 >> 2 = 0x20000000");
      
      --Shift right arithmetic
      decoded_opcode <= "0111";
      funct_3 <= "101";
      funct_7 <= "0100000";
      src_A <= x"80000001";
      src_B <= x"00000002";
      tmp := x"E0000000";
      wait for 100 ns;
      check_equal(alu_result, tmp, "0x80000001 >> 2 = 0xE0000000");
      
      decoded_opcode <= "1000";
      funct_3 <= "101";
      funct_7 <= "0100000";
      src_A <= x"80000001";
      src_B <= x"00000002";
      tmp := x"E0000000";
      wait for 100 ns;
      check_equal(alu_result, tmp, "0x80000001 >> 2 = 0xE0000000");
      
      --Set < (signed)
      decoded_opcode <= "0111";
      funct_3 <= "010";
      funct_7 <= "0000000";
      src_A <= x"80000001";
      src_B <= x"00000001";
      tmp := x"00000001";
      wait for 100 ns;
      check_equal(alu_result, tmp, "0x80000001 < 1 = 0x00000001");
      
      decoded_opcode <= "1000";
      funct_3 <= "010";
      funct_7 <= "0000000";
      src_A <= x"80000001";
      src_B <= x"00000001";
      tmp := x"00000001";
      wait for 100 ns;
      check_equal(alu_result, tmp, "0x80000001 < 1 = 0x00000001");
      
      --Set < (unsigned)
      decoded_opcode <= "0111";
      funct_3 <= "011";
      funct_7 <= "0000000";
      src_A <= x"80000001";
      src_B <= x"00000001";
      tmp := x"00000000";
      wait for 100 ns;
      check_equal(alu_result, tmp, "0x80000001 < 1 = 0x00000000");
      
      decoded_opcode <= "1000";
      funct_3 <= "011";
      funct_7 <= "0000000";
      src_A <= x"80000001";
      src_B <= x"00000001";
      tmp := x"00000000";
      wait for 100 ns;
      check_equal(alu_result, tmp, "0x80000001 < 1 = 0x00000000");
      
      
      
      test_runner_cleanup(runner);
  end process;
    -----------------------------------------------------------
    -- Entity Under Test
    -----------------------------------------------------------
    DUT : entity work.ALU_unit

      port map (
      src_A          => src_A,
      src_B          => src_B,
      funct_3        => funct_3,
      funct_7        => funct_7,
      decoded_opcode => decoded_opcode,
      alu_result     => alu_result
    );
    
    end architecture testbench;