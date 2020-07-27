----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/21/2020 12:15:37 PM
-- Design Name: 
-- Module Name: PC - Behavioral
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

entity PC is
    Port ( clk : in std_logic;
           reset : in std_logic;
           PCsrc : in std_logic;
           ID_stall : in std_logic;
           jumps : in std_logic_vector(1 downto 0);
           SignImmSh : in std_logic_vector(31 downto 0);
           ID_PC_signal : in std_logic_vector(31 downto 0);
           ID_read_data_1 : in std_logic_vector(31 downto 0);
           PC_out : out std_logic_vector(31 downto 0));
end PC;

architecture PC_arch of PC is

signal PC_signal : std_logic_vector(31 downto 0);
signal IF_PCplus4 : std_logic_vector(31 downto 0);
signal PCnextbr : std_logic_vector(31 downto 0);
signal PCbranch : std_logic_vector(31 downto 0);
signal PCjumpreg : std_logic_vector(31 downto 0);
begin

  IF_PCplus4 <= std_logic_vector(unsigned(PC_signal) +4 );
  
  PCbranch <=  std_logic_vector(unsigned(ID_PC_signal) + unsigned(SignImmSh));
  PCjumpreg <=  std_logic_vector(unsigned(ID_read_data_1) + unsigned(SignImmSh));
  
  PCnextbr <= PCbranch when ((PCsrc = '1'or jumps(1) ='1') and ID_stall = '0') else
              PCjumpreg when (jumps(0) = '1' and ID_stall = '0') else IF_PCplus4;   
              
  PC_process : process(clk,reset)
    begin
      if rising_edge(clk) then
        if reset = '1' then 
          PC_out <= (others=>'0');
          PC_signal <= (others=>'0');
        else
          PC_signal <= PCnextbr;
          PC_out <= PCnextbr;
        end if;
      end if;
    end process;
end PC_arch;
