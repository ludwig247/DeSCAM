//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18.
//

#ifndef RISCV_ISA_H_
#define RISCV_ISA_H_


#include "systemc.h"
#include "Interfaces.h"
#include "../../../RISCV_commons/Memory_Interfaces.h"
#include "Defines.h"
#include "CPU_Interfaces.h"
#include "CSR.h"

// Adjusts code to be appropriate for the SCAM tool
// Working ESL-Description -> #define NOSCAM
// Properties can be generated -> //#define NOSCAM
//#define NOSCAM

#define PRIVCODE_ECALL      0x000
#define PRIVCODE_EBREAK     0x001
#define PRIVCODE_URET       0x002
#define PRIVCODE_SRET       0x102
#define PRIVCODE_MRET       0x302
#define PRIVCODE_WFI        0x105
#define PRIVCODE_SFENCEVMA  0x009

#define OPCODE_AMO          0x02F



#define READONLY 3

#define FUNC5_FIELD(x) (((x) >> 27) & 0x1F)

class ISA : public sc_module {
public:
    //Constructor
    SC_HAS_PROCESS(ISA);

    ISA(sc_module_name name) :
            fromMemoryPort("fromMemoryPort"),
            toMemoryPort("toMemoryPort"),
            toRegsPort("toRegsPort"),
            fromRegsPort("fromRegsPort"),
            isa_ecall_Port("isa_ecall_Port"),
            ecall_isa_Port("ecall_isa_Port"),
            mip_isa_Port("mip_isa_Port"),
            isaREQ(false),
            sysRES(true),
            section(fetch),
            nextsection(fetch),
            prv(MachineMode),
            pending(0),
            exception(0),
            mip_tmp(0),
            lr_sc(0),
            lastPc(0),
            pcReg(0) {
        SC_THREAD(run);
    }

    // ports for communication with memory/decoder
    blocking_out<MMU_in> toMemoryPort;
    blocking_in<MMU_return> fromMemoryPort;

    // ports for communication with register file
    master_in<RegfileType> fromRegsPort;
    master_out<RegfileWriteType> toRegsPort;

    // ports for communication with ecallHandler
    blocking_out<bool> isa_ecall_Port;
    blocking_in<bool> ecall_isa_Port;

    // port for communication with mip
    master_in<unsigned int> mip_isa_Port;

    // data for communication with memory
    CUtoME_IF toMemoryData;
    MEtoCU_IF fromMemoryData;

    MMU_in to_mmu;
    MMU_return from_mmu;

    // data for communication with register file
    RegfileWriteType regfileWrite;
    RegfileType regfile;

    // data for communication with ecallHandler
    bool isaREQ;
    bool sysRES;

    // data for communication with mip 
//    unsigned int mip;

    // ISA sections
    enum Sections {
        fetch,              // fetch next instruction from memory
        execute             // decode the fetched instruction and do all the manipulations till writing back to the register file
    };
    Sections section, nextsection;

    // Other control signals:
    unsigned int encodedInstr;
    unsigned int exception;
    unsigned int write;
    unsigned int aluOp1;
    unsigned int aluOp2;
    unsigned int aluResult;
    unsigned int prv;
    unsigned int mip_tmp;
    unsigned int xcause;
    unsigned int xtval;
    unsigned int xtvec;
    unsigned int xstatus_mask;
    unsigned int pending;
    unsigned int target_prv;
    unsigned int lr_sc;

    unsigned int pcReg;
    unsigned int lastPc;

unsigned int test;


    CSRfileType csrfile;

    void run(); // thread

    //Decoding functions

    unsigned int writeCSRresult(unsigned int write, unsigned int encodedInstr,
                                unsigned int data, unsigned int currval, unsigned int tag, unsigned int exception) const;
    unsigned int isInvalidCSRaction(unsigned int write, unsigned int priv_lvl, unsigned int encodedInstr, unsigned int mstatus, unsigned int mcounteren, unsigned int scounteren) const;
    unsigned int isCSRwrite(InstrType_Complete instr_type, unsigned int rs1addr) const;
    unsigned int isCSRinRange(unsigned int encodedInstr) const;
    unsigned int validCntRead(unsigned int address, unsigned int priv_lvl, unsigned int mcounteren, unsigned int scounteren) const;

    unsigned int updateMCAUSE(unsigned int exception, unsigned int pending, unsigned int xcause, unsigned int target_prv, unsigned int mcause) const;
    unsigned int updateSCAUSE(unsigned int exception, unsigned int pending, unsigned int xcause, unsigned int target_prv, unsigned int scause) const;
    unsigned int updateUCAUSE(unsigned int exception, unsigned int pending, unsigned int xcause, unsigned int target_prv, unsigned int ucause) const;

    unsigned int updateMSTATUS(unsigned int mstatus, unsigned int exception, unsigned int pending, unsigned int xstatus_mask, unsigned int target_prv) const;

    unsigned int updateMEPC(unsigned int exception, unsigned int pending, unsigned int target_prv, unsigned int mepc, unsigned int pcReg) const;
    unsigned int updateSEPC(unsigned int exception, unsigned int pending, unsigned int target_prv, unsigned int sepc, unsigned int pcReg) const;
    unsigned int updateUEPC(unsigned int exception, unsigned int pending, unsigned int target_prv, unsigned int uepc, unsigned int pcReg) const;

    unsigned int updatePC(unsigned int exception, unsigned int pending, unsigned int xtvec, unsigned int pcReg) const;
    unsigned int mtimeoffset(unsigned int encodedInstr) const;
    unsigned int minstrethcount(unsigned int minstretl, unsigned int minstreth, unsigned int exception) const;
    unsigned int minstretlcount(unsigned int minstretl, unsigned int exception) const;
    unsigned int mcyclehcount(unsigned int mcyclel, unsigned int mcycleh) const;
    unsigned int mcyclelcount(unsigned int mcyclel) const;
    unsigned int readmtimel(unsigned int mtimel, unsigned int encodedInstr, unsigned int exception, unsigned int data) const;
    unsigned int readmtimeh(unsigned int mtimeh, unsigned int encodedInstr, unsigned int exception, unsigned int data) const;
  
    unsigned int updateXTVAL(unsigned int exception, unsigned int pcReg, unsigned int encodedInstr, unsigned int xtval) const;
    unsigned int delegateTrapS(unsigned int exception, unsigned int pending, unsigned int medeleg, unsigned int mideleg,
                               unsigned int sedeleg, unsigned int sideleg, unsigned int prv) const;
    unsigned int delegateTrapU(unsigned int exception, unsigned int pending, unsigned int sedeleg, unsigned int sideleg, unsigned int prv) const;
    unsigned int updateXTVEC(unsigned int mtvec, unsigned int stvec, unsigned int utvec, unsigned int target_prv) const;

    unsigned int updateXSTATUSmask(unsigned int mstatus, unsigned int target_prv, unsigned int prv) const;

    unsigned int updateMTVAL(unsigned int mtval, unsigned int xtval, unsigned int exception, unsigned int target_prv) const;
    unsigned int updateSTVAL(unsigned int stval, unsigned int xtval, unsigned int exception, unsigned int target_prv) const;
    unsigned int updateUTVAL(unsigned int utval, unsigned int xtval, unsigned int exception, unsigned int target_prv) const;
    unsigned int computeInterruptPending(unsigned int mie, unsigned int mip, unsigned int mstatus, unsigned int prv) const;
    unsigned int updateXCAUSE(unsigned int exception, unsigned int pending) const;
    unsigned int mstatusTrapReturn(unsigned int mstatus, unsigned int xret) const;
    AmoInstrType getAmoType(unsigned int encodedInstr) const;
    unsigned int ignoreLSB(unsigned int reg) const;
    unsigned int amoData(AmoInstrType instr, unsigned int aluResult, unsigned int mmudata, unsigned int aluOp2) const;
  
    ALUfuncType getAmoAlufunc(AmoInstrType instr) const;

    EncType getEncType(unsigned int encodedInstr) const;

    InstrType_Complete getInstrType(unsigned int encodedInstr) const;

    unsigned int getRs1Addr(unsigned int encodedInstr) const;

    unsigned int getRs2Addr(unsigned int encodedInstr) const;

    unsigned int getRdAddr(unsigned int encodedInstr) const;

    unsigned int getImmediate(unsigned int encodedInstr) const;

    ME_MaskType getMemoryMask(InstrType_Complete instr) const;

    ALUfuncType getALUfunc(InstrType_Complete instr) const;

    unsigned int readRegfile(unsigned int src, RegfileType regfile) const;

    unsigned int getALUresult(ALUfuncType aluFunction, unsigned int operand1, unsigned int operand2) const;

    PrivInstrType getPrivInstrType(unsigned int encodedInstr) const;

    unsigned int getCSR(CSRfileType csrfile, unsigned int encodedInstr) const;

    unsigned int getCSRresult(InstrType_Complete instr, unsigned int rs1, unsigned int csr) const;

    unsigned int getBranchresult(unsigned int encodedInstr, unsigned int aluResult, unsigned int pcReg) const;

    unsigned int getALUresult_U(unsigned int encodedInstr, unsigned int pcReg, unsigned int imm) const;

    unsigned int checkAddrAlignment(ME_MaskType masktype, unsigned int address, bool isLoad) const;
};


void ISA::run() {
    while (true) {



        // fetch next instruction
        if (section == Sections::fetch) {
            // Set up memory access
            exception = 0;
            regfileWrite.exception = 0;

to_mmu.accesstype = FETCH;
to_mmu.prv = prv;
to_mmu.v_addr = pcReg;
to_mmu.satp = csrfile.satp;
to_mmu.mstatus = csrfile.mstatus;
to_mmu.mask = MT_W;
to_mmu.data = 0;
to_mmu.exception_in = 0;
to_mmu.lrsc = NONE; 



                toMemoryPort->write(to_mmu); //Send request to memory

                fromMemoryPort->read(from_mmu); //Read encoded instruction from memory



                encodedInstr = from_mmu.data;
                exception = from_mmu.exception;
                xtval = pcReg;
                lastPc = pcReg;
        

//                std::cout << "----------------------------------- instr: " << hex << (pcReg) << ", instruction: " << hex
//                          << encodedInstr << " ------- addr: " << toMemoryData.addrIn << "\n";

#ifndef NOSCAM
            /// Termination happens through a proper EBREAK or ECALL(SYS_exit) 

//!!RISCV_privilege: ECALL only causes exception, so for system to properly exit with sc_stop() some modification needs to be done as with riscv-tests where access to a certain memory location causes a call to this function

//            if (fromMemoryData.loadedData == 0x6f) {
//                std::cout << "terminating instruction" << std::endl;
//                sc_stop();
//                wait(SC_ZERO_TIME);
//            }
#endif
            nextsection = Sections::execute;
        }

        if (section == Sections::execute) {

            // Decode instruction
            if(exception == 0) {
                if (getEncType(encodedInstr) == ENC_R) {
                    /////////////////////////////////////////////////////////////////////////////
                    //|  ID (RF_READ)   |        EX       |    ---------    |  WB (RF_WRITE)  |//
                    /////////////////////////////////////////////////////////////////////////////
                    fromRegsPort->read(regfile); //Read register contents

                    //Set-up operands for alu by reading from regfile
                    aluOp1 = readRegfile(getRs1Addr(encodedInstr), regfile);
                    aluOp2 = readRegfile(getRs2Addr(encodedInstr), regfile);

                    aluResult = getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2); //Compute result

                    //Set up write back
                    regfileWrite.dst = getRdAddr(encodedInstr);
                    regfileWrite.dstData = aluResult;

                    toRegsPort->write(regfileWrite); //Perform write back

                    //Set-up PC
                    pcReg = pcReg + 4;

                } else if (getEncType(encodedInstr) == ENC_A) {
                    /////////////////////////////////////////////////////////////////////////////
                    //|  ID (RF_READ)   |        EX       |    ---------    |  WB (RF_WRITE)  |//
                    /////////////////////////////////////////////////////////////////////////////
                    fromRegsPort->read(regfile); //Read register contents

                    aluOp1 = readRegfile(getRs1Addr(encodedInstr), regfile);
                    aluOp2 = readRegfile(getRs2Addr(encodedInstr), regfile);


                    if (getAmoType(encodedInstr) == AMO_LR) {

                        exception =  checkAddrAlignment(MT_W, aluOp1, true);
                        xtval = aluOp1;

                        to_mmu.accesstype = LOAD;
                        to_mmu.prv = prv;
                        to_mmu.v_addr = aluOp1;
                        to_mmu.satp = csrfile.satp;
                        to_mmu.mstatus = csrfile.mstatus;
                        to_mmu.mask = MT_W;
                        to_mmu.data = 0;
                        to_mmu.exception_in = exception; //upon exception on entry MMU does nothing

                        to_mmu.lrsc = LR;
                        to_mmu.reset_lrsc = 0;
                        //Put reservation on address in memory manager/interface
                        toMemoryPort->write(to_mmu);

                        // Load done
                        fromMemoryPort->read(from_mmu);

                        exception = from_mmu.exception;
                        xtval = aluOp1;
                     
                            //Set up write back
                            regfileWrite.dst = getRdAddr(encodedInstr);
                            regfileWrite.dstData = from_mmu.data;
                            regfileWrite.exception = exception;

                            //store content of address in rs1 in Rd
                            toRegsPort->write(regfileWrite);
                       
                            pcReg = pcReg + 4;
                        

                    } else if (getAmoType(encodedInstr) == AMO_SC) {

                        exception =  checkAddrAlignment(MT_W, aluOp1, false);

                        xtval = aluOp1;


                        to_mmu.accesstype = STORE;
                        to_mmu.prv = prv;
                        to_mmu.v_addr = aluOp1;
                        to_mmu.satp = csrfile.satp;
                        to_mmu.mstatus = csrfile.mstatus;
                        to_mmu.mask = MT_W;
                        to_mmu.data = aluOp2;
                        to_mmu.exception_in = exception;



                            to_mmu.lrsc = SC;
                            toMemoryPort->write(to_mmu); // Store

                            fromMemoryPort->read(from_mmu);
                            exception = from_mmu.exception;
                            xtval = aluOp1;

                            if(from_mmu.sc_success != 0){
                            regfileWrite.dst = getRdAddr(encodedInstr);
                            regfileWrite.dstData = 0; //nonzero means error
                             }else{
                            regfileWrite.dst = getRdAddr(encodedInstr);
                            regfileWrite.dstData = 1; //nonzero means error, error code above 1 is reserved
                            }


                       regfileWrite.exception = exception;
                        //write
                        
                            toRegsPort->write(regfileWrite);
                        
                            pcReg = pcReg + 4;


                    }else {

                        exception =  checkAddrAlignment(MT_W, aluOp1, false); //STORE_AMO_MISALIGNED exception raised regardless of the fact that operation both loads and stores.

                        xtval = aluOp1;

                        to_mmu.accesstype = LOAD;
                        to_mmu.prv = prv;
                        to_mmu.v_addr = aluOp1;
                        to_mmu.satp = csrfile.satp;
                        to_mmu.mstatus = csrfile.mstatus;
                        to_mmu.mask = MT_W;
                        to_mmu.data = 0;
                        to_mmu.exception_in = exception;

                        //need to invoke some bus lock for multicore system
                        toMemoryPort->write(to_mmu);

                        // Load done
                        fromMemoryPort->read(from_mmu);

                        exception = from_mmu.exception;
                        xtval = aluOp1;


                        //Set up write back
                        regfileWrite.dst = getRdAddr(encodedInstr);
                        regfileWrite.dstData = from_mmu.data;
                        regfileWrite.exception = exception;
                    
                            //store content of address in rs1 in Rd
                            toRegsPort->write(regfileWrite);
                         
                          


                            aluResult = getALUresult(getAmoAlufunc(getAmoType(encodedInstr)), from_mmu.data,
                                                     aluOp2); //Compute result

                            to_mmu.accesstype = STORE;
                            to_mmu.prv = prv;
                            to_mmu.v_addr = aluOp1;
                            to_mmu.satp = csrfile.satp;
                            to_mmu.mstatus = csrfile.mstatus;
                            to_mmu.mask = MT_W;
                            to_mmu.exception_in = exception;


                            to_mmu.data = amoData(getAmoType(encodedInstr), aluResult, from_mmu.data, aluOp2);

                   

                            toMemoryPort->write(to_mmu); // Store
                            fromMemoryPort->read(from_mmu);
                            //future bus lock can be released here
                            exception = from_mmu.exception;
                            xtval = aluOp1;


                            pcReg = pcReg + 4;

     
                    }
                } else if (getEncType(encodedInstr) == ENC_B) {
                    /////////////////////////////////////////////////////////////////////////////
                    //|  ID (RF_READ)   |        EX       |    ---------    |    ---------    |//
                    /////////////////////////////////////////////////////////////////////////////
                    fromRegsPort->read(regfile); //Read register contents

                    //Set-up operands for alu by reading from regfile
                    aluOp1 = readRegfile(getRs1Addr(encodedInstr), regfile);
                    aluOp2 = readRegfile(getRs2Addr(encodedInstr), regfile);

                    aluResult = getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2); //Compute result

                    //Set-up PC
                    xtval = getBranchresult(encodedInstr, aluResult, pcReg);
                    pcReg = xtval;



                    if ((xtval & 0x3) != 0) exception = EXCEPTION | EXC_MISALIGNED_ADR_INSTR; //upon exception pcReg is overwritten with trap vector


   

                } else if (getEncType(encodedInstr) == ENC_S) {
                    /////////////////////////////////////////////////////////////////////////////
                    //|  ID (RF_READ)   |        EX       |       MEM       |    ---------    |//
                    /////////////////////////////////////////////////////////////////////////////
                    fromRegsPort->read(regfile); //Read register contents

                    //Set-up operands for alu by reading from regfile
                    aluOp1 = readRegfile(getRs1Addr(encodedInstr), regfile);
                    aluOp2 = getImmediate(encodedInstr);

                    aluResult = getALUresult(ALU_ADD, aluOp1, aluOp2); //Compute result


                    to_mmu.accesstype = STORE;
                    to_mmu.prv = prv;
                    to_mmu.v_addr = aluResult; // Set address (getALUresult result) for stores
                    to_mmu.satp = csrfile.satp;
                    to_mmu.mstatus = csrfile.mstatus;
                    to_mmu.mask = getMemoryMask(getInstrType(encodedInstr)); // set memory access mask
                    to_mmu.data = readRegfile(getRs2Addr(encodedInstr), regfile); // Set data for stores, rs2 = source for store
               

                    exception = checkAddrAlignment(to_mmu.mask, to_mmu.v_addr, false);
                    xtval = to_mmu.v_addr;
                    to_mmu.exception_in = exception;
                   

                        toMemoryPort->write(to_mmu); // Store
                        fromMemoryPort->read(from_mmu); //check for exceptions
                        //Set-up PC
                        exception = from_mmu.exception;
                        xtval = to_mmu.v_addr;


                            pcReg = pcReg + 4;

                    

                } else if (getEncType(encodedInstr) == ENC_U) {
                    /////////////////////////////////////////////////////////////////////////////
                    //|        ID       |        EX       |    ---------    |  WB (RF_WRITE)  |//
                    /////////////////////////////////////////////////////////////////////////////
                    aluOp1 = pcReg;
                    aluOp2 = getImmediate(encodedInstr);
                    aluResult = getALUresult_U(encodedInstr, aluOp1, aluOp2);

                    regfileWrite.dst = getRdAddr(encodedInstr); //Compute destination
                    regfileWrite.dstData = aluResult; //Compute result

                    toRegsPort->write(regfileWrite); //Perform write back

                    //Set-up PC
                    pcReg = pcReg + 4;

                } else if (getEncType(encodedInstr) == ENC_J) {
                    /////////////////////////////////////////////////////////////////////////////
                    //|        ID       |    ---------    |    ---------    |  WB (RF_WRITE)  |//
                    /////////////////////////////////////////////////////////////////////////////
                    //Set up write back
                    regfileWrite.dst = getRdAddr(encodedInstr);
                    regfileWrite.dstData = pcReg + 4; //Compute result



                    //Set-up PC
                    xtval = pcReg + getImmediate(encodedInstr);
                    pcReg = xtval;
                    if ((xtval & 0x3) != 0) exception = EXCEPTION | EXC_MISALIGNED_ADR_INSTR;

                        regfileWrite.exception = exception; //no update if exception
                        toRegsPort->write(regfileWrite); //Perform write back
                    


                } else if (getEncType(encodedInstr) == ENC_I_I) {
                    /////////////////////////////////////////////////////////////////////////////
                    //|  ID (RF_READ)   |        EX       |    ---------    |  WB (RF_WRITE)  |//
                    /////////////////////////////////////////////////////////////////////////////
                    fromRegsPort->read(regfile); //Read register contents

                    //Set-up operands for alu by reading from regfile
                    aluOp1 = readRegfile(getRs1Addr(encodedInstr), regfile);
                    aluOp2 = getImmediate(encodedInstr);

                    aluResult = getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2); //Compute result
                   
                       if((getInstrType(encodedInstr) == INSTR_SLLI || getInstrType(encodedInstr) == INSTR_SRLI ||
                        getInstrType(encodedInstr) == INSTR_SRAI) && (encodedInstr & SHAMT5) != 0){
                     exception = EXCEPTION | EXC_ILLEGAL_INSTRUCTION; //This is not specified in the base isa spec, but in the book, so for the cpu to be risc-v compliant it needs to cause an exception for shamt[5] != 0 (see riscv-tests; rv32mi-p-shamt)
}

                    //Set up write back
                    regfileWrite.dst = getRdAddr(encodedInstr);
                    regfileWrite.dstData = aluResult; //Compute result
                    regfileWrite.exception = exception;//no update if exception
                    toRegsPort->write(regfileWrite); //Perform write back

                    //Set-up PC
                    pcReg = pcReg + 4;

                } else if (getEncType(encodedInstr) == ENC_I_L) { // loads
                    /////////////////////////////////////////////////////////////////////////////
                    //|  ID (RF_READ)   |        EX       |       MEM       |  ID (RF_WRITE)  |//
                    /////////////////////////////////////////////////////////////////////////////
                    fromRegsPort->read(regfile); //Read register contents

                    //Set-up operands for alu by reading from regfile
                    aluOp1 = readRegfile(getRs1Addr(encodedInstr), regfile);
                    aluOp2 = getImmediate(encodedInstr);

                    aluResult = getALUresult(ALU_ADD, aluOp1, aluOp2);


                    to_mmu.accesstype = LOAD;
                    to_mmu.prv = prv;
                    to_mmu.v_addr = aluResult; // Set address (getALUresult result) for loads
                    to_mmu.satp = csrfile.satp;
                    to_mmu.mstatus = csrfile.mstatus;
                    to_mmu.mask = getMemoryMask(getInstrType(encodedInstr)); // set memory access mask
                    to_mmu.data = 0;
           

                    regfileWrite.dst = getRdAddr(encodedInstr);

                    exception = checkAddrAlignment(to_mmu.mask, to_mmu.v_addr, true);
                    xtval = to_mmu.v_addr;
                    to_mmu.exception_in = exception;
                   
                        // Request load
                        toMemoryPort->write(to_mmu);

                        // Load done
                        fromMemoryPort->read(from_mmu);

                        exception = from_mmu.exception;
                        xtval = to_mmu.v_addr;
                        regfileWrite.exception = exception;
                        
                            //Set up write back
                            regfileWrite.dstData = from_mmu.data;


                            //Perform write back
                            toRegsPort->write(regfileWrite);
                       
                            //Set-up PC
                            pcReg = pcReg + 4;

                    
                } else if (getEncType(encodedInstr) == ENC_I_J) {
                    /////////////////////////////////////////////////////////////////////////////
                    //|  ID (RF_READ)   |    ---------    |    ---------    |  WB (RF_WRITE)  |//
                    /////////////////////////////////////////////////////////////////////////////
                    fromRegsPort->read(regfile); //Read register contents

                    //Set up write back
                    regfileWrite.dst = getRdAddr(encodedInstr);
                    regfileWrite.dstData = pcReg + 4; //Compute result

                


                    //Set-up PC
                    xtval = readRegfile(getRs1Addr(encodedInstr), regfile) + getImmediate(encodedInstr);
                    xtval = ignoreLSB(xtval); // SCAM fails without putting expression into function
                    pcReg = xtval;
                
                    if ((xtval & 0x3) != 0) exception = EXCEPTION | EXC_MISALIGNED_ADR_INSTR;
                                       

                        regfileWrite.exception = exception; //no update if exception
                        toRegsPort->write(regfileWrite);
                    



                } else if (getEncType(encodedInstr) == ENC_I_M) {
                    /////////////////////////////////////////////////////////////////////////////
                    //|  -------   |        -------       |       --------       |  --------  |//
                    /////////////////////////////////////////////////////////////////////////////
                    //Set-up PC
                    pcReg = pcReg + 4;

                } else if (getEncType(encodedInstr) == ENC_I_S) {
                    if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_CSRRW ||
                        getInstrType(encodedInstr) == InstrType_Complete::INSTR_CSRRS ||
                        getInstrType(encodedInstr) == InstrType_Complete::INSTR_CSRRC) {
                        /////////////////////////////////////////////////////////////////////////////
                        //|  ID (RF_READ)   |       ------     |     ------     |  WB (RF_WRITE)  |//
                        /////////////////////////////////////////////////////////////////////////////
                        fromRegsPort->read(regfile); //Read register contents


                        write = isCSRwrite(getInstrType(encodedInstr), getRs1Addr(encodedInstr));
                        exception = isInvalidCSRaction(write, prv, encodedInstr, csrfile.mstatus, csrfile.mcounteren, csrfile.scounteren);


                        if(POS_IMM_I_FIELD(encodedInstr) == UCSR_TIME || POS_IMM_I_FIELD(encodedInstr) == UCSR_TIME_H){

                            to_mmu.accesstype = LOAD;
                            to_mmu.prv = MachineMode; //mcounteren and scounteren is checked and exception is raised if lower privilege read is disallowed.
                            to_mmu.v_addr = CLINT_mtime_ADDR + mtimeoffset(encodedInstr); // Set address (getALUresult result) for loads
                            to_mmu.satp = csrfile.satp;
                            to_mmu.mstatus = csrfile.mstatus;
                            to_mmu.mask = MT_W; // set memory access mask
                            to_mmu.data = 0;
                            to_mmu.exception_in = exception;

                            // Request load
                            toMemoryPort->write(to_mmu);

                            // Load done
                            fromMemoryPort->read(from_mmu); //beware this if clause removes 11 operations from PrintITL, very suspicious!!

                            exception = from_mmu.exception;



                                csrfile.mtimel = readmtimel(csrfile.mtimel, encodedInstr, exception, from_mmu.data);
                                csrfile.mtimeh = readmtimel(csrfile.mtimel, encodedInstr, exception, from_mmu.data);


                        }
                      
                            //get operand for next csr by reading from regfile and read current csr value
                            aluOp1 = readRegfile(getRs1Addr(encodedInstr), regfile);
                            aluOp2 = getCSR(csrfile, encodedInstr);
                            aluResult = getCSRresult(getInstrType(encodedInstr), aluOp1, aluOp2);

                            //CSR is only written if address matches tag, and no exception occured

                            csrfile.mstatus = writeCSRresult(write, encodedInstr, aluResult, csrfile.mstatus,
                                                             MCSR_MSTATUS, exception);
                            csrfile.medeleg = writeCSRresult(write, encodedInstr, aluResult, csrfile.medeleg,
                                                             MCSR_MEDELEG, exception);
                            csrfile.mideleg = writeCSRresult(write, encodedInstr, aluResult, csrfile.mideleg,
                                                             MCSR_MIDELEG, exception);
                            csrfile.mie = writeCSRresult(write, encodedInstr, aluResult, csrfile.mie, MCSR_MIE, exception);
                            csrfile.mtvec = writeCSRresult(write, encodedInstr, aluResult, csrfile.mtvec, MCSR_MTVEC, exception);
                            csrfile.mcounteren = writeCSRresult(write, encodedInstr, aluResult, csrfile.mcounteren,
                                                                MCSR_MCOUNTEREN, exception);
                            csrfile.mscratch = writeCSRresult(write, encodedInstr, aluResult, csrfile.mscratch,
                                                              MCSR_MSCRATCH, exception);
                            csrfile.mepc = writeCSRresult(write, encodedInstr, aluResult, csrfile.mepc, MCSR_MEPC, exception);
                            csrfile.mcause = writeCSRresult(write, encodedInstr, aluResult, csrfile.mcause,
                                                            MCSR_MCAUSE, exception);
                            csrfile.mtval = writeCSRresult(write, encodedInstr, aluResult, csrfile.mtval, MCSR_MTVAL, exception);
                            mip_tmp = writeCSRresult(write, encodedInstr, aluResult, csrfile.mip, MCSR_MIP, exception);

                            csrfile.sedeleg = writeCSRresult(write, encodedInstr, aluResult, csrfile.sedeleg,
                                                             SCSR_SEDELEG, exception);
                            csrfile.sideleg = writeCSRresult(write, encodedInstr, aluResult, csrfile.sideleg,
                                                             SCSR_SIDELEG, exception);
                            csrfile.stvec = writeCSRresult(write, encodedInstr, aluResult, csrfile.stvec, SCSR_STVEC, exception);
                            csrfile.scounteren = writeCSRresult(write, encodedInstr, aluResult, csrfile.scounteren,
                                                                SCSR_SCOUNTEREN, exception);
                            csrfile.sscratch = writeCSRresult(write, encodedInstr, aluResult, csrfile.sscratch,
                                                              SCSR_SSCRATCH, exception);
                            csrfile.sepc = writeCSRresult(write, encodedInstr, aluResult, csrfile.sepc, SCSR_SEPC, exception);
                            csrfile.scause = writeCSRresult(write, encodedInstr, aluResult, csrfile.scause,
                                                            SCSR_SCAUSE, exception);
                            csrfile.stval = writeCSRresult(write, encodedInstr, aluResult, csrfile.stval, SCSR_STVAL, exception);
                            csrfile.satp = writeCSRresult(write, encodedInstr, aluResult, csrfile.satp, SCSR_SATP, exception);


                            csrfile.utvec = writeCSRresult(write, encodedInstr, aluResult, csrfile.utvec, UCSR_UTVEC, exception);
                            csrfile.uscratch = writeCSRresult(write, encodedInstr, aluResult, csrfile.uscratch,
                                                              UCSR_USCRATCH, exception);
                            csrfile.uepc = writeCSRresult(write, encodedInstr, aluResult, csrfile.uepc, UCSR_UEPC, exception);
                            csrfile.ucause = writeCSRresult(write, encodedInstr, aluResult, csrfile.ucause,
                                                            UCSR_UCAUSE, exception);
                            csrfile.utval = writeCSRresult(write, encodedInstr, aluResult, csrfile.utval, UCSR_UTVAL, exception);


                            
                            //Set up write back
                            regfileWrite.dst = getRdAddr(encodedInstr);



                            regfileWrite.dstData = aluOp2; //Compute result
                            regfileWrite.exception = exception;
                            toRegsPort->write(regfileWrite); //Perform write back
                            
                            //Set-up PC
                            pcReg = pcReg + 4; 
                        
                    } else if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_CSRRWI ||
                               getInstrType(encodedInstr) == InstrType_Complete::INSTR_CSRRSI ||
                               getInstrType(encodedInstr) == InstrType_Complete::INSTR_CSRRCI) {
                        /////////////////////////////////////////////////////////////////////////////
                        //|    ------    |       ------      |       ------     |  WB (RF_WRITE)  |//
                        /////////////////////////////////////////////////////////////////////////////
                        //get operand for next csr by reading from regfile and read current csr value
                        write = isCSRwrite(getInstrType(encodedInstr), getRs1Addr(encodedInstr));
                        exception = isInvalidCSRaction(write, prv, encodedInstr,  csrfile.mstatus, csrfile.mcounteren, csrfile.scounteren);


                            //get operand for next csr by reading from regfile and read current csr value
                            aluOp1 = getRs1Addr(encodedInstr);
                            aluOp2 = getCSR(csrfile, encodedInstr);
                            aluResult = getCSRresult(getInstrType(encodedInstr), aluOp1, aluOp2);

                            //CSR is only written if address matches tag, and no exception occured

                            csrfile.mstatus = writeCSRresult(write, encodedInstr, aluResult, csrfile.mstatus,
                                                             MCSR_MSTATUS, exception);
                            csrfile.medeleg = writeCSRresult(write, encodedInstr, aluResult, csrfile.medeleg,
                                                             MCSR_MEDELEG, exception);
                            csrfile.mideleg = writeCSRresult(write, encodedInstr, aluResult, csrfile.mideleg,
                                                             MCSR_MIDELEG, exception);
                            csrfile.mie = writeCSRresult(write, encodedInstr, aluResult, csrfile.mie, MCSR_MIE, exception);
                            csrfile.mtvec = writeCSRresult(write, encodedInstr, aluResult, csrfile.mtvec, MCSR_MTVEC, exception);
                            csrfile.mcounteren = writeCSRresult(write, encodedInstr, aluResult, csrfile.mcounteren,
                                                                MCSR_MCOUNTEREN, exception);
                            csrfile.mscratch = writeCSRresult(write, encodedInstr, aluResult, csrfile.mscratch,
                                                              MCSR_MSCRATCH, exception);
                            csrfile.mepc = writeCSRresult(write, encodedInstr, aluResult, csrfile.mepc, MCSR_MEPC, exception);
                            csrfile.mcause = writeCSRresult(write, encodedInstr, aluResult, csrfile.mcause,
                                                            MCSR_MCAUSE, exception);
                            csrfile.mtval = writeCSRresult(write, encodedInstr, aluResult, csrfile.mtval, MCSR_MTVAL, exception);
                            mip_tmp = writeCSRresult(write, encodedInstr, aluResult, csrfile.mip, MCSR_MIP, exception);

                            csrfile.sedeleg = writeCSRresult(write, encodedInstr, aluResult, csrfile.sedeleg,
                                                             SCSR_SEDELEG, exception);
                            csrfile.sideleg = writeCSRresult(write, encodedInstr, aluResult, csrfile.sideleg,
                                                             SCSR_SIDELEG, exception);
                            csrfile.stvec = writeCSRresult(write, encodedInstr, aluResult, csrfile.stvec, SCSR_STVEC, exception);
                            csrfile.scounteren = writeCSRresult(write, encodedInstr, aluResult, csrfile.scounteren,
                                                                SCSR_SCOUNTEREN, exception);
                            csrfile.sscratch = writeCSRresult(write, encodedInstr, aluResult, csrfile.sscratch,
                                                              SCSR_SSCRATCH, exception);
                            csrfile.sepc = writeCSRresult(write, encodedInstr, aluResult, csrfile.sepc, SCSR_SEPC, exception);
                            csrfile.scause = writeCSRresult(write, encodedInstr, aluResult, csrfile.scause,
                                                            SCSR_SCAUSE, exception);
                            csrfile.stval = writeCSRresult(write, encodedInstr, aluResult, csrfile.stval, SCSR_STVAL, exception);
                            csrfile.satp = writeCSRresult(write, encodedInstr, aluResult, csrfile.satp, SCSR_SATP, exception);


                            csrfile.utvec = writeCSRresult(write, encodedInstr, aluResult, csrfile.utvec, UCSR_UTVEC, exception);
                            csrfile.uscratch = writeCSRresult(write, encodedInstr, aluResult, csrfile.uscratch,
                                                              UCSR_USCRATCH, exception);
                            csrfile.uepc = writeCSRresult(write, encodedInstr, aluResult, csrfile.uepc, UCSR_UEPC, exception);
                            csrfile.ucause = writeCSRresult(write, encodedInstr, aluResult, csrfile.ucause,
                                                            UCSR_UCAUSE, exception);
                            csrfile.utval = writeCSRresult(write, encodedInstr, aluResult, csrfile.utval, UCSR_UTVAL, exception);

                            
                            //Set up write back
                            regfileWrite.dst = getRdAddr(encodedInstr);

                            regfileWrite.dstData = aluOp2; //Compute result
                            regfileWrite.exception = exception;
                            toRegsPort->write(regfileWrite); //Perform write back
                            
                            //Set-up PC  
                            pcReg = pcReg + 4;
                        
                    } else if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_PRIV) {
                        /////////////////////////////////////////////////////////////////////////////
                        //|    ------     |       ------      |       ------      |    ------     |//
                        /////////////////////////////////////////////////////////////////////////////
                        if (getPrivInstrType(encodedInstr) == PrivInstrType::INSTR_ECALL) {
////                        isaREQ = true; // FIXME: no need for this variable
//                            isa_ecall_Port->write(true);
                            // wait for ecall to finish processing the ecall
//                            ecall_isa_Port->read(sysRES);
//#ifndef NOSCAM
//                            if (!sysRES) {
//                                std::cout << "ECALL exit" << std::endl;
//                                sc_stop();
//                                wait(SC_ZERO_TIME);
//                            }
//#endif
                            //                           pcReg = pcReg + 4;

                            if(prv == MachineMode){
                                exception = EXCEPTION | EXC_ECALL_M_MODE;    //instruction only causes exception, with exception code dependent on privilege level.
                                                                             //system calls are handled in SW
                            }else if(prv == SupervisorMode){
                                exception = EXCEPTION | EXC_ECALL_S_MODE;

                            }else if(prv == UserMode){
                                exception = EXCEPTION | EXC_ECALL_U_MODE;

                            }else{
                                exception = 0;
                            }
                        } else if (getPrivInstrType(encodedInstr) == PrivInstrType::INSTR_EBREAK) {
                            exception = EXCEPTION | EXC_BREAKPOINT;
                        } else if (getPrivInstrType(encodedInstr) == PrivInstrType::INSTR_MRET) {
                       
                            prv = MPP_ALIGN(csrfile.mstatus);  //privilege level = privilege level prior to trap
                            csrfile.mstatus = mstatusTrapReturn(csrfile.mstatus,
                                                                MachineMode); // MIE = MPIE, MPIE = 1, MPP = U-mode

                            csrfile.mcause = 0;
                            pcReg = csrfile.mepc;  //mepc is written with appropriate value by SW in trap handler
                            to_mmu.reset_lrsc = 1; //load reserved address invalidated on return from trap handler
                        } else if (getPrivInstrType(encodedInstr) == PrivInstrType::INSTR_SRET) {
                       
                            if ((csrfile.mstatus & MSTATUS_TSR) != 0 && prv == SupervisorMode) {
                                exception = EXCEPTION | EXC_ILLEGAL_INSTRUCTION;
                            } else {
                                prv = SPP_ALIGN(csrfile.mstatus);

                                csrfile.mstatus = mstatusTrapReturn(csrfile.mstatus,
                                                                    SupervisorMode);  // SIE = SPIE, SPIE = 1, SPP = U-mode

                                csrfile.scause = 0;
                                pcReg = csrfile.sepc; 
                             to_mmu.reset_lrsc = 1; 
                            }
                        } else if (getPrivInstrType(encodedInstr) == PrivInstrType::INSTR_URET) {
                        
                            prv = 0;
                            csrfile.mstatus = mstatusTrapReturn(csrfile.mstatus, UserMode);  // UIE = UPIE, UPIE = 1, UPP always implied 0
                            csrfile.ucause = 0;
                            pcReg = csrfile.uepc;
                            to_mmu.reset_lrsc = 1; 
                        } else if (getPrivInstrType(encodedInstr) == PrivInstrType::INSTR_WFI) {
                            if (prv == SupervisorMode && (csrfile.mstatus & MSTATUS_TW) != 0) {
                                exception = EXCEPTION | EXC_ILLEGAL_INSTRUCTION; //Even as NOP it needs to raise exception to be RISCV compliant
                            }
                                pcReg = pcReg + 4; //NOP as we only focus on single CPU implementation at the moment
                            
                        } else if (getPrivInstrType(encodedInstr) == PrivInstrType::INSTR_SFENCEVMA) {
                   
                            if (prv == SupervisorMode && (csrfile.mstatus & MSTATUS_TVM) != 0) {
                                exception = EXCEPTION | EXC_ILLEGAL_INSTRUCTION; //Even as NOP it needs to raise exception to be RISCV compliant
                            }
                                pcReg = pcReg + 4; //Supposed to flush TLB but TLB not yet implemented
                            

                        } else { 
                  
                            exception = EXCEPTION | EXC_ILLEGAL_INSTRUCTION;
                        }
                    }
                } else {
                    if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_UNKNOWN) {
                        exception = EXCEPTION | EXC_ILLEGAL_INSTRUCTION;
                       
                    }

                }
            }



            mip_isa_Port->read(csrfile.mip);

            csrfile.mip = (((csrfile.mip & (-MIP_WRITE_MASK) -1))  | (mip_tmp & MIP_WRITE_MASK)); //mip_isa_Port->read overwrites changes by CSR instruction
            pending = computeInterruptPending(csrfile.mie, csrfile.mip, csrfile.mstatus, prv);

            xtval = updateXTVAL(exception, pcReg, encodedInstr, xtval); //trap value register value stored in generic register

            target_prv = delegateTrapS(exception, pending, csrfile.medeleg, csrfile.mideleg, csrfile.sedeleg,  //Delegation of trap handler
                                       csrfile.sideleg, prv);
            xtvec = updateXTVEC(csrfile.mtvec, csrfile.stvec, csrfile.utvec, target_prv); //vector address generic register, selected based on delegation
            xcause = updateXCAUSE(exception, pending); //trap cause generic register

            csrfile.mcause = updateMCAUSE(exception, pending, xcause, target_prv, csrfile.mcause);  //Appropriate cause register receives generic cause register value based on delegation, if trap occurs
            csrfile.scause = updateSCAUSE(exception, pending, xcause, target_prv, csrfile.scause);
            csrfile.ucause = updateUCAUSE(exception, pending, xcause, target_prv, csrfile.ucause);

            csrfile.mepc = updateMEPC(exception, pending, target_prv, csrfile.mepc, pcReg);         //Appropriate epc register updated based on delegation, if trap occurs
            csrfile.sepc = updateSEPC(exception, pending, target_prv, csrfile.sepc, pcReg);
            csrfile.uepc = updateUEPC(exception, pending, target_prv, csrfile.uepc, pcReg);

            csrfile.mtval = updateMTVAL(csrfile.mtval, xtval, exception, target_prv);      //Appropriate trap value register receive generic register based on delegation, if trap occurs
            csrfile.stval = updateSTVAL(csrfile.stval, xtval, exception, target_prv);
            csrfile.utval = updateUTVAL(csrfile.utval, xtval, exception, target_prv);

            pcReg = updatePC(exception, pending, xtvec, pcReg);                          //program counter either incremented or updated with generic trap vector



            xstatus_mask = updateXSTATUSmask(csrfile.mstatus, target_prv, prv);    //mstatus is updated differently based on privilege level

            csrfile.mstatus = updateMSTATUS(csrfile.mstatus, exception, pending, xstatus_mask, target_prv); //mstatus updated based on if trap occurs and privilege level.

 



            prv = target_prv; //update privilege level.


            csrfile.mcycleh = mcyclehcount(csrfile.mcyclel, csrfile.mcycleh); //TODO: inaccurate, needs to account for type of instruction, MMU etc
            csrfile.mcyclel = mcyclelcount(csrfile.mcyclel);


            csrfile.minstreth = minstrethcount(csrfile.minstretl, csrfile.minstreth, exception); //instructions retired only updated if instruction did not cause exception
            csrfile.minstretl = minstretlcount(csrfile.minstretl, exception);




            nextsection = Sections::fetch; // Fetch next instruction
        }

        section = nextsection; // Set next section
    }
}


unsigned int ISA::readmtimel(unsigned int mtimel, unsigned int encodedInstr, unsigned int exception, unsigned int data) const{

    if(POS_IMM_I_FIELD(encodedInstr) == UCSR_TIME && exception == 0){
        return data;
    }else{
        return mtimel;
    }

}




unsigned int ISA::readmtimeh(unsigned int mtimeh, unsigned int encodedInstr, unsigned int exception, unsigned int data) const{

    if(POS_IMM_I_FIELD(encodedInstr) == UCSR_TIME_H && exception == 0){
        return data;
    }else{
        return mtimeh;
    }

}


unsigned int ISA::minstrethcount(unsigned int minstretl, unsigned int minstreth, unsigned int exception) const{

    if(minstretl == static_cast<unsigned int>(0xFFFFFFFF) && minstreth < static_cast<unsigned int>(0xFFFFFFFF) && exception == 0){
        return minstreth + 1;
    }else if(minstreth == static_cast<unsigned int>(0xFFFFFFFF) && exception == 0){
        return 0;
    }else{
        return minstreth;
    }

}



unsigned int ISA::minstretlcount(unsigned int minstretl, unsigned int exception) const{

    if(minstretl == static_cast<unsigned int>(0xFFFFFFFF) && exception == 0){
        return 0;
    }else if(minstretl < static_cast<unsigned int>(0xFFFFFFFF) && exception == 0){
        return minstretl + 1;
    }else{
        return minstretl;
    }

}

unsigned int ISA::mcyclehcount(unsigned int mcyclel, unsigned int mcycleh) const{

    if(mcyclel == static_cast<unsigned int>(0xFFFFFFFF) && mcycleh < static_cast<unsigned int>(0xFFFFFFFF)){
        return mcycleh + 2; //from fetch to end of execution is min 2 cycles
    }else if(mcycleh == static_cast<unsigned int>(0xFFFFFFFF)){
        return 0;
    }else{
        return mcycleh;
    }

}

unsigned int ISA::mcyclelcount(unsigned int mcyclel) const{

    if(mcyclel == static_cast<unsigned int>(0xFFFFFFFF)){
        return 0;
    }else{
        return mcyclel + 2;
    }


}


unsigned int ISA::mtimeoffset(unsigned int encodedInstr) const{


    if(POS_IMM_I_FIELD(encodedInstr) == UCSR_TIME){
        return 0;
    }else{
        return 4;
    }



}

unsigned int ISA::amoData(AmoInstrType instr, unsigned int aluResult, unsigned int mmudata, unsigned int aluOp2) const{

if(aluResult != 0 && (instr == AMO_MIN || instr == AMO_MINU)){
return mmudata;
}else if(aluResult == 0 && (instr == AMO_MAX || instr == AMO_MAXU)){
return mmudata;
}else if(instr == AMO_ADD || instr == AMO_AND || instr == AMO_OR || instr == AMO_XOR){
return aluResult;
}else{
return aluOp2;
}
}

unsigned int ISA::ignoreLSB(unsigned int reg) const{

return reg & -2;

}

ALUfuncType ISA::getAmoAlufunc(AmoInstrType instr) const{

    if(instr == AMO_ADD){
        return ALU_ADD;
    }else if(instr == AMO_XOR){
        return ALU_XOR;
    }else if(instr == AMO_OR){
        return ALU_OR;
    }else if(instr == AMO_AND){
        return ALU_AND;
    }else if(instr == AMO_MIN || instr == AMO_MAX){
        return ALU_SLT;
    }else if(instr == AMO_MINU || instr == AMO_MAXU){
        return ALU_SLTU;
    }else{
        return ALU_X;
    }
}


AmoInstrType ISA::getAmoType(unsigned int encodedInstr) const{
    if(FUNC5_FIELD(encodedInstr) == 0x02){
        return AMO_LR;
    }else if(FUNC5_FIELD(encodedInstr) == 0x03){
        return AMO_SC;
    }else if(FUNC5_FIELD(encodedInstr) == 0x01){
        return AMO_SWAP;
    }else if(FUNC5_FIELD(encodedInstr) == 0x00){
        return AMO_ADD;
    }else if(FUNC5_FIELD(encodedInstr) == 0x04){
        return AMO_XOR;
    }else if(FUNC5_FIELD(encodedInstr) == 0x0C){
        return AMO_AND;
    }else if(FUNC5_FIELD(encodedInstr) == 0x08){
        return AMO_OR;
    }else if(FUNC5_FIELD(encodedInstr) == 0x10){
        return AMO_MIN;
    }else if(FUNC5_FIELD(encodedInstr) == 0x14){
        return AMO_MAX;
    }else if(FUNC5_FIELD(encodedInstr) == 0x18){
        return AMO_MINU;
    }else if(FUNC5_FIELD(encodedInstr) == 0x1C){
        return AMO_MAXU;
    }else{
        return AMO_UNKNOWN;
    }

}

unsigned int ISA::checkAddrAlignment(ME_MaskType masktype, unsigned int address, bool isLoad) const{

    if(((masktype == ME_MaskType::MT_H) || (masktype == ME_MaskType::MT_HU)) && ((address % 2) != 0)){
        if(isLoad) return EXCEPTION |EXC_LOAD_ADR_MISALIGNED;
        else return EXCEPTION | EXC_STORE_AMO_ADR_MISALIGNED;
    }else if(masktype == ME_MaskType::MT_W && ((address % 4) != 0)){
        if(isLoad) return EXCEPTION |EXC_LOAD_ADR_MISALIGNED;
        else return EXCEPTION | EXC_STORE_AMO_ADR_MISALIGNED;
    }else{
        return 0;
    }


}

unsigned int ISA::mstatusTrapReturn(unsigned int mstatus, unsigned int xret) const{

    if(xret == UserMode){
        return ((mstatus | UPIE_ALIGN(mstatus) | MSTATUS_UPIE));
    }else if(xret == SupervisorMode){
        return ((mstatus | SPIE_ALIGN(mstatus) | MSTATUS_SPIE) & ((-MSTATUS_SPP)-1));
    }else if(xret == MachineMode){
        return ((mstatus | MPIE_ALIGN(mstatus) | MSTATUS_MPIE) & ((-MSTATUS_MPP)-1));
    }else{
        return mstatus;
    }

}


unsigned int ISA::updateXCAUSE(unsigned int exception, unsigned int pending) const{

    if(pending != 0 && exception == 0){
        if(MTRAP_MEI(pending) != 0) return INTERRUPT | EXC_M_EXTERNAL_INTERRUPT;
        else if(MTRAP_MTI(pending) != 0) return INTERRUPT | EXC_M_TIMER_INTERRUPT;
        else if(MTRAP_MSI(pending) != 0) return INTERRUPT | EXC_M_SOFTWARE_INTERRUPT;
        else if(MTRAP_SEI(pending) != 0) return INTERRUPT | EXC_S_EXTERNAL_INTERRUPT;
        else if(MTRAP_STI(pending) != 0) return INTERRUPT | EXC_S_TIMER_INTERRUPT;
        else if(MTRAP_SSI(pending) != 0) return INTERRUPT | EXC_S_SOFTWARE_INTERRUPT;
        else if(MTRAP_UEI(pending) != 0) return INTERRUPT | EXC_U_EXTERNAL_INTERRUPT;
        else if(MTRAP_UTI(pending) != 0) return INTERRUPT | EXC_U_TIMER_INTERRUPT;
        else if(MTRAP_USI(pending) != 0) return INTERRUPT | EXC_U_SOFTWARE_INTERRUPT;
        else return 0;
    }else if(exception != 0){
        return exception & ((-EXCEPTION)-1);
    }else{
        return 0;
    }
}


unsigned int ISA::computeInterruptPending(unsigned int mie, unsigned int mip, unsigned int mstatus, unsigned int prv) const { //need to effectively check privilege as MIE is implied 1 if privilege level is < machinemode
                                                                                                                              //and that MIE and SIE is implied 1 if privilege level is < supervisormode
    if ((MTRAP_MEI(mie) != 0) && (MTRAP_MEI(mip) != 0) && (MSTATUS_MIE(mstatus) != 0 || prv < MachineMode)) {
        return mip & mie; // Mcause_MEI
    } else if ((MTRAP_MSI(mie) != 0) && (MTRAP_MSI(mip) != 0) && (MSTATUS_MIE(mstatus) != 0 || prv < MachineMode)) {
        return mip & mie;
    } else if ((MTRAP_MTI(mie) != 0) && (MTRAP_MTI(mip) != 0) && (MSTATUS_MIE(mstatus) != 0 || prv < MachineMode)) {
        return mip & mie;
    }else  if ((MTRAP_SEI(mie) != 0) && (MTRAP_SEI(mip) != 0) && (MSTATUS_SIE(mstatus) != 0 ||
                                                                  (prv == MachineMode && MSTATUS_MIE(mstatus) != 0) || prv < SupervisorMode)) {
        return mip & mie;
    } else if ((MTRAP_SSI(mie) != 0) && (MTRAP_SSI(mip) != 0) && (MSTATUS_SIE(mstatus) != 0 ||
                                                                  (prv == MachineMode && MSTATUS_MIE(mstatus) != 0) || prv < SupervisorMode)) {
        return mip & mie;
    } else if ((MTRAP_STI(mie) != 0) && (MTRAP_STI(mip) != 0) && (MSTATUS_SIE(mstatus) != 0 ||
                                                                  (prv == MachineMode && MSTATUS_MIE(mstatus) != 0) || prv < SupervisorMode)) {
        return mip & mie;
    }else  if ((MTRAP_UEI(mie) != 0) && (MTRAP_UEI(mip) != 0) && ((MSTATUS_SIE(mstatus) != 0 && prv == SupervisorMode) ||
                                                                  (prv == MachineMode && MSTATUS_MIE(mstatus) != 0) || MSTATUS_UIE(mstatus) != 0)){
        return mip & mie;
    } else if ((MTRAP_USI(mie) != 0) && (MTRAP_USI(mip) != 0) && ((MSTATUS_SIE(mstatus) != 0 && prv == SupervisorMode) ||
                                                                  (prv == MachineMode && MSTATUS_MIE(mstatus) != 0) || MSTATUS_UIE(mstatus) != 0)) {
        return mip & mie;
    } else if ((MTRAP_UTI(mie) != 0) && (MTRAP_UTI(mip) != 0) && ((MSTATUS_SIE(mstatus) != 0 && prv == SupervisorMode)||
                                                                  (prv == MachineMode && MSTATUS_MIE(mstatus) != 0) || MSTATUS_UIE(mstatus) != 0)) {
        return mip & mie;
    }else{
        return 0;
    }

}

unsigned int ISA::updateMTVAL(unsigned int mtval, unsigned int xtval, unsigned int exception, unsigned int target_prv) const{

    if((exception & EXCEPTION) != 0 && target_prv == MachineMode){
        return xtval;
    }else{
        return mtval;
    }

}

unsigned int ISA::updateSTVAL(unsigned int stval, unsigned int xtval, unsigned int exception, unsigned int target_prv) const{

    if((exception & EXCEPTION) != 0 && target_prv == SupervisorMode){
        return xtval;
    }else{
        return stval;
    }

}

unsigned int ISA::updateUTVAL(unsigned int utval, unsigned int xtval, unsigned int exception, unsigned int target_prv) const{

    if((exception & EXCEPTION) != 0 && target_prv == UserMode){
        return xtval;
    }else{
        return utval;
    }

}



unsigned int ISA::updateXSTATUSmask(unsigned int mstatus, unsigned int target_prv, unsigned int prv) const {

    if(target_prv == MachineMode) {


        return ((MSTATUS_MIE(mstatus) << 4) | (prv << 11)); //MPIE = MIE, MIE = 0, MPP = priv-level prior to trap
    }else if(target_prv == SupervisorMode){
        return ((MSTATUS_SIE(mstatus) << 4) | (prv << 8));  //SPIE = SIE, SIE = 0, SPP = priv-level prior to trap
    }else if(target_prv == UserMode){
        return ((MSTATUS_UIE(mstatus) << 4)); //UPIE = UIE, UIE = 0, UPP always 0
    }else{
        return 0;
    }
}


unsigned int ISA::updateXTVEC(unsigned int mtvec, unsigned int stvec, unsigned int utvec, unsigned int target_prv) const { //selects appropriate trap vector

    if(target_prv == MachineMode) return mtvec;
    else if(target_prv == SupervisorMode) return stvec;
    else if(target_prv == UserMode) return utvec;
    else return 0;

}

unsigned int ISA::delegateTrapS(unsigned int exception, unsigned int pending, unsigned int medeleg, unsigned int mideleg,
                                unsigned int sedeleg, unsigned int sideleg, unsigned int prv) const{



    if(pending != 0 && exception == 0){
        if((pending & mideleg) != 0 && (prv < MachineMode)) { //interrupts or exceptions occuring while in M-mode is never delegated
            return ISA::delegateTrapU(exception, pending, sedeleg, sideleg, prv);
        }else {
            return MachineMode;
        }
    }else if(exception != 0){
        if((medeleg & (1 << (exception & ((-EXCEPTION)-1)))) != 0 && (prv < MachineMode)){
            return ISA::delegateTrapU(exception, pending, sedeleg, sideleg, prv);
        }else{
            return MachineMode;
        }

    }else{
        return prv;
    }



}

unsigned int ISA::delegateTrapU(unsigned int exception, unsigned int pending , unsigned int sedeleg, unsigned int sideleg, unsigned int prv) const{


    if(pending != 0 && exception == 0) {
        if ((pending & sideleg) != 0 && (prv < SupervisorMode)){//interrupts or exceptions occuring while in S-mode is never further delegated
            return UserMode;
        }else {
            return SupervisorMode;
        }
    }else{
        if((sedeleg & (1 << (exception & ((-EXCEPTION)-1)))) != 0 && (prv < SupervisorMode)){
            return UserMode;
        }else{
            return SupervisorMode;
        }
    }

}

unsigned int ISA::updateXTVAL(unsigned int exception, unsigned int pcReg, unsigned int encodedInstr, unsigned int xtval) const{


    if((exception & ((-EXCEPTION)-1)) == EXC_ILLEGAL_INSTRUCTION){
        return encodedInstr;
    }else if((exception & ((-EXCEPTION)-1)) == EXC_MISALIGNED_ADR_INSTR){
        return xtval;
    }else if((exception & ((-EXCEPTION)-1)) == EXC_LOAD_ADR_MISALIGNED){
        return xtval;
    }else if((exception & ((-EXCEPTION)-1)) == EXC_STORE_AMO_ADR_MISALIGNED){
        return xtval;
    }else if((exception & ((-EXCEPTION)-1)) == EXC_BREAKPOINT){
        return pcReg;
    }else if((exception & ((-EXCEPTION)-1)) == EXC_INSTR_PAGE_FAULT){
        return xtval;
    }else if((exception & ((-EXCEPTION)-1)) == EXC_LOAD_PAGE_FAULT){
        return xtval;
    }else if((exception & ((-EXCEPTION)-1)) == EXC_STORE_AMO_PAGE_FAULT){
        return xtval;
    }else if((exception & ((-EXCEPTION)-1)) == EXC_INSTR_ACC_FAULT){
        return xtval;
    }else if((exception & ((-EXCEPTION)-1)) == EXC_LOAD_ACC_FAULT){
        return xtval;
    }else if((exception & ((-EXCEPTION)-1)) == EXC_STORE_AMO_ACC_FAULT){
        return xtval;
    }else{
        return 0;
    }

}




unsigned int ISA::updateMCAUSE(unsigned int exception, unsigned int pending, unsigned int xcause, unsigned int target_prv, unsigned int mcause) const {

    if ((exception != 0 || pending != 0) && target_prv == MachineMode) {
        return xcause;
    } else {
        return mcause;
    }

}

unsigned int ISA::updateSCAUSE(unsigned int exception, unsigned int pending, unsigned int xcause, unsigned int target_prv, unsigned int scause) const {

    if ((exception != 0 || pending != 0) && target_prv == SupervisorMode) {
        return xcause;
    } else {
        return scause;
    }

}

unsigned int ISA::updateUCAUSE(unsigned int exception, unsigned int pending, unsigned int xcause, unsigned int target_prv, unsigned int ucause) const {

    if ((exception != 0 || pending != 0) && target_prv == UserMode) {
        return xcause;
    } else {
        return ucause;
    }
}

unsigned int ISA::updateMSTATUS(unsigned int mstatus, unsigned int exception, unsigned int pending, unsigned int xstatus_mask, unsigned int target_prv) const {
    if ((exception != 0) || (pending != 0)) {
        if (target_prv == MachineMode) {
            return ((mstatus & ((-CLEAR_MSTATUS_TRAP)-1)) | xstatus_mask); 
        } else if (target_prv == SupervisorMode) {
            return ((mstatus & ((-CLEAR_SSTATUS_TRAP)-1)) | xstatus_mask);
        } else if (target_prv == UserMode) {
            return ((mstatus & ((-CLEAR_USTATUS_TRAP)-1)) | xstatus_mask);
        } else {
            return mstatus;
        }
    } else {
        return mstatus;
    }
}

unsigned int ISA::updateMEPC(unsigned int exception , unsigned int pending, unsigned int target_prv, unsigned int mepc, unsigned int pcReg) const {



    if (pending != 0 && exception == 0 && target_prv == MachineMode) {
        return pcReg; 
    } else if (exception != 0 && target_prv == MachineMode) { // exceptions
        return lastPc; // pc is not incremented if an exception occurs
    } else {
        return mepc;
    }

}

unsigned int ISA::updateSEPC(unsigned int exception , unsigned int pending, unsigned int target_prv, unsigned int sepc, unsigned int pcReg) const {


    if (pending != 0 && exception == 0 && target_prv == SupervisorMode) {
        return pcReg; // 
    }else if (exception != 0 && target_prv == SupervisorMode) { // exceptions
        return lastPc; // pc is not incremented if an exception occurs
    }else {
        return sepc;
    }

}

unsigned int ISA::updateUEPC(unsigned int exception , unsigned int pending, unsigned int target_prv, unsigned int uepc, unsigned int pcReg) const {


    if (pending != 0  && exception == 0 && target_prv == UserMode) {
        return pcReg; 
    }else if (exception != 0 && target_prv == UserMode) { // exceptions
        return lastPc; // pc is not incremented if an exception occurs
    }else {
        return uepc;
    }

}


unsigned int ISA::updatePC(unsigned int exception, unsigned int pending, unsigned int xtvec, unsigned int pcReg) const {

    if(exception != 0 || pending != 0){
        if ((xcause & INTERRUPT) != 0 && (xtvec & XTVEC_VECTORED) != 0) {
            return (xtvec & XTVEC_BASE_MASK) + 4*(xcause & ((-INTERRUPT)-1));
        } else{
            return (xtvec & XTVEC_BASE_MASK);
        }
    }else {
        return pcReg;
    }

}




unsigned int ISA::isCSRwrite(InstrType_Complete instr_type, unsigned int rs1addr) const {

    if((instr_type == InstrType_Complete::INSTR_CSRRC || instr_type == InstrType_Complete::INSTR_CSRRS ||
        instr_type == InstrType_Complete::INSTR_CSRRCI || instr_type == InstrType_Complete::INSTR_CSRRSI) && rs1addr == 0){
        return 0;
    }else return 1;


}

unsigned int ISA::isCSRinRange(unsigned int encodedInstr) const {

    if((POS_IMM_I_FIELD(encodedInstr) >= 0x300) && (POS_IMM_I_FIELD(encodedInstr) <= 0x306)){
        return 0;
    }else if((POS_IMM_I_FIELD(encodedInstr) >= 0x340) && (POS_IMM_I_FIELD(encodedInstr) <= 0x344)){
        return 0;
    }else if((POS_IMM_I_FIELD(encodedInstr) >= 0xF11) && (POS_IMM_I_FIELD(encodedInstr) <= 0xF14)){
        return 0;
    }else if((POS_IMM_I_FIELD(encodedInstr) >= 0xC00) && (POS_IMM_I_FIELD(encodedInstr) <= 0xC1F)){
        return 0;
    }else if((POS_IMM_I_FIELD(encodedInstr) >= 0xC80) && (POS_IMM_I_FIELD(encodedInstr) <= 0xC9F)){
        return 0;
    }else if((POS_IMM_I_FIELD(encodedInstr) >= 0xB00) && (POS_IMM_I_FIELD(encodedInstr) <= 0xB1F)){
        return 0;
    }else if((POS_IMM_I_FIELD(encodedInstr) >= 0xB80) && (POS_IMM_I_FIELD(encodedInstr) <= 0xB9F)){
        return 0;
    }else if((POS_IMM_I_FIELD(encodedInstr) >= 0x323) && (POS_IMM_I_FIELD(encodedInstr) <= 0x33F)){
        return 0;
    }else if((POS_IMM_I_FIELD(encodedInstr) >= 0x3A0) && (POS_IMM_I_FIELD(encodedInstr) <= 0x3A3)){
        return 0;
    }else if((POS_IMM_I_FIELD(encodedInstr) >= 0x3B0) && (POS_IMM_I_FIELD(encodedInstr) <= 0x3BF)){
        return 0;
    }else if((POS_IMM_I_FIELD(encodedInstr) >= 0x100) && (POS_IMM_I_FIELD(encodedInstr) <= 0x106)){
        return 0;
    }else if((POS_IMM_I_FIELD(encodedInstr) >= 0x140) && (POS_IMM_I_FIELD(encodedInstr) <= 0x144)){
        return 0;
    }else if((POS_IMM_I_FIELD(encodedInstr) >= 0x040) && (POS_IMM_I_FIELD(encodedInstr) <= 0x044)){
        return 0;
    }else if((POS_IMM_I_FIELD(encodedInstr) == 0x000) || (POS_IMM_I_FIELD(encodedInstr) == 0x004) ||
             (POS_IMM_I_FIELD(encodedInstr) == 0x005) || (POS_IMM_I_FIELD(encodedInstr) == 0x180)){
        return 0;
    }else{
        return EXCEPTION | EXC_ILLEGAL_INSTRUCTION;
    }
}

unsigned int ISA::isInvalidCSRaction(unsigned int write, unsigned int priv_lvl,
                                     unsigned int encodedInstr, unsigned int mstatus, unsigned int mcounteren, unsigned int scounteren) const {


    if(write != 0 && (getCSRrwtype(POS_IMM_I_FIELD(encodedInstr)) == READONLY)){
        return EXCEPTION | EXC_ILLEGAL_INSTRUCTION;
    }else if(getCSRprivlvl(POS_IMM_I_FIELD(encodedInstr)) > priv_lvl){  //does rd = 0 need to be accounted for?
        return EXCEPTION | EXC_ILLEGAL_INSTRUCTION;
    }else if((POS_IMM_I_FIELD(encodedInstr) == SCSR_SATP) && (mstatus & MSTATUS_TVM) != 0){
        return EXCEPTION | EXC_ILLEGAL_INSTRUCTION;
    }else if(((POS_IMM_I_FIELD(encodedInstr) >= UCSR_CYCLE) && (POS_IMM_I_FIELD(encodedInstr) <= HPMCOUNTER_L_31)) ||
             ((POS_IMM_I_FIELD(encodedInstr) >= UCSR_CYCLE_H) && (POS_IMM_I_FIELD(encodedInstr) <= HPMCOUNTER_H_31))){
        return ISA::validCntRead( (POS_IMM_I_FIELD(encodedInstr) & 0x1F), priv_lvl, mcounteren, scounteren);
    }else{
        return ISA::isCSRinRange(encodedInstr);
    }



}

unsigned int ISA::validCntRead(unsigned int address, unsigned int priv_lvl, unsigned int mcounteren, unsigned int scounteren) const {

    if(priv_lvl == SupervisorMode && (mcounteren & (1 << (address))) == 0){
        return EXCEPTION | EXC_ILLEGAL_INSTRUCTION;
    }else if(priv_lvl == UserMode && ((mcounteren & (1 << (address))) == 0   ||
                                      (scounteren & (1 << (address))) == 0)){
        return EXCEPTION | EXC_ILLEGAL_INSTRUCTION;
    }else return 0;


}


unsigned int ISA::writeCSRresult(unsigned int write, unsigned int encodedInstr, unsigned int data,
                                 unsigned int currval, unsigned int tag, unsigned int exception) const {


    if(write != 0 && exception == 0) {
        if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MSTATUS && tag == MCSR_MSTATUS) {
            return  ((currval & ((-MSTATUS_MASK)-1)) | (data & MSTATUS_MASK));
        } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MIE && tag == MCSR_MIE) {
            return ((currval & ((-MIE_MASK)-1)) | (data & MIE_MASK));
        } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MTVEC  && tag == MCSR_MTVEC) {
            return ((currval & ((-MTVEC_MASK)-1)) | (data & MTVEC_MASK));
        } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MEPC && tag == MCSR_MEPC) {
            return data & MEPC_MASK;
        } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MCAUSE && tag == MCSR_MCAUSE) {
            return data;
        } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MIP && tag == MCSR_MIP) {
            return data; //mask handled elsewhere
        } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MEDELEG && tag == MCSR_MEDELEG) {
            return (data & MEDELEG_MASK);
        } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MIDELEG && tag == MCSR_MIDELEG) {
            return (data & MIDELEG_MASK);
        } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MCOUNTEREN && tag == MCSR_MCOUNTEREN) {
            return data & MCOUNTEREN_MASK;
        } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MTVAL && tag == MCSR_MTVAL) {
            return data;
        } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MSCRATCH && tag == MCSR_MSCRATCH) {
            return data;
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_SSTATUS && tag == MCSR_MSTATUS) {
            return  ((currval & ((-SSTATUS_MASK)-1)) | (data & SSTATUS_MASK));
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_SEDELEG && tag == SCSR_SEDELEG) {
            return data & SEDELEG_MASK;
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_SIDELEG && tag == SCSR_SIDELEG) {
            return data & SIDELEG_MASK;
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_SIE && tag == MCSR_MIE) {
            return ((currval & ((-SIE_MASK)-1)) | (data & SIE_MASK));
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_STVEC && tag == SCSR_STVEC) {
            return ((currval & ((-MTVEC_MASK)-1)) | (data & MTVEC_MASK));
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_SCOUNTEREN && tag == SCSR_SCOUNTEREN) {
            return data & MCOUNTEREN_MASK;
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_SSCRATCH && tag == SCSR_SSCRATCH) {
            return data;
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_SEPC && tag == SCSR_SEPC) {
            return data & MEPC_MASK;
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_SCAUSE && tag == SCSR_SCAUSE) {
            return data;
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_STVAL && tag == SCSR_STVAL) {
            return data;
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_SIP && tag == MCSR_MIP) {
            return  (data & SIP_WRITE_MASK);
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_SATP && tag == SCSR_SATP) {
            return data; //exception case already checked
        } else if (POS_IMM_I_FIELD(encodedInstr) == UCSR_USTATUS && tag == MCSR_MSTATUS) {
            return  ((currval & ((-USTATUS_MASK)-1)) | (data & USTATUS_MASK));
        } else if (POS_IMM_I_FIELD(encodedInstr) == UCSR_UIE && tag == MCSR_MIE) {
            return ((currval & ((-UIE_MASK)-1)) | (data & UIE_MASK));
        } else if (POS_IMM_I_FIELD(encodedInstr) == UCSR_UTVEC && tag == UCSR_UTVEC) {
            return ((currval & ((-MTVEC_MASK)-1)) | (data & MTVEC_MASK));
        } else if (POS_IMM_I_FIELD(encodedInstr) == UCSR_UEPC && tag == UCSR_UEPC) {
            return data & MEPC_MASK;
        } else if (POS_IMM_I_FIELD(encodedInstr) == UCSR_USCRATCH && tag == UCSR_USCRATCH) {
            return data;
        } else if (POS_IMM_I_FIELD(encodedInstr) == UCSR_UCAUSE && tag == UCSR_UCAUSE) {
            return data;
        } else if (POS_IMM_I_FIELD(encodedInstr) == UCSR_UTVAL && tag == UCSR_UTVAL) {
            return data;
        } else if (POS_IMM_I_FIELD(encodedInstr) == UCSR_UIP && tag == MCSR_MIP) {
            return (data & UIP_WRITE_MASK);
        } else  {
            return currval; //Still might need to implement PMP
        }
    }else return currval;


}


EncType ISA::getEncType(unsigned int encodedInstr) const {
    if (OPCODE_FIELD(encodedInstr) == OPCODE_R) {
        return ENC_R;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_I) {
        return ENC_I_I;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_L) {
        return ENC_I_L;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_J) {
        return ENC_I_J;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_M) {
        return ENC_I_M;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_S) {
        return ENC_I_S;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_S) {
        return ENC_S;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_B) {
        return ENC_B;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U1 || OPCODE_FIELD(encodedInstr) == OPCODE_U2) {
        return ENC_U;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_J) {
        return ENC_J;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_AMO) {
        return ENC_A;
    } else {
        return ENC_ERR;
    }
}


InstrType_Complete ISA::getInstrType(unsigned int encodedInstr) const {
    if (OPCODE_FIELD(encodedInstr) == OPCODE_R) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            if (FUNCT7_FIELD(encodedInstr) == 0x00) {
                return INSTR_ADD;
            } else if (FUNCT7_FIELD(encodedInstr) == 0x20) {
                return INSTR_SUB;
            } else {
                return INSTR_UNKNOWN;
            }
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return INSTR_SLL;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x02) {
            return INSTR_SLT;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x03) {
            return INSTR_SLTU;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x04) {
            return INSTR_XOR;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x05) {
            if (FUNCT7_FIELD(encodedInstr) == 0x00) {
                return INSTR_SRL;
            } else if (FUNCT7_FIELD(encodedInstr) == 0x20) {
                return INSTR_SRA;
            } else {
                return INSTR_UNKNOWN;
            }
        } else if (FUNCT3_FIELD(encodedInstr) == 0x06) {
            return INSTR_OR;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x07) {
            return INSTR_AND;
        } else {
            return INSTR_UNKNOWN;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_I) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            return INSTR_ADDI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return INSTR_SLLI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x02) {
            return INSTR_SLTI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x03) {
            return INSTR_SLTUI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x04) {
            return INSTR_XORI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x05) {
            if (FUNCT7_FIELD(encodedInstr) == 0x00) {
                return INSTR_SRLI;
            } else if (FUNCT7_FIELD(encodedInstr) == 0x20) {
                return INSTR_SRAI;
            } else {
                return INSTR_UNKNOWN;
            }
        } else if (FUNCT3_FIELD(encodedInstr) == 0x06) {
            return INSTR_ORI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x07) {
            return INSTR_ANDI;
        } else {
            return INSTR_UNKNOWN;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_L) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            return INSTR_LB;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return INSTR_LH;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x02) {
            return INSTR_LW;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x04) {
            return INSTR_LBU;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x05) {
            return INSTR_LHU;
        } else {
            return INSTR_UNKNOWN;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_J) {
        return INSTR_JALR;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_M) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            return INSTR_FENCE;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return INSTR_FENCEI;
        } else {
            return INSTR_UNKNOWN;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_S) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            return INSTR_PRIV;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return INSTR_CSRRW;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x02) {
            return INSTR_CSRRS;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x03) {
            return INSTR_CSRRC;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x05) {
            return INSTR_CSRRWI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x06) {
            return INSTR_CSRRSI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x07) {
            return INSTR_CSRRCI;
        } else {
            return INSTR_UNKNOWN;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_S) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            return INSTR_SB;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return INSTR_SH;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x02) {
            return INSTR_SW;
        } else {
            return INSTR_UNKNOWN;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_B) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            return INSTR_BEQ;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return INSTR_BNE;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x04) {
            return INSTR_BLT;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x05) {
            return INSTR_BGE;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x06) {
            return INSTR_BLTU;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x07) {
            return INSTR_BGEU;
        } else {
            return INSTR_UNKNOWN;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U1) {
        return INSTR_LUI;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U2) {
        return INSTR_AUIPC;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_J) {
        return INSTR_JAL;
    } else {
        return INSTR_UNKNOWN;
    }
}


unsigned int ISA::getRs1Addr(unsigned int encodedInstr) const {
    if (OPCODE_FIELD(encodedInstr) == OPCODE_R ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_I ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_L ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_J ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_S ||
        OPCODE_FIELD(encodedInstr) == OPCODE_S ||
        OPCODE_FIELD(encodedInstr) == OPCODE_B ||
        OPCODE_FIELD(encodedInstr) == OPCODE_AMO) {
        return RS1_FIELD(encodedInstr);
    } else {
        return 0;
    }
}


unsigned int ISA::getRs2Addr(unsigned int encodedInstr) const {
    if (OPCODE_FIELD(encodedInstr) == OPCODE_R ||
        OPCODE_FIELD(encodedInstr) == OPCODE_S ||
        OPCODE_FIELD(encodedInstr) == OPCODE_B  ||
        OPCODE_FIELD(encodedInstr) == OPCODE_AMO) {
        return RS2_FIELD(encodedInstr);
    } else {
        return 0;
    }
}


unsigned int ISA::getRdAddr(unsigned int encodedInstr) const {
    if (OPCODE_FIELD(encodedInstr) == OPCODE_R ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_I ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_L ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_J ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_S ||
        OPCODE_FIELD(encodedInstr) == OPCODE_U1 ||
        OPCODE_FIELD(encodedInstr) == OPCODE_U2 ||
        OPCODE_FIELD(encodedInstr) == OPCODE_J  ||
        OPCODE_FIELD(encodedInstr) == OPCODE_AMO){
        return RD_FIELD(encodedInstr);
    } else {
        return 0;
    }
}


unsigned int ISA::getImmediate(unsigned int encodedInstr) const {
    if (OPCODE_FIELD(encodedInstr) == OPCODE_I_I ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_L ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_M ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_S ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_J) {
        if (SIGN_FIELD(encodedInstr) == 0)
            return POS_IMM_I_FIELD(encodedInstr);
        else
            return NEG_IMM_I_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_S) {
        if (SIGN_FIELD(encodedInstr) == 0)
            return POS_IMM_S_FIELD(encodedInstr);
        else
            return NEG_IMM_S_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_B) {
        if (SIGN_FIELD(encodedInstr) == 0)
            return POS_IMM_B_FIELD(encodedInstr);
        else
            return NEG_IMM_B_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U1 ||
               OPCODE_FIELD(encodedInstr) == OPCODE_U2) {
        return IMM_U_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_J) {
        if (SIGN_FIELD(encodedInstr) == 0)
            return POS_IMM_J_FIELD(encodedInstr);
        else
            return NEG_IMM_J_FIELD(encodedInstr);
    } else {
        return 0;
    }
}


ALUfuncType ISA::getALUfunc(InstrType_Complete instr) const {
    if (instr == INSTR_ADD || instr == INSTR_ADDI ||
        instr == INSTR_LB || instr == INSTR_LH || instr == INSTR_LW || instr == INSTR_LBU || instr == INSTR_LHU ||
        instr == INSTR_SB || instr == INSTR_SH || instr == INSTR_SW ||
        instr == INSTR_AUIPC) {
        return ALU_ADD;
    } else if (instr == INSTR_SUB ||
               instr == INSTR_BEQ || instr == INSTR_BNE) {
        return ALU_SUB;
    } else if (instr == INSTR_SLL || instr == INSTR_SLLI) {
        return ALU_SLL;
    } else if (instr == INSTR_SLT || instr == INSTR_SLTI ||
               instr == INSTR_BLT || instr == INSTR_BGE) {
        return ALU_SLT;
    } else if (instr == INSTR_SLTU || instr == INSTR_SLTUI ||
               instr == INSTR_BLTU || instr == INSTR_BGEU) {
        return ALU_SLTU;
    } else if (instr == INSTR_XOR || instr == INSTR_XORI) {
        return ALU_XOR;
    } else if (instr == INSTR_SRL || instr == INSTR_SRLI) {
        return ALU_SRL;
    } else if (instr == INSTR_SRA || instr == INSTR_SRAI) {
        return ALU_SRA;
    } else if (instr == INSTR_OR || instr == INSTR_ORI) {
        return ALU_OR;
    } else if (instr == INSTR_AND || instr == INSTR_ANDI) {
        return ALU_AND;
    } else if (instr == INSTR_JALR || instr == INSTR_JAL) {
        return ALU_X;
    } else if (instr == INSTR_LUI) {
        return ALU_COPY1;
    } else return ALU_X;
}


ME_MaskType ISA::getMemoryMask(InstrType_Complete instr) const {
    if (instr == INSTR_LW || instr == INSTR_SW) {
        return MT_W;
    } else if (instr == INSTR_LH || instr == INSTR_SH) {
        return MT_H;
    } else if (instr == INSTR_LB || instr == INSTR_SB) {
        return MT_B;
    } else if (instr == INSTR_LHU) {
        return MT_HU;
    } else if (instr == INSTR_LBU) {
        return MT_BU;
    } else return MT_X;
}


unsigned int ISA::readRegfile(unsigned int src, RegfileType regfile) const {
    if (src == 0) {
        return 0;
    } else if (src == 1) {
        return regfile.reg_file_01;
    } else if (src == 2) {
        return regfile.reg_file_02;
    } else if (src == 3) {
        return regfile.reg_file_03;
    } else if (src == 4) {
        return regfile.reg_file_04;
    } else if (src == 5) {
        return regfile.reg_file_05;
    } else if (src == 6) {
        return regfile.reg_file_06;
    } else if (src == 7) {
        return regfile.reg_file_07;
    } else if (src == 8) {
        return regfile.reg_file_08;
    } else if (src == 9) {
        return regfile.reg_file_09;
    } else if (src == 10) {
        return regfile.reg_file_10;
    } else if (src == 11) {
        return regfile.reg_file_11;
    } else if (src == 12) {
        return regfile.reg_file_12;
    } else if (src == 13) {
        return regfile.reg_file_13;
    } else if (src == 14) {
        return regfile.reg_file_14;
    } else if (src == 15) {
        return regfile.reg_file_15;
    } else if (src == 16) {
        return regfile.reg_file_16;
    } else if (src == 17) {
        return regfile.reg_file_17;
    } else if (src == 18) {
        return regfile.reg_file_18;
    } else if (src == 19) {
        return regfile.reg_file_19;
    } else if (src == 20) {
        return regfile.reg_file_20;
    } else if (src == 21) {
        return regfile.reg_file_21;
    } else if (src == 22) {
        return regfile.reg_file_22;
    } else if (src == 23) {
        return regfile.reg_file_23;
    } else if (src == 24) {
        return regfile.reg_file_24;
    } else if (src == 25) {
        return regfile.reg_file_25;
    } else if (src == 26) {
        return regfile.reg_file_26;
    } else if (src == 27) {
        return regfile.reg_file_27;
    } else if (src == 28) {
        return regfile.reg_file_28;
    } else if (src == 29) {
        return regfile.reg_file_29;
    } else if (src == 30) {
        return regfile.reg_file_30;
    } else {
        return regfile.reg_file_31;
    }
}


unsigned int ISA::getALUresult(ALUfuncType aluFunction, unsigned int operand1, unsigned int operand2) const {
    if (aluFunction == ALU_ADD) {
        return operand1 + operand2;
    } else if (aluFunction == ALU_SUB) {
        return operand1 - operand2;
    } else if (aluFunction == ALU_AND) {
        return operand1 & operand2;
    } else if (aluFunction == ALU_OR) {
        return operand1 | operand2;
    } else if (aluFunction == ALU_XOR) {
        return operand1 ^ operand2;
    } else if (aluFunction == ALU_SLT) {
        if (static_cast<int>(operand1) < static_cast<int>(operand2)) {
            return 1;
        } else {
            return 0;
        }
    } else if (aluFunction == ALU_SLTU) {
        if (operand1 < operand2) {
            return 1;
        } else {
            return 0;
        }
    } else if (aluFunction == ALU_SLL) {
        return operand1 << (operand2 & 0x1F);
    } else if (aluFunction == ALU_SRA) {
        return static_cast<unsigned int>(static_cast<int>(operand1) >> static_cast<int>(operand2 & 0x1F));
    } else if (aluFunction == ALU_SRL) {
        return operand1 >> (operand2 & 0x1F);
    } else if (aluFunction == ALU_COPY1) {
        return operand2;
    } else {
        return 0;
    }
}


PrivInstrType ISA::getPrivInstrType(unsigned int encodedInstr) const {
    if(POS_IMM_I_FIELD(encodedInstr) == PRIVCODE_ECALL) {
        return PrivInstrType::INSTR_ECALL;
    } else if (POS_IMM_I_FIELD(encodedInstr) == PRIVCODE_EBREAK) {
        return PrivInstrType::INSTR_EBREAK;
    } else if (POS_IMM_I_FIELD(encodedInstr) == PRIVCODE_URET) {
        return PrivInstrType::INSTR_URET;
    } else if (POS_IMM_I_FIELD(encodedInstr) == PRIVCODE_SRET) {
        return PrivInstrType::INSTR_SRET;
    } else if (POS_IMM_I_FIELD(encodedInstr) == PRIVCODE_MRET) {
        return PrivInstrType::INSTR_MRET;
    } else if (POS_IMM_I_FIELD(encodedInstr) == PRIVCODE_WFI) {
        return PrivInstrType::INSTR_WFI;
    } else if (FUNCT7_FIELD(encodedInstr) == PRIVCODE_SFENCEVMA) {
        return PrivInstrType::INSTR_SFENCEVMA;
    } else {
        return PrivInstrType::INSTR_PRIV_UNKNOWN;
    }
}


unsigned int ISA::getCSR(CSRfileType csrfile, unsigned int encodedInstr) const {


        if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MSTATUS) {
            return csrfile.mstatus & MSTATUS_MASK;
        } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MIE) {
            return csrfile.mie & MIE_MASK;
        } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MTVEC) {
            return csrfile.mtvec;
        } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MEPC) {
            return csrfile.mepc;
        } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MCAUSE) {
            return csrfile.mcause;
        } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MIP) {
            return csrfile.mip & MIP_READ_MASK;
        } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MEDELEG) {
            return csrfile.medeleg;
        } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MIDELEG) {
            return csrfile.mideleg;
        } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MCOUNTEREN) {
            return csrfile.mcounteren;
        } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MTVAL) {
            return csrfile.mtval;
        } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MSCRATCH) {
            return csrfile.mscratch;
        }else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MISA) {
            return csrfile.misa;
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_SSTATUS) {
            return csrfile.mstatus & SSTATUS_MASK;
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_SEDELEG) {
            return csrfile.sedeleg;
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_SIDELEG) {
            return csrfile.sideleg;
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_SIE) {
            return csrfile.mie & SIE_MASK;
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_STVEC) {
            return csrfile.stvec;
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_SCOUNTEREN) {
            return csrfile.scounteren;
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_SSCRATCH) {
            return csrfile.sscratch;
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_SEPC) {
            return csrfile.sepc;
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_SCAUSE) {
            return csrfile.scause;
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_STVAL) {
            return csrfile.stval;
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_SIP) {
            return csrfile.mip & SIP_READ_MASK;
        } else if (POS_IMM_I_FIELD(encodedInstr) == SCSR_SATP) {
            return csrfile.satp; //exception check done elsewhere
        } else if (POS_IMM_I_FIELD(encodedInstr) == UCSR_USTATUS) {
            return csrfile.mstatus & USTATUS_MASK;
        } else if (POS_IMM_I_FIELD(encodedInstr) == UCSR_UIE) {
            return csrfile.mie & UIE_MASK;
        } else if (POS_IMM_I_FIELD(encodedInstr) == UCSR_UTVEC) {
            return csrfile.utvec;
        } else if (POS_IMM_I_FIELD(encodedInstr) == UCSR_UEPC) {
            return csrfile.uepc;
        } else if (POS_IMM_I_FIELD(encodedInstr) == UCSR_USCRATCH) {
            return csrfile.uscratch;
        } else if (POS_IMM_I_FIELD(encodedInstr) == UCSR_UCAUSE) {
            return csrfile.ucause;
        } else if (POS_IMM_I_FIELD(encodedInstr) == UCSR_UTVAL) {
            return csrfile.utval;
        } else if (POS_IMM_I_FIELD(encodedInstr) == UCSR_UIP) {
            return csrfile.mip & UIP_READ_MASK;
        } else if ((POS_IMM_I_FIELD(encodedInstr) == UCSR_CYCLE) || (POS_IMM_I_FIELD(encodedInstr) == MCSR_MCYCLE)) {
            return csrfile.mcyclel;
        } else if ((POS_IMM_I_FIELD(encodedInstr) == UCSR_CYCLE_H) || (POS_IMM_I_FIELD(encodedInstr) == MCSR_MCYCLE_H)) {
            return csrfile.mcycleh;
        } else if ((POS_IMM_I_FIELD(encodedInstr) == UCSR_INSTRET) || (POS_IMM_I_FIELD(encodedInstr) == MCSR_MINSTRET)) {
            return csrfile.minstretl;
        } else if ((POS_IMM_I_FIELD(encodedInstr) == UCSR_INSTRET_H) || (POS_IMM_I_FIELD(encodedInstr) == MCSR_MINSTRET_H)) {
            return csrfile.minstreth;
        } else if ((POS_IMM_I_FIELD(encodedInstr) == UCSR_TIME) || (POS_IMM_I_FIELD(encodedInstr) == MCSR_MTIME)) {
            return csrfile.mtimel;
        } else if ((POS_IMM_I_FIELD(encodedInstr) == UCSR_TIME_H) || (POS_IMM_I_FIELD(encodedInstr) == MCSR_MTIME_H)) {
            return csrfile.mtimeh;
        }
//        else if ((POS_IMM_I_FIELD(encodedInstr) >= HPMCOUNTER_L_3) && //need read access rights
//                   (POS_IMM_I_FIELD(encodedInstr) <= HPMCOUNTER_L_31)) {
//            return 0;
//        } else if ((POS_IMM_I_FIELD(encodedInstr) >= HPMCOUNTER_H_3) && //need read access rights
//                   (POS_IMM_I_FIELD(encodedInstr) <= HPMCOUNTER_H_31)) {
//            return 0;
//        } else if ((POS_IMM_I_FIELD(encodedInstr) >= MHPMCOUNTER_L_3) &&
//                   (POS_IMM_I_FIELD(encodedInstr) <= MHPMCOUNTER_L_31)) {
//            return 0;
//        } else if ((POS_IMM_I_FIELD(encodedInstr) >= MHPMCOUNTER_H_3) &&
//                   (POS_IMM_I_FIELD(encodedInstr) <= MHPMCOUNTER_H_31)) {
//            return 0;
//        } else if ((POS_IMM_I_FIELD(encodedInstr) >= MHPMEVENT_3) && //need read access rights
//                   (POS_IMM_I_FIELD(encodedInstr) <= MHPMEVENT_31)) {
//            return 0;
//        } else if ((POS_IMM_I_FIELD(encodedInstr) >= MCSR_PMPCFG0) && //returns 0 until we know if we need them
//                   (POS_IMM_I_FIELD(encodedInstr) <= MCSR_PMPCFG3)) {
//            return 0;
//        } else if ((POS_IMM_I_FIELD(encodedInstr) >= MCSR_PMPADDR0) && //returns 0 until we know if we need them
//                   (POS_IMM_I_FIELD(encodedInstr) <= MCSR_PMPADDR15)) {
//            return 0;
//        }
        else {
            return 0;
        }

}


unsigned int ISA::getCSRresult(InstrType_Complete instr, unsigned int rs1, unsigned int csr) const {
    if (instr == InstrType_Complete::INSTR_CSRRW || instr == InstrType_Complete::INSTR_CSRRWI) {
        return rs1;
    } else if (instr == InstrType_Complete::INSTR_CSRRS || instr == InstrType_Complete::INSTR_CSRRSI) {
        return csr | rs1;
    } else if (instr == InstrType_Complete::INSTR_CSRRC || instr == InstrType_Complete::INSTR_CSRRCI) {
        return csr & ((-rs1) - 1);
    } else
        return 0;
}






unsigned int ISA::getBranchresult(unsigned int encodedInstr, unsigned int aluResult, unsigned int pcReg) const {
    if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_BEQ && aluResult == 0) {
        return pcReg + getImmediate(encodedInstr);
    } else if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_BNE && aluResult != 0) {
        return pcReg + getImmediate(encodedInstr);
    } else if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_BLT && aluResult == 1) {
        return pcReg + getImmediate(encodedInstr);
    } else if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_BGE && aluResult == 0) {
        return pcReg + getImmediate(encodedInstr);
    } else if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_BLTU && aluResult == 1) {
        return pcReg + getImmediate(encodedInstr);
    } else if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_BGEU && aluResult == 0) {
        return pcReg + getImmediate(encodedInstr);
    } else {
        return pcReg + 4;
    }
}


unsigned int ISA::getALUresult_U(unsigned int encodedInstr, unsigned int pcReg, unsigned int imm) const {
    if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_LUI) {
        return getALUresult(ALU_COPY1, pcReg, imm); //Compute result
    } else { //INSTR_AUIPC
        return getALUresult(ALU_ADD, pcReg, imm); //Compute result
    }
}

#endif //RISCV_ISA_H_
