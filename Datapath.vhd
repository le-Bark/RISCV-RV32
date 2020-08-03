----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/30/2020 10:59:44 AM
-- Design Name: 
-- Module Name: Datapath - Datapath_arch
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
use work.pack.all; 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Datapath is
	generic(
		constant bus_size : integer := 32
		);
    Port ( clk : in std_logic;
           reset : in std_logic;
           reg_out : out ramtype);
end Datapath;

architecture Datapath_arch of Datapath is
  signal PCsrc               : std_logic;
  signal stall               : std_logic;
  signal IF_Flush            : std_logic;
  signal ID_stall            : std_logic;
  signal AUIPC_ctrl_EX       : std_logic;
  signal PC_stall            : std_logic;
  signal MEM_WB_sig          : std_logic_vector(1 downto 0);
  signal WB_WB               : std_logic_vector(1 downto 0);
  signal EX_WB               : std_logic_vector(1 downto 0);
  signal FOWARD_OP_A         : std_logic_vector(1 downto 0);
  signal FOWARD_OP_B         : std_logic_vector(1 downto 0);
  signal WB_ctrl             : std_logic_vector(1 downto 0);
  signal ID_ctrl             : std_logic_vector(2 downto 0);
  signal inst_type           : std_logic_vector(2 downto 0);
  signal MEM_load            : std_logic_vector(2 downto 0);
  signal MEM_store           : std_logic_vector(2 downto 0);
  signal EX_ctrl             : std_logic_vector(5 downto 0);
  signal EX_EX               : std_logic_vector(5 downto 0);

  signal EX_Register_Rd      : std_logic_vector(4 downto 0);
  signal MEM_Register_Rd     : std_logic_vector(4 downto 0);
  signal WB_Register_Rd      : std_logic_vector(4 downto 0);
  signal EX_funct3           : std_logic_vector(2 downto 0);
  signal EX_funct7           : std_logic_vector(6 downto 0);
  signal MEM_M               : std_logic_vector(7 downto 0);
  signal EX_M                : std_logic_vector(7 downto 0);
  signal MEM_ctrl            : std_logic_vector(7 downto 0);
  signal Control_mux         : std_logic_vector(15 downto 0);
  signal Result_mux_control  : std_logic_vector(15 downto 0);
  signal ID_SignImm          : std_logic_vector(bus_size - 1 downto 0);
  signal SignImmSh           : std_logic_vector(bus_size - 1 downto 0);
  signal EX_SignImmSh        : std_logic_vector(bus_size - 1 downto 0);
  signal WB_Result           : std_logic_vector(bus_size - 1 downto 0);
  signal MEM_AluResult       : std_logic_vector(bus_size - 1 downto 0);
  signal ID_Instruction      : std_logic_vector(bus_size - 1 downto 0);
  signal IF_Instruction      : std_logic_vector(bus_size - 1 downto 0);
  signal AluResult_sig       : std_logic_vector(bus_size - 1 downto 0);
  signal ID_read_data_1      : std_logic_vector(bus_size - 1 downto 0);
  signal ID_read_data_2      : std_logic_vector(bus_size - 1 downto 0);
  signal EX_read_data_1      : std_logic_vector(bus_size - 1 downto 0);
  signal EX_read_data_2      : std_logic_vector(bus_size - 1 downto 0);
  signal ALU_src_A           : std_logic_vector(bus_size - 1 downto 0);
  signal ALU_src_B           : std_logic_vector(bus_size - 1 downto 0);
  signal ALUSrc_result_B     : std_logic_vector(bus_size - 1 downto 0);
  signal MEM_ALU_src_B       : std_logic_vector(bus_size - 1 downto 0);
  signal MEM_ReadData        : std_logic_vector(bus_size - 1 downto 0);
  signal MEM_writeData_store : std_logic_vector(bus_size - 1 downto 0);
  signal MEM_readData_load   : std_logic_vector(bus_size - 1 downto 0);
  signal IF_PC               : std_logic_vector(bus_size - 1 downto 0);
  signal ID_PC               : std_logic_vector(bus_size - 1 downto 0);
  signal EX_PC               : std_logic_vector(bus_size - 1 downto 0);
  signal ALUSrc_result_A     : std_logic_vector(bus_size - 1 downto 0);
  signal ID_src_A            : std_logic_vector(bus_size - 1 downto 0);
  signal ID_src_B            : std_logic_vector(bus_size - 1 downto 0);
  signal MEM_Result          : std_logic_vector(bus_size - 1 downto 0);

begin

  Instruction_memory_1 : instruction_mem
    port map (
      PC          => IF_PC,
      Instruction => IF_Instruction);

  IF_ID_1 : IF_ID
    port map (
      clk            => clk,
      reset          => reset,
      IF_Flush       => IF_Flush,
      stall          => stall,
      IF_PC          => IF_PC,
      IF_Instruction => IF_Instruction,
      ID_stall       => ID_stall,
      ID_PC          => ID_PC,
      ID_Instruction => ID_Instruction);

  control_unit_1 : control_unit
    port map (
      instruction => ID_Instruction,
      EX_ALU_op   => EX_ctrl,
      WB_ctrl     => WB_ctrl,
      MEM_ctrl    => MEM_ctrl,
      ID_ctrl     => ID_ctrl,
      IF_ctrl     => IF_Flush,
      inst_type   => inst_type);

  imm_gen_1 : imm_gen
    port map (
      instruction => ID_Instruction,
      inst        => inst_type,
      immediate   => SignImmSh);

  PC_1 : PC
    port map (
      clk            => clk,
      reset          => reset,
      PCsrc          => PCsrc,
      ID_stall       => ID_stall,
      PC_stall       => PC_stall,
      jumps          => ID_ctrl(1 downto 0),
      SignImmSh      => SignImmSh,
      ID_PC_signal   => ID_PC,
      ID_read_data_1 => ID_read_data_1,
      PC_out         => IF_PC);

  Hazard_unit_1 : hasard_detection_unit
    port map (
      branch_condition => PCsrc,
      ID_stall       => ID_stall,
      opcode           => ID_Instruction (6 downto 0),
      stall            => stall,
      PC_stall    => PC_stall);

  Registers_1 : Registers
    port map (
      clk         => clk,
      reg_write   => WB_WB(1),
      read_reg_1  => ID_Instruction (19 downto 15),
      read_reg_2  => ID_Instruction (24 downto 20),
      write_reg   => WB_Register_Rd,
      write_data  => WB_Result,
      read_data_1 => ID_read_data_1,
      read_data_2 => ID_read_data_2,
      reg_out => reg_out);
        


  branch_verif : branch
    port map (
      read_data_1      => ID_src_A,
      read_data_2      => ID_src_B,
      control_branch   => ID_Instruction (14 downto 12),
      branch_instruc   => ID_ctrl(2),
      branch_condition => PCsrc);

  Control_mux        <= WB_ctrl & MEM_ctrl & EX_ctrl;
  Result_mux_control <= (others => '0') when (ID_stall = '1') else Control_mux;

  ID_EX_1 : ID_EX
    port map (
      clk                => clk,
      reset              => reset,
      Result_mux_control => Result_mux_control,
      ID_Instruction     => ID_Instruction,
      ID_read_data_1     => ID_src_A,
      ID_read_data_2     => ID_src_B,
      ID_PC              => ID_PC,
      SignImmSh          => SignImmSh,
      EX_SignImmSh       => EX_SignImmSh,
      EX_EX              => EX_EX,
      EX_M               => EX_M,
      EX_WB              => EX_WB,
      EX_funct3          => EX_funct3,
      EX_funct7          => EX_funct7,
      EX_read_data_1     => EX_read_data_1,
      EX_read_data_2     => EX_read_data_2,
      EX_PC              => EX_PC,
      EX_Register_Rd     => EX_Register_Rd);

  ALU_src_A_1 : ALU_src
    port map (
      FOWARD_OP     => FOWARD_OP_A,
      REG_read  => ID_read_data_1,
      EX_Result     => AluResult_sig,
      MEM_Result => MEM_result,
      ID_src       => ID_src_A);

  ALU_src_B_1 : ALU_src
    port map (
      FOWARD_OP     => FOWARD_OP_B,
      REG_read  => ID_read_data_2,
      EX_Result     => AluResult_sig,
      MEM_Result => MEM_result,
      ID_src       => ID_src_B);

  AUIPC_ctrl_EX <= '1' when EX_EX(3 downto 0) = "0001" else
    '0';

  ALUSrc_result_A <= EX_PC when ( (EX_EX(5) = '1') or (AUIPC_ctrl_EX = '1') ) else
  EX_read_data_1;

  ALUSrc_result_B <= EX_SignImmSh when (EX_EX(4) = '1') else
    (x"00000004") when (EX_EX(5) = '1') else
    EX_read_data_2;

  ALU_unit_1 : ALU_unit
    port map (
      src_A          => ALUSrc_result_A,
      src_B          => ALUSrc_result_B,
      funct_3        => EX_funct3,
      funct_7        => EX_funct7,
      decoded_opcode => EX_EX (3 downto 0),
      alu_result     => AluResult_sig);

  Fowarding_unit_1 : Fowarding_unit
    port map (
      rs1         => ID_Instruction (19 downto 15),
      rs2         => ID_Instruction (24 downto 20),
      rd_ex      => EX_Register_Rd,
      ex_enable  => EX_WB(1),
      rd_mem       => MEM_Register_Rd,
      mem_enable   => MEM_WB_sig(1),
      foward_op_a => FOWARD_OP_A,
      foward_op_b => FOWARD_OP_B);

  EX_MEM_1 : EX_MEM
    port map (
      clk             => clk,
      reset           => reset,
      EX_M            => EX_M,
      EX_WB           => EX_WB,
      AluResult_sig   => AluResult_sig,
      ALU_src_B       => EX_read_data_2,
      EX_Register_Rd  => EX_Register_Rd,
      MEM_M           => MEM_M,
      MEM_WB          => MEM_WB_sig,
      MEM_AluResult   => MEM_AluResult,
      MEM_ALU_src_B   => MEM_ALU_src_B,
      MEM_Register_Rd => MEM_Register_Rd);

  MEM_store <= MEM_M(2 downto 0);
  MEM_load  <= MEM_M(5 downto 3);

  Data_memory_1 : Data_memory
    port map (
      clk        => clk,
      reset      => reset,
      address    => MEM_AluResult,
      write_data => MEM_ALU_src_B,
      mem_read   => MEM_M(7),
      store_ctrl => MEM_store,
      mem_write  => MEM_M(6),
      read_data  => MEM_ReadData);


  MEM_readData_load <= std_logic_vector(resize(signed(MEM_ReadData(7 downto 0)),32)) when MEM_load = "000" else
    std_logic_vector(resize(signed(MEM_ReadData(15 downto 0)),32))   when MEM_load = "001" else
    std_logic_vector(resize(unsigned(MEM_ReadData(7 downto 0)),32))  when MEM_load = "100" else
    std_logic_vector(resize(unsigned(MEM_ReadData(15 downto 0)),32)) when MEM_load = "101" else
    MEM_ReadData;


  MEM_Result <= MEM_readData_load when (MEM_WB_sig(0) = '1') else MEM_AluResult;

  MEM_WB_1 : MEM_WB
    port map (
      clk             => clk,
      reset           => reset,
      MEM_Result       => MEM_Result,
      MEM_WB          => MEM_WB_sig,
      MEM_Register_Rd => MEM_Register_Rd,
      WB_WB           => WB_WB,
      WB_result       => WB_result,
      WB_Register_Rd  => WB_Register_Rd);

    
end Datapath_arch;
