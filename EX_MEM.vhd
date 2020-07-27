----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/21/2020 11:02:44 AM
-- Design Name: 
-- Module Name: EX_MEM - Behavioral
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

entity EX_MEM is
    Port ( clk : in std_logic;
           EX_M : in std_logic_vector(7 downto 0);
           EX_WB : in std_logic_vector(1 downto 0);
           AluResult_sig : in std_logic_vector(31 downto 0);
           ALU_src_B : in std_logic_vector(31 downto 0);
           EX_Register_Rd : in std_logic_vector(4 downto 0);
           MEM_M : out std_logic_vector(7 downto 0);
           MEM_WB : out std_logic_vector(1 downto 0);
           MEM_AluResult : out std_logic_vector(31 downto 0);
           MEM_ALU_src_B : out std_logic_vector(31 downto 0);
           MEM_Register_Rd : out std_logic_vector(4 downto 0));
end EX_MEM;

architecture EX_MEM_arch of EX_MEM is

begin

  EX_MEM_process : process(clk)
    begin
      if rising_edge(clk) then
        MEM_M <= EX_M;
        MEM_WB <= EX_WB;
        MEM_AluResult <=  AluResult_sig;
        MEM_ALU_src_B <= ALU_src_B;
        MEM_Register_Rd <= EX_Register_Rd;
      end if;
    end process;
end EX_MEM_arch;
