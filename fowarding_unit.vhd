----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/12/2020 06:31:34 PM
-- Design Name: 
-- Module Name: fowarding_unit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fowarding_unit is
    port(
        rs1 : in std_logic_vector(4 downto 0);
        rs2 : in std_logic_vector(4 downto 0);
        rd_ex : in std_logic_vector(4 downto 0);
        ex_enable : in std_logic;
        rd_mem : in std_logic_vector(4 downto 0);
        mem_enable : in std_logic;
        foward_op_a : out std_logic_vector(1 downto 0);
        foward_op_b : out std_logic_vector(1 downto 0)
    );
end entity fowarding_unit;

architecture fowarding_unit_arch of fowarding_unit is
begin
    process (rs1,rd_ex,rd_mem,ex_enable,mem_enable)
    begin
        if (rs1 = rd_ex) and (ex_enable = '1') then
            foward_op_a <= "01";
        elsif (rs1 = rd_mem) and (mem_enable = '1') then
            foward_op_a <= "10";
        else
            foward_op_a <= "00";
        end if;
    end process;

    process (rs2,rd_ex,rd_mem,ex_enable,mem_enable)
    begin
        if (rs2 = rd_ex) and (ex_enable = '1') then
            foward_op_b <= "01";
        elsif (rs2 = rd_mem) and (mem_enable = '1') then
            foward_op_b <= "10";
        else
            foward_op_b <= "00";
        end if;
    end process;

end fowarding_unit_arch ; -- fowarding_unit_arch