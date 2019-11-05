# FOLDERS #
# Relative position to this file (run.tcl) #
set lucent93_lib_source	"../../../SONET/lucent93/sources";
set osa93_source 		"../../../SONET/sources";
#set sdh_application stm64_4
set sdh_application stm256_8

read_vhdl -golden -library LUCENT93 -version 93 {${lucent93_lib_source}/*.vhd};

read_vhdl -golden -version 93 {
 ${osa93_source}/adk93_basic_types_pkg.vhd
 ${osa93_source}/adk93_sys_types_pkg.vhd
 ${osa93_source}/adk93_basic_pkg.vhd
 ${osa93_source}/adk93_basic_sys_pkg.vhd
 ${osa93_source}/osa93_reg.vhd
 ${osa93_source}/osa93_reg_adr_pkg.vhd
 ${osa93_source}/osa93_reg_wrap.vhd
 ${osa93_source}/regmap_env_pkg.vhd
 ${osa93_source}/reglib_icore93.vhd
 };

read_vhdl -golden -version 93 { *.vhd };



 set app_ok 1

 switch $sdh_application {
   stm256_8 {
       set app_ok 1;
     set_elaborate_option -golden -call_threshold 100 -loop_iter_threshold 300 -x_optimism -noverilog_library_resolution_ieee_compliance -vhdl_generic {sdh_rate=8} -vhdl_assertion_report_prefix {onespin} -black_box {{work.osa93_reg_wrap(str)}} -black_box_empty_modules -noblack_box_missing_modules -top {Vhdl!work.myosa_cfg};
   }
   stm64_4 {
       set app_ok 1;
     set_elaborate_option -golden -call_threshold 100 -loop_iter_threshold 300 -x_optimism -noverilog_library_resolution_ieee_compliance -vhdl_generic {sdh_rate=6} -vhdl_assertion_report_prefix {onespin} -black_box {{work.osa93_reg_wrap(str)}} -black_box_empty_modules -noblack_box_missing_modules -top {Vhdl!work.myosa_cfg}; 
   }
 }



 if $app_ok {
   elaborate -golden;
   compile -golden;
   set_mode mv;
   set_reset_sequence -high reset_dp;
   compute_invariants;
   read_itl {dataAlign_macro.vhi main.vhi completeness.vhi lof.vhi};

   check_assertion [ get_assertions ];
   check_property  [ get_properties ];
   check_completeness myosa;
   check_completeness myosalof;
 }
 if !$app_ok {
   puts "ERROR: None valid sdh_application in run.tcl, only stm256_8 and stm64_4 can be used. Design does not synthesize correctly for any other value"
 }



