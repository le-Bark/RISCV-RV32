----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/21/2020 11:02:44 AM
-- Design Name: 
-- Module Name: ID_EX - Behavioral
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

entity ID_EX is
    Port ( clk : in std_logic;
           reset : in std_logic;
           Result_mux_control : in std_logic_vector(15 downto 0);
           ID_Instruction : in std_logic_vector(31 downto 0);
           ID_read_data_1 : in std_logic_vector(31 downto 0);
           ID_read_data_2 : in std_logic_vector(31 downto 0);
           ID_PC : in std_logic_vector(31 downto 0);
           SignImmSh : in std_logic_vector(31 downto 0);
           EX_SignImmSh : out std_logic_vector(31 downto 0);
           EX_EX : out std_logic_vector(5 downto 0);
           EX_M : out std_logic_vector(7 downto 0);
           EX_WB : out std_logic_vector(1 downto 0);
           EX_funct3 : out std_logic_vector(2 downto 0);
           EX_funct7 : out std_logic_vector(6 downto 0);
           EX_read_data_1 : out std_logic_vector(31 downto 0);
           EX_read_data_2 : out std_logic_vector(31 downto 0);
           EX_PC : out std_logic_vector(31 downto 0);
           EX_Register_Rs1 : out std_logic_vector(4 downto 0);
           EX_Register_Rs2 : out std_logic_vector(4 downto 0);
           EX_Register_Rd : out std_logic_vector(4 downto 0));
end ID_EX;

architecture ID_EX_arch of ID_EX is

begin

  ID_EX_process : process(clk)
    begin
      if rising_edge(clk) then
        if reset = '1' then
          EX_EX <=(others => '0');
          EX_M <=(others => '0');
          EX_WB <=(others => '0');
          EX_funct3 <=(others => '0');
          EX_funct7 <=(others => '0');
          EX_read_data_1 <=(others => '0');
          EX_read_data_2 <=(others => '0');
          EX_Register_Rs1 <=(others => '0');
          EX_Register_Rs2 <=(others => '0');
          EX_Register_Rd <=(others => '0');
          EX_SignImmSh <=(others => '0');
          EX_PC <=(others => '0');
        else
          EX_EX <= Result_mux_control(5 downto 0);
          EX_M <= Result_mux_control(13 downto 6);
          EX_WB <= Result_mux_control(15 downto 14);
          EX_funct3 <= ID_Instruction (14 downto 12);
          EX_funct7 <= ID_Instruction (31 downto 25);
          EX_read_data_1 <=  ID_read_data_1;
          EX_read_data_2 <=  ID_read_data_2; 
          EX_Register_Rs1 <=  ID_Instruction (19 downto 15);
          EX_Register_Rs2 <=  ID_Instruction (24 downto 20);
          EX_Register_Rd <=  ID_Instruction (11 downto 7);
          EX_SignImmSh <= SignImmSh;
          EX_PC <= ID_PC;
        end if;
      end if;
    end process;

end ID_EX_arch;
