----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/21/2020 08:56:01 PM
-- Design Name: 
-- Module Name: pack - Behavioral
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

package pack is
  component PC is
    Port ( 
      clk : in std_logic;
      reset : in std_logic;
      PCsrc : in std_logic;
      ID_stall : in std_logic;
      jumps : in std_logic_vector(1 downto 0);
      SignImmSh : in std_logic_vector(31 downto 0);
      ID_PC_signal : in std_logic_vector(31 downto 0);
      ID_read_data_1 : in std_logic_vector(31 downto 0);
      PC_out : out std_logic_vector(31 downto 0));
  end component PC;
  
component instruction_mem is
    Port (
      PC : in std_logic_vector(31 downto 0);
      Instruction : out std_logic_vector(31 downto 0));
  end component instruction_mem;
  
  component IF_ID is
    Port ( 
      clk : in std_logic;
      reset : in std_logic;
      IF_Flush : in std_logic;
      stall : in std_logic;
      PC_signal : in std_logic_vector(31 downto 0);
      IF_Instruction : in std_logic_vector(31 downto 0);
      ID_stall : out std_logic;
      ID_PC_signal : out std_logic_vector(31 downto 0);
      ID_Instruction : out std_logic_vector(31 downto 0));
  end component IF_ID;
  
  component hasard_detection_unit is
    Port (
      branch_condition : in std_logic;
      opcode : in std_logic_vector(6 downto 0);
      stall : out std_logic);
  end component hasard_detection_unit;

  component control_unit is
    Port (
      instruction : in std_logic_vector(31 downto 0);
      EX_ALU_op   : out std_logic_vector(4 downto 0);
      WB_ctrl  : out std_logic_vector(1 downto 0);
      MEM_ctrl :  out std_logic_vector(7 downto 0);
      ID_ctrl  : out std_logic_vector(2 downto 0);
      IF_ctrl  : out std_logic;
      inst_type: out  std_logic_vector(2 downto 0));
  end component control_unit;
  
  component imm_gen is
    Port (
      instruction : in std_logic_vector(31 downto 0);
      inst : in std_logic_vector(2 downto 0);
      immediate : out std_logic_vector(31 downto 0));
  end component imm_gen;

  component Registers is
    Port (
      clk : in std_logic;
      reg_write : in std_logic;
      read_reg_1 : in std_logic_vector(4 downto 0);
      read_reg_2 : in std_logic_vector(4 downto 0);
      write_reg  : in std_logic_vector(4 downto 0);
      write_data : in std_logic_vector(31 downto 0);
      read_data_1: out std_logic_vector(31 downto 0);
      read_data_2: out std_logic_vector(31 downto 0));
  end component Registers;
  
  component branch is
    Port (
      read_data_1 : in std_logic_vector(31 downto 0);
      read_data_2 : in std_logic_vector(31 downto 0);
      control_branch : in std_logic_vector(2 downto 0);
      branch_instruc : in std_logic;
      branch_condition : out std_logic);
  end component branch;
  
  component ID_EX is
    Port ( 
      clk : in std_logic;
      reset : in std_logic;
      Result_mux_control : in std_logic_vector(14 downto 0);
      ID_Instruction : in std_logic_vector(31 downto 0);
      ID_read_data_1 : in std_logic_vector(31 downto 0);
      ID_read_data_2 : in std_logic_vector(31 downto 0);
      SignImmSh : in std_logic_vector(31 downto 0);
      EX_SignImmSh : out std_logic_vector(31 downto 0);
      EX_EX : out std_logic_vector(4 downto 0);
      EX_M : out std_logic_vector(7 downto 0);
      EX_WB : out std_logic_vector(1 downto 0);
      EX_funct3 : out std_logic_vector(2 downto 0);
      EX_funct7 : out std_logic_vector(6 downto 0);
      EX_read_data_1 : out std_logic_vector(31 downto 0);
      EX_read_data_2 : out std_logic_vector(31 downto 0);
      EX_Register_Rs1 : out std_logic_vector(4 downto 0);
      EX_Register_Rs2 : out std_logic_vector(4 downto 0);
      EX_Register_Rd : out std_logic_vector(4 downto 0));
  end component ID_EX;
  
  component ALU_src is
    Port ( 
      FOWARD_OP : in std_logic_vector(1 downto 0);
      EX_read_data : in std_logic_vector(31 downto 0);
      WB_Result : in std_logic_vector(31 downto 0);
      MEM_AluResult : in std_logic_vector(31 downto 0);
      ALU_src : out std_logic_vector(31 downto 0));
  end component ALU_src;
  
  component ALU_unit is
    Port (
      src_A : in std_logic_vector(31 downto 0);
      src_B : in std_logic_vector(31 downto 0);
      funct_3 : in std_logic_vector(2 downto 0);
      funct_7 : in std_logic_vector(6 downto 0);
      decoded_opcode : in std_logic_vector(3 downto 0); 
      alu_result : out std_logic_vector (31 downto 0));
  end component ALU_unit;
  
  component Fowarding_unit is
    Port (
      rs1 : in std_logic_vector(4 downto 0);
      rs2 : in std_logic_vector(4 downto 0);
      rd_mem : in std_logic_vector(4 downto 0);
      mem_enable : in std_logic;
      rd_wb : in std_logic_vector(4 downto 0);
      wb_enable : in std_logic;
      foward_op_a : out std_logic_vector(1 downto 0);
      foward_op_b : out std_logic_vector(1 downto 0));
  end component Fowarding_unit;
  
  component EX_MEM is
    Port ( 
      clk : in std_logic;
      reset : in std_logic;
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
  end component EX_MEM;
  
  component Data_memory is
    Port (
      clk : in std_logic;
      reset : in std_logic;
      address : in std_logic_vector(31 downto 0);
      write_data : in std_logic_vector(31 downto 0);
      mem_read : in std_logic;
      mem_write : in std_logic;
      read_data : out std_logic_vector(31 downto 0));
  end component Data_memory;
  
  component MEM_WB is
    Port ( 
      clk : in std_logic;
      reset : in std_logic;
      MEM_WB : in std_logic_vector(1 downto 0);
      MEM_ReadData : in std_logic_vector(31 downto 0);
      MEM_AluResult : in std_logic_vector(31 downto 0);
      MEM_Register_Rd : in std_logic_vector(4 downto 0);
      WB_WB : out std_logic_vector(1 downto 0);
      WB_ReadData : out std_logic_vector(31 downto 0);
      WB_AluResult : out std_logic_vector(31 downto 0);
      WB_Register_Rd : out std_logic_vector(4 downto 0));
  end component MEM_WB;
  

end package pack;
