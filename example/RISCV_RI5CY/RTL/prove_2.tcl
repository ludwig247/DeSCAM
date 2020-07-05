delete_design -both
read_verilog -golden  -pragma_ignore {}  -version sv2009 {include/fpnew/src/fpnew_pkg.sv}
read_verilog -golden  -pragma_ignore {}  -version sv2009 {include/riscv_defines.sv include/apu_core_package.sv include/apu_macros.sv include/riscv_config.sv include/riscv_tracer_defines.sv}
read_verilog -golden  -pragma_ignore {}  -version sv2009 {include/top_level_types.sv include/isa_ri5cy_types.sv}
read_verilog -golden  -pragma_ignore {}  -version sv2009 {riscv_if_stage.sv riscv_hwloop_regs.sv riscv_hwloop_controller.sv riscv_prefetch_buffer.sv riscv_prefetch_L0_buffer.sv riscv_L0_buffer.sv riscv_fetch_fifo.sv}
read_verilog -golden  -pragma_ignore {}  -version sv2009 {riscv_id_stage.sv riscv_apu_disp.sv riscv_decoder.sv riscv_compressed_decoder.sv}
read_verilog -golden  -pragma_ignore {}  -version sv2009 {riscv_cs_registers.sv riscv_register_file.sv register_file_test_wrap.sv}
read_verilog -golden  -pragma_ignore {}  -version sv2009 {riscv_ex_stage.sv riscv_alu_div.sv riscv_alu.sv riscv_mult.sv riscv_pmp.sv}
read_verilog -golden  -pragma_ignore {}  -version sv2009 {riscv_load_store_unit.sv riscv_int_controller.sv riscv_controller.sv riscv_core.sv}
elaborate -golden
compile -golden

set_mode mv
set_itl_flavor vli



