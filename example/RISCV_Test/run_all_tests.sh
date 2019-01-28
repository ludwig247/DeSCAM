export SYSTEMC_DISABLE_COPYRIGHT_MESSAGE=1
export SCAM_DIR=/home/$USER/SCAM


printf "\n=============================== run_all_tests.sh ==================================================== \n\n"

printf "=============================== Running program tests (hex) =============================================== \n\n"
for f in ${SCAM_DIR}/example/RISCV_Test/Programs/*.hex ;
do
    "${SCAM_DIR}/bin/RISCV_regression_test" "$f"
done
printf "\n=============================== Running tests for each instruction (hex) ================================= \n\n"
for f in ${SCAM_DIR}/example/RISCV_Test/Instruction_Tests/*.hex  ;
do
    "${SCAM_DIR}/bin/RISCV_regression_test" "$f"
done

printf "\n=============================== Finished run_all_tests.sh =========================================== \n\n"
