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
    clk        : in  std_logic;
    reset      : in  std_logic;
    address    : in  std_logic_vector(31 downto 0);
    write_data : in  std_logic_vector(31 downto 0);
    mem_read   : in  std_logic;
    store_ctrl : in  std_logic_vector(2 downto 0);
    mem_write  : in  std_logic;
    read_data  : out std_logic_vector(31 downto 0)
  );
end data_memory;

architecture mem of data_memory is

  constant MEM_SIZE  : integer := 4096;
  constant ADDR_SIZE : integer := integer(ceil(log2(real(MEM_SIZE))));
  type ram_type is array (0 to MEM_SIZE-1) of std_logic_vector(7 downto 0);
  signal data_mem : ram_type;
  signal int_add  : integer := to_integer(unsigned(address(ADDR_SIZE-1 downto 0)));


begin

  process(clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        data_mem    <= others => (others => '0');
        data_mem(0) <= x"0A";
      elsif mem_write = '1' then
        case store_ctrl is
          when "000" => data_mem(int_add) <= write_data(7 downto 0); -- Store Byte
          when "001" => data_mem(int_add) <= write_data(7 downto 0); --Store 16bits
            data_mem(int_add +1) <= write_data(15 downto 8);
          when others => data_mem(int_add) <= write_data(7 downto 0); --Store 32bits
            data_mem(int_add +1) <= write_data(15 downto 8);
            data_mem(int_add +2) <= write_data(23 downto 16);
            data_mem(int_add +3) <= write_data(31 downto 24);
        end case;
      end if;
    end if;
  end process;

  read_data <= data_mem(int_add + 3) & data_mem(int_add + 2) & data_mem(int_add +1) & data_mem(int_add);


end mem;
