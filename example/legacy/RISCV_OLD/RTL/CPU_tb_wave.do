onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 30 Clock
add wave -noupdate -height 15 /cpu_tb/clk
add wave -noupdate -divider -height 30 Reset
add wave -noupdate -height 15 /cpu_tb/rst
add wave -noupdate -divider -height 30 {Memory to Decoder}
add wave -noupdate -height 15 -radix hexadecimal /cpu_tb/MemToDec_port
add wave -noupdate -height 15 /cpu_tb/MemToDec_port_sync
add wave -noupdate -height 15 /cpu_tb/MemToDec_port_notify
add wave -noupdate -divider -height 30 {Memory to Control-Path}
add wave -noupdate -height 15 -radix hexadecimal -subitemconfig {/cpu_tb/MemToCtl_port(31) {-height 15} /cpu_tb/MemToCtl_port(30) {-height 15} /cpu_tb/MemToCtl_port(29) {-height 15} /cpu_tb/MemToCtl_port(28) {-height 15} /cpu_tb/MemToCtl_port(27) {-height 15} /cpu_tb/MemToCtl_port(26) {-height 15} /cpu_tb/MemToCtl_port(25) {-height 15} /cpu_tb/MemToCtl_port(24) {-height 15} /cpu_tb/MemToCtl_port(23) {-height 15} /cpu_tb/MemToCtl_port(22) {-height 15} /cpu_tb/MemToCtl_port(21) {-height 15} /cpu_tb/MemToCtl_port(20) {-height 15} /cpu_tb/MemToCtl_port(19) {-height 15} /cpu_tb/MemToCtl_port(18) {-height 15} /cpu_tb/MemToCtl_port(17) {-height 15} /cpu_tb/MemToCtl_port(16) {-height 15} /cpu_tb/MemToCtl_port(15) {-height 15} /cpu_tb/MemToCtl_port(14) {-height 15} /cpu_tb/MemToCtl_port(13) {-height 15} /cpu_tb/MemToCtl_port(12) {-height 15} /cpu_tb/MemToCtl_port(11) {-height 15} /cpu_tb/MemToCtl_port(10) {-height 15} /cpu_tb/MemToCtl_port(9) {-height 15} /cpu_tb/MemToCtl_port(8) {-height 15} /cpu_tb/MemToCtl_port(7) {-height 15} /cpu_tb/MemToCtl_port(6) {-height 15} /cpu_tb/MemToCtl_port(5) {-height 15} /cpu_tb/MemToCtl_port(4) {-height 15} /cpu_tb/MemToCtl_port(3) {-height 15} /cpu_tb/MemToCtl_port(2) {-height 15} /cpu_tb/MemToCtl_port(1) {-height 15} /cpu_tb/MemToCtl_port(0) {-height 15}} /cpu_tb/MemToCtl_port
add wave -noupdate -height 15 /cpu_tb/MemToCtl_port_sync
add wave -noupdate -height 15 /cpu_tb/MemToCtl_port_notify
add wave -noupdate -divider -height 30 {Control-Path to Memory}
add wave -noupdate -height 15 -radix unsigned -childformat {{/cpu_tb/CtlToMem_port.addrIn -radix decimal} {/cpu_tb/CtlToMem_port.dataIn -radix hexadecimal}} -expand -subitemconfig {/cpu_tb/CtlToMem_port.addrIn {-height 15 -radix decimal} /cpu_tb/CtlToMem_port.dataIn {-height 15 -radix hexadecimal} /cpu_tb/CtlToMem_port.mask {-height 15} /cpu_tb/CtlToMem_port.req {-height 15}} /cpu_tb/CtlToMem_port
add wave -noupdate -height 15 /cpu_tb/CtlToMem_port_sync
add wave -noupdate -height 15 /cpu_tb/CtlToMem_port_notify
add wave -noupdate -divider -height 30 {ALU to Control-Path}
add wave -noupdate -height 15 -radix unsigned /cpu_tb/IF_CPU/ALUtoCtl_port
add wave -noupdate -height 15 /cpu_tb/IF_CPU/ALUtoCtl_port_sync
add wave -noupdate -height 15 /cpu_tb/IF_CPU/ALUtoCtl_port_notify
add wave -noupdate -divider -height 30 {Control-Path to ALU}
add wave -noupdate -height 15 -radix unsigned -childformat {{/cpu_tb/IF_CPU/CtlToALU_port.imm -radix unsigned} {/cpu_tb/IF_CPU/CtlToALU_port.pc_reg -radix unsigned} {/cpu_tb/IF_CPU/CtlToALU_port.reg1_contents -radix unsigned} {/cpu_tb/IF_CPU/CtlToALU_port.reg2_contents -radix unsigned}} -expand -subitemconfig {/cpu_tb/IF_CPU/CtlToALU_port.alu_fun {-height 15} /cpu_tb/IF_CPU/CtlToALU_port.imm {-height 15 -radix unsigned} /cpu_tb/IF_CPU/CtlToALU_port.op1_sel {-height 15} /cpu_tb/IF_CPU/CtlToALU_port.op2_sel {-height 15} /cpu_tb/IF_CPU/CtlToALU_port.pc_reg {-height 15 -radix unsigned} /cpu_tb/IF_CPU/CtlToALU_port.reg1_contents {-height 15 -radix unsigned} /cpu_tb/IF_CPU/CtlToALU_port.reg2_contents {-height 15 -radix unsigned}} /cpu_tb/IF_CPU/CtlToALU_port
add wave -noupdate -height 15 /cpu_tb/IF_CPU/CtlToALU_port_sync
add wave -noupdate -height 15 /cpu_tb/IF_CPU/CtlToALU_port_notify
add wave -noupdate -divider -height 30 {Control-Path to Register-File}
add wave -noupdate -height 15 -radix unsigned -childformat {{/cpu_tb/IF_CPU/CtlToRegs_port.dst -radix unsigned} {/cpu_tb/IF_CPU/CtlToRegs_port.dst_data -radix unsigned} {/cpu_tb/IF_CPU/CtlToRegs_port.src1 -radix unsigned} {/cpu_tb/IF_CPU/CtlToRegs_port.src2 -radix unsigned}} -expand -subitemconfig {/cpu_tb/IF_CPU/CtlToRegs_port.dst {-height 15 -radix unsigned} /cpu_tb/IF_CPU/CtlToRegs_port.dst_data {-height 15 -radix unsigned} /cpu_tb/IF_CPU/CtlToRegs_port.req {-height 15} /cpu_tb/IF_CPU/CtlToRegs_port.src1 {-height 15 -radix unsigned} /cpu_tb/IF_CPU/CtlToRegs_port.src2 {-height 15 -radix unsigned}} /cpu_tb/IF_CPU/CtlToRegs_port
add wave -noupdate -height 15 /cpu_tb/IF_CPU/CtlToRegs_port_sync
add wave -noupdate -height 15 /cpu_tb/IF_CPU/CtlToRegs_port_notify
add wave -noupdate -divider -height 30 {Register-File to Control-Path}
add wave -noupdate -height 15 -radix unsigned -childformat {{/cpu_tb/IF_CPU/RegsToCtl_port.contents1 -radix unsigned} {/cpu_tb/IF_CPU/RegsToCtl_port.contents2 -radix unsigned}} -expand -subitemconfig {/cpu_tb/IF_CPU/RegsToCtl_port.contents1 {-height 15 -radix unsigned} /cpu_tb/IF_CPU/RegsToCtl_port.contents2 {-height 15 -radix unsigned}} /cpu_tb/IF_CPU/RegsToCtl_port
add wave -noupdate -height 15 /cpu_tb/IF_CPU/RegsToCtl_port_sync
add wave -noupdate -height 15 /cpu_tb/IF_CPU/RegsToCtl_port_notify
add wave -noupdate -divider -height 30 {Decoder to Control-Path}
add wave -noupdate -height 15 -radix decimal -childformat {{/cpu_tb/IF_CPU/DecToCtl_port.imm -radix decimal} {/cpu_tb/IF_CPU/DecToCtl_port.rd_addr -radix decimal} {/cpu_tb/IF_CPU/DecToCtl_port.rs1_addr -radix decimal} {/cpu_tb/IF_CPU/DecToCtl_port.rs2_addr -radix decimal}} -expand -subitemconfig {/cpu_tb/IF_CPU/DecToCtl_port.encType {-height 15} /cpu_tb/IF_CPU/DecToCtl_port.imm {-height 15 -radix decimal} /cpu_tb/IF_CPU/DecToCtl_port.instrType {-height 15} /cpu_tb/IF_CPU/DecToCtl_port.rd_addr {-height 15 -radix decimal} /cpu_tb/IF_CPU/DecToCtl_port.rs1_addr {-height 15 -radix decimal} /cpu_tb/IF_CPU/DecToCtl_port.rs2_addr {-height 15 -radix decimal}} /cpu_tb/IF_CPU/DecToCtl_port
add wave -noupdate -height 15 /cpu_tb/IF_CPU/DecToCtl_port_sync
add wave -noupdate -height 15 /cpu_tb/IF_CPU/DecToCtl_port_notify
add wave -noupdate -divider -height 30 ALU
add wave -noupdate -height 15 /cpu_tb/IF_CPU/IF_ALU/section
add wave -noupdate -height 15 -radix unsigned -subitemconfig {/cpu_tb/IF_CPU/IF_ALU/ALUtoCtl_data_signal.ALU_result {-height 15}} /cpu_tb/IF_CPU/IF_ALU/ALUtoCtl_data_signal
add wave -noupdate -height 15 -radix decimal /cpu_tb/IF_CPU/IF_ALU/CtlToALU_data_signal
add wave -noupdate -divider -height 30 Control-Path
add wave -noupdate -height 15 /cpu_tb/IF_CPU/IF_CPath/section
add wave -noupdate -height 15 -radix unsigned /cpu_tb/IF_CPU/IF_CPath/ALUtoCtl_data_signal
add wave -noupdate -height 15 -radix unsigned /cpu_tb/IF_CPU/IF_CPath/CtlToALU_data_signal
add wave -noupdate -height 15 -radix unsigned /cpu_tb/IF_CPU/IF_CPath/CtlToRegs_data_signal
add wave -noupdate -height 15 -radix unsigned /cpu_tb/IF_CPU/IF_CPath/RegsToCtl_data_signal
add wave -noupdate -height 15 /cpu_tb/IF_CPU/IF_CPath/br_en_signal
add wave -noupdate -height 15 -radix unsigned /cpu_tb/IF_CPU/IF_CPath/decodedInstr_signal
add wave -noupdate -height 15 -radix unsigned /cpu_tb/IF_CPU/IF_CPath/MemToCtl_data_signal
add wave -noupdate -height 15 /cpu_tb/IF_CPU/IF_CPath/mem_en_signal
add wave -noupdate -height 15 -radix unsigned /cpu_tb/IF_CPU/IF_CPath/memoryAccess_signal
add wave -noupdate -height 15 -radix unsigned /cpu_tb/IF_CPU/IF_CPath/pc_next_signal
add wave -noupdate -height 15 -radix unsigned /cpu_tb/IF_CPU/IF_CPath/pc_reg_signal
add wave -noupdate -height 15 /cpu_tb/IF_CPU/IF_CPath/pc_sel_signal
add wave -noupdate -height 15 /cpu_tb/IF_CPU/IF_CPath/reg_rd_en_signal
add wave -noupdate -height 15 -radix unsigned -subitemconfig {/cpu_tb/IF_CPU/IF_CPath/wb_data_signal(31) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(30) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(29) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(28) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(27) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(26) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(25) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(24) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(23) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(22) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(21) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(20) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(19) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(18) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(17) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(16) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(15) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(14) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(13) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(12) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(11) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(10) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(9) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(8) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(7) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(6) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(5) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(4) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(3) {-height 15} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal(2) {-height 15}} /cpu_tb/IF_CPU/IF_CPath/wb_data_signal
add wave -noupdate -height 15 /cpu_tb/IF_CPU/IF_CPath/wb_en_signal
add wave -noupdate -height 15 /cpu_tb/IF_CPU/IF_CPath/wb_sel_signal
add wave -noupdate -divider -height 30 Decoder
add wave -noupdate -height 15 /cpu_tb/IF_CPU/IF_Decoder/section
add wave -noupdate -height 15 -radix unsigned /cpu_tb/IF_CPU/IF_Decoder/decoded_instr_signal
add wave -noupdate -height 15 -radix hexadecimal /cpu_tb/IF_CPU/IF_Decoder/encoded_instr_signal
add wave -noupdate -divider -height 30 Register-File
add wave -noupdate -height 15 /cpu_tb/IF_CPU/IF_Regs/section
add wave -noupdate -height 15 -radix unsigned /cpu_tb/IF_CPU/IF_Regs/CtlToRegs_data_signal
add wave -noupdate -height 15 -radix unsigned /cpu_tb/IF_CPU/IF_Regs/RegsToCtl_data_signal
add wave -noupdate -height 15 -radix unsigned -childformat {{/cpu_tb/IF_CPU/IF_Regs/reg_file(0) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(1) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(2) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(3) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(4) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(5) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(6) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(7) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(8) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(9) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(10) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(11) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(12) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(13) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(14) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(15) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(16) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(17) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(18) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(19) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(20) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(21) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(22) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(23) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(24) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(25) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(26) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(27) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(28) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(29) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(30) -radix unsigned} {/cpu_tb/IF_CPU/IF_Regs/reg_file(31) -radix unsigned}} -expand -subitemconfig {/cpu_tb/IF_CPU/IF_Regs/reg_file(0) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(1) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(2) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(3) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(4) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(5) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(6) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(7) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(8) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(9) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(10) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(11) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(12) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(13) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(14) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(15) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(16) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(17) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(18) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(19) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(20) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(21) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(22) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(23) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(24) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(25) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(26) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(27) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(28) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(29) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(30) {-height 15 -radix unsigned} /cpu_tb/IF_CPU/IF_Regs/reg_file(31) {-height 15 -radix unsigned}} /cpu_tb/IF_CPU/IF_Regs/reg_file
add wave -noupdate -divider -height 30 Memory
add wave -noupdate -height 15 /cpu_tb/IF_Memory/section
add wave -noupdate -height 15 -radix hexadecimal /cpu_tb/IF_Memory/ram
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7135 ns} 0}
configure wave -namecolwidth 237
configure wave -valuecolwidth 350
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {6841 ns} {7167 ns}
