----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/21/2020 11:02:44 AM
-- Design Name: 
-- Module Name: IF_ID - Behavioral
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

entity IF_ID is
    Port ( clk : in std_logic;
           reset : in std_logic;
           IF_Flush : in std_logic;
           stall : in std_logic;
           IF_PC_4 : in std_logic_vector(31 downto 0);
           PC_signal : in std_logic_vector(31 downto 0);
           IF_Instruction : in std_logic_vector(31 downto 0);
           ID_stall : out std_logic;
           ID_PC_4 : out std_logic_vector(31 downto 0);
           ID_PC_signal : out std_logic_vector(31 downto 0);
           ID_Instruction : out std_logic_vector(31 downto 0));
end IF_ID;

architecture IF_ID_arch of IF_ID is

begin

  IF_ID_process : process(clk,IF_Flush)
    begin
      if rising_edge(clk) then
        if reset = '1' then
          ID_PC_signal <= (others => '0');
          ID_Instruction <= (others => '0');
          ID_stall <= '0';
          ID_PC_4 <= (others => '0');
        elsif IF_Flush = '1' then 
          ID_Instruction <= (others=>'0');
          ID_PC_signal <= PC_signal;
          ID_stall <= stall;
          ID_PC_4 <= IF_PC_4;
        else
          ID_PC_signal <= PC_signal;
          ID_Instruction <= IF_Instruction;
          ID_stall <= stall;
          ID_PC_4 <= IF_PC_4;
        end if;
      end if;
    end process;
end IF_ID_arch;
