#ifndef UART_TRANSMITTER_H
#define UART_TRANSMITTER_H

#include "systemc.h"
#include "Interfaces/Interfaces.h"
#include "compound.h"

class Transmitter : public sc_module {
public:

    enum Sections {IDLE_0, DATA_1, STOP_2};

    Sections CSection, NSection;

    SC_HAS_PROCESS(Transmitter);
    //VISUAL REGISTERS
    uart_transaction itx_regs;
    unsigned int itx_payload;
    // INPUT PORTS
    master_in<uart_transaction> tx_regs;
    // OUTPUT PORTS
    master_out<bool> tx_ready;
    blocking_out<unsigned int> tx_pin;

    Transmitter(sc_module_name name) :
        tx_regs("TX_REGS"),
        tx_ready("TX_READY"),
        tx_pin("TX_PIN"),
        //INTERNAL
        itx_payload(0),
        CSection(Sections::IDLE_0),
        NSection(Sections::IDLE_0)
    {
      SC_THREAD(fsm);
    }

    void fsm();
    unsigned int get_Payload() const;
    unsigned int get_DataMask() const;
    unsigned int get_ParityReg() const;
    unsigned int get_ParityBit() const;
};


unsigned int Transmitter::get_ParityReg() const
{
  if((itx_regs.ctrl_reg & TX_WLS) == 0)
    return
      ( ((itx_regs.data_reg >> 4) & 1) ^
        ((itx_regs.data_reg >> 3) & 1) ^
        ((itx_regs.data_reg >> 2) & 1) ^
        ((itx_regs.data_reg >> 1) & 1) ^
        ((itx_regs.data_reg >> 0) & 1) );

  else if((itx_regs.ctrl_reg & TX_WLS) == 1)
    return
      ( ((itx_regs.data_reg >> 5) & 1) ^
        ((itx_regs.data_reg >> 4) & 1) ^
        ((itx_regs.data_reg >> 3) & 1) ^
        ((itx_regs.data_reg >> 2) & 1) ^
        ((itx_regs.data_reg >> 1) & 1) ^
        ((itx_regs.data_reg >> 0) & 1) );

  else if((itx_regs.ctrl_reg & TX_WLS) == 2)
    return
      ( ((itx_regs.data_reg >> 6) & 1) ^
        ((itx_regs.data_reg >> 5) & 1) ^
        ((itx_regs.data_reg >> 4) & 1) ^
        ((itx_regs.data_reg >> 3) & 1) ^
        ((itx_regs.data_reg >> 2) & 1) ^
        ((itx_regs.data_reg >> 1) & 1) ^
        ((itx_regs.data_reg >> 0) & 1) );

  else if((itx_regs.ctrl_reg & TX_WLS) == 3)
    return
      ( ((itx_regs.data_reg >> 7) & 1) ^
        ((itx_regs.data_reg >> 6) & 1) ^
        ((itx_regs.data_reg >> 5) & 1) ^
        ((itx_regs.data_reg >> 4) & 1) ^
        ((itx_regs.data_reg >> 3) & 1) ^
        ((itx_regs.data_reg >> 2) & 1) ^
        ((itx_regs.data_reg >> 1) & 1) ^
        ((itx_regs.data_reg >> 0) & 1) );

  else
    return 0;
}

unsigned int Transmitter::get_DataMask() const
{
    return ((1 << ((itx_regs.ctrl_reg & TX_WLS) + MINFRAME + 1)) - 1);
}

unsigned int Transmitter::get_ParityBit() const
{
  if((itx_regs.ctrl_reg & TX_PEN) != 0)
  {
    if ((itx_regs.ctrl_reg & TX_SP) != 0)
      return !(itx_regs.ctrl_reg & TX_EPS);
  	else
      return ((itx_regs.ctrl_reg & TX_EPS)?get_ParityReg():!get_ParityReg());
  }
  else
    return 0;
}

unsigned int Transmitter::get_Payload() const
{
  if((itx_regs.ctrl_reg & TX_STB) != 0)
    return (STARTBIT              << STARTBIT_POS)  |
           (itx_regs.data_reg     << DATABITS_POS)  |
           (get_ParityBit()       << PARITYBIT_POS) |
           (STOPBIT               << STOPBIT_1_POS) |
           (STOPBIT               << STOPBIT_2_POS) ;
  else
    return (STARTBIT              << STARTBIT_POS)  |
           (itx_regs.data_reg     << DATABITS_POS)  |
           (get_ParityBit()       << PARITYBIT_POS) |
           (STOPBIT               << STOPBIT_1_POS) ;

}
void Transmitter::fsm(){
    while(1) {

        //std::cout << "On Transmitter - State is:" << CSection << endl;

        if(CSection == Sections::IDLE_0)
        {
          tx_regs->master_read(itx_regs);
          if((itx_regs.ctrl_reg & TX_START) != 0)
          {
            itx_payload = get_Payload();
            NSection = Sections::DATA_1;
          }
        }
        else if(CSection == Sections::DATA_1)
        {
           tx_pin->write(itx_payload);
           NSection = Sections::STOP_2;
           //std::cout << "tx_payload is:" << itx_payload << endl;
           //std::cout << "tx_data is:" << itx_regs.data_reg << endl;
        }
        else if(CSection == Sections::STOP_2){
           tx_ready->master_write(true);
           NSection = Sections::IDLE_0;
        }
        CSection = NSection;
        //wait(SC_ZERO_TIME//);
    }
}

#endif //UART_TRANSMITTER_H

/*
class Transmitter : public sc_module {
public:

    enum Sections {IDLE_0, DATA_1, STOP_2};

    Sections CSection, NSection;

    SC_HAS_PROCESS(Transmitter);
    //VISUAL REGISTERS
    bool iFinished_reg;
    bool iTx2_reg;
    bool iSout_reg;
    bool iLast_reg;
    bool iFinal_reg;
    bool iInit_reg;
    bool iParitytx_reg;
    unsigned int iCount_reg;
    unsigned int iDout_reg;
    //INTERNAL SIGNALS

    //VARIABLES
    bool itx_pin;
    unsigned int itx_ctrlreg;
    bool ibaud_rate;
    unsigned int itx_data;
    // INPUT PORTS
    master_in<unsigned int> TX_CTRLREG;
    master_in<bool> TX_BAUDRATE;
    master_in<unsigned int> TX_DATA;
    // OUTPUT PORTS
    master_out<bool> TX_READY;
    shared_out<bool> TX_PIN;

    Transmitter(sc_module_name name) :
          TX_CTRLREG("TX_CTRLREG"),
          TX_BAUDRATE("TX_BAUDRATE"),
          TX_DATA("TX_DATA"),
          TX_READY("TX_READY"),
          TX_PIN("TX_PIN"),
        //INTERNAL
        iFinished_reg(false),
        iTx2_reg(false),
        iSout_reg(true),
        iLast_reg(false),
        iFinal_reg(false),
        iInit_reg(true),
        iParitytx_reg(false),
        iCount_reg(0),
        itx_pin(false),
        //ibaud_rate(false),
        itx_data(0),
        CSection(Sections::IDLE_0),
        NSection(Sections::IDLE_0)
    {
      SC_THREAD(fsm);
    }

    void fsm();
    bool HalfStopBit();
    bool iParity_reg();
    bool iParityBit();
    unsigned int DataSize();
};

bool  Transmitter::HalfStopBit()
{
  return ((itx_ctrlreg & TXSTB) && !(itx_ctrlreg & TXWLS) && iFinal_reg);
}

bool Transmitter::iParity_reg()
{
  switch (itx_ctrlreg & TXWLS)
  {
    case 0:
      {
      return
        ( ((iDout_reg >> 4) & 1) ^
          ((iDout_reg >> 3) & 1) ^
          ((iDout_reg >> 2) & 1) ^
          ((iDout_reg >> 1) & 1) ^
          ((iDout_reg >> 0) & 1) );
      }
    case 1:
      {
      return
            ( ((iDout_reg >> 5) & 1) ^
          ((iDout_reg >> 4) & 1) ^
          ((iDout_reg >> 3) & 1) ^
          ((iDout_reg >> 2) & 1) ^
          ((iDout_reg >> 1) & 1) ^
          ((iDout_reg >> 0) & 1) );
      }
    case 2:
      {
      return
            ( ((iDout_reg >> 6) & 1) ^
          ((iDout_reg >> 5) & 1) ^
          ((iDout_reg >> 4) & 1) ^
          ((iDout_reg >> 3) & 1) ^
          ((iDout_reg >> 2) & 1) ^
          ((iDout_reg >> 1) & 1) ^
          ((iDout_reg >> 0) & 1) );
      }
    case 3:
      {
      return
            ( ((iDout_reg >> 7) & 1) ^
          ((iDout_reg >> 6) & 1) ^
          ((iDout_reg >> 5) & 1) ^
          ((iDout_reg >> 4) & 1) ^
          ((iDout_reg >> 3) & 1) ^
          ((iDout_reg >> 2) & 1) ^
          ((iDout_reg >> 1) & 1) ^
          ((iDout_reg >> 0) & 1) );
      }
    default:
      {
        return false;
      }
  }
}

unsigned int Transmitter::DataSize()
{
  switch (itx_ctrlreg & TXWLS) {
    case 0:
            return 5;
            break;
    case 1:
            return 6;
            break;
    case 2:
            return 7;
            break;
    case 3:
            return 8;
            break;
  }
}

bool Transmitter::iParityBit()
{
    if (itx_ctrlreg & TXSP)
        return !(itx_ctrlreg & TXEPS);
    else
        return ((itx_ctrlreg & TXEPS)?iParity_reg():!iParity_reg());
}
void Transmitter::fsm(){
    while(1) {

        //Comments
        std::cout << "On Transmitter - State is:" << CSection << endl;
        TX_BAUDRATE->master_read(ibaud_rate);
        if(CSection == Sections::IDLE_0){
          TX_CTRLREG->master_read(itx_ctrlreg);
          TX_DATA->master_read(itx_data);
          if (ibaud_rate)
          {
            if (!iTx2_reg)
            {
              iTx2_reg = true;
              if (itx_ctrlreg & TXSTART)
              {//IDLE_0_DATA_1_TXTXSTART
                std::cout << "case 1" << endl;
                iSout_reg = false;
                iCount_reg = 0;
                iParitytx_reg = false;
                itx_pin = false;
                NSection = Sections::DATA_1;
              }
              else
              {//IDLE_0_IDLE_0_1STTXCLK
                std::cout << "case 2" << endl;
                iTx2_reg = true;
                iSout_reg = true;
                itx_pin = !(itx_ctrlreg & TXBC);
                if(!iInit_reg)
                {
                  iInit_reg = (!iLast_reg || iFinal_reg);
                }
                NSection = Sections::IDLE_0;
              }
              //TX_READY->master_write(false);
            }
            else
            {
              if(!HalfStopBit())
              {//IDLE_0_IDLE_0_2NDTXCLK
                std::cout << "case 3" << endl;
                iTx2_reg = false;
                iSout_reg = true;
                itx_pin = !(itx_ctrlreg & TXBC);
                //TX_READY->master_write(false);
                NSection = Sections::IDLE_0;
              }
              else
              {
                  if (itx_ctrlreg & TXSTART)
                  {//IDLE_0_DATA_1_HALFSTOPBITTXSTART
                std::cout << "case 4" << endl;
                    iSout_reg = false;
                    iCount_reg = 0;
                    iInit_reg	=	false;
                    iFinal_reg = false;
                    iLast_reg	=	true;
                    itx_pin = false;
                    //TX_READY->master_write(false);
                    NSection = Sections::DATA_1;
                  }
                  else
                  {//IDLE_0_IDLE_0_HALFSTOPBITNOTXSTART
                std::cout << "case 5" << endl;
                    iSout_reg = true;
                    iInit_reg	=	iFinal_reg;
                    itx_pin = !(itx_ctrlreg & TXBC);
                    //TX_READY->master_write(false);
                    NSection = Sections::IDLE_0;
                  }
              }
            }
          }
          else
          {//IDLE_0_IDLE_0_NOTXCLK
            std::cout << "case 6" << endl;
            iSout_reg = true;
            iLast_reg = (iFinal_reg || iInit_reg);
            itx_pin = !(itx_ctrlreg & TXBC);
            //TX_READY->master_write(((!iInit_reg && !iFinal_reg)?iLast_reg:false));
            NSection = Sections::IDLE_0;
          }
        }
        else if(CSection == Sections::DATA_1){
          TX_READY->master_write(false);
          if (ibaud_rate)
          {
            if (iTx2_reg)
            {//DATA_1_DATA_1_1STTXCLK
              iTx2_reg =  false;
              itx_pin = ((!(itx_ctrlreg & TXBC))?iSout_reg : false);
              NSection = Sections::DATA_1;
            }
            else
            {
              iTx2_reg =	true;
              if(iCount_reg < DataSize())
              {//DATA_1_DATA_1_NEXTBIT
                iSout_reg	=	(itx_data & (1 << iCount_reg)) >> iCount_reg;
                iCount_reg = iCount_reg + 1;
                iParitytx_reg	=	false;
                itx_pin = ((!(itx_ctrlreg & TXBC))?iSout_reg : false);
                NSection = Sections::DATA_1;
              }
              else if(iCount_reg = DataSize())
              {
                if (!(itx_ctrlreg & TXPEN))
                {
                  iSout_reg	=	true;
                  itx_pin = !(itx_ctrlreg & TXBC);
                  if ((itx_ctrlreg & TXSTB))
                  {//DATA_1_STOP_2_ENDNOPAR
                    NSection = Sections::STOP_2;
                  }
                  else
                  {//DATA_1_IDLE_0_ENDNOPAR
                    iLast_reg	=	true;
                    iFinal_reg = false;
                    iInit_reg	=	false;
                    NSection = Sections::DATA_1;
                  }
                }
                else
                {
                  if(!iParitytx_reg)
                  {//DATA_1_DATA_1_PAR
                    iSout_reg	=	iParityBit();
                    iParitytx_reg = true;
                    itx_pin = ((!(itx_ctrlreg & TXBC))?iSout_reg : false);
                    NSection = Sections::DATA_1;
                  }
                  else
                  {
                    iSout_reg	=	true;
                    iLast_reg	=	true;
                    itx_pin = !(itx_ctrlreg & TXBC);
                    if(itx_ctrlreg & TXSTB)
                    {//DATA_1_STOP_2_ENDPAR
                      NSection = Sections::STOP_2;
                    }
                    else
                    {//DATA_1_IDLE_0_ENDPAR
                      iFinal_reg = false;
                      iInit_reg = false;
                      NSection = Sections::IDLE_0;
                    }
                  }
                }
              }
            }
          }
          else
          {//DATA_1_DATA_1_NOTXCLK
            itx_pin = ((!(itx_ctrlreg & TXBC))?iSout_reg : false);
            NSection = Sections::DATA_1;
          }
        }else if(CSection == Sections::STOP_2){
          if(ibaud_rate)
          {
            if(iTx2_reg)
            {//STOP_2_STOP_2_1STTXCLK
              iTx2_reg = false;
              iSout_reg = true;
              iFinal_reg = false;
              iLast_reg = false;
              itx_pin = !(itx_ctrlreg & TXBC);
              TX_READY->master_write(false);
              NSection = Sections::STOP_2;
            }
            else
            {//STOP_2_IDLE_0_FINAL
                iTx2_reg = true;
                iSout_reg = true;
                iFinal_reg = true;
                iLast_reg = false;
                iInit_reg = false;
                itx_pin = !(itx_ctrlreg & TXBC);
                TX_READY->master_write(false);
                NSection = Sections::IDLE_0;
            }
          }
          else
          {//STOP_2_STOP_2_NOTXCLK
            iSout_reg = true;
            iFinal_reg = false;
            itx_pin = !(itx_ctrlreg & TXBC);
            TX_READY->master_write(iLast_reg);
            NSection = Sections::STOP_2;
          }
        }
        //TX_PIN->set(itx_pin);
        CSection = NSection;

        wait(SC_ZERO_TIME);
    }
}

#endif //UART_TRANSMITTER_H

*/
