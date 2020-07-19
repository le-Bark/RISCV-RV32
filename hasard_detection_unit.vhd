library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

library demo_lib;


entity hasard_detection_unit is
    port(
        branch_condition : in std_logic;
        opcode : in std_logic_vector(6 downto 0);
        stall : out std_logic
    );
end entity hasard_detection_unit;

architecture hasard_detection_unit_arch of hasard_detection_unit is

    constant branch_opcode : std_logic_vector(6 downto 0) := "1100011";
    constant jal_opcode : std_logic_vector(6 downto 0) := "1101111";
    constant jalr_opcode : std_logic_vector(6 downto 0) := "1100111";

begin
    process (opcode,branch_condition)
    begin
        if opcode = branch_opcode then
            stall <= branch_condition;
        elsif opcode = jal_opcode then
            stall <= '1';
        elsif opcode = jalr_opcode then
            stall <= '1';
        else
            stall <= '0';
        end if;
    end process;

end hasard_detection_unit_arch ; -- hasard_detection_unit_arch
