--------------------------------------------------------------------------------
-- Title       : <Control_unit>
-- Project     : RISCV Hardware Conception
--------------------------------------------------------------------------------
-- File        : control_unit.vhd
-- Author      : Angelo
-- Last update : Fri Jul 31 01:09:00 2020
--------------------------------------------------------------------------------
-- Copyright (c) 2020 Angelo Bautista-Gomez
-------------------------------------------------------------------------------
-- Description: Control Unit that sends all the control signals needed for
--              the processor
--------------------------------------------------------------------------------
-- Revisions:  
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity control_unit is
    Port (
        instruction : in  std_logic_vector(31 downto 0);
        EX_ALU_op   : out std_logic_vector(5 downto 0);
        WB_ctrl     : out std_logic_vector(1 downto 0);
        MEM_ctrl    : out std_logic_vector(7 downto 0);
        ID_ctrl     : out std_logic_vector(2 downto 0);
        IF_ctrl     : out std_logic;
        inst_type   : out std_logic_vector(2 downto 0)
    );
end control_unit;

architecture control of control_unit is
    signal opcode : std_logic_vector (6 downto 0);
    signal funct3 : std_logic_vector (2 downto 0);
    signal funct7 : std_logic_vector (6 downto 0);
    -- Ordre des bits de 12 a 0: 
    -- RegWrite(1) / Branch(1) / Decoded_Opcode(4) / MemRead(1) / MemWrite(1) / MemtoReg(1) / JAL(1) / JALR(1) / Flush(1)
    signal output     : std_logic_vector (12 downto 0);
    signal i_type     : std_logic_vector(2 downto 0);
    signal load_ctrl  : std_logic_vector(2 downto 0);
    signal store_ctrl : std_logic_vector(2 downto 0);

begin

    opcode <= instruction(6 downto 0);
    funct3 <= instruction(14 downto 12);
    funct7 <= instruction(31 downto 25);


    Process(opcode)
    begin
        case opcode is
            when "0110011" => output <= "1010000000000"; i_type <= "000" ; --Type R
            when "0000011" => output <= "1001011010001"; i_type <= "001";  --Type I (Loads) 
            when "1100111" => output <= "1000110000101"; i_type <= "001";  --Type I JALR
            when "0010011" => output <= "1001110000001"; i_type <= "001";  --Type I Arithmetics
            when "0100011" => output <= "0001100100001"; i_type <= "010";  --Type S (Stores)
            when "1100011" => output <= "0100000000000"; i_type <= "011";  --Type B (Branches)
            when "0110111" => output <= "1000000000001"; i_type <= "100";  --Type U (LUI)
            when "0010111" => output <= "1000010000001"; i_type <= "100";  --Type U (AUIPC)
                                                                           --                         --2109876543210
            when "1101111" => output <= "1000100001000"; i_type <= "101";  --Type J (JAL)
            when "1110011" => output <= "0000000000011"; i_type <= "110";  --NOP
            when others    => output <= "0000000000000"; i_type <= "110";
        end case;

    end process;

    load_ctrl  <= funct3 when opcode = "0000011" else "010"; --load word par default
    store_ctrl <= funct3 when opcode = "0100011" else "010"; --store word par default

    --Assignation des sorties
    EX_ALU_op <= (output(3) or output(2)) & output(0) & output(10 downto 7) ; --Decoded_opcode/AluSrc
    WB_ctrl   <= output(12) & output(4);                                      -- RegWrite/MemtoReg
    MEM_ctrl  <= output(6) & output(5) & load_ctrl & store_ctrl;              -- MemRead/MemWrite
    ID_ctrl   <= output(11) & output(3) & output(2);                          --Branch/JAL/JALR
    IF_ctrl   <= output(1);                                                   -- ID_FLUSH
    inst_type <= i_type;


end control;
