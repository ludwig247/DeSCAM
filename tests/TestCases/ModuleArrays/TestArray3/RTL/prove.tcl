read_vhdl -golden -pragma_ignore {} -version 93 { globalTypes.vhdl TestArray03_types.vhdl TestArray03.vhdl }
elaborate -golden
set_mode mv
read_itl { properties/TestArray03_macros.vhi properties/TestArray03.vhi }
check -all [get_checks]

