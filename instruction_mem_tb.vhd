--------------------------------------------------------------------------------
-- Title       : <Instruction_memory testbench>
-- Project     : RISCV Hardware Conception
--------------------------------------------------------------------------------
-- File        : instruction_mem_tb.vhd
-- Author      : Angelo
-- Last update : Fri Jul 31 15:50:14 2020
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

		pc                    <= X"00000000";
		exepected_instruction <= X"00400517";
		wait for 40 ns;
		check_equal(instruction,exepected_instruction);

		pc                    <= X"00000004";
		exepected_instruction <= X"00052503";
		wait for 40 ns;
		check_equal(instruction,exepected_instruction);

		pc                    <= X"00000008";
		exepected_instruction <= X"00400597";
		wait for 40 ns;
		check_equal(instruction,exepected_instruction);

		pc                    <= X"0000000C";
		exepected_instruction <= X"ffc5a583";
		wait for 40 ns;
		check_equal(instruction,exepected_instruction);

		pc                    <= X"00000010";
		exepected_instruction <= X"004000ef";
		wait for 40 ns;
		check_equal(instruction,exepected_instruction);

		pc                    <= X"00000014";
		exepected_instruction <= X"00050663";
		wait for 40 ns;
		check_equal(instruction,exepected_instruction);

		pc                    <= X"00000018";
		exepected_instruction <= X"00058463";
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