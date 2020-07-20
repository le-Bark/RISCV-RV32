library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

library demo_lib;


entity fowarding_unit is
    port(
        rs : in std_logic_vector(4 downto 0);
        rt : in std_logic_vector(4 downto 0);
        rd_mem : in std_logic_vector(4 downto 0);
        mem_enable : in std_logic;
        rd_wb : in std_logic_vector(4 downto 0);
        wb_enable : in std_logic;
        foward_op_a : out std_logic_vector(1 downto 0);
        foward_op_b : out std_logic_vector(1 downto 0)
    );
end entity fowarding_unit;

architecture fowarding_unit_arch of fowarding_unit is
begin
    process (rs,rd_mem,rd_wb,mem_enable,wb_enable)
    begin
        if (rs = rd_mem) and (mem_enable = '1') then
            foward_op_a <= "01";
        elsif (rs = rd_wb) and (wb_enable = '1') then
            foward_op_a <= "10";
        else
            foward_op_a <= "00";
        end if;
    end process;

    process (rt,rd_mem,rd_wb,mem_enable,wb_enable)
    begin
        if (rt = rd_mem) and (mem_enable = '1') then
            foward_op_b <= "01";
        elsif (rt = rd_wb) and (wb_enable = '1') then
            foward_op_b <= "10";
        else
            foward_op_b <= "00";
        end if;
    end process;

end fowarding_unit_arch ; -- fowarding_unit_arch