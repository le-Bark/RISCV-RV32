--------------------------------------------------------------------------------
-- Title       : <Instruction_memory testbench>
-- Project     : RISCV Hardware Conception
--------------------------------------------------------------------------------
-- File        : instruction_mem_tb.vhd
-- Author      : Angelo
-- Last update : Thu Jul 30 23:24:57 2020
--------------------------------------------------------------------------------
-- Copyright (c) 2020 Angelo Bautista-Gomez
-------------------------------------------------------------------------------
-- Description: Testbench of the instruction memory
--------------------------------------------------------------------------------
-- Revisions:  
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library vunit_lib;
context vunit_lib.vunit_context;

library demo_lib;

-----------------------------------------------------------

entity instruction_mem_tb is
	generic (runner_cfg : string);
end entity instruction_mem_tb;

-----------------------------------------------------------

architecture testbench of instruction_mem_tb is
	-- Testbench DUT ports
	signal pc          : std_logic_vector(31 downto 0);
	signal instruction : std_logic_vector(31 downto 0);

	--Testbench expected values
	signal exepected_instruction : std_logic_vector(31 downto 0);

begin
	-----------------------------------------------------------
	-- Testbench 
	-----------------------------------------------------------
	main : process
	begin
		test_runner_setup(runner, runner_cfg);

		pc                    <= 0;
		exepected_instruction <= X"00400597";
		wait for 40 ns;
		check_equal(instruction,exepected_instruction);

		pc                    <= pc+1;
		exepected_instruction <= X"00058593";
		wait for 40 ns;
		check_equal(instruction,exepected_instruction);

		pc                    <= pc+1;
		exepected_instruction <= X"00c000ef";
		wait for 40 ns;
		check_equal(instruction,exepected_instruction);

		pc                    <= pc+1;
		exepected_instruction <= X"00050093";
		wait for 40 ns;
		check_equal(instruction,exepected_instruction);

		pc                    <= pc+1;
		exepected_instruction <= X"0200006f";
		wait for 40 ns;
		check_equal(instruction,exepected_instruction);

		pc                    <= pc+1;
		exepected_instruction <= X"00000513";
		wait for 40 ns;
		check_equal(instruction,exepected_instruction);

		pc                    <= pc+1;
		exepected_instruction <= X"00058283";
		wait for 40 ns;
		check_equal(instruction,exepected_instruction);



		test_runner_cleanup(runner);
	end process main;

	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.instruction_mem
		port map (
			pc          => pc,
			instruction => instruction
		);

end architecture testbench;