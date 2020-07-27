----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/13/2020 08:19:53 PM
-- Design Name: 
-- Module Name: branch - Behavioral
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

entity branch is
    Port ( read_data_1 : in std_logic_vector(31 downto 0);
           read_data_2 : in std_logic_vector(31 downto 0);
           control_branch : in std_logic_vector(2 downto 0);
           branch_instruc : in std_logic;
           branch_condition : out std_logic);
end branch;

architecture branch_arch of branch is
signal uns_ID_read_data_1 : unsigned(31 downto 0);
signal uns_ID_read_data_2 : unsigned(31 downto 0);
signal sign_ID_read_data_1 : signed(31 downto 0);
signal sign_ID_read_data_2 : signed(31 downto 0);
begin
  uns_ID_read_data_1  <= unsigned(read_data_1);
  uns_ID_read_data_2  <= unsigned(read_data_2);
  sign_ID_read_data_1  <= signed(read_data_1);
  sign_ID_read_data_2  <= signed(read_data_2);
  
  branch_condition  <= '1' when (control_branch = "000" and branch_instruc = '1' and (sign_ID_read_data_1 = sign_ID_read_data_2)) or
					 (control_branch = "001" and branch_instruc = '1' and (sign_ID_read_data_1 /= sign_ID_read_data_2)) or
					 (control_branch = "100" and branch_instruc = '1' and (sign_ID_read_data_1 < sign_ID_read_data_2)) or
					 (control_branch = "101" and branch_instruc = '1' and ((sign_ID_read_data_1 > sign_ID_read_data_2) or (sign_ID_read_data_1 = sign_ID_read_data_2))) or
					 (control_branch = "110" and branch_instruc = '1' and (uns_ID_read_data_1 < uns_ID_read_data_2)) or
					 (control_branch = "111" and branch_instruc = '1' and ((uns_ID_read_data_1 > uns_ID_read_data_2) or (uns_ID_read_data_1 = uns_ID_read_data_2)))
					 else '0';

end branch_arch;
