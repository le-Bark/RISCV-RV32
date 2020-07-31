library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;
library demo_lib;

entity fowarding_unit_tb is
    generic (runner_cfg : string);
end entity fowarding_unit_tb;

architecture testbench of fowarding_unit_tb is

    signal rs1 : std_logic_vector(4 downto 0);
    signal rs2 : std_logic_vector(4 downto 0);
    signal rd_ex : std_logic_vector(4 downto 0);
    signal ex_enable : std_logic;
    signal mem_enable : std_logic;
    signal rd_mem : std_logic_vector(4 downto 0);
    signal foward_op_a : std_logic_vector(1 downto 0);
    signal foward_op_b : std_logic_vector(1 downto 0);
    signal expected_a : std_logic_vector(1 downto 0);
    signal expected_b : std_logic_vector(1 downto 0);

begin

    main : process
    begin
        test_runner_setup(runner, runner_cfg);

        rs1 <= "00001";
        rs2 <= "00010";
        rd_ex <= "00100";
        rd_mem <= "00110";
        ex_enable <= '1';
        mem_enable <= '1';

        expected_a <= "00";
        expected_b <= "00";

        wait for 40 ns;

        check_equal(foward_op_a,expected_a,"test op a 1");
        check_equal(foward_op_b,expected_b,"test op b 1");

        rs1 <= rd_ex;

        expected_a <= "01";
        expected_b <= "00";
        wait for 40 ns;

        check_equal(foward_op_a,expected_a,"test op a 1");
        check_equal(foward_op_b,expected_b,"test op b 1");

        rs1 <= rd_mem;
        rs2 <= rd_ex;

        expected_a <= "10";
        expected_b <= "01";

        wait for 40 ns;

        check_equal(foward_op_a,expected_a,"test op a 1");
        check_equal(foward_op_b,expected_b,"test op b 1");

        rs1 <= "00001";
        rs2 <= rd_mem;

        expected_a <= "00";
        expected_b <= "10";

        wait for 40 ns;

        check_equal(foward_op_a,expected_a,"test op a 1");
        check_equal(foward_op_b,expected_b,"test op b 1");

        rs1 <= "00100";
        rs2 <= "00100";
        rd_ex <= "00100";
        rd_mem <= "00100";

        expected_a <= "01";
        expected_b <= "01";

        wait for 40 ns;

        check_equal(foward_op_a,expected_a,"test op a 1");
        check_equal(foward_op_b,expected_b,"test op b 1");

        rs1 <= "00110";
        rs2 <= "00100";
        rd_ex <= "00110";
        rd_mem <= "00100";
        ex_enable <= '0';
        mem_enable <= '0';

        expected_a <= "00";
        expected_b <= "00";

        wait for 40 ns;

        check_equal(foward_op_a,expected_a,"test write enable");
        check_equal(foward_op_b,expected_b,"test mem enable");


        test_runner_cleanup(runner);
    end process;
    
    DUT : entity work.fowarding_unit
    port map (
        rs1 => rs1,
        rs2 => rs2,
        rd_ex => rd_ex,
        rd_mem => rd_mem,
        ex_enable => ex_enable,
        mem_enable => mem_enable,
        foward_op_a => foward_op_a,
        foward_op_b => foward_op_b
    );

end testbench ; -- testbench