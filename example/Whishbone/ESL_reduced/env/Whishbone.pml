///////////////////////////////////////////////
//// Datatype definitions
///////////////////////////////////////////////
//States
mtype {run0,run1,run2,run3,run4,run5,run6,run7,run8,run9};
//Enum Type: ack_t
mtype:ack_t = {ERR, OK, RTY};
//Enum Type: addr_t
mtype:addr_t = {SLAVE0, SLAVE1, SLAVE2, SLAVE3};
//Enum Type: trans_t
//mtype:trans_t = {SINGLE_READ, SINGLE_WRITE};
//Compound Type: bus_req_t
typedef bus_req_t{
	mtype:addr_t addr;
	bool data;
	bit trans_type; //0 for read, 1 for write 
};
//Compound Type: bus_resp_t
typedef bus_resp_t{
	mtype:ack_t ack;
	bool data;
};
//Compound Type: master_signals
typedef master_signals{
	mtype:addr_t addr;
	bool cyc;
	bool data;
	bool stb;
	bool we;
};
//Compound Type: slave_signals
typedef slave_signals{
	bool ack;
	bool data;
	bool err;
};
///////////////////////////////////////////////
//// Communication channels & global variables
///////////////////////////////////////////////
master_signals InterConnToSlaveAgent0;
master_signals InterConnToSlaveAgent1;
master_signals InterConnToSlaveAgent2;
master_signals InterConnToSlaveAgent3;
slave_signals SlaveAgentTOInterconn0;
slave_signals SlaveAgentTOInterconn1;
slave_signals SlaveAgentTOInterconn2;
slave_signals SlaveAgentTOInterconn3;
slave_signals busToMasterAgent;
master_signals masterAgentToBus;

chan BusRun0 = [1] of {bus_req_t};
chan BusRun1 = [1] of {bus_req_t};
chan BusRun2 = [1] of {bus_resp_t};
chan BusRun3 = [1] of {bus_resp_t};
chan BusRun4 = [1] of {bus_req_t};
chan BusRun5 = [1] of {bus_resp_t};
chan BusRun6 = [1] of {bus_req_t};
chan BusRun7 = [1] of {bus_resp_t};
chan BusRun8 = [1] of {bus_req_t};
chan BusRun9 = [1] of {bus_resp_t};


bool state0 = false;
bool state1 = false;
bool state2 = false;
bool state3 = false;
bool state4 = false;
bool state5 = false;
bool state6 = false;
bool state7 = false;
bool state8 = false;
bool state9 = false;

#define no_state (!state0 && !state1 && !state2 && !state3 && !state4 && !state5 && !state6 && !state7 && !state8 && !state9)
#define any_state (state0 || state1 || state2 || state3 || state4 || state5 || state6 || state7 || state8 || state9)


///////////////////////////////////////////////
//// Module:Interconnect
///////////////////////////////////////////////

///////////////////////////////////////////////
//// Instance:interconnect Module:Interconnect
///////////////////////////////////////////////

active proctype interconnect_Interconnect(){
mtype Interconnect_state = run0;
mtype:addr_t from_master_addr;
bool from_master_cyc;
bool from_master_data;
bool from_master_stb;
bool from_master_we;
byte slave_number;
bool to_master_ack;
bool to_master_data;
bool to_master_err;



 end:	 do
		:: Interconnect_state ==  run2 ->
			//Communication 
        
			//Dpath operations 
			d_step{
			if 
  			:: !((!(masterAgentToBus.cyc)  &&  !(masterAgentToBus.stb))) -> 
				from_master_addr = masterAgentToBus.addr;
				from_master_cyc = masterAgentToBus.cyc;
				from_master_data = masterAgentToBus.data;
				from_master_stb = masterAgentToBus.stb;
				from_master_we = masterAgentToBus.we;
				busToMasterAgent.ack = to_master_ack;
				busToMasterAgent.data = to_master_data;
				busToMasterAgent.err = to_master_err;
				Interconnect_state = run2;
			:: !(masterAgentToBus.cyc) && !(masterAgentToBus.stb) -> 
				from_master_addr = masterAgentToBus.addr;
				from_master_cyc = masterAgentToBus.cyc;
				from_master_data = masterAgentToBus.data;
				from_master_stb = masterAgentToBus.stb;
				from_master_we = masterAgentToBus.we;
				busToMasterAgent.ack = false;
				busToMasterAgent.data = false;
				busToMasterAgent.err = false;
				to_master_ack = false;
				to_master_data = false;
				to_master_err = false;
				Interconnect_state = run0;
			fi;
			};
		:: Interconnect_state ==  run0 ->
			//Communication 
   
			//Dpath operations 
			d_step{
			if 
  			:: !((masterAgentToBus.cyc  &&  masterAgentToBus.stb)) ->
				from_master_addr = masterAgentToBus.addr;
				from_master_cyc = masterAgentToBus.cyc;
				from_master_data = masterAgentToBus.data;
				from_master_stb = masterAgentToBus.stb;
				from_master_we = masterAgentToBus.we;
				Interconnect_state = run0;
			:: masterAgentToBus.cyc && masterAgentToBus.stb && (masterAgentToBus.addr == SLAVE0) -> 
				from_master_addr = SLAVE0;
				from_master_cyc = false;
				from_master_data = false;
				from_master_stb = false;
				from_master_we = false;
				slave_number = 0;
				InterConnToSlaveAgent0.addr = masterAgentToBus.addr;
				InterConnToSlaveAgent0.cyc = masterAgentToBus.cyc;
				InterConnToSlaveAgent0.data = masterAgentToBus.data;
				InterConnToSlaveAgent0.stb = masterAgentToBus.stb;
				InterConnToSlaveAgent0.we = masterAgentToBus.we;
				Interconnect_state = run1;
			:: masterAgentToBus.cyc && masterAgentToBus.stb && (masterAgentToBus.addr == SLAVE1) -> 
				from_master_addr = SLAVE0;
				from_master_cyc = false;
				from_master_data = false;
				from_master_stb = false;
				from_master_we = false;
				slave_number = 1;
				InterConnToSlaveAgent1.addr = masterAgentToBus.addr;
				InterConnToSlaveAgent1.cyc = masterAgentToBus.cyc;
				InterConnToSlaveAgent1.data = masterAgentToBus.data;
				InterConnToSlaveAgent1.stb = masterAgentToBus.stb;
				InterConnToSlaveAgent1.we = masterAgentToBus.we;
				Interconnect_state = run1;
			:: masterAgentToBus.cyc && masterAgentToBus.stb && (masterAgentToBus.addr == SLAVE2) -> 
				from_master_addr = SLAVE0;
				from_master_cyc = false;
				from_master_data = false;
				from_master_stb = false;
				from_master_we = false;
				slave_number = 2;
				InterConnToSlaveAgent2.addr = masterAgentToBus.addr;
				InterConnToSlaveAgent2.cyc = masterAgentToBus.cyc;
				InterConnToSlaveAgent2.data = masterAgentToBus.data;
				InterConnToSlaveAgent2.stb = masterAgentToBus.stb;
				InterConnToSlaveAgent2.we = masterAgentToBus.we;
				Interconnect_state = run1;
			:: masterAgentToBus.cyc && masterAgentToBus.stb && (masterAgentToBus.addr == SLAVE3) -> 
				from_master_addr = SLAVE0;
				from_master_cyc = false;
				from_master_data = false;
				from_master_stb = false;
				from_master_we = false;
				slave_number = 3;
				InterConnToSlaveAgent3.addr = masterAgentToBus.addr;
				InterConnToSlaveAgent3.cyc = masterAgentToBus.cyc;
				InterConnToSlaveAgent3.data = masterAgentToBus.data;
				InterConnToSlaveAgent3.stb = masterAgentToBus.stb;
				InterConnToSlaveAgent3.we = masterAgentToBus.we;
				Interconnect_state = run1;
			fi;
			};
		:: Interconnect_state ==  run1 ->
			//Communication 

			//Dpath operations 
			d_step{
			if 
  			:: SlaveAgentTOInterconn0.ack && (slave_number == 0) -> 
				busToMasterAgent.ack = SlaveAgentTOInterconn0.ack;
				busToMasterAgent.data = SlaveAgentTOInterconn0.data;
				busToMasterAgent.err = SlaveAgentTOInterconn0.err;
				slave_number = 0;
				InterConnToSlaveAgent0.addr = from_master_addr;
				InterConnToSlaveAgent0.cyc = from_master_cyc;
				InterConnToSlaveAgent0.data = from_master_data;
				InterConnToSlaveAgent0.stb = from_master_stb;
				InterConnToSlaveAgent0.we = from_master_we;
				to_master_ack = SlaveAgentTOInterconn0.ack;
				to_master_data = SlaveAgentTOInterconn0.data;
				to_master_err = SlaveAgentTOInterconn0.err;
				Interconnect_state = run2;
			:: SlaveAgentTOInterconn1.ack && (slave_number == 1) -> 
				busToMasterAgent.ack = SlaveAgentTOInterconn1.ack;
				busToMasterAgent.data = SlaveAgentTOInterconn1.data;
				busToMasterAgent.err = SlaveAgentTOInterconn1.err;
				slave_number = 1;
				InterConnToSlaveAgent1.addr = from_master_addr;
				InterConnToSlaveAgent1.cyc = from_master_cyc;
				InterConnToSlaveAgent1.data = from_master_data;
				InterConnToSlaveAgent1.stb = from_master_stb;
				InterConnToSlaveAgent1.we = from_master_we;
				to_master_ack = SlaveAgentTOInterconn1.ack;
				to_master_data = SlaveAgentTOInterconn1.data;
				to_master_err = SlaveAgentTOInterconn1.err;
				Interconnect_state = run2;
			:: SlaveAgentTOInterconn2.ack && (slave_number == 2) -> 
				busToMasterAgent.ack = SlaveAgentTOInterconn2.ack;
				busToMasterAgent.data = SlaveAgentTOInterconn2.data;
				busToMasterAgent.err = SlaveAgentTOInterconn2.err;
				slave_number = 2;
				InterConnToSlaveAgent2.addr = from_master_addr;
				InterConnToSlaveAgent2.cyc = from_master_cyc;
				InterConnToSlaveAgent2.data = from_master_data;
				InterConnToSlaveAgent2.stb = from_master_stb;
				InterConnToSlaveAgent2.we = from_master_we;
				to_master_ack = SlaveAgentTOInterconn2.ack;
				to_master_data = SlaveAgentTOInterconn2.data;
				to_master_err = SlaveAgentTOInterconn2.err;
				Interconnect_state = run2;
			:: !((slave_number == 0)) && !((slave_number == 1)) && !((slave_number == 2)) && SlaveAgentTOInterconn3.ack -> 
				busToMasterAgent.ack = SlaveAgentTOInterconn3.ack;
				busToMasterAgent.data = SlaveAgentTOInterconn3.data;
				busToMasterAgent.err = SlaveAgentTOInterconn3.err;
				slave_number = 3;
				InterConnToSlaveAgent3.addr = from_master_addr;
				InterConnToSlaveAgent3.cyc = from_master_cyc;
				InterConnToSlaveAgent3.data = from_master_data;
				InterConnToSlaveAgent3.stb = from_master_stb;
				InterConnToSlaveAgent3.we = from_master_we;
				to_master_ack = SlaveAgentTOInterconn3.ack;
				to_master_data = SlaveAgentTOInterconn3.data;
				to_master_err = SlaveAgentTOInterconn3.err;
				Interconnect_state = run2;
			:: !(SlaveAgentTOInterconn0.ack) && (slave_number == 0) -> 
				from_master_addr = SLAVE0;
				from_master_cyc = false;
				from_master_data = false;
				from_master_stb = false;
				from_master_we = false;
				slave_number = 0;
				to_master_ack = SlaveAgentTOInterconn0.ack;
				to_master_data = SlaveAgentTOInterconn0.data;
				to_master_err = SlaveAgentTOInterconn0.err;
				Interconnect_state = run1;
			:: !(SlaveAgentTOInterconn1.ack) && (slave_number == 1) -> 
				from_master_addr = SLAVE0;
				from_master_cyc = false;
				from_master_data = false;
				from_master_stb = false;
				from_master_we = false;
				slave_number = 1;
				to_master_ack = SlaveAgentTOInterconn1.ack;
				to_master_data = SlaveAgentTOInterconn1.data;
				to_master_err = SlaveAgentTOInterconn1.err;
				Interconnect_state = run1;
			:: !(SlaveAgentTOInterconn2.ack) && (slave_number == 2) -> 
				from_master_addr = SLAVE0;
				from_master_cyc = false;
				from_master_data = false;
				from_master_stb = false;
				from_master_we = false;
				slave_number = 2;
				to_master_ack = SlaveAgentTOInterconn2.ack;
				to_master_data = SlaveAgentTOInterconn2.data;
				to_master_err = SlaveAgentTOInterconn2.err;
				Interconnect_state = run1;
			:: !((slave_number == 0)) && !((slave_number == 1)) && !((slave_number == 2)) && !(SlaveAgentTOInterconn3.ack) -> 
				from_master_addr = SLAVE0;
				from_master_cyc = false;
				from_master_data = false;
				from_master_stb = false;
				from_master_we = false;
				slave_number = 3;
				to_master_ack = SlaveAgentTOInterconn3.ack;
				to_master_data = SlaveAgentTOInterconn3.data;
				to_master_err = SlaveAgentTOInterconn3.err;
				Interconnect_state = run1;
			fi;
                    };
	od;
}
 
///////////////////////////////////////////////
//// Module:MasterAgent
///////////////////////////////////////////////

///////////////////////////////////////////////
//// Instance:masterAgent Module:MasterAgent
///////////////////////////////////////////////

active proctype masterAgent_MasterAgent(){
mtype Master_state = run0;
bit agent_to_bus_req_trans_type;
//mtype:ack_t agent_to_bus_resp_ack;
//bool agent_to_bus_resp_data;
bus_req_t master_to_agent_sig;
bus_resp_t agent_to_bus_resp;
agent_to_bus_resp.data = false;

xr BusRun0;
xs BusRun3;

 endm:	 do
		:: Master_state ==  run2 -> //DONE0
			//Communication 
			atomic{
                            state3 = true;
                            BusRun3!agent_to_bus_resp;
                            BusRun3!agent_to_bus_resp;
                            state3 = false;
                         
                        }
			//Dpath operations 
			d_step{
			if 
  			:: busToMasterAgent.ack -> 
				Master_state = run2;
			:: !(busToMasterAgent.ack) -> 
				Master_state = run3;
			fi;
			};
		:: Master_state ==  run3 -> //DONE1
			//Communication 

			//Dpath operations 
			d_step{
			if 
  			:: true -> 
				Master_state = run0;
			fi;
			};
		:: Master_state ==  run0 -> //IDLE2
			//Communication 
			//atomic{
			//if
                        //:: true ->
                        //    master_to_agent_sig.trans_type = 0;
                        //    master_to_agent_sig.addr = SLAVE0;
                        //    master_to_agent_sig.data = true;
                        //:: true ->
                        //    master_to_agent_sig.addr = SLAVE1;
                        //    master_to_agent_sig.data = true;
                        //    master_to_agent_sig.trans_type = 0;
                        //:: true -> 
                        //    master_to_agent_sig.addr = SLAVE2;
                        //    master_to_agent_sig.data = true;
                        //    master_to_agent_sig.trans_type = 0;
                        //:: true ->
                        //    master_to_agent_sig.addr = SLAVE3;
                        //    master_to_agent_sig.data = true;
                        //    master_to_agent_sig.trans_type = 0;
			//fi;
			//};
			atomic{
                            state0 = true;
                            BusRun0?master_to_agent_sig;
                            BusRun0?master_to_agent_sig;
                            state0 = false;
                 
                        };
			//Dpath operations 
			d_step{
			if 
  			:: (master_to_agent_sig.trans_type == 0) -> 
				agent_to_bus_req_trans_type = master_to_agent_sig.trans_type;
				masterAgentToBus.addr = master_to_agent_sig.addr;
				masterAgentToBus.cyc = true;
				masterAgentToBus.data = false;
				masterAgentToBus.stb = true;
				masterAgentToBus.we = false;
				Master_state = run1;
			:: !(master_to_agent_sig.trans_type == 0) -> 
				agent_to_bus_req_trans_type = master_to_agent_sig.trans_type;
				masterAgentToBus.addr = master_to_agent_sig.addr;
				masterAgentToBus.cyc = true;
				masterAgentToBus.data = master_to_agent_sig.data;
				masterAgentToBus.stb = true;
				masterAgentToBus.we = true;
				Master_state = run1;
			fi;
			};
		:: Master_state ==  run1 -> //WAITING3
			//Communication 

			//Dpath operations 
			d_step{
			if 
  			:: busToMasterAgent.ack && !((agent_to_bus_req_trans_type == 0)) && !(busToMasterAgent.err) -> 
				agent_to_bus_resp.ack = OK;
				masterAgentToBus.addr = SLAVE0;
				masterAgentToBus.cyc = false;
				masterAgentToBus.data = false;
				masterAgentToBus.stb = false;
				masterAgentToBus.we = false;
				Master_state = run2;
			:: busToMasterAgent.ack && (agent_to_bus_req_trans_type == 0) && !(busToMasterAgent.err) -> 
				agent_to_bus_resp.ack = OK;
				agent_to_bus_resp.data = busToMasterAgent.data;
				masterAgentToBus.addr = SLAVE0;
				masterAgentToBus.cyc = false;
				masterAgentToBus.data = false;
				masterAgentToBus.stb = false;
				masterAgentToBus.we = false;
				Master_state = run2;
			:: busToMasterAgent.ack && !((agent_to_bus_req_trans_type == 0)) && busToMasterAgent.err -> 
				agent_to_bus_resp.ack = ERR;
				masterAgentToBus.addr = SLAVE0;
				masterAgentToBus.cyc = false;
				masterAgentToBus.data = false;
				masterAgentToBus.stb = false;
				masterAgentToBus.we = false;
				Master_state = run2;
			:: busToMasterAgent.ack && (agent_to_bus_req_trans_type == 0) && busToMasterAgent.err -> 
				agent_to_bus_resp.ack = ERR;
				agent_to_bus_resp.data = busToMasterAgent.data;
				masterAgentToBus.addr = SLAVE0;
				masterAgentToBus.cyc = false;
				masterAgentToBus.data = false;
				masterAgentToBus.stb = false;
				masterAgentToBus.we = false;
				Master_state = run2;
			:: !(busToMasterAgent.ack) -> 
				Master_state = run1;
			fi;
			};
	od;
}
 
 
///////////////////////////////////////////////
//// Module:SlaveAgent
///////////////////////////////////////////////

///////////////////////////////////////////////
//// Instance:slaveAgent0 Module:SlaveAgent
///////////////////////////////////////////////

active proctype slaveAgent0_SlaveAgent(){
mtype Slave0_state = run0;
bus_req_t agent_to_slave_req;
//mtype:addr_t agent_to_slave_req_addr;
//bool agent_to_slave_req_data;
//mtype:trans_t agent_to_slave_req_trans_type;
bus_resp_t slave_to_agent_resp;
//mtype:ack_t slave_to_agent_resp_ack;
//bool slave_to_agent_resp_data;

xs BusRun1;
xr BusRun2;

 ends0:	 do
		:: Slave0_state ==  run5 ->
			//Communication 

			//Dpath operations 
			d_step{
			if 
  			:: !((!(InterConnToSlaveAgent0.cyc)  &&  !(InterConnToSlaveAgent0.stb))) && InterConnToSlaveAgent0.we -> 
				SlaveAgentTOInterconn0.ack = true;
				SlaveAgentTOInterconn0.data = false;
				SlaveAgentTOInterconn0.err = !((slave_to_agent_resp.ack == OK));
				Slave0_state = run5;
			:: !((!(InterConnToSlaveAgent0.cyc)  &&  !(InterConnToSlaveAgent0.stb))) && !(InterConnToSlaveAgent0.we) -> 
				SlaveAgentTOInterconn0.ack = true;
				SlaveAgentTOInterconn0.data = slave_to_agent_resp.data;
				SlaveAgentTOInterconn0.err = !((slave_to_agent_resp.ack == OK));
				Slave0_state = run5;
			:: !(InterConnToSlaveAgent0.cyc) && !(InterConnToSlaveAgent0.stb) -> 
				SlaveAgentTOInterconn0.ack = false;
				SlaveAgentTOInterconn0.data = false;
				SlaveAgentTOInterconn0.err = false;
				Slave0_state = run0;
			fi;
			};
                        
		:: Slave0_state ==  run0 ->
			//Communication 

			//Dpath operations 
			d_step{
			if 
  			:: !((InterConnToSlaveAgent0.cyc  &&  InterConnToSlaveAgent0.stb)) -> 
				Slave0_state = run0;
			:: InterConnToSlaveAgent0.cyc && InterConnToSlaveAgent0.stb && !(InterConnToSlaveAgent0.we) -> 
				agent_to_slave_req.addr = InterConnToSlaveAgent0.addr;
				agent_to_slave_req.data = false;
				agent_to_slave_req.trans_type = 0;
				Slave0_state = run1;
			:: InterConnToSlaveAgent0.cyc && InterConnToSlaveAgent0.stb && InterConnToSlaveAgent0.we -> 
				agent_to_slave_req.addr = InterConnToSlaveAgent0.addr;
				agent_to_slave_req.data = InterConnToSlaveAgent0.data;
				agent_to_slave_req.trans_type = 1;
				Slave0_state = run2;
			fi;
			};
                        
		:: Slave0_state ==  run1 ->
			//Communication 
			//Write to SlaveDummy
			atomic{
                            state1 = true;
                            BusRun1!agent_to_slave_req;
                            BusRun1!agent_to_slave_req;
                            state1 = false;
                    
                        };
			//Dpath operations 
			d_step{
			if 
  			:: true -> 
				Slave0_state = run3;
			fi;
			};
		:: Slave0_state ==  run3 ->
			//Communication 
			//Read from SlaveDummy
			atomic{
                            state2 = true;
                            BusRun2?slave_to_agent_resp;
                            BusRun2?slave_to_agent_resp;
                            state2 = false;
          
                            Slave0_state = run5;
                        };
			//Dpath operations 
			//atomic{
			//if 
                        //    :: slave_to_agent_resp_ack = OK;
                        //        slave_to_agent_resp_data = true;
                        //        Slave0_state = run5;
                        //    :: slave_to_agent_resp_ack = ERR;
			//	slave_to_agent_resp_data = true;
			//	Slave0_state = run5;
			//fi;
			//};
		:: Slave0_state ==  run2 ->
			//Communication 
			atomic{
			//Write to SlaveDummy
                            state1 = true;
                            BusRun1!agent_to_slave_req;
                            BusRun1!agent_to_slave_req;
                            state1 = false;
    
                        };
			//Dpath operations 
			d_step{
			if 
  			:: true -> 
				Slave0_state = run4;
			fi;
			};
		:: Slave0_state ==  run4 ->
			//Communication 
			//Read from SlaveDummy
			atomic{
                            state2 = true;
                            BusRun2?slave_to_agent_resp;
                            BusRun2?slave_to_agent_resp;
                            state2 = false;
      
                            Slave0_state = run5;
                        };
			//Dpath operations 
			//d_step{
			//if 
                        //    :: slave_to_agent_resp_ack = OK;
                        //        slave_to_agent_resp_data = true;
                        //        Slave0_state = run5;
                        //    :: slave_to_agent_resp_ack = ERR;
			//	slave_to_agent_resp_data = true;
			//	Slave0_state = run5;
			//fi;
			//};
	od;
}

///////////////////////////////////////////////
//// Module:SlaveAgent
///////////////////////////////////////////////

///////////////////////////////////////////////
//// Instance:slaveAgent1 Module:SlaveAgent
///////////////////////////////////////////////

active proctype slaveAgent1_SlaveAgent(){
mtype Slave1_state = run0;
bus_req_t agent_to_slave_req;
//mtype:addr_t agent_to_slave_req_addr;
//bool agent_to_slave_req_data;
//mtype:trans_t agent_to_slave_req_trans_type;
bus_resp_t slave_to_agent_resp;
//mtype:ack_t slave_to_agent_resp_ack;
//bool slave_to_agent_resp_data;

xs BusRun4;
xr BusRun5;

 ends1:	 do
		:: Slave1_state ==  run5 ->
			//Communication 

			//Dpath operations 
			d_step{
			if 
  			:: !((!(InterConnToSlaveAgent1.cyc)  &&  !(InterConnToSlaveAgent1.stb))) && InterConnToSlaveAgent1.we -> 
				SlaveAgentTOInterconn1.ack = true;
				SlaveAgentTOInterconn1.data = false;
				SlaveAgentTOInterconn1.err = !((slave_to_agent_resp.ack == OK));
				Slave1_state = run5;
			:: !((!(InterConnToSlaveAgent1.cyc)  &&  !(InterConnToSlaveAgent1.stb))) && !(InterConnToSlaveAgent1.we) -> 
				SlaveAgentTOInterconn1.ack = true;
				SlaveAgentTOInterconn1.data = slave_to_agent_resp.data;
				SlaveAgentTOInterconn1.err = !((slave_to_agent_resp.ack == OK));
				Slave1_state = run5;
			:: !(InterConnToSlaveAgent1.cyc) && !(InterConnToSlaveAgent1.stb) -> 
				SlaveAgentTOInterconn1.ack = false;
				SlaveAgentTOInterconn1.data = false;
				SlaveAgentTOInterconn1.err = false;
				Slave1_state = run0;
			fi;
			};
                        
		:: Slave1_state ==  run0 ->
			//Communication 

			//Dpath operations 
			d_step{
			if 
  			:: !((InterConnToSlaveAgent1.cyc  &&  InterConnToSlaveAgent1.stb)) -> 
				Slave1_state = run0;
			:: InterConnToSlaveAgent1.cyc && InterConnToSlaveAgent1.stb && !(InterConnToSlaveAgent1.we) -> 
				agent_to_slave_req.addr = InterConnToSlaveAgent1.addr;
				agent_to_slave_req.data = false;
				agent_to_slave_req.trans_type = 0;
				Slave1_state = run1;
			:: InterConnToSlaveAgent1.cyc && InterConnToSlaveAgent1.stb && InterConnToSlaveAgent1.we -> 
				agent_to_slave_req.addr = InterConnToSlaveAgent1.addr;
				agent_to_slave_req.data = InterConnToSlaveAgent1.data;
				agent_to_slave_req.trans_type = 1;
				Slave1_state = run2;
			fi;
			};
                     
		:: Slave1_state ==  run1 ->
			//Communication 
			//Write to SlaveDummy
			atomic{
                            state4 = true;
                            BusRun4!agent_to_slave_req;
                            BusRun4!agent_to_slave_req;
                            state4 = false;
       
                        };
			//Dpath operations 
			d_step{
			if 
  			:: true -> 
				Slave1_state = run3;
			fi;
			};
		:: Slave1_state ==  run3 ->
			//Communication 
			//Read from SlaveDummy
			atomic{
                            state5 = true;
                            BusRun5?slave_to_agent_resp;
                            BusRun5?slave_to_agent_resp;
                            state5 = false;
     
                            Slave1_state = run5;
                        };
			//Dpath operations 
			//atomic{
			//if 
                        //    :: slave_to_agent_resp_ack = OK;
                        //        slave_to_agent_resp_data = true;
                        //        Slave1_state = run5;
                        //    :: slave_to_agent_resp_ack = ERR;
			//	slave_to_agent_resp_data = true;
			//	Slave1_state = run5;
			//fi;
			//};
		:: Slave1_state ==  run2 ->
			//Communication 
			//Write to SlaveDummy
			atomic{
                            state4 = true;
                            BusRun4!agent_to_slave_req;
                            BusRun4!agent_to_slave_req;
                            state4 = false;
        
                        };
			//Dpath operations:states 
			d_step{
			if 
  			:: true -> 
				Slave1_state = run4;
			fi;
			};
		:: Slave1_state ==  run4 ->
			//Communication 
			//Read from SlaveDummy
			atomic{
                            state5 = true;
                            BusRun5?slave_to_agent_resp;
                            BusRun5?slave_to_agent_resp;
                            state5 = false;
 
                            Slave1_state = run5;
                        };
			//Dpath operations 
			//atomic{
			//if 
                        //    :: slave_to_agent_resp_ack = OK;
                        //        slave_to_agent_resp_data = true;
                        //        Slave1_state = run5;
                        //    :: slave_to_agent_resp_ack = ERR;
			//	slave_to_agent_resp_data = true;
			//	Slave1_state = run5;
			//fi;
			//};
	od;
}


///////////////////////////////////////////////
//// Module:SlaveAgent
///////////////////////////////////////////////

///////////////////////////////////////////////
//// Instance:slaveAgent2 Module:SlaveAgent
///////////////////////////////////////////////

active proctype slaveAgent2_SlaveAgent(){
mtype Slave2_state = run0;
bus_req_t agent_to_slave_req;
//mtype:addr_t agent_to_slave_req_addr;
//bool agent_to_slave_req_data;
//mtype:trans_t agent_to_slave_req_trans_type;
bus_resp_t slave_to_agent_resp;
//mtype:ack_t slave_to_agent_resp_ack;
//bool slave_to_agent_resp_data;

xs BusRun6;
xr BusRun7;

 ends2:	 do
		:: Slave2_state ==  run5 ->
			//Communication 

			//Dpath operations 
			d_step{
			if 
  			:: !((!(InterConnToSlaveAgent2.cyc)  &&  !(InterConnToSlaveAgent2.stb))) && InterConnToSlaveAgent2.we -> 
				SlaveAgentTOInterconn2.ack = true;
				SlaveAgentTOInterconn2.data = false;
				SlaveAgentTOInterconn2.err = !((slave_to_agent_resp.ack == OK));
				Slave2_state = run5;
			:: !((!(InterConnToSlaveAgent2.cyc)  &&  !(InterConnToSlaveAgent2.stb))) && !(InterConnToSlaveAgent2.we) -> 
				SlaveAgentTOInterconn2.ack = true;
				SlaveAgentTOInterconn2.data = slave_to_agent_resp.data;
				SlaveAgentTOInterconn2.err = !((slave_to_agent_resp.ack == OK));
				Slave2_state = run5;
			:: !(InterConnToSlaveAgent2.cyc) && !(InterConnToSlaveAgent2.stb) -> 
				SlaveAgentTOInterconn2.ack = false;
				SlaveAgentTOInterconn2.data = false;
				SlaveAgentTOInterconn2.err = false;
				Slave2_state = run0;
			fi;
			};
                        
		:: Slave2_state ==  run0 ->
			//Communication 

			//Dpath operations 
			d_step{
			if 
  			:: !((InterConnToSlaveAgent2.cyc  &&  InterConnToSlaveAgent2.stb)) -> 
				Slave2_state = run0;
			:: InterConnToSlaveAgent2.cyc && InterConnToSlaveAgent2.stb && !(InterConnToSlaveAgent2.we) -> 
				agent_to_slave_req.addr = InterConnToSlaveAgent2.addr;
				agent_to_slave_req.data = false;
				agent_to_slave_req.trans_type = 0;
				Slave2_state = run1;
			:: InterConnToSlaveAgent2.cyc && InterConnToSlaveAgent2.stb && InterConnToSlaveAgent2.we -> 
				agent_to_slave_req.addr = InterConnToSlaveAgent2.addr;
				agent_to_slave_req.data = InterConnToSlaveAgent2.data;
				agent_to_slave_req.trans_type = 1;
				Slave2_state = run2;
			fi;
			};
                        
		:: Slave2_state ==  run1 ->
			//Communication 
			//Write to SlaveDummy
			atomic{
                            state6 = true;
                            BusRun6!agent_to_slave_req;
                            BusRun6!agent_to_slave_req;
                            state6 = false;

                        };
			//Dpath operations 
			d_step{
			if 
  			:: true -> 
				Slave2_state = run3;
			fi;
			};
		:: Slave2_state ==  run3 ->
			//Communication 
			//Read from SlaveDummy
			atomic{
                            state7 =true;
                            BusRun7?slave_to_agent_resp;
                            BusRun7?slave_to_agent_resp;
                            state7 = false;
   
                            Slave2_state = run5;
                        };
			//Dpath operations 
			//atomic{
			//if 
                        //    :: slave_to_agent_resp_ack = OK;
                        //        slave_to_agent_resp_data = true;
                        //        Slave2_state = run5;
                        //    :: slave_to_agent_resp_ack = ERR;
			//	slave_to_agent_resp_data = true;
			//	Slave2_state = run5;
			//fi;
			//};
		:: Slave2_state ==  run2 ->
			//Communication 
			//Write to SlaveDummy
			atomic{
                            state6 = true;
                            BusRun6!agent_to_slave_req;
                            BusRun6!agent_to_slave_req;
                            state6 = false;

                        };
			//Dpath operations 
			d_step{
			if 
  			:: true -> 
				Slave2_state = run4;
			fi;
			};
		:: Slave2_state ==  run4 ->
			//Communication 
			//Read from SlaveDummy
			atomic{
                            state7 = true;
                            BusRun7?slave_to_agent_resp;
                            BusRun7?slave_to_agent_resp;
                            state7 = false;

                            Slave2_state = run5;
                        };
			//Dpath operations 
			//atomic{
			//if 
                        //    :: slave_to_agent_resp_ack = OK;
                        //        slave_to_agent_resp_data = true;
                        //        Slave2_state = run5;
                        //    :: slave_to_agent_resp_ack = ERR;
			//	slave_to_agent_resp_data = true;
			//	Slave2_state = run5;
			//fi;
			//};
	od;
}


///////////////////////////////////////////////
//// Module:SlaveAgent
///////////////////////////////////////////////

///////////////////////////////////////////////
//// Instance:slaveAgent3 Module:SlaveAgent
///////////////////////////////////////////////

active proctype slaveAgent3_SlaveAgent(){
mtype Slave3_state = run0;
bus_req_t agent_to_slave_req;
//mtype:addr_t agent_to_slave_req_addr;
//bool agent_to_slave_req_data;
//mtype:trans_t agent_to_slave_req_trans_type;
bus_resp_t slave_to_agent_resp;
//mtype:ack_t slave_to_agent_resp_ack;
//bool slave_to_agent_resp_data;

xs BusRun8;
xr BusRun9;

 ends3:	 do
		:: Slave3_state ==  run5 ->
			//Communication 

			//Dpath operations 
			d_step{
			if 
  			:: !((!(InterConnToSlaveAgent3.cyc)  &&  !(InterConnToSlaveAgent3.stb))) && InterConnToSlaveAgent3.we -> 
				SlaveAgentTOInterconn3.ack = true;
				SlaveAgentTOInterconn3.data = false;
				SlaveAgentTOInterconn3.err = !((slave_to_agent_resp.ack == OK));
				Slave3_state = run5;
			:: !((!(InterConnToSlaveAgent3.cyc)  &&  !(InterConnToSlaveAgent3.stb))) && !(InterConnToSlaveAgent3.we) -> 
				SlaveAgentTOInterconn3.ack = true;
				SlaveAgentTOInterconn3.data = slave_to_agent_resp.data;
				SlaveAgentTOInterconn3.err = !((slave_to_agent_resp.ack == OK));
				Slave3_state = run5;
			:: !(InterConnToSlaveAgent3.cyc) && !(InterConnToSlaveAgent3.stb) -> 
				SlaveAgentTOInterconn3.ack = false;
				SlaveAgentTOInterconn3.data = false;
				SlaveAgentTOInterconn3.err = false;
				Slave3_state = run0;
			fi;
			};
                        
		:: Slave3_state ==  run0 ->
			//Communication 

			//Dpath operations 
			d_step{
			if 
  			:: !((InterConnToSlaveAgent3.cyc  &&  InterConnToSlaveAgent3.stb)) -> 
				Slave3_state = run0;
			:: InterConnToSlaveAgent3.cyc && InterConnToSlaveAgent3.stb && !(InterConnToSlaveAgent3.we) -> 
				agent_to_slave_req.addr = InterConnToSlaveAgent3.addr;
				agent_to_slave_req.data = false;
				agent_to_slave_req.trans_type = 0;
				Slave3_state = run1;
			:: InterConnToSlaveAgent3.cyc && InterConnToSlaveAgent3.stb && InterConnToSlaveAgent3.we -> 
				agent_to_slave_req.addr = InterConnToSlaveAgent3.addr;
				agent_to_slave_req.data = InterConnToSlaveAgent3.data;
				agent_to_slave_req.trans_type = 1;
				Slave3_state = run2;
			fi;
			};
                        
		:: Slave3_state ==  run1 ->
			//Communication 
			//Write to SlaveDummy
			atomic{
                            state8 = true;
                            BusRun8!agent_to_slave_req;
                            BusRun8!agent_to_slave_req;
                            state8 = false;
  
                        };
			//Dpath operations 
			d_step{
			if 
  			:: true -> 
				Slave3_state = run3;
			fi;
			};
		:: Slave3_state ==  run3 ->
			//Communication 
			//Read from SlaveDummy
			atomic{
                            state9 = true;
                            BusRun9?slave_to_agent_resp;
                            BusRun9?slave_to_agent_resp;
                            state9 = false;
 
                            Slave3_state = run5;
                        };
			//Dpath operations 
			//atomic{
			//if 
                        //    :: slave_to_agent_resp_ack = OK;
                        //        slave_to_agent_resp_data = true;
                        //        Slave3_state = run5;
                        //    :: slave_to_agent_resp_ack = ERR;
			//	slave_to_agent_resp_data = true;
			//	Slave3_state = run5;
			//fi;
			//};
		:: Slave3_state ==  run2 ->
			//Communication 
			//Write to SlaveDummy
			atomic{
                            state8 = true;
                            BusRun8!agent_to_slave_req;
                            BusRun8!agent_to_slave_req;
                            state8 = false;

                        };
			//Dpath operations 
			d_step{
			if 
  			:: true -> 
				Slave3_state = run4;
			fi;
			};
		:: Slave3_state ==  run4 ->
			//Communication 
			//Read from SlaveDummy
			atomic{
                            state9 = true;
                            BusRun9?slave_to_agent_resp;
                            BusRun9?slave_to_agent_resp;
                            state9 = false;

                            Slave3_state = run5;
                        };
			//Dpath operations 
			//atomic{
			//if 
                        //    :: slave_to_agent_resp_ack = OK;
                        //        slave_to_agent_resp_data = true;
                        //        Slave3_state = run5;
                        //    :: slave_to_agent_resp_ack = ERR;
			//	slave_to_agent_resp_data = true;
			//	Slave3_state = run5;
			//fi;
			//};
	od;
}


///////////////////////////////////////////////
//// Module:Bus
///////////////////////////////////////////////

///////////////////////////////////////////////
//// Instance:bus Module:Bus
///////////////////////////////////////////////

active proctype bus_Bus(){
mtype Bus_state = run0;
mtype:trans_t req_trans_type;
bus_req_t master_in_sig;
bus_resp_t master_out_sig;
bus_req_t slave_out0_sig;
bus_req_t slave_out1_sig;
bus_req_t slave_out2_sig;
bus_req_t slave_out3_sig;

bus_resp_t slave_in_sig;
bus_req_t compare_req;
bus_resp_t compare_resp;

xs BusRun0;
xr BusRun1;
xs BusRun2;
xr BusRun3;
xr BusRun4;
xs BusRun5;
xr BusRun6;
xs BusRun7;
xr BusRun8;
xs BusRun9;

 endb:	 do
		:: Bus_state ==  run0 ->
			//Communication 
			atomic{
			if
                        :: true ->
                            master_in_sig.trans_type = 1;
                            master_in_sig.addr = SLAVE0;
                            master_in_sig.data = true;
                        :: true ->
                            master_in_sig.addr = SLAVE1;
                            master_in_sig.data = true;
                            master_in_sig.trans_type = 0;
                        :: true -> 
                            master_in_sig.addr = SLAVE2;
                            master_in_sig.data = true;
                            master_in_sig.trans_type = 0;
                        :: true ->
                            master_in_sig.addr = SLAVE3;
                            master_in_sig.data = true;
                            master_in_sig.trans_type = 0;
                        :: true ->
                            master_in_sig.trans_type = 0;
                            master_in_sig.addr = SLAVE0;
                            master_in_sig.data = true;
                        :: true ->
                            master_in_sig.addr = SLAVE1;
                            master_in_sig.data = true;
                            master_in_sig.trans_type = 1;
                        :: true -> 
                            master_in_sig.addr = SLAVE2;
                            master_in_sig.data = true;
                            master_in_sig.trans_type = 1;
                        :: true ->
                            master_in_sig.addr = SLAVE3;
                            master_in_sig.data = true;
                            master_in_sig.trans_type = 1;
                            
			fi;
                        BusRun0!master_in_sig;
                        BusRun0!master_in_sig;
			};
			//Dpath operations 
			d_step{
			if 
  			:: !((0 == master_in_sig.trans_type)) && (master_in_sig.addr == SLAVE0) -> 
				req_trans_type = master_in_sig.trans_type;
				slave_out0_sig.addr = master_in_sig.addr;
				slave_out0_sig.data = master_in_sig.data;
				slave_out0_sig.trans_type = master_in_sig.trans_type;
				Bus_state = run1;
			:: (0 == master_in_sig.trans_type) && (master_in_sig.addr == SLAVE0) -> 
				req_trans_type = master_in_sig.trans_type;
				slave_out0_sig.addr = master_in_sig.addr;
				slave_out0_sig.data = false;
				slave_out0_sig.trans_type = master_in_sig.trans_type;
				Bus_state = run1;
			:: (0 == master_in_sig.trans_type) && !(master_in_sig.addr == SLAVE0) && !(master_in_sig.addr == SLAVE1) && !(master_in_sig.addr == SLAVE2) && !(master_in_sig.addr == SLAVE3) -> 
				master_out_sig.ack = OK;
				master_out_sig.data = false;
				req_trans_type = master_in_sig.trans_type;
				Bus_state = run3;
                        :: !(master_in_sig.addr == SLAVE0) && !(master_in_sig.addr == SLAVE1) && !(master_in_sig.addr == SLAVE2) && !(master_in_sig.addr == SLAVE3) && (1 == master_in_sig.trans_type) ->  
				master_out_sig.ack = OK;
				master_out_sig.data = false;
				req_trans_type = master_in_sig.trans_type;
				Bus_state = run3;
			:: !((0 == master_in_sig.trans_type)) && (master_in_sig.addr == SLAVE1) ->
				req_trans_type = master_in_sig.trans_type;
				slave_out1_sig.addr = master_in_sig.addr;
				slave_out1_sig.data = master_in_sig.data;
				slave_out1_sig.trans_type = master_in_sig.trans_type;
				Bus_state = run4;
			:: (0 == master_in_sig.trans_type) && (master_in_sig.addr == SLAVE1) -> 
				req_trans_type = master_in_sig.trans_type;
				slave_out1_sig.addr = master_in_sig.addr;
				slave_out1_sig.data = false;
				slave_out1_sig.trans_type = master_in_sig.trans_type;
				Bus_state = run4;
			:: !((0 == master_in_sig.trans_type)) && (master_in_sig.addr == SLAVE2) -> 				
				req_trans_type = master_in_sig.trans_type;
				slave_out2_sig.addr = master_in_sig.addr;
				slave_out2_sig.data = master_in_sig.data;
				slave_out2_sig.trans_type = master_in_sig.trans_type;
				Bus_state = run6;
			:: (0 == master_in_sig.trans_type) && (master_in_sig.addr == SLAVE2) -> 				
				req_trans_type = master_in_sig.trans_type;
				slave_out2_sig.addr = master_in_sig.addr;
				slave_out2_sig.data = false;
				slave_out2_sig.trans_type = master_in_sig.trans_type;
				Bus_state = run6;
			:: !((0 == master_in_sig.trans_type)) && (master_in_sig.addr == SLAVE3) -> 
				req_trans_type = master_in_sig.trans_type;
				slave_out3_sig.addr = master_in_sig.addr;
				slave_out3_sig.data = master_in_sig.data;
				slave_out3_sig.trans_type = master_in_sig.trans_type;
				Bus_state = run8;
			:: (0 == master_in_sig.trans_type) && (master_in_sig.addr == SLAVE3) -> 
				req_trans_type = master_in_sig.trans_type;
				slave_out3_sig.addr = master_in_sig.addr;
				slave_out3_sig.data = false;
				slave_out3_sig.trans_type = master_in_sig.trans_type;
				Bus_state = run8;
			fi;
			};
		:: Bus_state ==  run1 ->
			//Communication 
			atomic{
                            BusRun1?compare_req;
                            BusRun1?compare_req;
                            assert((compare_req.addr == slave_out0_sig.addr) && (compare_req.data == slave_out0_sig.data) && (compare_req.trans_type == slave_out0_sig.trans_type));
			};
			//Dpath operations 
			d_step{
			if 
  			:: true -> 
				Bus_state = run2;
			fi;
			};
		:: Bus_state ==  run2 ->
			//Communication 
			atomic{
                            if
                                :: true ->
                                    slave_in_sig.ack = OK;
                                    slave_in_sig.data = true;
                                //:: true ->
                                //    slave_in_sig.ack = ERR;
                                //    slave_in_sig.data = true;
                            fi;
                            BusRun2!slave_in_sig;
                            BusRun2!slave_in_sig;
			};
			//Dpath operations 
			d_step{
			if 
  			:: !((1 == req_trans_type)) -> 
				master_out_sig.ack = slave_in_sig.ack;
				master_out_sig.data = slave_in_sig.data;
				Bus_state = run3;
			:: (1 == req_trans_type) -> 
				master_out_sig.ack = slave_in_sig.ack;
				master_out_sig.data = false;
				Bus_state = run3;
			fi;
			};
		:: Bus_state ==  run3 ->
			//Communication 
			atomic{
                            BusRun3?compare_resp;
                            BusRun3?compare_resp;
                            //assert((compare_resp.ack == master_out_sig.ack));
                            //assert((compare_resp.ack == master_out_sig.ack) && (compare_resp.data == master_out_sig.data)); //TODO assertion violation
			}
			//Dpath operations 
			d_step{
			if 
  			:: true -> 
				Bus_state = run0;
			fi;
			};
		:: Bus_state ==  run4 ->
			//Communication 
			atomic{
                            BusRun4?compare_req;
                            BusRun4?compare_req;
                            assert((compare_req.addr == slave_out1_sig.addr) && (compare_req.data == slave_out1_sig.data) && (compare_req.trans_type == slave_out1_sig.trans_type));
			};
			//Dpath operations 
			d_step{
			if 
  			:: true -> 
				Bus_state = run5;
			fi;
			};
		:: Bus_state ==  run5 ->
			//Communication 
			atomic{
                            if
                                :: true ->
                                    slave_in_sig.ack = OK;
                                    slave_in_sig.data = true;
                                //:: true ->
                                //    slave_in_sig.ack = ERR;
                                //    slave_in_sig.data = true;
                            fi;
                            BusRun5!slave_in_sig;
                            BusRun5!slave_in_sig;
			};
			//Dpath operations 
			d_step{
			if 
  			:: !((1 == req_trans_type)) -> 
				master_out_sig.ack = slave_in_sig.ack;
				master_out_sig.data = slave_in_sig.data;
				Bus_state = run3;
			:: (1 == req_trans_type) -> 
				master_out_sig.ack = slave_in_sig.ack;
				master_out_sig.data = false;
				Bus_state = run3;
			fi;
			};
		:: Bus_state ==  run6 ->
                        //Communication 
			atomic{
                            BusRun6?compare_req;
                            BusRun6?compare_req;
                            assert((compare_req.addr == slave_out2_sig.addr) && (compare_req.data == slave_out2_sig.data) && (compare_req.trans_type == slave_out2_sig.trans_type));
			};
			//Dpath operations 
			d_step{
			if 
  			:: true -> 
				Bus_state = run7;
			fi;
			};
		:: Bus_state ==  run7 ->
                        //Communication 
			atomic{
                            if
                                :: true ->
                                    slave_in_sig.ack = OK;
                                    slave_in_sig.data = true;
                                //:: true ->
                                //    slave_in_sig.ack = ERR;
                                //    slave_in_sig.data = true;
                            fi;
                            BusRun7!slave_in_sig;
                            BusRun7!slave_in_sig;
			};
			//Dpath operations 
			d_step{
			if 
  			:: !((1 == req_trans_type)) -> 
				master_out_sig.ack = slave_in_sig.ack;
				master_out_sig.data = slave_in_sig.data;
				Bus_state = run3;
			:: (1 == req_trans_type) -> 
				master_out_sig.ack = slave_in_sig.ack;
				master_out_sig.data = false;
				Bus_state = run3;
			fi;
			};
		:: Bus_state ==  run8 ->
			//Communication 
			atomic{
                            BusRun8?compare_req;
                            BusRun8?compare_req;
                            assert((compare_req.addr == slave_out3_sig.addr) && (compare_req.data == slave_out3_sig.data) && (compare_req.trans_type == slave_out3_sig.trans_type));
			};
			//Dpath operations 
			d_step{
			if 
  			:: true -> 
				Bus_state = run9;
			fi;
			};
		:: Bus_state ==  run9 ->
			//Communication 
			atomic{
                            if
                                :: true ->
                                    slave_in_sig.ack = OK;
                                    slave_in_sig.data = true;
                                //:: true ->
                                //    slave_in_sig.ack = ERR;
                                //    slave_in_sig.data = true;
                            fi;
                            BusRun9!slave_in_sig;
                            BusRun9!slave_in_sig;
			};
			//Dpath operations 
			d_step{
			if 
  			:: !((1 == req_trans_type)) -> 
				master_out_sig.ack = slave_in_sig.ack;
				master_out_sig.data = slave_in_sig.data;
				Bus_state = run3;
			:: (1 == req_trans_type) -> 
				master_out_sig.ack = slave_in_sig.ack;
				master_out_sig.data = false;
				Bus_state = run3;
			fi;
			};
	od;
}

ltl xstate0 {[](state0 -> (!state1 && !state2 && !state3 && !state4 && !state5 && !state6 && !state7 && !state8 && !state9))}
ltl xstate1 {[](state1 -> (!state0 && !state2 && !state3 && !state4 && !state5 && !state6 && !state7 && !state8 && !state9))}
ltl xstate2 {[](state2 -> (!state1 && !state0 && !state3 && !state4 && !state5 && !state6 && !state7 && !state8 && !state9))}
ltl xstate3 {[](state3 -> (!state1 && !state2 && !state0 && !state4 && !state5 && !state6 && !state7 && !state8 && !state9))}
ltl xstate4 {[](state4 -> (!state1 && !state2 && !state3 && !state0 && !state5 && !state6 && !state7 && !state8 && !state9))}
ltl xstate5 {[](state5 -> (!state1 && !state2 && !state3 && !state4 && !state0 && !state6 && !state7 && !state8 && !state9))}
ltl xstate6 {[](state6 -> (!state1 && !state2 && !state3 && !state4 && !state5 && !state0 && !state7 && !state8 && !state9))}
ltl xstate7 {[](state7 -> (!state1 && !state2 && !state3 && !state4 && !state5 && !state6 && !state0 && !state8 && !state9))}
ltl xstate8 {[](state8 -> (!state1 && !state2 && !state3 && !state4 && !state5 && !state6 && !state7 && !state0 && !state9))}
ltl xstate9 {[](state9 -> (!state1 && !state2 && !state3 && !state4 && !state5 && !state6 && !state7 && !state8 && !state0))}
ltl progress {[](no_state -> (no_state U any_state))}
ltl progress0 {[](state0 -> (state0 U no_state))}
ltl progress1 {[](state1 -> (state1 U no_state))}
ltl progress2 {[](state2 -> (state2 U no_state))}
ltl progress3 {[](state3 -> (state3 U no_state))}
ltl progress4 {[](state4 -> (state4 U no_state))}
ltl progress5 {[](state5 -> (state5 U no_state))}
ltl progress6 {[](state6 -> (state6 U no_state))}
ltl progress7 {[](state7 -> (state7 U no_state))}
ltl progress8 {[](state8 -> (state8 U no_state))}
ltl progress9 {[](state9 -> (state9 U no_state))}



