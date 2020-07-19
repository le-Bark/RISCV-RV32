library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

library demo_lib;

entity hasard_detection_unit_tb is
    generic (runner_cfg : string);
end entity hasard_detection_unit_tb;

architecture testbench of hasard_detection_unit_tb is

    signal branch_condition : std_logic;
    signal opcode : std_logic_vector(6 downto 0);
    signal stall : std_logic;
    signal expected_stall : std_logic;

    constant branch_opcode : std_logic_vector(6 downto 0) := "1100011";
    constant jal_opcode : std_logic_vector(6 downto 0) :=    "1101111";
    constant jalr_opcode : std_logic_vector(6 downto 0) :=   "1100111";
    constant add_opcode : std_logic_vector(6 downto 0) :=    "0110011";

begin

    main : process
    begin
        test_runner_setup(runner, runner_cfg);

        branch_condition <= '1';
        opcode <= add_opcode;
        expected_stall <= '0';

        wait for 40 ns;

        check_equal(expected_stall,stall,"test no stall");

        branch_condition <= '1';
        opcode <= jal_opcode;
        expected_stall <= '1';

        wait for 40 ns;

        check_equal(expected_stall,stall,"test stall jal");

        branch_condition <= '0';
        opcode <= jalr_opcode;
        expected_stall <= '1';

        wait for 40 ns;

        check_equal(expected_stall,stall,"test stall jalr");

        branch_condition <= '1';
        opcode <= branch_opcode;
        expected_stall <= '1';

        wait for 40 ns;

        check_equal(expected_stall,stall,"test stall branch");

        branch_condition <= '0';
        opcode <= branch_opcode;
        expected_stall <= '0';

        wait for 40 ns;

        check_equal(expected_stall,stall,"test no stall branch");

        test_runner_cleanup(runner);
    end process;
    
    DUT : entity work.hasard_detection_unit
    port map (
        branch_condition => branch_condition,
        opcode => opcode,
        stall => stall
    );

end testbench ; -- testbench
