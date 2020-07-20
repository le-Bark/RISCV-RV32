library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

library demo_lib;

entity fowarding_unit_tb is
    generic (runner_cfg : string);
end entity fowarding_unit_tb;

architecture testbench of fowarding_unit_tb is

    signal rs : std_logic_vector(4 downto 0);
    signal rt : std_logic_vector(4 downto 0);
    signal rd_mem : std_logic_vector(4 downto 0);
    signal mem_enable : std_logic;
    signal wb_enable : std_logic;
    signal rd_wb : std_logic_vector(4 downto 0);
    signal foward_op_a : std_logic_vector(1 downto 0);
    signal foward_op_b : std_logic_vector(1 downto 0);
    signal expected_a : std_logic_vector(1 downto 0);
    signal expected_b : std_logic_vector(1 downto 0);

begin

    main : process
    begin
        test_runner_setup(runner, runner_cfg);

        rs <= "00001";
        rt <= "00010";
        rd_mem <= "00100";
        rd_wb <= "00110";
        mem_enable <= '1';
        wb_enable <= '1';

        expected_a <= "00";
        expected_b <= "00";

        wait for 40 ns;

        check_equal(foward_op_a,expected_a,"test op a 1");
        check_equal(foward_op_b,expected_b,"test op b 1");

        rs <= rd_mem;

        expected_a <= "01";
        expected_b <= "00";
        wait for 40 ns;

        check_equal(foward_op_a,expected_a,"test op a 1");
        check_equal(foward_op_b,expected_b,"test op b 1");

        rs <= rd_wb;
        rt <= rd_mem;

        expected_a <= "10";
        expected_b <= "01";

        wait for 40 ns;

        check_equal(foward_op_a,expected_a,"test op a 1");
        check_equal(foward_op_b,expected_b,"test op b 1");

        rs <= "00001";
        rt <= rd_wb;

        expected_a <= "00";
        expected_b <= "10";

        wait for 40 ns;

        check_equal(foward_op_a,expected_a,"test op a 1");
        check_equal(foward_op_b,expected_b,"test op b 1");

        rs <= "00100";
        rt <= "00100";
        rd_mem <= "00100";
        rd_wb <= "00100";

        expected_a <= "01";
        expected_b <= "01";

        wait for 40 ns;

        check_equal(foward_op_a,expected_a,"test op a 1");
        check_equal(foward_op_b,expected_b,"test op b 1");

        rs <= "00110";
        rt <= "00100";
        rd_mem <= "00110";
        rd_wb <= "00100";
        mem_enable <= '0';
        wb_enable <= '0';

        expected_a <= "00";
        expected_b <= "00";

        wait for 40 ns;

        check_equal(foward_op_a,expected_a,"test write enable");
        check_equal(foward_op_b,expected_b,"test mem enable");


        test_runner_cleanup(runner);
    end process;
    
    DUT : entity work.fowarding_unit
    port map (
        rs1 => rs,
        rs2 => rt,
        rd_mem => rd_mem,
        rd_wb => rd_wb,
        mem_enable => mem_enable,
        wb_enable => wb_enable,
        foward_op_a => foward_op_a,
        foward_op_b => foward_op_b
    );

end testbench ; -- testbench