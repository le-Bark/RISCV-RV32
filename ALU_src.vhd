----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/21/2020 01:23:09 PM
-- Design Name: 
-- Module Name: ALU_src - Behavioral
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

entity ALU_src is
    Port ( FOWARD_OP : in std_logic_vector(1 downto 0);
           EX_read_data : in std_logic_vector(31 downto 0);
           WB_Result : in std_logic_vector(31 downto 0);
           MEM_AluResult : in std_logic_vector(31 downto 0);
           ALU_src : out std_logic_vector(31 downto 0));
end ALU_src;

architecture ALU_src_arch of ALU_src is

begin

  ALU_src <= 
    EX_read_data when (FOWARD_OP = "00") else
    MEM_AluResult when (FOWARD_OP = "01") else
    WB_Result;
    
end ALU_src_arch;

