----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/20/2020 07:02:10 PM
-- Design Name: 
-- Module Name: hasard_detection_unit - Behavioral
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

entity hasard_detection_unit is
    port(
        branch_condition : in std_logic;
        ID_stall : in std_logic;
        opcode : in std_logic_vector(6 downto 0);
        stall : out std_logic;
        PC_stall : out std_logic
    );
end entity hasard_detection_unit;

architecture hasard_detection_unit_arch of hasard_detection_unit is

    constant branch_opcode : std_logic_vector(6 downto 0) := "1100011";
    constant jal_opcode : std_logic_vector(6 downto 0) := "1101111";
    constant jalr_opcode : std_logic_vector(6 downto 0) := "1100111";
    constant load_opcode : std_logic_vector(6 downto 0) := "0000011";

begin
    process (opcode,branch_condition,ID_stall)
    begin
        PC_stall <= '0';
        if ID_stall = '1' then
            stall <= '0';
            PC_stall <= '0';
        elsif opcode = branch_opcode then
            stall <= branch_condition;
            PC_stall <= '0';
        elsif opcode = jal_opcode then
            stall <= '1';
            PC_stall <= '0';
        elsif opcode = jalr_opcode then
            stall <= '1';
            PC_stall <= '0';
        elsif opcode = load_opcode then
            stall <= '1';
            PC_stall <= '1';
        else
            stall <= '0';
            PC_stall <= '0';
        end if;
    end process;

end hasard_detection_unit_arch ; -- hasard_detection_unit_arch
