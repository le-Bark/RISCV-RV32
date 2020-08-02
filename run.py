##############################################################################
# TRIUMF4 Benchmarks unit test runner
# Author : Simon
# Date : 2018-12-06
# Adapted from https://github.com/VUnit/vunit/blob/master/examples/vhdl/uart/run.py
##############################################################################
from os.path import join, dirname
from vunit import VUnit

ui = VUnit.from_argv()

src_path = join(dirname(__file__), ".")
demo_lib = ui.add_library("demo_lib")

demo_lib.add_source_files(join(src_path, "ALU.vhd"))
demo_lib.add_source_files(join(src_path, "ALU_src.vhd"))
demo_lib.add_source_files(join(src_path, "branch.vhd"))
demo_lib.add_source_files(join(src_path, "data_memory.vhd"))
demo_lib.add_source_files(join(src_path, "Datapath_tb.vhd"))
demo_lib.add_source_files(join(src_path, "fowarding_unit.vhd"))
demo_lib.add_source_files(join(src_path, "hasard_detection_unit.vhd"))
demo_lib.add_source_files(join(src_path, "IF_ID.vhd"))
demo_lib.add_source_files(join(src_path, "instruction_mem.vhd"))
demo_lib.add_source_files(join(src_path, "pack.vhd"))
demo_lib.add_source_files(join(src_path, "registers.vhd"))
demo_lib.add_source_files(join(src_path, "ALU_control.vhd"))
demo_lib.add_source_files(join(src_path, "ALU_unit.vhd"))
demo_lib.add_source_files(join(src_path, "control_unit.vhd"))
#demo_lib.add_source_files(join(src_path, "Datapath.vhd"))
demo_lib.add_source_files(join(src_path, "EX_MEM.vhd"))
demo_lib.add_source_files(join(src_path, "fowarding_unit_tb.vhd"))
demo_lib.add_source_files(join(src_path, "ID_EX.vhd"))
demo_lib.add_source_files(join(src_path, "imm_gen.vhd"))
demo_lib.add_source_files(join(src_path, "MEM_WB.vhd"))
demo_lib.add_source_files(join(src_path, "PC.vhd"))
demo_lib.add_source_files(join(src_path, "hasard_detection_unit_tb.vhd"))
demo_lib.add_source_files(join(src_path, "control_unit_tb.vhd"))
demo_lib.add_source_files(join(src_path, "data_memory_tb.vhd"))
demo_lib.add_source_files(join(src_path, "imm_gen_tb.vhd"))
demo_lib.add_source_files(join(src_path, "instruction_mem_tb.vhd"))
demo_lib.add_source_files(join(src_path, "registers_tb.vhd"))


ui.set_compile_option("ghdl.flags", ["-frelaxed-rules","--no-vital-checks"])
ui.set_sim_option("ghdl.elab_flags", ["-fexplicit", "-frelaxed-rules",
                  "--no-vital-checks", "--warn-binding", "--mb-comments"])

ui.main()

