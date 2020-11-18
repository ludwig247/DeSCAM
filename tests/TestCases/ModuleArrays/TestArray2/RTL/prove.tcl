read_vhdl -golden -pragma_ignore {} -version 93 { globalTypes.vhdl TestArray02_types.vhdl TestArray02.vhdl }
elaborate -golden
set_mode mv
read_itl { properties/TestArray02_macros.vhi properties/TestArray02.vhi }
check -all [get_checks]

