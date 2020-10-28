read_vhdl -golden -pragma_ignore {} -version 93 { globalTypes.vhdl TestArray04_types.vhdl TestArray04.vhdl }
elaborate -golden
set_mode mv
read_itl { properties/TestArray04_macros.vhi properties/TestArray04.vhi }
check -all [get_checks]

