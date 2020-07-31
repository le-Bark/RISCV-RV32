--------------------------------------------------------------------------------
-- Title       : <Immediate generator testbench>
-- Project     : RISCV Hardware Conception
--------------------------------------------------------------------------------
-- File        : imm_gen_tb.vhd
-- Author      : Angelo
-- Last update : Fri Jul 31 17:31:59 2020
--------------------------------------------------------------------------------
-- Copyright (c) 2020 Angelo Bautista-Gomez
-------------------------------------------------------------------------------
-- Description: 
--------------------------------------------------------------------------------
-- Revisions:  
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library vunit_lib;
context vunit_lib.vunit_context;

library demo_lib;

-----------------------------------------------------------

entity imm_gen_tb is
	generic (runner_cfg : string);
end entity imm_gen_tb;

-----------------------------------------------------------

architecture testbench of imm_gen_tb is

	-- Testbench DUT generics


	-- Testbench DUT ports
	signal instruction : std_logic_vector(31 downto 0);
	signal inst        : std_logic_vector(2 downto 0);
	signal immediate   : std_logic_vector(31 downto 0);

	-- Testbench expected signals
	signal expected_imm : std_logic_vector(31 downto 0);

begin
	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------
	main : process
	begin
		test_runner_setup(runner, runner_cfg);
		instruction  <= X"00000000";
		inst         <= "000";
		expected_imm <= (others => '0');
		wait for 40 ns;
		check_equal(immediate,expected_imm);


		instruction  <= X"00100000";
		inst         <= "001";
		expected_imm <= X"00000001";
		wait for 40 ns;
		check_equal(immediate,expected_imm);


		instruction  <= X"00000080";
		inst         <= "010";
		expected_imm <= X"00000001";
		wait for 40 ns;
		check_equal(immediate,expected_imm);


		instruction  <= X"00000100";
		inst         <= "011";
		expected_imm <= X"00000002";
		wait for 40 ns;
		check_equal(immediate,expected_imm);


		instruction  <= X"00001000";
		inst         <= "100";
		expected_imm <= X"00001000";
		wait for 40 ns;
		check_equal(immediate,expected_imm);

		instruction  <= X"00200000";
		inst         <= "101";
		expected_imm <= X"00000002";
		wait for 40 ns;
		check_equal(immediate,expected_imm);

		instruction  <= X"00000000";
		inst         <= "111";
		expected_imm <= (others => '0');
		wait for 40 ns;
		check_equal(immediate,expected_imm);

		test_runner_cleanup(runner);
	end process;


	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.imm_gen
		port map (
			instruction => instruction,
			inst        => inst,
			immediate   => immediate
		);

end architecture testbench;