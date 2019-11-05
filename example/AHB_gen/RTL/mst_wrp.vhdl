library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.wrp_types.all;

entity masterWrapper is
port(
    clk:  in std_logic;
    rst:  in std_logic;
    mst_to_wrp:  in CUtoAHB_IF;
    mst_to_wrp_sync:  in Boolean;
    mst_to_wrp_notify: out Boolean;
    wrp_to_bus: out ahb_mst_out;
	bus_to_wrp:  in ahb_mst_in;
	wrp_to_mst: out AHBtoCU_IF;
	wrp_to_mst_sync:  in Boolean;
	wrp_to_mst_notify: out Boolean
);
end masterWrapper;

architecture mWrp of masterWrapper is 

function isWrite(hwrite: trans_type) return unsigned is
begin
 if(hwrite = AHB_WRITE) then
	return AHB_WRITES;
 else
	return AHB_READS;
 end if;
end isWrite;

function isSize(hsize: mask) return unsigned is
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

signal section : mWrp_sec;
signal nextsection : mWrp_sec;

---- config regs
signal haddr : unsigned(31 downto 0);
signal hwdata : unsigned(31 downto 0);
signal hburst : unsigned(2 downto 0);
signal hprot : unsigned(3 downto 0);
signal hsize : unsigned(2 downto 0);
signal hwrite : unsigned(0 downto 0);
signal hmastlock : unsigned(0 downto 0);
signal htrans : unsigned(1 downto 0);
--- end config regs

signal hrdata : unsigned(31 downto 0);
signal hresp : unsigned(1 downto 0);

signal writing : unsigned(0 downto 0);
signal addr_reg : unsigned(31 downto 0); --Need to store address for property macros
signal size_reg : mask; --Need to store size for property macros


signal helper_c : Boolean;
signal helper_r : Boolean;

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


wrp_to_mst.hrdata <= hrdata;
wrp_to_mst.hresp <= hresp;

hmastlock <= AHB_NOLOCK;
hprot <= AHB_DEF_PROT;
hburst <= SINGLE_TRANSFER;

mst_to_wrp_notify <= mst_to_wrp_notify_tmp;
wrp_to_mst_notify <= wrp_to_mst_notify_tmp;


htrans <= NONSEQ when (((mst_to_wrp_sync = true) and (mst_to_wrp_notify_tmp = true)) or helper_r = true) and (section = addr_phase) else IDLE_t; -- Needs update when burst is implemented
haddr <= mst_to_wrp.haddr when (mst_to_wrp_sync = true) and (mst_to_wrp_notify_tmp = true) else addr_reg; -- need update when burst is implemented
hwrite <= isWrite(mst_to_wrp.hwrite) when (mst_to_wrp_sync = true) and (mst_to_wrp_notify_tmp = true) else writing; 
hsize <= isSize(mst_to_wrp.hsize) when (mst_to_wrp_sync = true) and (mst_to_wrp_notify_tmp = true) else isSize(size_reg); -- value must be guaranteed throughout burst transfer when implemented


read_m : process(clk) ---------------DATA  
  begin 
     if(clk = '1' and clk'event) then
	    if(rst = '1') then
		   hwdata <= to_unsigned(0,32);
		   hrdata <= to_unsigned(0,32);
		   size_reg <= MT_B;
		   addr_reg <= to_unsigned(0,32);
		   writing <= to_unsigned(0,1);
                   hresp <= AHB_OKAY;
		else  
			   
		  if((mst_to_wrp_sync = true) and (mst_to_wrp_notify_tmp = true)) then
			hwdata <= mst_to_wrp.hwdata;
			writing <= isWrite(mst_to_wrp.hwrite);
			addr_reg <= mst_to_wrp.haddr;
			size_reg <= mst_to_wrp.hsize;
		  end if;	
            	   
		   if((writing = AHB_WRITES) and (section = data_phase) and bus_to_wrp.hready = AHB_READY) then
		         hrdata <= to_unsigned(0,32);
			 hresp <= bus_to_wrp.hresp;	
			elsif((writing = AHB_READS) and (section = data_phase) and bus_to_wrp.hready = AHB_READY) then
			  hrdata <= bus_to_wrp.hrdata;	
                          hresp <= bus_to_wrp.hresp;			  
			end if;
		   
		   
		   
        end if;
	 end if;
end process;	 



state_s:process(clk) ------------------------STATE MACHINE SEQUENTIAL 
  begin 
     if(clk = '1' and clk'event) then
        if(rst = '1') then
          section <= init_cycle;
		  mst_to_wrp_notify_tmp <= true;
		  wrp_to_mst_notify_tmp <= false;
		  else
		   section <= nextsection;
		   mst_to_wrp_notify_tmp <= mst_to_wrp_notify_comb;
           wrp_to_mst_notify_tmp <= wrp_to_mst_notify_comb;
		   helper_r <= helper_c;
        end if;
	 end if;
end process; 


------------------STATE MACHINE COMBINATIONAL
state_c : process(section, mst_to_wrp_notify_tmp, mst_to_wrp_sync, bus_to_wrp.hready, wrp_to_mst_sync, wrp_to_mst_notify_tmp)
begin
nextsection <= section;
wrp_to_mst_notify_comb <= wrp_to_mst_notify_tmp;
mst_to_wrp_notify_comb <= mst_to_wrp_notify_comb;
helper_c <= false;

if(section = init_cycle) then --ahb_s3_port needs one cycle longer than wrappers after rst not to give error (d_Sel_reg in mux) 
if((mst_to_wrp_sync = true) and (mst_to_wrp_notify_tmp = true))then
helper_c <= true;
mst_to_wrp_notify_comb <= false;
else
mst_to_wrp_notify_comb <= true;
end if;
nextsection <= addr_phase;
end if;


if((mst_to_wrp_sync = true) and (mst_to_wrp_notify_tmp = true) and (section = addr_phase)) then
nextsection <= data_phase;
mst_to_wrp_notify_comb <= false;
end if;

if(helper_r = true and (section = addr_phase)) then
nextsection <= data_phase;
end if; 


if((section = data_phase) and (bus_to_wrp.hready = AHB_READY)) then
wrp_to_mst_notify_comb <= true;
nextsection <= resp;
end if;

if((section = resp) and (wrp_to_mst_sync = true) and (wrp_to_mst_notify_tmp = true)) then
nextsection <= addr_phase;
wrp_to_mst_notify_comb <= false;
mst_to_wrp_notify_comb <= true;
end if;

end process;


end mWrp;
