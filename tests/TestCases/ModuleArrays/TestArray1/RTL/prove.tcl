read_vhdl -golden -pragma_ignore {} -version 93 { globalTypes.vhdl TestArray01_types.vhdl TestArray01.vhdl }
elaborate -golden
set_mode mv
read_itl { properties/TestArray01_macros.vhi properties/TestArray01.vhi }
check -all [get_checks]

