#include "systemc.h"

#include "PID_Actuator.h"

#include "Server.h"
#include "Temp_detector.h"
#include "Timer.h"
#include "uProcessor.h"
#include "Bus.h"
#include "Buffer.h"
#include "ADC_out.h"
#include "ADC_in.h"


#include "../../WB_bus/ESL/Interconnect.h"
#include "../../WB_bus/ESL/MasterAgent.h"
#include "../../WB_bus/ESL/SlaveAgent.h"
#include "../../WB_bus/ESL/Compound_Bus.h"


using namespace std;

int sc_main(int, char **) {
    /*
    //Server
    Server server("Server");
    //Bus
    Bus bus("Bus");
    //Actuator
    PID_Actuator heat_actuator("heat_pid");
    PID_Actuator mixer_actuator("mixer_pid");
    //Buffer
    Buffer buff0("buff0");
    Buffer buff1("buff1");
    //Temp
    Temp_detector temp_detector_top("Temp_detector_top");
    Temp_detector temp_detector_bot("Temp_detector_bot");
    //Timer
    Timer timer("Timer");
    Timer timer4("Timer4");
    Timer timer5("Timer5");
    //ADC_out in
    ADC_out adc_top("ADC_top");
    ADC_out adc_bot("ADC_bot");
    ADC_in mixer_adc("mixer_adc");
    ADC_in heat_adc("heat_adc");
    //Proc
    uProcessor uP("uP");

    //Server
    RendezVous<bus_req_t> ServerBusReq("ServerBusReq");
    server.bus_out(ServerBusReq);
    bus.master_in(ServerBusReq);

    RendezVous<bus_resp_t> ServerBusResp("ServerBusResp");
    server.bus_in(ServerBusResp);
    bus.master_out(ServerBusResp);

    RendezVous<config_t> ServerFromUP("ServerFromUP");
    server.uP_in(ServerFromUP);
    uP.uP_out(ServerFromUP);

    RendezVous<err_id_t> ServerToUP("ServerToUP");
    server.uP_report_out(ServerToUP);
    uP.uP_report_in(ServerToUP);

    Shared<bool> ServerToHeatPower("ServerToHeatPower");
    server.heat_power(ServerToHeatPower);
    heat_actuator.power(ServerToHeatPower);

    Shared<bool> ServerToMixPower("ServerToMixPower");
    server.mix_power(ServerToMixPower);
    mixer_actuator.power(ServerToMixPower);

    Synch serverToTimer("serverToTimer");
    server.sample_timer(serverToTimer);
    timer.timer_dt(serverToTimer);


    //Bus
    //Slave 0
    RendezVous<bus_req_t> BusToSlave0Req("BusToSlave0Req");
    bus.slave_out0(BusToSlave0Req);
    heat_actuator.bus_req(BusToSlave0Req);

    RendezVous<bus_resp_t> BusToSlave0Resp("BusToSlave0Resp");
    bus.slave_in0(BusToSlave0Resp);
    heat_actuator.bus_resp(BusToSlave0Resp);
    //Slave 1
    RendezVous<bus_req_t> BusToSlave1Req("BusToSlave1Req");
    bus.slave_out1(BusToSlave1Req);
    mixer_actuator.bus_req(BusToSlave1Req);

    RendezVous<bus_resp_t> BusToSlave1Resp("BusToSlave1Resp");
    bus.slave_in1(BusToSlave1Resp);
    mixer_actuator.bus_resp(BusToSlave1Resp);

    //Slave 2
    RendezVous<bus_req_t> BusToSlave2Req("BusToSlave2Req");
    bus.slave_out2(BusToSlave2Req);
    buff1.bus_req(BusToSlave2Req);

    RendezVous<bus_resp_t> BusToSlave2Resp("BusToSlave2Resp");
    bus.slave_in2(BusToSlave2Resp);
    buff1.bus_resp(BusToSlave2Resp);

    RendezVous<bus_req_t> BusToSlave3Req("BusToSlave3Req");
    bus.slave_out3(BusToSlave3Req);
    buff0.bus_req(BusToSlave3Req);

    RendezVous<bus_resp_t> BusToSlave3Resp("BusToSlave3Resp");
    bus.slave_in3(BusToSlave3Resp);
    buff0.bus_resp(BusToSlave3Resp);

    //Buffer
    Shared<int> BufferToDetector1("BufferToDetector1");
    buff0.value_in(BufferToDetector1);
    temp_detector_top.temp_out(BufferToDetector1);
    
    Shared<int> BufferToDetector2("BufferToDetector2");
    buff1.value_in(BufferToDetector2);
    temp_detector_bot.temp_out(BufferToDetector2);

    //Temp Top
    Synch TimerEvent5("TimerEvent5");
    temp_detector_top.sample_event(TimerEvent5);
    timer5.timer_dt(TimerEvent5);

    Shared<int> ADC_IN_BOT("ADC_IN_BOT");
    temp_detector_bot.adc_in(ADC_IN_BOT);
    adc_bot.adc_val(ADC_IN_BOT);

    //Temp bot
    Synch TimerEvent4("TimerEvent4");
    temp_detector_bot.sample_event(TimerEvent4);
    timer4.timer_dt(TimerEvent4);

    Shared<int> ADC_IN_TOP("ADC_IN_TOP");
    temp_detector_top.adc_in(ADC_IN_TOP);
    adc_top.adc_val(ADC_IN_TOP);

    //Mixer
    Shared<int> Mixer_out("Mixer_out");
    mixer_actuator.dac(Mixer_out);
    mixer_adc.adc_val(Mixer_out);

    //Heat
    Shared<int> Heat_out("Heat_out");
    heat_actuator.dac(Heat_out);
    heat_adc.adc_val(Heat_out);
    */
    //Server
    Server server("Server");
    //Bus
    MasterAgent masterAgent("master_agent");
    Interconnect interconnect("intercon");
    SlaveAgent slaveAgent0("slaveAgent0");
    SlaveAgent slaveAgent1("slaveAgent1");
    SlaveAgent slaveAgent2("slaveAgent2");
    SlaveAgent slaveAgent3("slaveAgent3");

    //Actuator
    PID_Actuator heat_actuator("heat_pid");
    PID_Actuator mixer_actuator("mixer_pid");
    //Buffer
    Buffer buff0("buff0");
    Buffer buff1("buff1");
    //Temp
    Temp_detector temp_detector_top("Temp_detector_top");
    Temp_detector temp_detector_bot("Temp_detector_bot");
    //Timer
    Timer timer("Timer");
    Timer timer4("Timer4");
    Timer timer5("Timer5");
    //ADC_out in
    ADC_out adc_top("ADC_top");
    ADC_out adc_bot("ADC_bot");
    ADC_in mixer_adc("mixer_adc");
    ADC_in heat_adc("heat_adc");
    //Proc
    uProcessor uP("uP");

    //Server
    Blocking<bus_req_t> ServerBusReq("ServerBusReq");
    server.bus_out(ServerBusReq);
    masterAgent.master_to_agent(ServerBusReq);

    Blocking<bus_resp_t> ServerBusResp("ServerBusResp");
    server.bus_in(ServerBusResp);
    masterAgent.agent_to_master(ServerBusResp);

    Blocking<config_t> ServerFromUP("ServerFromUP");
    server.uP_in(ServerFromUP);
    uP.uP_out(ServerFromUP);

    Blocking<err_id_t> ServerToUP("ServerToUP");
    server.uP_report_out(ServerToUP);
    uP.uP_report_in(ServerToUP);

    Shared<bool> ServerToHeatPower("ServerToHeatPower");
    server.heat_power(ServerToHeatPower);
    heat_actuator.power(ServerToHeatPower);

    Shared<bool> ServerToMixPower("ServerToMixPower");
    server.mix_power(ServerToMixPower);
    mixer_actuator.power(ServerToMixPower);

    Blocking<bool> serverToTimer("serverToTimer");
    server.sample_timer(serverToTimer);
    timer.timer_dt(serverToTimer);


    //Bus
    Shared<master_signals> masterAgentToBus("masterAgentToBus");
    masterAgent.agent_to_bus(masterAgentToBus);
    interconnect.master_in(masterAgentToBus);
    Shared<slave_signals> busToMasterAgent("busToMasterAgent");
    masterAgent.bus_to_agent(busToMasterAgent);
    interconnect.master_out(busToMasterAgent);

    Shared<master_signals> InterConnToSlaveAgent0("InterConnToSlaveAgent0");
    interconnect.slave_out0(InterConnToSlaveAgent0);
    slaveAgent0.bus_to_agent(InterConnToSlaveAgent0);
    Shared<master_signals> InterConnToSlaveAgent1("InterConnToSlaveAgent1");
    interconnect.slave_out1(InterConnToSlaveAgent1);
    slaveAgent1.bus_to_agent(InterConnToSlaveAgent1);
    Shared<master_signals> InterConnToSlaveAgent2("InterConnToSlaveAgent2");
    interconnect.slave_out2(InterConnToSlaveAgent2);
    slaveAgent2.bus_to_agent(InterConnToSlaveAgent2);
    Shared<master_signals> InterConnToSlaveAgent3("InterConnToSlaveAgent3");
    interconnect.slave_out3(InterConnToSlaveAgent3);
    slaveAgent3.bus_to_agent(InterConnToSlaveAgent3);


    Shared<slave_signals> SlaveAgentTOInterconn0("SlaveAgentTOInterconn0");
    interconnect.slave_in0(SlaveAgentTOInterconn0);
    slaveAgent0.agent_to_bus(SlaveAgentTOInterconn0);
    Shared<slave_signals> SlaveAgentTOInterconn1("SlaveAgentTOInterconn1");
    interconnect.slave_in1(SlaveAgentTOInterconn1);
    slaveAgent1.agent_to_bus(SlaveAgentTOInterconn1);
    Shared<slave_signals> SlaveAgentTOInterconn2("SlaveAgentTOInterconn2");
    interconnect.slave_in2(SlaveAgentTOInterconn2);
    slaveAgent2.agent_to_bus(SlaveAgentTOInterconn2);
    Shared<slave_signals> SlaveAgentTOInterconn3("SlaveAgentTOInterconn3");
    interconnect.slave_in3(SlaveAgentTOInterconn3);
    slaveAgent3.agent_to_bus(SlaveAgentTOInterconn3);


    //Slave 0
    Blocking<bus_req_t> BusToSlave0Req("BusToSlave0Req");
    slaveAgent0.agent_to_slave(BusToSlave0Req);
    heat_actuator.bus_req(BusToSlave0Req);

    Blocking<bus_resp_t> BusToSlave0Resp("BusToSlave0Resp");
    slaveAgent0.slave_to_agent(BusToSlave0Resp);
    heat_actuator.bus_resp(BusToSlave0Resp);
    //Slave 1
    Blocking<bus_req_t> BusToSlave1Req("BusToSlave1Req");
    slaveAgent1.agent_to_slave(BusToSlave1Req);
    mixer_actuator.bus_req(BusToSlave1Req);

    Blocking<bus_resp_t> BusToSlave1Resp("BusToSlave1Resp");
    slaveAgent1.slave_to_agent(BusToSlave1Resp);
    mixer_actuator.bus_resp(BusToSlave1Resp);

    //Slave 2
    Blocking<bus_req_t> BusToSlave2Req("BusToSlave2Req");
    slaveAgent2.agent_to_slave(BusToSlave2Req);
    buff1.bus_req(BusToSlave2Req);

    Blocking<bus_resp_t> BusToSlave2Resp("BusToSlave2Resp");
    slaveAgent2.slave_to_agent(BusToSlave2Resp);
    buff1.bus_resp(BusToSlave2Resp);

    Blocking<bus_req_t> BusToSlave3Req("BusToSlave3Req");
    slaveAgent3.agent_to_slave(BusToSlave3Req);
    buff0.bus_req(BusToSlave3Req);

    Blocking<bus_resp_t> BusToSlave3Resp("BusToSlave3Resp");
    slaveAgent3.slave_to_agent(BusToSlave3Resp);
    buff0.bus_resp(BusToSlave3Resp);

    //Buffer
    Shared<int> BufferToDetector1("BufferToDetector1");
    buff0.value_in(BufferToDetector1);
    temp_detector_top.temp_out(BufferToDetector1);

    Shared<int> BufferToDetector2("BufferToDetector2");
    buff1.value_in(BufferToDetector2);
    temp_detector_bot.temp_out(BufferToDetector2);

    //Temp Top
    Blocking<bool> TimerEvent5("TimerEvent5");
    temp_detector_top.sample_event(TimerEvent5);
    timer5.timer_dt(TimerEvent5);

    Shared<int> ADC_IN_BOT("ADC_IN_BOT");
    temp_detector_bot.adc_in(ADC_IN_BOT);
    adc_bot.adc_val(ADC_IN_BOT);

    //Temp bot
    Blocking<bool> TimerEvent4("TimerEvent4");
    temp_detector_bot.sample_event(TimerEvent4);
    timer4.timer_dt(TimerEvent4);

    Shared<int> ADC_IN_TOP("ADC_IN_TOP");
    temp_detector_top.adc_in(ADC_IN_TOP);
    adc_top.adc_val(ADC_IN_TOP);

    //Mixer
    Shared<int> Mixer_out("Mixer_out");
    mixer_actuator.dac(Mixer_out);
    mixer_adc.adc_val(Mixer_out);

    //Heat
    Shared<int> Heat_out("Heat_out");
    heat_actuator.dac(Heat_out);
    heat_adc.adc_val(Heat_out);
    sc_start();

    //std::cout << sc_delta_count() << std::endl;
    return 0;
}

