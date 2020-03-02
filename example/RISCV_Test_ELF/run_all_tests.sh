#!/bin/bash
export SYSTEMC_DISABLE_COPYRIGHT_MESSAGE=1
export SCAM_DIR=$HOME/DeSCAM

echo -e "\e[30;48;5;82mCreate the elf files\e[0m";
cd ${SCAM_DIR}/example/RISCV_Test_ELF/Instruction_Tests
make
cd ${SCAM_DIR}/example/RISCV_Test_ELF/Programs
make
cd ${SCAM_DIR}/example/RISCV_Test_ELF/Programs/BubbleSort_c
make
cd ${SCAM_DIR}/example/RISCV_Test_ELF/Programs/Fibonacci_c
make
cd ${SCAM_DIR}/example/RISCV_Test_ELF/Programs/Prime_c
make
echo -e "\e[30;48;5;82mFinished creating the elf files\e[0m";

#Running Instruction_Tests
#echo -e "\e[30;48;5;82mRunning tests for each instruction\e[0m";
#for f in ${SCAM_DIR}/example/RISCV_Test_ELF/Instruction_Tests/*.elf  ;
#do
#    "${SCAM_DIR}/bin/RISCV_elf_test" "$f"
#done

#Running Programs Tests
echo -e "\e[30;48;5;82mRunning Programs Tests\e[0m";
for f in ${SCAM_DIR}/example/RISCV_Test_ELF/Programs/*.elf ;
do
    "${SCAM_DIR}/bin/RISCV_elf_test" "$f"
done


#Running Special Programs Tests
echo -e "\e[30;48;5;82mRunning Special Programs Tests\e[0m";
for f in ${SCAM_DIR}/example/RISCV_Test_ELF/Programs/*/*.elf ;
do
    "${SCAM_DIR}/bin/RISCV_elf_test" "$f"
done



#DELETE generated elf ans asm files
echo -e "\e[30;48;5;82mDeleting generated elf and asm files\e[0m";
cd ${SCAM_DIR}/example/RISCV_Test_ELF/Instruction_Tests
make clean
cd ${SCAM_DIR}/example/RISCV_Test_ELF/Programs
make clean
cd ${SCAM_DIR}/example/RISCV_Test_ELF/Programs/BubbleSort_c
make clean
cd ${SCAM_DIR}/example/RISCV_Test_ELF/Programs/Fibonacci_c
make clean
cd ${SCAM_DIR}/example/RISCV_Test_ELF/Programs/Prime_c
make clean


echo -e "\e[30;48;5;82mDone!\e[0m";
