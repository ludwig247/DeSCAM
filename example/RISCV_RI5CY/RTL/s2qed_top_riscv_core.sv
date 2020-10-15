import apu_core_package::*;

`include "include/riscv_config.sv"

import riscv_defines::*;
import top_level_types::*;
//import isa_ri5cy_types::*;

module s2qed_top_riscv_core
#(
    parameter N_EXT_PERF_COUNTERS =  0,
    parameter INSTR_RDATA_WIDTH   = 32,
    parameter PULP_SECURE         =  0,
    parameter N_PMP_ENTRIES       = 16,
    parameter USE_PMP             =  1, //if PULP_SECURE is 1, you can still not use the PMP
    parameter PULP_CLUSTER        =  0, //-- changed from 1 to 0
    parameter FPU                 =  0,
    parameter Zfinx               =  0,
    parameter FP_DIVSQRT          =  0,
    parameter SHARED_FP           =  0,
    parameter SHARED_DSP_MULT     =  0,
    parameter SHARED_INT_MULT     =  0,
    parameter SHARED_INT_DIV      =  0,
    parameter SHARED_FP_DIVSQRT   =  0,
    parameter WAPUTYPE            =  0,
    parameter APU_NARGS_CPU       =  3,
    parameter APU_WOP_CPU         =  6,
    parameter APU_NDSFLAGS_CPU    = 15,
    parameter APU_NUSFLAGS_CPU    =  5,
    parameter DM_HaltAddress      = 32'h1A110800
)
(
    // Clock and Reset
    input  logic        clk_i,
    input  logic        rst_ni,

    input  logic        clock_en_i,    // enable clock, otherwise it is gated
    input  logic        test_en_i,     // enable all clock gates for testing

    input  logic        fregfile_disable_i,  // disable the fp regfile, using int regfile instead

    // Core ID, Cluster ID and boot address are considered more or less static
    input  logic [31:0] boot_addr_i,
    input  logic [ 3:0] core_id_i,
    input  logic [ 5:0] cluster_id_i,

    // Instruction memory interface cpu1
    input  logic                         instr_gnt_1_i,
    input  logic                         instr_rvalid_1_i,
    input  logic [INSTR_RDATA_WIDTH-1:0] instr_rdata_1_i,

    // Instruction memory interface cpu2
    input  logic                         instr_gnt_2_i,
    input  logic                         instr_rvalid_2_i,
    input  logic [INSTR_RDATA_WIDTH-1:0] instr_rdata_2_i,

    // Data memory interface cpu1
    input  logic        data_gnt_1_i,
    input  logic        data_rvalid_1_i,
    input  logic [31:0] data_rdata_1_i,

    // Data memory interface cpu2
    input  logic        data_gnt_2_i,
    input  logic        data_rvalid_2_i,
    input  logic [31:0] data_rdata_2_i,

    // apu-interconnect
    // handshake signals
    input logic                            apu_master_gnt_i,
    // response channel
    input logic                            apu_master_valid_i,
    input logic [31:0]                     apu_master_result_i,
    input logic [APU_NUSFLAGS_CPU-1:0]     apu_master_flags_i,

    // Interrupt inputs
    input  logic        irq_i,                 // level sensitive IR lines
    input  logic [4:0]  irq_id_i,
    input  logic        irq_sec_i,

    // Debug Interface
    input  logic        debug_req_i,

    // CPU Control Signals
    input  logic        fetch_enable_i,

    input  logic [N_EXT_PERF_COUNTERS-1:0] ext_perf_counters_i
);

    ///////////////////////////////////
    //                               //
    //          CPU2 SIGNALS         //
    //                               //
    ///////////////////////////////////

    // Instruction memory interface
    logic                         instr_req_o_1;
    logic                         instr_gnt_i_1;
    logic                         instr_rvalid_i_1;
    logic                  [31:0] instr_addr_o_1;
    logic [INSTR_RDATA_WIDTH-1:0] instr_rdata_i_1;

    // Data memory interface
    logic        data_req_o_1;
    logic        data_gnt_i_1;
    logic        data_rvalid_i_1;
    logic        data_we_o_1;
    logic [3:0]  data_be_o_1;
    logic [31:0] data_addr_o_1;
    logic [31:0] data_wdata_o_1;
    logic [31:0] data_rdata_i_1;

    // apu-interconnect
    // handshake signals
    logic                           apu_master_req_o_1;
    logic                           apu_master_ready_o_1;
    // request channel
    logic [APU_NARGS_CPU-1:0][31:0] apu_master_operands_o_1;
    logic [APU_WOP_CPU-1:0]         apu_master_op_o_1;
    logic [WAPUTYPE-1:0]            apu_master_type_o_1;
    logic [APU_NDSFLAGS_CPU-1:0]    apu_master_flags_o_1;

    // Interrupt
    logic        irq_ack_o_1;
    logic [4:0]  irq_id_o_1;

    logic        sec_lvl_o_1;

    // CPU Control Signals
    logic        core_busy_o_1;

    ///////////////////////////////////
    //                               //
    //          CPU2 SIGNALS         //
    //                               //
    ///////////////////////////////////
    // Instruction memory interface
    logic                         instr_req_o_2;
    logic                         instr_gnt_i_2;
    logic                         instr_rvalid_i_2;
    logic                  [31:0] instr_addr_o_2;
    logic [INSTR_RDATA_WIDTH-1:0] instr_rdata_i_2;

    // Data memory interface
    logic        data_req_o_2;
    logic        data_gnt_i_2;
    logic        data_rvalid_i_2;
    logic        data_we_o_2;
    logic [3:0]  data_be_o_2;
    logic [31:0] data_addr_o_2;
    logic [31:0] data_wdata_o_2;
    logic [31:0] data_rdata_i_2;

    // apu-interconnect
    // handshake signals
    logic                           apu_master_req_o_2;
    logic                           apu_master_ready_o_2;
    // request channel
    logic [APU_NARGS_CPU-1:0][31:0] apu_master_operands_o_2;
    logic [APU_WOP_CPU-1:0]         apu_master_op_o_2;
    logic [WAPUTYPE-1:0]            apu_master_type_o_2;
    logic [APU_NDSFLAGS_CPU-1:0]    apu_master_flags_o_2;

    // Interrupt
    logic        irq_ack_o_2;
    logic [4:0]  irq_id_o_2;

    logic        sec_lvl_o_2;
    
    // CPU Control Signals
    logic        core_busy_o_2;

    ///////////////////////////////////
    //                               //
    //        Inputs assignment      //
    //                               //
    ///////////////////////////////////
    assign instr_gnt_i_1 = instr_gnt_1_i;
    assign instr_rvalid_i_1 = instr_rvalid_1_i;
    assign instr_rdata_i_1 = instr_rdata_1_i;
    assign data_gnt_i_1 = data_gnt_1_i;
    assign data_rvalid_i_1 = data_rvalid_1_i;
    assign data_rdata_i_1 = data_rdata_1_i;

    assign instr_gnt_i_2 = instr_gnt_2_i;
    assign instr_rvalid_i_2 = instr_rvalid_2_i;
    assign instr_rdata_i_2 = instr_rdata_2_i;
    assign data_gnt_i_2 = data_gnt_2_i;
    assign data_rvalid_i_2 = data_rvalid_2_i;
    assign data_rdata_i_2 = data_rdata_2_i;


s2qed_riscv_core
#(
    .N_EXT_PERF_COUNTERS ( N_EXT_PERF_COUNTERS ),
    .INSTR_RDATA_WIDTH   ( INSTR_RDATA_WIDTH   ),
    .PULP_SECURE         ( PULP_SECURE         ),
    .N_PMP_ENTRIES       ( N_PMP_ENTRIES       ),
    .USE_PMP             ( USE_PMP             ), //if PULP_SECURE is 1, you can still not use the PMP
    .PULP_CLUSTER        ( PULP_CLUSTER        ), //-- changed from 1 to 0
    .FPU                 ( FPU                 ),
    .Zfinx               ( Zfinx               ),
    .FP_DIVSQRT          ( FP_DIVSQRT          ),
    .SHARED_FP           ( SHARED_FP           ),
    .SHARED_DSP_MULT     ( SHARED_DSP_MULT     ),
    .SHARED_INT_MULT     ( SHARED_INT_MULT     ),
    .SHARED_INT_DIV      ( SHARED_INT_DIV      ),
    .SHARED_FP_DIVSQRT   ( SHARED_FP_DIVSQRT   ),
    .WAPUTYPE            ( WAPUTYPE            ),
    .APU_NARGS_CPU       ( APU_NARGS_CPU       ),
    .APU_WOP_CPU         ( APU_WOP_CPU         ),
    .APU_NDSFLAGS_CPU    ( APU_NDSFLAGS_CPU    ),
    .APU_NUSFLAGS_CPU    ( APU_NUSFLAGS_CPU    ),
    .DM_HaltAddress      ( DM_HaltAddress      )
)
cpu1
(
    // Clock and Reset
    .clk_i                  ( clk_i ),
    .rst_ni                 ( rst_ni ),

    .clock_en_i             ( clock_en_i ),
    .test_en_i              ( test_en_i ),

    .fregfile_disable_i     ( fregfile_disable_i ),

    // Core ID, Cluster ID and boot address are considered more or less static
    .boot_addr_i            ( boot_addr_i ),
    .core_id_i              ( core_id_i ),
    .cluster_id_i           ( cluster_id_i ),

    // Instruction memory interface
    .instr_req_o            ( instr_req_o_1 ),
    .instr_gnt_i            ( instr_gnt_i_1 ),
    .instr_rvalid_i         ( instr_rvalid_i_1 ),
    .instr_addr_o           ( instr_addr_o_1 ),
    .instr_rdata_i          ( instr_rdata_i_1 ),

    // Data memory interface
    .data_req_o             ( data_req_o_1 ),
    .data_gnt_i             ( data_gnt_i_1 ),
    .data_rvalid_i          ( data_rvalid_i_1 ),
    .data_we_o              ( data_we_o_1 ),
    .data_be_o              ( data_be_o_1 ),
    .data_addr_o            ( data_addr_o_1 ),
    .data_wdata_o           ( data_wdata_o_1 ),
    .data_rdata_i           ( data_rdata_i_1 ),

    // apu-interconnect
    // handshake signals
    .apu_master_req_o       ( apu_master_req_o_1 ),
    .apu_master_ready_o     ( apu_master_ready_o_1 ),
    .apu_master_gnt_i       ( apu_master_gnt_i ),
    // request channel
    .apu_master_operands_o  ( apu_master_operands_o_1 ),
    .apu_master_op_o        ( apu_master_op_o_1 ),
    .apu_master_type_o      ( apu_master_type_o_1 ),
    .apu_master_flags_o     ( apu_master_flags_o_1 ),
    // response channel
    .apu_master_valid_i     ( apu_master_valid_i ),
    .apu_master_result_i    ( apu_master_result_i ),
    .apu_master_flags_i     ( apu_master_flags_i ),

    // Interrupt inputs
    .irq_i                  ( irq_i ),
    .irq_id_i               ( irq_id_i ),
    .irq_ack_o              ( irq_ack_o_1 ),
    .irq_id_o               ( irq_id_o_1 ),
    .irq_sec_i              ( irq_sec_i ),

    .sec_lvl_o              ( sec_lvl_o_1 ),

    // Debug Interface
    .debug_req_i            ( debug_req_i ),

    // CPU Control Signals
    .fetch_enable_i         ( fetch_enable_i ),
    .core_busy_o            ( core_busy_o_1 ),

    .ext_perf_counters_i    ( ext_perf_counters_i )
);

s2qed_riscv_core
#(
    .N_EXT_PERF_COUNTERS ( N_EXT_PERF_COUNTERS ),
    .INSTR_RDATA_WIDTH   ( INSTR_RDATA_WIDTH   ),
    .PULP_SECURE         ( PULP_SECURE         ),
    .N_PMP_ENTRIES       ( N_PMP_ENTRIES       ),
    .USE_PMP             ( USE_PMP             ), //if PULP_SECURE is 1, you can still not use the PMP
    .PULP_CLUSTER        ( PULP_CLUSTER        ), //-- changed from 1 to 0
    .FPU                 ( FPU                 ),
    .Zfinx               ( Zfinx               ),
    .FP_DIVSQRT          ( FP_DIVSQRT          ),
    .SHARED_FP           ( SHARED_FP           ),
    .SHARED_DSP_MULT     ( SHARED_DSP_MULT     ),
    .SHARED_INT_MULT     ( SHARED_INT_MULT     ),
    .SHARED_INT_DIV      ( SHARED_INT_DIV      ),
    .SHARED_FP_DIVSQRT   ( SHARED_FP_DIVSQRT   ),
    .WAPUTYPE            ( WAPUTYPE            ),
    .APU_NARGS_CPU       ( APU_NARGS_CPU       ),
    .APU_WOP_CPU         ( APU_WOP_CPU         ),
    .APU_NDSFLAGS_CPU    ( APU_NDSFLAGS_CPU    ),
    .APU_NUSFLAGS_CPU    ( APU_NUSFLAGS_CPU    ),
    .DM_HaltAddress      ( DM_HaltAddress      )
)
cpu2
(
    // Clock and Reset
    .clk_i                  ( clk_i ),
    .rst_ni                 ( rst_ni ),

    .clock_en_i             ( clock_en_i ),
    .test_en_i              ( test_en_i ),

    .fregfile_disable_i     ( fregfile_disable_i ),

    // Core ID, Cluster ID and boot address are considered more or less static
    .boot_addr_i            ( boot_addr_i ),
    .core_id_i              ( core_id_i ),
    .cluster_id_i           ( cluster_id_i ),

    // Instruction memory interface
    .instr_req_o            ( instr_req_o_2 ),
    .instr_gnt_i            ( instr_gnt_i_2 ),
    .instr_rvalid_i         ( instr_rvalid_i_2 ),
    .instr_addr_o           ( instr_addr_o_2 ),
    .instr_rdata_i          ( instr_rdata_i_2 ),

    // Data memory interface
    .data_req_o             ( data_req_o_2 ),
    .data_gnt_i             ( data_gnt_i_2 ),
    .data_rvalid_i          ( data_rvalid_i_2 ),
    .data_we_o              ( data_we_o_2 ),
    .data_be_o              ( data_be_o_2 ),
    .data_addr_o            ( data_addr_o_2 ),
    .data_wdata_o           ( data_wdata_o_2 ),
    .data_rdata_i           ( data_rdata_i_2 ),

    // apu-interconnect
    // handshake signals
    .apu_master_req_o       ( apu_master_req_o_2 ),
    .apu_master_ready_o     ( apu_master_ready_o_2 ),
    .apu_master_gnt_i       ( apu_master_gnt_i ),
    // request channel
    .apu_master_operands_o  ( apu_master_operands_o_2 ),
    .apu_master_op_o        ( apu_master_op_o_2 ),
    .apu_master_type_o      ( apu_master_type_o_2 ),
    .apu_master_flags_o     ( apu_master_flags_o_2 ),
    // response channel
    .apu_master_valid_i     ( apu_master_valid_i ),
    .apu_master_result_i    ( apu_master_result_i ),
    .apu_master_flags_i     ( apu_master_flags_i ),

    // Interrupt inputs
    .irq_i                  ( irq_i ),
    .irq_id_i               ( irq_id_i ),
    .irq_ack_o              ( irq_ack_o_2 ),
    .irq_id_o               ( irq_id_o_2 ),
    .irq_sec_i              ( irq_sec_i ),

    .sec_lvl_o              ( sec_lvl_o_2 ),

    // Debug Interface
    .debug_req_i            ( debug_req_i ),

    // CPU Control Signals
    .fetch_enable_i         ( fetch_enable_i ),
    .core_busy_o            ( core_busy_o_2 ),

    .ext_perf_counters_i    ( ext_perf_counters_i )
);

endmodule