set_mode setup
delete_design -both
read_verilog -golden  -pragma_ignore {}  -version sv2005 {design/ibex_pkg.sv }
read_verilog -golden  -pragma_ignore {}  -version sv2005 {design/ibex_fetch_fifo.sv}
read_verilog -golden  -pragma_ignore {}  -version sv2005 {design/ibex_compressed_decoder.sv design/ibex_if_stage.sv design/ibex_prefetch_buffer.sv }
read_verilog -golden  -pragma_ignore {}  -version sv2005 {design/ibex_ex_block.sv design/ibex_multdiv_fast.sv}
read_verilog -golden  -pragma_ignore {}  -version sv2005 {design/ibex_controller.sv design/ibex_id_stage.sv design/ibex_register_file_ff.sv design/ibex_decoder.sv}
read_verilog -golden  -pragma_ignore {}  -version sv2005 {design/ibex_alu.sv design/ibex_load_store_unit.sv design/ibex_cs_registers.sv}
read_verilog -golden  -pragma_ignore {}  -version sv2005 {design/ibex_core.sv }
elaborate -golden
set_mode mv
set_itl_flavor vli
#read_itl {verif/macros.vli verif/prop.vli verif/constraints.vli verif/instr_alu.vli verif/instr_branch.vli verif/instr_ld.vli verif/instr_st.vli verif/instr_jump.vli verif/instr_const.vli verif/instr_csr.vli}
read_itl {verif/macros.vli verif/new_prop.vli verif/constraints.vli verif/instr_csr.vli}
#read_itl {verif/completeness.vli}
#check_completeness -reset * "ibex"
#check_completeness -successor {* *} "ibex"
#check_completeness -determination {* *} "ibex"
check -pass -force [get_properties]
check [get_properties]