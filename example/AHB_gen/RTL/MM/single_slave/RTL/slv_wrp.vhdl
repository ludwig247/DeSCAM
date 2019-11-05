library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.ahb_package.all;

entity slaveWrapper is
generic(ADDR_OFFSET : std_logic_vector(31 downto 0) := (others => '0'));
port(
              clk:  in std_logic;
              rst:  in std_logic;
	   wrp_to_slv:  out CUtoAHB_IF;
  wrp_to_slv_sync:  in Boolean;
wrp_to_slv_notify: out Boolean;	
       slv_to_wrp:	in AHBtoCU_IF;
  slv_to_wrp_sync:  in Boolean;
slv_to_wrp_notify: out Boolean;
	   bus_to_wrp:  in slv_in_t;
	   wrp_to_bus: out slv_out_t
);
end slaveWrapper;


architecture slvwrp of slaveWrapper is

function isWrite(hwrite: std_logic) return trans_type is
begin
 if(hwrite = AHB_WRITES) then
	return AHB_WRITE;
 else
	return AHB_READ;
 end if;
end isWrite;

function isSize(hsize: std_logic_vector(2 downto 0)) return mask is
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

signal section, nextsection : sWrp_sec;

signal slv_to_wrp_notify_tmp : Boolean;
signal slv_to_wrp_notify_comb : Boolean;
signal wrp_to_slv_notify_tmp : Boolean;
signal wrp_to_slv_notify_comb : Boolean;

signal hresp : std_logic_vector(1 downto 0);
signal hsplit : std_logic_vector(15 downto 0);
signal hready : std_logic;
signal hrdata : std_logic_vector(31 downto 0);

signal load_addr, load_data, write_data : std_logic;

--signal addr_reg: std_logic_vector(31 downto 0);



signal errortemp : std_logic_vector(1 downto 0);



begin



wrp_to_slv_notify <= wrp_to_slv_notify_tmp;
slv_to_wrp_notify <= slv_to_wrp_notify_tmp;

wrp_to_bus.hresp <= hresp;
wrp_to_bus.hready <= hready;
wrp_to_bus.hrdata <= hrdata;
wrp_to_bus.hsplit <= hsplit;


hsplit <= (others => '0');

hready <= '1' when (section = idle_phase) or (section = error_phase) else '0';



hresp <= slv_to_wrp.hresp when slv_to_wrp_notify_tmp = true and slv_to_wrp_sync = true else error_resp when section = error_phase else ok_resp;



state_s : process(clk)
  begin 
     if(clk = '1' and clk'event) then
	    if(rst = '1') then
          section <= idle_phase;
		  slv_to_wrp_notify_tmp <= false;
		  wrp_to_slv_notify_tmp <= false;
                  wrp_to_slv.haddr <= x"00000000";
                  wrp_to_slv.hwdata <= x"00000000";
                  wrp_to_slv.hwrite <= AHB_READ;
                  wrp_to_slv.hsize <= MT_W;
                  hrdata <= x"00000000";

		else
		   section <= nextsection;
		   slv_to_wrp_notify_tmp <= slv_to_wrp_notify_comb;
		   wrp_to_slv_notify_tmp <= wrp_to_slv_notify_comb;
   
		   
		   if(load_addr = '1') then
		    wrp_to_slv.haddr <= std_logic_vector(unsigned(bus_to_wrp.haddr) - unsigned(ADDR_OFFSET));
	--		wrp_to_slv.hwdata <= (others => '0');
			wrp_to_slv.hwrite <= isWrite(bus_to_wrp.hwrite);
		    wrp_to_slv.hsize <= isSize(bus_to_wrp.hsize);
		   end if;
                
                  
		   
		   if(load_data = '1') then
		     wrp_to_slv.hwdata <= bus_to_wrp.hwdata;
		   end if;
		   
		   if(write_data = '1') then --and writing = '0') then --simplifying slave agent to behave equally to read and write the 0 out for read and 0 resp for write must now be handled in master
		    hrdata <= slv_to_wrp.hrdata;
                --   elsif(write_data = '1' and writing = '1') then
                 --   hrdata <= x"00000000";
		   end if;
		   

		   
        end if;
	 end if;  
end process;


state_c : process(section, nextsection, slv_to_wrp_notify_tmp, wrp_to_slv_notify_tmp, slv_to_wrp_sync, wrp_to_slv_sync, bus_to_wrp)
begin
nextsection <= section;
slv_to_wrp_notify_comb <= slv_to_wrp_notify_tmp;
wrp_to_slv_notify_comb <= wrp_to_slv_notify_tmp;
load_addr <= '0';
load_data <= '0';
write_data <= '0';
writing_c <= writing;

case section is
 when idle_phase => 
   if(bus_to_wrp.hsel = '1' and bus_to_wrp.hready = '1') then
     if(bus_to_wrp.htrans = nonseq) then
	   load_addr <= '1';
	--   if(bus_to_wrp.hwrite = '1') then
	     nextsection <= data;
        --     writing_c <= '1';
	--   else
	--     nextsection <= to_slv;
	--	 wrp_to_slv_notify_comb <= true;
	  -- end if;
	 end if;
   end if;
 when data =>
    load_data <= '1';
    nextsection <= to_slv;
	wrp_to_slv_notify_comb <= true;
 when to_slv =>
   if(wrp_to_slv_notify_tmp = true and wrp_to_slv_sync = true) then
    nextsection <= from_slv;
	slv_to_wrp_notify_comb <= true;
    wrp_to_slv_notify_comb <= false;
   end if;
 when from_slv =>
    if(slv_to_wrp_notify_tmp = true and slv_to_wrp_sync = true) then
	  slv_to_wrp_notify_comb <= false;
	  write_data <= '1';
          writing_c <= '0';
	  if(slv_to_wrp.hresp = error_resp) then
	    nextsection <= error_phase;
      elsif(slv_to_wrp.hresp = ok_resp) then
	      nextsection <= idle_phase;
	  end if;
	end if;
 when error_phase =>
   if(bus_to_wrp.htrans = nonseq and bus_to_wrp.hsel = '1') then -- and bus_to_wrp.hwrite = AHB_WRITES ) then
      nextsection <= data;
      writing_c <= '1';
      load_addr <= '1';
    else
      nextsection <= idle_phase;
     end if;
 when others => null;

end case;


end process;



end slvwrp;
