--------------------------------------------------------------------------------
-- Title       : <Registers TestBench>
-- Project     : RISCV Hardware Conception
--------------------------------------------------------------------------------
-- File        : registers_tb.vhd
-- Author      : Angelo
-- Last update : Fri Jul 31 00:34:48 2020
--------------------------------------------------------------------------------
-- Copyright (c) 2020 Angelo Bautista-Gomez
-------------------------------------------------------------------------------
-- Description: Tesbench of the RAM of registers
--------------------------------------------------------------------------------
-- Revisions:  
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library vunit_lib;
context vunit_lib.vunit_context;

library demo_lib;

-----------------------------------------------------------

entity registers_tb is
	generic(runner_cfg : string);
end entity registers_tb;

-----------------------------------------------------------

architecture testbench of registers_tb is

	-- Testbench DUT generics


	-- Testbench DUT ports
	signal clk         : std_logic;
	signal reg_write   : std_logic;
	signal read_reg_1  : std_logic_vector(4 downto 0);
	signal read_reg_2  : std_logic_vector(4 downto 0);
	signal write_reg   : std_logic_vector(4 downto 0);
	signal write_data  : std_logic_vector(31 downto 0);
	signal read_data_1 : std_logic_vector(31 downto 0);
	signal read_data_2 : std_logic_vector(31 downto 0);

	--Testbench expected signals
	signal expected_read_data_1 : std_logic_vector(31 downto 0);
	signal expected_read_data_2 : std_logic_vector(31 downto 0);


	-- Other constants
	constant C_CLK_PERIOD : real := 200.0e-9; -- NS

begin
	-----------------------------------------------------------
	-- Clocks and Reset
	-----------------------------------------------------------
	CLK_GEN : process
	begin
		clk <= '1';
		wait for C_CLK_PERIOD / 2.0 * (1 SEC);
		clk <= '0';
		wait for C_CLK_PERIOD / 2.0 * (1 SEC);
	end process CLK_GEN;

	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------

	main : process
	begin
		test_runner_setup(runner, runner_cfg);
		reg_write  <= '1';
		read_reg_1 <= (others => '0');
		read_reg_2 <= (others => '0');
		write_reg  <= ("00001");
		write_data <= (others => '1');

		wait for C_CLK_PERIOD;

		reg_write  <= '1';
		read_reg_1 <= (others => '0');
		read_reg_2 <= (others => '0');
		write_reg  <= ("00010");
		write_data <= (others => '1');

		wait for C_CLK_PERIOD;

		reg_write            <= '0';
		expected_read_data_1 <= (others => '1');
		expected_read_data_2 <= (others => '1');
		wait for 40 ns;

		check_equal(read_data_1,expected_read_data_1);
		check_equal(read_data_2,expected_read_data_2);



		test_runner_cleanup(runner);
	end process main;

	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.registers
		port map (
			clk         => clk,
			reg_write   => reg_write,
			read_reg_1  => read_reg_1,
			read_reg_2  => read_reg_2,
			write_reg   => write_reg,
			write_data  => write_data,
			read_data_1 => read_data_1,
			read_data_2 => read_data_2
		);

end architecture testbench;