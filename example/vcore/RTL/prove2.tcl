read_verilog -golden  -pragma_ignore {}  -version 2001 {opcodes.v vcore.v }
elaborate -golden
set_mode mv
set_itl_flavor vhi
read_itl  { Properties_generated/macros.vhi Properties_generated/load.vhi Properties_generated/add.vhi Properties_generated/sub.vhi Properties_generated/neg.vhi Properties_generated/nop.vhi Properties_generated/store.vhi Properties_generated/branch.vhi  Properties_generated/reset.vhi}
check  [get_properties]
read_sva -completeness  {Properties_generated/comp.gfv}
check_completeness "vcore"
