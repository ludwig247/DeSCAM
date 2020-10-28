read_vhdl -golden -pragma_ignore {} -version 93 { globalTypes.vhdl TestArray05_types.vhdl TestArray05.vhdl }
elaborate -golden
set_mode mv
read_itl { properties/TestArray05_macros.vhi properties/TestArray05.vhi }
check -all [get_checks]

