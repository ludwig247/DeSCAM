library ieee ;
use ieee.std_logic_1164.all;
--use IEEE.numeric_std.all; 
use ieee.std_logic_arith.all;
use work.ahb_package.all;

entity masterWrapper is
port(
    clk:  in std_logic;
    rst:  in std_logic;
    mst_to_wrp:  in CUtoAHB_IF;
    mst_to_wrp_sync:  in Boolean;
    mst_to_wrp_notify: out Boolean;
    wrp_to_bus: out mst_out_t;
	bus_to_wrp:  in mst_in_t;
	wrp_to_mst: out AHBtoCU_IF;
	wrp_to_mst_sync:  in Boolean;
	wrp_to_mst_notify: out Boolean
);
end masterWrapper;

architecture mWrp of masterWrapper is 

function isWrite(hwrite: trans_type) return std_logic is
begin
 if(hwrite = AHB_WRITE) then
	return AHB_WRITES;
 else
	return AHB_READS;
 end if;
end isWrite;

function isSize(hsize: mask) return std_logic_vector is
begin
 if((hsize = MT_B) or (hsize = MT_BU)) then
	return BYTE;
 elsif((hsize = MT_H) or (hsize = MT_HU)) then
	return HALFWORD;
 elsif(hsize = MT_W) then
	return WORD;
 else
    return X; 
 end if;
end isSize;



signal section, nextsection : mAgent_sec;


---- config regs
signal haddr : std_logic_vector(31 downto 0);
signal hwdata : std_logic_vector(31 downto 0);
signal hburst : std_logic_vector(2 downto 0);
signal hprot : std_logic_vector(3 downto 0);
signal hsize : std_logic_vector(2 downto 0);
signal hwrite : std_logic;
signal hmastlock : std_logic;
signal htrans : std_logic_vector(1 downto 0);
signal hbusreq : std_logic;
--- end config regs

signal hrdata : std_logic_vector(31 downto 0);
signal hresp : std_logic_vector(1 downto 0);

signal writing : std_logic;
signal addr_reg : std_logic_vector(31 downto 0); --Need to store address for property macros
signal size_reg : mask; --Need to store size for property macros

signal busreq : std_logic;
signal load, load2 : std_logic;

signal haddr_temp, hwdata_temp : std_logic_vector(31 downto 0);
signal hsize_temp : std_logic_vector(2 downto 0);
signal hwrite_temp : std_logic;

--- notify
signal mst_to_wrp_notify_tmp : Boolean;
signal wrp_to_mst_notify_tmp : Boolean;
signal mst_to_wrp_notify_comb : Boolean;
signal wrp_to_mst_notify_comb : Boolean;
--- end notify

begin

wrp_to_bus.haddr <= haddr;
wrp_to_bus.hwdata <= hwdata;
wrp_to_bus.hburst <= hburst;
wrp_to_bus.htrans <= htrans;
wrp_to_bus.hsize <= hsize;
wrp_to_bus.hwrite <= hwrite;
wrp_to_bus.hprot <= hprot;
wrp_to_bus.hlock <= hmastlock;
wrp_to_bus.hbusreq <= busreq;

wrp_to_mst.hrdata <= hrdata;
wrp_to_mst.hresp <= hresp;

hmastlock <= AHB_NOLOCK;
hprot <= AHB_DEF_PROT;
hburst <= SINGLE_TRANSFER;

mst_to_wrp_notify <= mst_to_wrp_notify_tmp;
wrp_to_mst_notify <= wrp_to_mst_notify_tmp;

--htrans <= nonseq when section = addr else seq when section = addr_data else idle;
htrans <= nonseq when section = address_phase else idle;
--busreq <= '1' when (section = req_phase) or (section = addr and hburst /= SINGLE_TRANSFER) or (section = addr_data) else '0';
busreq <= '1' when (section = request_phase) or (section = address_phase and hburst /= SINGLE_TRANSFER) else '0';
	 
state_s:process(clk) ------------------------STATE MACHINE SEQUENTIAL 
  begin 
if(rst = '1') then
          section <= idle_phase;
		  mst_to_wrp_notify_tmp <= true;
		  wrp_to_mst_notify_tmp <= false;
		  hwdata <= (others => '0');
		  haddr <= (others => '0');
		  hwrite <= '0';
		  hwrite_temp <= '0';
		  hsize_temp <= "010";
		  hwdata_temp <= (others => '0');
		  haddr_temp <= (others => '0');
		  hsize <= "010";
		  hresp <= (others => '0');
		  hrdata <= (others => '0'); 
     elsif(clk = '1' and clk'event) then
		   section <= nextsection;
		   mst_to_wrp_notify_tmp <= mst_to_wrp_notify_comb;
		   wrp_to_mst_notify_tmp <= wrp_to_mst_notify_comb;
		   
		   if(load = '1') then
		    hwdata <= mst_to_wrp.hwdata;
			haddr <= mst_to_wrp.haddr;
			hwrite <= isWrite(mst_to_wrp.hwrite);
			hsize <= isSize(mst_to_wrp.hsize);
		   end if;
		 		   
		   if(section = data_phase and bus_to_wrp.hready = '1') then
		     hresp <= bus_to_wrp.hresp;
			 hrdata <= bus_to_wrp.hrdata;
		   end if;
   
	 end if;
end process; 


------------------STATE MACHINE COMBINATIONAL
state_c : process(section, nextsection, mst_to_wrp_notify_tmp, mst_to_wrp_sync, bus_to_wrp, wrp_to_mst_sync, wrp_to_mst_notify_tmp)
begin
nextsection <= section;
wrp_to_mst_notify_comb <= wrp_to_mst_notify_tmp;
mst_to_wrp_notify_comb <= mst_to_wrp_notify_tmp;
load <= '0';
load2 <= '0';

case section is
 when idle_phase =>
  if(mst_to_wrp_sync = true and mst_to_wrp_notify_tmp = true) then
   mst_to_wrp_notify_comb <= false;
   load <= '1';
   nextsection <= request_phase;
  end if;
 when request_phase =>
  if (bus_to_wrp.hgrant = '1' and bus_to_wrp.hready = '1') then
   load2 <= '1';
   nextsection <= address_phase;
  end if;
 when address_phase =>
  if(bus_to_wrp.hready = '1')  then 
   --  if(hburst = SINGLE_TRANSFER) then --Might be better to monitor fifo for this but we shall see. 
	 nextsection <= data_phase;
--	else
--	 nextsection <= addr_data;
--	end if;
  end if; 
 when data_phase =>
  if(bus_to_wrp.hready = '1') then
   nextsection <= response_phase;
   wrp_to_mst_notify_comb <= true;
  else
   nextsection <= data_phase;
  end if;
 when response_phase => 
   if(wrp_to_mst_sync = true and wrp_to_mst_notify_tmp = true) then
     mst_to_wrp_notify_comb <= true;
     wrp_to_mst_notify_comb <= false;
	 nextsection <= idle_phase;
   end if;
 when others => null;
end case;


end process;


end mWrp;
