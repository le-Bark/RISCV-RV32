--------------------------------------------------------------------------------
-- Title       : <control_unit_tb.vhd>
-- Project     : RISCV Hardware Conception
--------------------------------------------------------------------------------
-- File        : control_unit_tb.vhd
-- Author      : Angelo
-- Last update : Fri Jul 31 00:13:57 2020
--------------------------------------------------------------------------------
-- Copyright (c) 2020 Angelo Bautista-Gomez
-------------------------------------------------------------------------------
-- Description: Testbench of the control unit
--------------------------------------------------------------------------------
-- Revisions:  
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library vunit_lib;
context vunit_lib.vunit_context;

library demo_lib;


-----------------------------------------------------------

entity control_unit_tb is
generic (runner_cfg : string);
end entity control_unit_tb;

-----------------------------------------------------------

architecture testbench of control_unit_tb is

	-- Testbench DUT generics


	-- Testbench DUT ports
	signal instruction : std_logic_vector(31 downto 0);
	signal EX_ALU_op   : std_logic_vector(5 downto 0);
	signal WB_ctrl     : std_logic_vector(1 downto 0);
	signal MEM_ctrl    : std_logic_vector(7 downto 0);
	signal ID_ctrl     : std_logic_vector(2 downto 0);
	signal IF_ctrl     : std_logic;
	signal inst_type   : std_logic_vector(2 downto 0);

	--Testbench expected values
	signal expected_EX_ALU_op : std_logic_vector(5 downto 0);
	signal expected_WB_ctrl   : std_logic_vector(1 downto 0);
	signal expected_MEM_ctrl  : std_logic_vector(7 downto 0);
	signal expected_ID_ctrl   : std_logic_vector(2 downto 0);
	signal expected_IF_ctrl   : std_logic;
	signal expected_inst_type : std_logic_vector(2 downto 0);



begin
	-----------------------------------------------------------
	-- Testbench 
	-----------------------------------------------------------
	main : process
	begin
		test_runner_setup(runner, runner_cfg);

		------------------   R Type test  -------------------------
		instruction        <= x"00000033";
		expected_EX_ALU_op <= "0000000";
		expected_WB_ctrl   <= "10";
		expected_MEM_ctrl  <= "00010010";
		expected_ID_ctrl   <= "000";
		expected_IF_ctrl   <= "0";
		expected_inst_type <= "000";

		wait for 40 ns;

		check_equal(EX_ALU_op,expected_EX_ALU_op,"Test Ctrl ALU_op");
		check_equal(WB_ctrl,expected_WB_ctrl,"Test Ctrl WB");
		check_equal(MEM_ctrl,expected_MEM_ctrl,"Test Ctrl MEM");
		check_equal(ID_ctrl,expected_ID_ctrl,"Test Ctrl ID");
		check_equal(IF_ctrl,expected_IF_ctrl,"Test Ctrl IF");
		check_equal(inst_type,expected_inst_type,"Test Ctrl inst_type");


		------------------   I load Type test  -------------------------

		instruction        <= x"00000003";
		expected_EX_ALU_op <= "0010101";
		expected_WB_ctrl   <= "11";
		expected_MEM_ctrl  <= "10000010";
		expected_ID_ctrl   <= "000";
		expected_IF_ctrl   <= "0";
		expected_inst_type <= "001";

		wait for 40 ns;

		check_equal(EX_ALU_op,expected_EX_ALU_op,"Test Ctrl ALU_op");
		check_equal(WB_ctrl,expected_WB_ctrl,"Test Ctrl WB");
		check_equal(MEM_ctrl,expected_MEM_ctrl,"Test Ctrl MEM");
		check_equal(ID_ctrl,expected_ID_ctrl,"Test Ctrl ID");
		check_equal(IF_ctrl,expected_IF_ctrl,"Test Ctrl IF");
		check_equal(inst_type,expected_inst_type,"Test Ctrl inst_type");


		------------------   I JALR Type test  -------------------------

		instruction        <= x"00000067";
		expected_EX_ALU_op <= "0110011";
		expected_WB_ctrl   <= "10";
		expected_MEM_ctrl  <= "00010010";
		expected_ID_ctrl   <= "001";
		expected_IF_ctrl   <= "0";
		expected_inst_type <= "001";

		wait for 40 ns;

		check_equal(EX_ALU_op,expected_EX_ALU_op,"Test Ctrl ALU_op");
		check_equal(WB_ctrl,expected_WB_ctrl,"Test Ctrl WB");
		check_equal(MEM_ctrl,expected_MEM_ctrl,"Test Ctrl MEM");
		check_equal(ID_ctrl,expected_ID_ctrl,"Test Ctrl ID");
		check_equal(IF_ctrl,expected_IF_ctrl,"Test Ctrl IF");
		check_equal(inst_type,expected_inst_type,"Test Ctrl inst_type");


		------------------   I Arithmetics Type test  -------------------------

		instruction        <= x"00000013";
		expected_EX_ALU_op <= "0010111";
		expected_WB_ctrl   <= "10";
		expected_MEM_ctrl  <= "00010010";
		expected_ID_ctrl   <= "000";
		expected_IF_ctrl   <= "0";
		expected_inst_type <= "001";

		wait for 40 ns;

		check_equal(EX_ALU_op,expected_EX_ALU_op,"Test Ctrl ALU_op");
		check_equal(WB_ctrl,expected_WB_ctrl,"Test Ctrl WB");
		check_equal(MEM_ctrl,expected_MEM_ctrl,"Test Ctrl MEM");
		check_equal(ID_ctrl,expected_ID_ctrl,"Test Ctrl ID");
		check_equal(IF_ctrl,expected_IF_ctrl,"Test Ctrl IF");
		check_equal(inst_type,expected_inst_type,"Test Ctrl inst_type");


		------------------   S Type test  -------------------------

		instruction        <= x"00000023";
		expected_EX_ALU_op <= "0010110";
		expected_WB_ctrl   <= "00";
		expected_MEM_ctrl  <= "01010000";
		expected_ID_ctrl   <= "000";
		expected_IF_ctrl   <= "0";
		expected_inst_type <= "010";

		wait for 40 ns;

		check_equal(EX_ALU_op,expected_EX_ALU_op,"Test Ctrl ALU_op");
		check_equal(WB_ctrl,expected_WB_ctrl,"Test Ctrl WB");
		check_equal(MEM_ctrl,expected_MEM_ctrl,"Test Ctrl MEM");
		check_equal(ID_ctrl,expected_ID_ctrl,"Test Ctrl ID");
		check_equal(IF_ctrl,expected_IF_ctrl,"Test Ctrl IF");
		check_equal(inst_type,expected_inst_type,"Test Ctrl inst_type");



		------------------   B Type test  -------------------------

		instruction        <= x"00000063";
		expected_EX_ALU_op <= "0000000";
		expected_WB_ctrl   <= "00";
		expected_MEM_ctrl  <= "00010010";
		expected_ID_ctrl   <= "100";
		expected_IF_ctrl   <= "0";
		expected_inst_type <= "011";

		wait for 40 ns;

		check_equal(EX_ALU_op,expected_EX_ALU_op,"Test Ctrl ALU_op");
		check_equal(WB_ctrl,expected_WB_ctrl,"Test Ctrl WB");
		check_equal(MEM_ctrl,expected_MEM_ctrl,"Test Ctrl MEM");
		check_equal(ID_ctrl,expected_ID_ctrl,"Test Ctrl ID");
		check_equal(IF_ctrl,expected_IF_ctrl,"Test Ctrl IF");
		check_equal(inst_type,expected_inst_type,"Test Ctrl inst_type");


		------------------   U Type LUI test  -------------------------

		instruction        <= x"00000037";
		expected_EX_ALU_op <= "0010000";
		expected_WB_ctrl   <= "10";
		expected_MEM_ctrl  <= "00010010";
		expected_ID_ctrl   <= "000";
		expected_IF_ctrl   <= "0";
		expected_inst_type <= "100";



		wait for 40 ns;

		check_equal(EX_ALU_op,expected_EX_ALU_op,"Test Ctrl ALU_op");
		check_equal(WB_ctrl,expected_WB_ctrl,"Test Ctrl WB");
		check_equal(MEM_ctrl,expected_MEM_ctrl,"Test Ctrl MEM");
		check_equal(ID_ctrl,expected_ID_ctrl,"Test Ctrl ID");
		check_equal(IF_ctrl,expected_IF_ctrl,"Test Ctrl IF");
		check_equal(inst_type,expected_inst_type,"Test Ctrl inst_type");



		------------------   U Type AUIPC test  -------------------------

		instruction        <= x"00000017";
		expected_EX_ALU_op <= "0010001";
		expected_WB_ctrl   <= "10";
		expected_MEM_ctrl  <= "00010010";
		expected_ID_ctrl   <= "000";
		expected_IF_ctrl   <= "0";
		expected_inst_type <= "100";


		wait for 40 ns;

		check_equal(EX_ALU_op,expected_EX_ALU_op,"Test Ctrl ALU_op");
		check_equal(WB_ctrl,expected_WB_ctrl,"Test Ctrl WB");
		check_equal(MEM_ctrl,expected_MEM_ctrl,"Test Ctrl MEM");
		check_equal(ID_ctrl,expected_ID_ctrl,"Test Ctrl ID");
		check_equal(IF_ctrl,expected_IF_ctrl,"Test Ctrl IF");
		check_equal(inst_type,expected_inst_type,"Test Ctrl inst_type");

		------------------   J Type test  -------------------------

		instruction        <= x"0000006F";
		expected_EX_ALU_op <= "1000010";
		expected_WB_ctrl   <= "10";
		expected_MEM_ctrl  <= "00010010";
		expected_ID_ctrl   <= "010";
		expected_IF_ctrl   <= "0";
		expected_inst_type <= "101";


		wait for 40 ns;

		check_equal(EX_ALU_op,expected_EX_ALU_op,"Test Ctrl ALU_op");
		check_equal(WB_ctrl,expected_WB_ctrl,"Test Ctrl WB");
		check_equal(MEM_ctrl,expected_MEM_ctrl,"Test Ctrl MEM");
		check_equal(ID_ctrl,expected_ID_ctrl,"Test Ctrl ID");
		check_equal(IF_ctrl,expected_IF_ctrl,"Test Ctrl IF");
		check_equal(inst_type,expected_inst_type,"Test Ctrl inst_type");


		------------------   NOP Type test  -------------------------

		instruction        <= x"00000073";
		expected_EX_ALU_op <= "0010000";
		expected_WB_ctrl   <= "00";
		expected_MEM_ctrl  <= "00010010";
		expected_ID_ctrl   <= "000";
		expected_IF_ctrl   <= "1";
		expected_inst_type <= "110";


		wait for 40 ns;

		check_equal(EX_ALU_op,expected_EX_ALU_op,"Test Ctrl ALU_op");
		check_equal(WB_ctrl,expected_WB_ctrl,"Test Ctrl WB");
		check_equal(MEM_ctrl,expected_MEM_ctrl,"Test Ctrl MEM");
		check_equal(ID_ctrl,expected_ID_ctrl,"Test Ctrl ID");
		check_equal(IF_ctrl,expected_IF_ctrl,"Test Ctrl IF");
		check_equal(inst_type,expected_inst_type,"Test Ctrl inst_type");

		------------------   OTHERS Type test  -------------------------

		instruction        <= x"000000FF";
		expected_EX_ALU_op <= "0000000";
		expected_WB_ctrl   <= "00";
		expected_MEM_ctrl  <= "00010010";
		expected_ID_ctrl   <= "000";
		expected_IF_ctrl   <= "0";
		expected_inst_type <= "110";


		wait for 40 ns;

		check_equal(EX_ALU_op,expected_EX_ALU_op,"Test Ctrl ALU_op");
		check_equal(WB_ctrl,expected_WB_ctrl,"Test Ctrl WB");
		check_equal(MEM_ctrl,expected_MEM_ctrl,"Test Ctrl MEM");
		check_equal(ID_ctrl,expected_ID_ctrl,"Test Ctrl ID");
		check_equal(IF_ctrl,expected_IF_ctrl,"Test Ctrl IF");
		check_equal(inst_type,expected_inst_type,"Test Ctrl inst_type");

		test_runner_cleanup(runner);
	end process main;

	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.control_unit
		port map (
			instruction => instruction,
			EX_ALU_op   => EX_ALU_op,
			WB_ctrl     => WB_ctrl,
			MEM_ctrl    => MEM_ctrl,
			ID_ctrl     => ID_ctrl,
			IF_ctrl     => IF_ctrl,
			inst_type   => inst_type
		);

end architecture testbench;