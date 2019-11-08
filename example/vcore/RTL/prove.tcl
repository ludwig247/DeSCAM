read_verilog -golden  -pragma_ignore {}  -version 2001 {opcodes.v vcore.v }
elaborate -golden
set_mode mv
set_itl_flavor vhi
read_itl  {Properties/VCORE.vhi Properties/load.vhi Properties/arithmetic.vhi Properties/nop.vhi Properties/store.vhi Properties/branch.vhi Properties/misspredict.vhi Properties/reset.vhi}
check  [get_properties]
read_sva -completeness  {Properties/comp.gfv}
check_completeness "vcore"
