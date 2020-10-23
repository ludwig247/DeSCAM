read_vhdl -golden  -pragma_ignore {}  -version 93 { Bus.vhdl types.vhd }
elaborate -golden
set_mode mv
read_itl  {Properties/Bus.vhi}
check  {reset run_0_read_0 run_0_read_1 run_0_read_2 run_0_read_3 run_0_read_4 run_0_read_5 run_0_read_6 run_0_read_7 run_0_read_8 run_0_read_9 run_1_write_10 run_2_read_11 run_2_read_12 run_3_write_13 run_4_write_14 run_5_read_15 run_5_read_16 run_6_write_17 run_7_read_18 run_7_read_19 run_8_write_20 run_9_read_21 run_9_read_22 wait_run_0 wait_run_1 wait_run_2 wait_run_3 wait_run_4 wait_run_5 wait_run_6 wait_run_7 wait_run_8 wait_run_9}



