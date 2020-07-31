##############################################################################
# RISC-V data_memory Test
# Author : Angelo Bautista-Gomez
# Date : 2020-07-30
# Adapted from https://github.com/VUnit/vunit/blob/master/examples/vhdl/uart/run.py
##############################################################################
from os.path import join, dirname
from vunit import VUnit

ui = VUnit.from_argv()

src_path = join(dirname(__file__), ".")
demo_lib = ui.add_library("demo_lib")

demo_lib.add_source_files(join(src_path, "data_memory.vhd"))
demo_lib.add_source_files(join(src_path, "data_memory_tb.vhd"))


ui.set_compile_option("ghdl.flags", ["-frelaxed-rules","--no-vital-checks"])
ui.set_sim_option("ghdl.elab_flags", ["-fexplicit", "-frelaxed-rules",
                  "--no-vital-checks", "--warn-binding", "--mb-comments"])

ui.main()