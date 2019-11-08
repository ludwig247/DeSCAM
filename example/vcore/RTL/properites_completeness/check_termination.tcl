source setup.tcl
read_itl all.vli
check [get_checks]
check_completeness 
check_consistency -category model_building
report_result -signoff

