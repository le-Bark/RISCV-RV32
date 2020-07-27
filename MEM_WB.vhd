----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/21/2020 11:02:44 AM
-- Design Name: 
-- Module Name: MEM_WB - Behavioral
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

entity MEM_WB is
    Port ( clk : in std_logic;
           reset : in std_logic;
           MEM_WB : in std_logic_vector(1 downto 0);
           MEM_ReadData : in std_logic_vector(31 downto 0);
           MEM_AluResult : in std_logic_vector(31 downto 0);
           MEM_Register_Rd : in std_logic_vector(4 downto 0);
           WB_WB : out std_logic_vector(1 downto 0);
           WB_ReadData : out std_logic_vector(31 downto 0);
           WB_AluResult : out std_logic_vector(31 downto 0);
           WB_Register_Rd : out std_logic_vector(4 downto 0));
end MEM_WB;

architecture MEM_WB_arch of MEM_WB is

begin

  MEM_WB_process : process(clk)
    begin
      if rising_edge(clk) then
        if reset = '1' then
          WB_WB <= (others => '0');
          WB_ReadData <= (others => '0');
          WB_AluResult <= (others => '0');
          WB_Register_Rd <= (others => '0');
        else
          WB_WB <= MEM_WB;
          WB_ReadData <=  MEM_ReadData;   
          WB_AluResult <=  MEM_AluResult;
          WB_Register_Rd <= MEM_Register_Rd;
        end if;
      end if;
    end process;
end MEM_WB_arch;
