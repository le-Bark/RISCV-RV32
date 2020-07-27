----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/23/2020 01:47:20 PM
-- Design Name: 
-- Module Name: data_memory - Behavioral
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
use ieee.math_real.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_memory is
  Port ( 
     clk     : in std_logic;
     address :  in std_logic_vector(31 downto 0);
     write_data : in std_logic_vector(31 downto 0);
     mem_read : in std_logic;
     mem_write : in std_logic;
     read_data : out std_logic_vector(31 downto 0)
  );
end data_memory;

architecture mem of data_memory is

constant MEM_SIZE : integer := 1024;
constant ADDR_SIZE : integer := integer(ceil(log2(real(MEM_SIZE))));
type ram_type is array (MEM_SIZE-1 downto 0) of std_logic_vector(31 downto 0);
signal data_mem : ram_type;


begin

process(clk) is 
begin
if rising_edge(clk) then
    if mem_write = '1' then
        data_mem(to_integer(unsigned(address(ADDR_SIZE-1 downto 0)))) <= write_data;
    end if;
 end if; 
end process;

read_data <=  data_mem(to_integer(unsigned(address(ADDR_SIZE-1 downto 0)))) when mem_read = '1' else
              (others => '0');

end mem;
