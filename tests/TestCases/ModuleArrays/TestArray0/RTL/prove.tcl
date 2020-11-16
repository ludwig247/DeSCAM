read_vhdl -golden -pragma_ignore {} -version 93 { globalTypes.vhdl TestArray00_types.vhdl TestArray00.vhdl }
elaborate -golden
set_mode mv
read_itl { properties/TestArray00_macros.vhi properties/TestArray00.vhi }
check -all [get_checks]

