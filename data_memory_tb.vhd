--------------------------------------------------------------------------------
-- Title       : <Data_memory testbench>
-- Project     : RISCV Hardware Conception
--------------------------------------------------------------------------------
-- File        : data_memory_tb.vhd
-- Author      : Angelo
-- Last update : Fri Jul 31 16:32:08 2020
--------------------------------------------------------------------------------
-- Copyright (c) 2020 Angelo Bautista-Gomez
-------------------------------------------------------------------------------
-- Description: Testbench du data memory
--------------------------------------------------------------------------------
-- Revisions:  
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library vunit_lib;
context vunit_lib.vunit_context;

library demo_lib;

-----------------------------------------------------------

entity data_memory_tb is
	generic(runner_cfg : string);
end entity data_memory_tb;

-----------------------------------------------------------

architecture testbench of data_memory_tb is

	-- Testbench DUT generics

	-- Testbench DUT ports
	signal clk        : std_logic;
	signal reset      : std_logic;
	signal address    : std_logic_vector(31 downto 0);
	signal write_data : std_logic_vector(31 downto 0);
	signal mem_read   : std_logic;
	signal store_ctrl : std_logic_vector(2 downto 0);
	signal mem_write  : std_logic;
	signal read_data  : std_logic_vector(31 downto 0);

	-- Testbench expected signals
	signal expected_read_data : std_logic_vector(31 downto 0);



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

	RESET_GEN : process
	begin
		reset <= '1',
			'0' after 20.0*C_CLK_PERIOD * (1 SEC);
		wait;
	end process RESET_GEN;

	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------
	main : process
	begin
		test_runner_setup(runner, runner_cfg);
		wait for 4000 ns;
		address            <= (others => '0');
		mem_write          <= '0';
		mem_read           <= '0';
		expected_read_data <= X"40490fdb";
		wait for 200 ns;
		mem_write          <= '1';
		address            <= (others => '0');
		write_data         <= X"000000FF";
		expected_read_data <= X"000000FF";

		wait for 40 ns;
		mem_write <= '0';
		check_equal(read_data,expected_read_data);
		test_runner_cleanup(runner);
	end process main;

	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.data_memory
		port map (
			clk        => clk,
			reset      => reset,
			address    => address,
			write_data => write_data,
			mem_read   => mem_read,
			store_ctrl => store_ctrl,
			mem_write  => mem_write,
			read_data  => read_data
		);

end architecture testbench;