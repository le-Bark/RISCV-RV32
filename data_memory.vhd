--------------------------------------------------------------------------------
-- Title       : <Data_memory>
-- Project     : RISCV Hardware Conception
--------------------------------------------------------------------------------
-- File        : data_memory.vhd
-- Author      : Angelo
-- Company     : Angelo Bautista-Gomez
-- Last update : Fri Jul 31 00:16:38 2020
--------------------------------------------------------------------------------
-- Copyright (c) 2020 Angelo Bautista-Gomez
--------------------------------------------------------------------------------
-- Description: RAM the contains the data
--------------------------------------------------------------------------------
-- Revisions:  
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;


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
  signal int_add  : integer := 0;


begin

  int_add <= to_integer(unsigned(address(ADDR_SIZE-1 downto 0)));

  process(clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        data_mem(0) <= x"db";
        data_mem(1) <= x"0f";
        data_mem(2) <= x"49";
        data_mem(3) <= x"40";
        data_mem(4) <= x"14";
        data_mem(5) <= x"2e";
        data_mem(6) <= x"9f";
        data_mem(7) <= x"44";
        data_mem(8) <= x"00";
        data_mem(9) <= x"00";
        data_mem(10) <= x"80";
        data_mem(11) <= x"7F";
        data_mem(12) <= x"FF";
        data_mem(13) <= x"FF";
        data_mem(14) <= x"7F";
        data_mem(15) <= x"00";
        for i in 16 to MEM_SIZE - 1 loop
            data_mem(i) <= (others => '0');
        end loop;
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
