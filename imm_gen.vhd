----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/23/2020 01:44:18 PM
-- Design Name: 
-- Module Name: imm_gen - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity imm_gen is
 Port ( 
    instruction : in std_logic_vector(31 downto 0);
    inst: in std_logic_vector(2 downto 0);
    immediate : out std_logic_vector(31 downto 0)
 );
end imm_gen;

architecture gen of imm_gen is
signal pre_imm : std_logic_vector(11 downto 0);
signal B_pre_imm : std_logic_vector(12 downto 0);
signal U_pre_imm: std_logic_vector(19 downto 0);
signal J_pre_imm: std_logic_vector(20 downto 0);

begin

process(inst,instruction)
begin
 pre_imm <= (others => '0');
 B_pre_imm <= (others => '0');
 J_pre_imm <= (others => '0');
 U_pre_imm <= (others => '0');
 case inst is
    when "000" => pre_imm <= (others => '0');
    when "001" => pre_imm <= instruction(31 downto 20);
    when "010" => pre_imm <= (instruction (31 downto 25) & instruction(11 downto 7));
    when "011" => B_pre_imm <= (instruction(31) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0');
    when "100" => U_pre_imm <= instruction(31 downto 12);
    when "101" => J_pre_imm <= (instruction(31)& instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & '0');
    when others => 
        pre_imm <= (others => '0');
        B_pre_imm <= (others => '0');
        J_pre_imm <= (others => '0');
        U_pre_imm <= (others => '0');
    end case;
end process;

immediate <= std_logic_vector(resize(signed(pre_imm),32)) when inst= "000" OR inst= "001" OR inst= "010" else
             std_logic_vector(resize(signed(B_pre_imm),32)) when inst= "011" else
             (U_pre_imm &"000000000000") when inst = "100" else
             std_logic_vector(resize(signed(J_pre_imm),32)) when inst= "101" else
             (others => '0');
             

                                 
end gen;
