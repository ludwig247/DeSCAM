#include "systemc.h"

#include "PID_Actuator.h"

#include "Server.h"
#include "Temp_detector.h"
#include "Timer.h"
#include "uProcessor.h"

using namespace std;

int sc_main(int, char **) {
    //Server
    Server server("Server");
    //Actuator
    PID_Actuator heat_actuator("heat_pid");
    PID_Actuator mixer_actuator("mixer_pid");
    //Temp
    Temp_detector temp_detector_top("Temp_detector_top");
    Temp_detector temp_detector_bot("Temp_detector_bot");
    //Timer
    Timer timer("Timer");
    Timer timer2("Timer2");
    Timer timer3("Timer3");
    //Proc
    uProcessor uP("uP");

    Blocking<act_t> serverToHeat("ServerToHeat");
    server.heat_out(serverToHeat);
    heat_actuator.bus_in(serverToHeat);

    Blocking<act_t> serverToMixer("ServerToMixer");
    server.mix_out(serverToMixer);
    mixer_actuator.bus_in(serverToMixer);


    Blocking<sensor_t> serverToTempTop("serverToTempTop");
    server.temp_top_in(serverToTempTop);
    temp_detector_top.temp_out(serverToTempTop);

    Blocking<sensor_t> serverToTempBot("serverToTempBot");
    server.temp_bot_in(serverToTempBot);
    temp_detector_bot.temp_out(serverToTempBot);


    Blocking<bool> serverToTimer("serverToTimer");
    server.timer_dt(serverToTimer);
    timer.timer_dt(serverToTimer);

    Blocking<bool> temp_top_ToTimer2("serverToTimer2");
    temp_detector_top.sample_event(temp_top_ToTimer2);
    timer2.timer_dt(temp_top_ToTimer2);

    Blocking<bool> temp_bot_ToTimer3("serverToTimer3");
    temp_detector_bot.sample_event(temp_bot_ToTimer3);
    timer3.timer_dt(temp_bot_ToTimer3);

    Blocking<bool> heatBusResp("heatBusResp");
    server.heat_resp(heatBusResp);
    heat_actuator.bus_resp(heatBusResp);

    Blocking<bool> mixBusResp("mixBusResp");
    server.mix_resp(mixBusResp);
    mixer_actuator.bus_resp(mixBusResp);

    Shared<config_t> config("config");
    uP.uP_out(config);
    server.uP_in(config);



    Shared<err_id_t> errReport("errReport");
    server.uP_report_out(errReport);
    uP.uP_report_in(errReport);

    sc_start();
    std::cout << sc_delta_count() << std::endl;
    return 0;
}

