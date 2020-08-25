read_vhdl -golden  -pragma_ignore {}  -version 93 {PrintSkeleton/globalTypes.vhdl PrintSkeleton/FIR_types.vhdl PrintSkeleton/FIR_Pipeline.vhdl PrintSkeleton/FIR.vhdl} 
elaborate -golden
set_mode mv
set_itl_flavor vhi
read_itl  {PrintITL/FIR_macros.vhi PrintITL/FIR.vhi}


