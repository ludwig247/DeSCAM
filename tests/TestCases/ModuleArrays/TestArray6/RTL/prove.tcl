read_vhdl -golden -pragma_ignore {} -version 93 { globalTypes.vhdl TestArray06_types.vhdl TestArray06.vhdl }
elaborate -golden
set_mode mv
read_itl { properties/TestArray06_functions.vhi properties/TestArray06_macros.vhi properties/TestArray06.vhi }
check -all [get_checks]

