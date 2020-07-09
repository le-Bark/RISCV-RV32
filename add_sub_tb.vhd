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

entity add_sub_tb is
  generic (runner_cfg : string);
end entity add_sub_tb;


architecture testbench of add_sub_tb is
  -- Testbench DUT generics as constants
    constant bus_size : integer := 32;
    constant negative_1 : std_logic_vector := "11000001000101100110011001100110";
    constant negative_2 : std_logic_vector := "11000010000101110011001100110011";
    constant negative_3 : std_logic_vector := "11000001010011001100110011001100";
  
  -- Testbench DUT ports as signals
    signal clk     : std_logic;
    signal reset  : std_logic;
    signal inst : std_logic_vector (1 downto 0);
    signal op_A : std_logic_vector (bus_size-1 downto 0);
    signal op_B : std_logic_vector (bus_size-1 downto 0);
    signal result_ready  : std_logic;
    signal result_OUT : std_logic_vector (bus_size-1 downto 0);
    
  begin
    clk_gen : PROCESS
    BEGIN
    -- simulation d'une horloge de 50Hz
        clk <= '1';
        WAIT FOR 0.625 ms;
        clk <= '0';
        WAIT FOR 0.625 ms;
    END PROCESS clk_gen;
    
    reset_gen : PROCESS
    BEGIN
        reset <= '1','0' after 50 ms;
        WAIT;
    END PROCESS reset_gen;
    -----------------------------------------------------------
    -- Testbench Stimulus
    -----------------------------------------------------------
    main : process
    begin
      test_runner_setup(runner, runner_cfg);

      inst <= "01";
      op_A <= "00111111011001100110011001100110";
      op_B <= "00111110010011001100110011001101";
      
      wait until result_ready = '1' for 2000 ms;
      check_equal(result_OUT, 16#3f8ccccc#, "0.9 + 0.2 = 1.1 = 0x3f8ccccc");
      
      inst <= "01";
      op_A <= "00111111011001100110011001100110";
      op_B <= "10111110010011001100110011001101";
      
      wait until result_ready = '1' for 2000 ms;
      check_equal(result_OUT, 16#3f333333#, "0.9 + (-0.2) = 0.7 = 0x3f333333");
      
      inst <= "01";
      op_A <= "01000001010001001100110011001101";
      op_B <= "11000000001000000000000000000000";
      
      wait until result_ready = '1' for 2000 ms;
      check_equal(result_OUT, 16#411ccccd#, "12.3 + (-2.5) = 9.8 = 0x411ccccd");
      
      inst <= "01";
      op_A <= "10111110100110011001100110011010";
      op_B <= "11000001000100011001100110011010";
      
      wait until result_ready = '1' for 2000 ms;
      check_equal(result_OUT, negative_1, "(-0.3) + (-9.1) = -9.4 = 0xc1166666");
      
      inst <= "01";
      op_A <= "11000001110010100110011001100110";
      op_B <= "11000001010010000000000000000000";
      
      wait until result_ready = '1' for 2000 ms;
      check_equal(result_OUT, negative_2, "(-25.3) + (-12.5) = -37.8 = 0xc2173333");
      
      inst <= "01";
      op_A <= "01000001110010000000000000000000";
      op_B <= "11000001110010000000000000000000";
      
      wait until result_ready = '1' for 2000 ms;
      check_equal(result_OUT, 16#00000000#, "25 + (-25) = 0 = 0x00000000");
      
      inst <= "10";
      op_A <= "00111111011001100110011001100110";
      op_B <= "00111110010011001100110011001101";
      
      wait until result_ready = '1' for 2000 ms;
      check_equal(result_OUT, 16#3f333333#, "0.9 - 0.2 = 0.7 = 0x3f333333");
      
      inst <= "10";
      op_A <= "00111111011001100110011001100110";
      op_B <= "10111110010011001100110011001101";
      
      wait until result_ready = '1' for 2000 ms;
      check_equal(result_OUT, 16#3f8ccccc#, "0.9 - (-0.2) = 1.1 = 0x3f8ccccc");
      
      inst <= "10";
      op_A <= "01000001010001001100110011001101";
      op_B <= "11000000001000000000000000000000";
      
      wait until result_ready = '1' for 2000 ms;
      check_equal(result_OUT, 16#416ccccd#, "12.3 - (-2.5) = 14.8 = 0x416ccccd");
      
      inst <= "10";
      op_A <= "10111110100110011001100110011010";
      op_B <= "11000001000100011001100110011010";
      
      wait until result_ready = '1' for 2000 ms;
      check_equal(result_OUT, 16#410cccce#, "(-0.3) - (-9.1) = 8.8 = 0x410cccce");
      
      inst <= "10";
      op_A <= "11000001110010100110011001100110";
      op_B <= "11000001010010000000000000000000";
      
      wait until result_ready = '1' for 2000 ms;
      check_equal(result_OUT, negative_3, "(-25.3) - (-12.5) = (-12.8) = 0xc14ccccc");
      
      inst <= "11";
      op_A <= "11000001110010100110011001100110";
      op_B <= "11000001010010000000000000000000";
      
      wait until result_ready = '1' for 2000 ms;
      check_equal(result_OUT, 16#7f800000#, "-25.3 - (-12.5) = infini = 0x7f800000");
      
      test_runner_cleanup(runner);
  end process;
    -----------------------------------------------------------
    -- Entity Under Test
    -----------------------------------------------------------
    DUT : entity work.ADD_SUB

      port map (
      clk => clk,
      reset => reset,
      inst => inst,
      op_A => op_A,
      op_B => op_B,
      result_ready => result_ready,
      result_OUT => result_OUT
    );
    
    end architecture testbench;