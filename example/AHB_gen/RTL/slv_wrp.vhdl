library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.wrp_types.all;

entity slaveWrapper is
generic(ADDR_OFFSET : unsigned(31 downto 0) := to_unsigned(0,32));
port(
              clk:  in std_logic;
              rst:  in std_logic;
	   wrp_to_slv:  out CUtoAHB_IF;
  wrp_to_slv_sync:  in Boolean;
wrp_to_slv_notify: out Boolean;
	        s_sel:  in unsigned(0 downto 0);
		 ready_in:  in unsigned(0 downto 0);	
       slv_to_wrp:	in AHBtoCU_IF;
  slv_to_wrp_sync:  in Boolean;
slv_to_wrp_notify: out Boolean;
	   bus_to_wrp:  in ahb_slv_in;
	   wrp_to_bus: out ahb_slv_out
);
end slaveWrapper;


architecture slvwrp of slaveWrapper is

function isWrite(hwrite: unsigned(0 downto 0)) return trans_type is
begin
 if(hwrite = AHB_WRITES) then
	return AHB_WRITE;
 else
	return AHB_READ;
 end if;
end isWrite;

function isSize(hsize: unsigned(2 downto 0)) return mask is
begin
 if(hsize = BYTE) then
	return MT_B;
 elsif(hsize = HALFWORD) then
	return MT_H;
 elsif(hsize = WORD) then
	return MT_W;
 else
    return MT_X; 
 end if;
end isSize;

signal section : sWrp_sec;
signal nextsection : sWrp_sec;
signal slv_to_wrp_notify_tmp : Boolean;
signal slv_to_wrp_notify_comb : Boolean;
signal wrp_to_slv_notify_tmp : Boolean;
signal wrp_to_slv_notify_comb : Boolean;

signal hresp : unsigned(1 downto 0);
signal hreadyout : unsigned(0 downto 0);
signal hrdata : unsigned(31 downto 0);
signal hrdata_reg : unsigned(31 downto 0);

signal writing : unsigned(0 downto 0);

signal errortemp : unsigned(1 downto 0);

begin

wrp_to_slv_notify <= wrp_to_slv_notify_tmp;
slv_to_wrp_notify <= slv_to_wrp_notify_tmp;

wrp_to_bus.hresp <= hresp;
wrp_to_bus.hreadyout <= hreadyout;
wrp_to_bus.hrdata <= hrdata;


hreadyout <= AHB_READY when (section = addr_phase) or (section = err) else AHB_NOTREADY;
hresp <= errortemp;
hrdata <= slv_to_wrp.hrdata when (slv_to_wrp_notify_tmp = true) and (slv_to_wrp_sync = true) else hrdata_reg;

process(clk)
  begin 
     if(clk = '1' and clk'event) then
	    if(rst = '1') then

		else
		   if(section = addr_phase) then
		     wrp_to_slv.hwrite <= isWrite(bus_to_wrp.hwrite);
			 writing <= bus_to_wrp.hwrite;
			 wrp_to_slv.haddr <= bus_to_wrp.haddr - ADDR_OFFSET;
			 wrp_to_slv.hsize <= isSize(bus_to_wrp.hsize);
		   end if;
		   
                           if((slv_to_wrp_notify_tmp = true) and (slv_to_wrp_sync = true) and (section = resp)) then
                              hrdata_reg <= slv_to_wrp.hrdata;
                           end if;
		   
		   if(section = data_phase) then
		     if(writing = AHB_WRITES) then
                           wrp_to_slv.hwdata <= bus_to_wrp.hwdata;
		        else
			   wrp_to_slv.hwdata <= to_unsigned(0,32);                   
		      end if;
           end if;		   
		   

        end if;
	 end if;
end process;





state_s : process(clk)
  begin 
     if(clk = '1' and clk'event) then
	    if(rst = '1') then
          section <= addr_phase;
		  slv_to_wrp_notify_tmp <= false;
		  wrp_to_slv_notify_tmp <= false;
		else
		   section <= nextsection;
		   slv_to_wrp_notify_tmp <= slv_to_wrp_notify_comb;
		   wrp_to_slv_notify_tmp <= wrp_to_slv_notify_comb;
        end if;
	 end if;
end process;


state_c : process(section, slv_to_wrp_notify_tmp, wrp_to_slv_notify_tmp, slv_to_wrp_sync, wrp_to_slv_sync, ready_in, s_sel, bus_to_wrp)
begin
nextsection <= section;
slv_to_wrp_notify_comb <= slv_to_wrp_notify_tmp;
wrp_to_slv_notify_comb <= wrp_to_slv_notify_tmp;
errortemp <= AHB_OKAY;

if((section = addr_phase) and (ready_in = AHB_READY) and (s_sel = SELECTED) and (bus_to_wrp.htrans /= IDLE_t) and (bus_to_wrp.htrans /= BUSY)) then 
 nextsection <= data_phase;
end if;

if(section = data_phase) then
 nextsection <= req;
 wrp_to_slv_notify_comb <= true;
end if;

if((section = req) and (wrp_to_slv_notify_tmp = true) and (wrp_to_slv_sync = true)) then
 nextsection <= resp;
 wrp_to_slv_notify_comb <= false;
 slv_to_wrp_notify_comb <= true;
end if;

if((section = resp) and (slv_to_wrp_notify_tmp = true) and (slv_to_wrp_sync = true)) then 
 if(slv_to_wrp.hresp /= AHB_OKAY) then
  nextsection <= err;
  errortemp <= AHB_ERROR;
 else
  nextsection <= addr_phase;
 end if;
 slv_to_wrp_notify_comb <= false;
end if;

if(section = err) then
nextsection <= addr_phase;
errortemp <= AHB_ERROR;
end if;


end process;



end slvwrp;