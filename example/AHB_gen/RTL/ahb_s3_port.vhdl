library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 


entity ahb_lite_s3 is
generic(
P_NUM : Integer := 3;
P_HSEL0_START : unsigned(31 downto 0) := x"00000000";
P_HSEL0_SIZE : unsigned(31 downto 0) :=  x"00010000";
P_HSEL1_START : unsigned(31 downto 0) :=  x"10000000";
P_HSEL1_SIZE : unsigned(31 downto 0) :=  x"00010000";
P_HSEL2_START : unsigned(31 downto 0) :=  x"20000000";
P_HSEL2_SIZE : unsigned(31 downto 0) :=  x"00010000"
);
port(
       HRESETn: in std_logic;
          HCLK: in std_logic;
       M_HADDR: in unsigned(31 downto 0);
      M_HTRANS: in unsigned(1 downto 0);
      M_HWRITE: in unsigned(0 downto 0);
      M_HSIZE: in unsigned(2 downto 0);
      M_HBURST: in unsigned(2 downto 0);
      M_HPROT: in unsigned(3 downto 0);
      M_HWDATA: in unsigned(31 downto 0);
      M_HRDATA: out unsigned(31 downto 0);
      M_HRESP: out unsigned(1 downto 0);
      M_HREADY: out unsigned(0 downto 0);
      S_HADDR: out unsigned(31 downto 0);
      S_HTRANS: out unsigned(1 downto 0);
      S_HSIZE: out unsigned(2 downto 0);
      S_HBURST: out unsigned(2 downto 0);
      S_HPROT: out unsigned(3 downto 0);
      S_HWRITE: out unsigned(0 downto 0);
      S_HWDATA: out unsigned(31 downto 0);
      S_HREADY: out unsigned(0 downto 0);
      S0_HSEL: out unsigned(0 downto 0);
      S0_HREADY: in unsigned(0 downto 0);
      S0_HRESP: in unsigned(1 downto 0);
      S0_HRDATA: in unsigned(31 downto 0);
      S1_HSEL: out unsigned(0 downto 0);
      S1_HREADY: in unsigned(0 downto 0);
      S1_HRESP: in unsigned(1 downto 0);
      S1_HRDATA: in unsigned(31 downto 0);
      S2_HSEL: out unsigned(0 downto 0);
      S2_HREADY: in unsigned(0 downto 0);
      S2_HRESP: in unsigned(1 downto 0);
      S2_HRDATA: in unsigned(31 downto 0);
      REMAP:  in unsigned(0 downto 0)
); 
end ahb_lite_s3;


architecture ahbls3 of ahb_lite_s3 is

component ahb_decoder_s3
port(
HADDR : in unsigned(31 downto 0);
HSELd : out unsigned(0 downto 0); -- default slave
HSEL0 : out unsigned(0 downto 0);
HSEL1 : out unsigned(0 downto 0);
HSEL2 : out unsigned(0 downto 0);
REMAP :  in unsigned(0 downto 0)
);
end component;

component ahb_s2m_s3
port(
HRESETn : in std_logic;
HCLK : in std_logic;
HSELd : in unsigned(0 downto 0);
HSEL0 : in unsigned(0 downto 0);
HSEL1 : in unsigned(0 downto 0);
HSEL2 : in unsigned(0 downto 0);
HRDATA : out unsigned(31 downto 0);
HRESP : out unsigned(1 downto 0);
HREADY : out unsigned(0 downto 0);
HRDATA0 : in unsigned(31 downto 0);
HRESP0 : in unsigned(1 downto 0);
HREADY0 : in unsigned(0 downto 0);
HRDATA1 : in unsigned(31 downto 0);
HRESP1 : in unsigned(1 downto 0);
HREADY1 : in unsigned(0 downto 0);
HRDATA2 : in unsigned(31 downto 0);
HRESP2 : in unsigned(1 downto 0);
HREADY2 : in unsigned(0 downto 0);
HRDATAd : in unsigned(31 downto 0);
HRESPd : in unsigned(1 downto 0);
HREADYd : in unsigned(0 downto 0)
);

end component;

component ahb_default_slave
port(
HRESETn : in std_logic;
HCLK : in std_logic;
HSEL : in unsigned(0 downto 0);
HADDR : in unsigned(31 downto 0);
HTRANS : in unsigned(1 downto 0);
HWRITE : in unsigned(0 downto 0);
HSIZE : in unsigned(2 downto 0);
HBURST : in unsigned(2 downto 0);
HWDATA : in unsigned(31 downto 0);
HRDATA : out unsigned(31 downto 0);
HRESP : out unsigned(1 downto 0);
HREADYin : in unsigned(0 downto 0);
HREADYout : out unsigned(0 downto 0)
);
end component;



signal HSELd : unsigned(0 downto 0); -- default slave
signal HRDATAd : unsigned(31 downto 0);
signal HRESPd : unsigned(1 downto 0);
signal HREADYd : unsigned(0 downto 0);
signal M_HREADY_SIG : unsigned(0 downto 0);

signal S0_HSEL_SIG : unsigned(0 downto 0);
signal S1_HSEL_SIG : unsigned(0 downto 0);
signal S2_HSEL_SIG : unsigned(0 downto 0);


begin
S_HADDR  <= M_HADDR;
S_HTRANS <= M_HTRANS;
S_HSIZE  <= M_HSIZE;
S_HBURST <= M_HBURST;
S_HWRITE <= M_HWRITE;
S_HPROT  <= M_HPROT;
S_HWDATA <= M_HWDATA;
S_HREADY <= M_HREADY_SIG;
M_HREADY <= M_HREADY_SIG;
S0_HSEL <= S0_HSEL_SIG;
S1_HSEL <= S1_HSEL_SIG;
S2_HSEL <= S2_HSEL_SIG;


dec : ahb_decoder_s3 port map (
HADDR => M_HADDR,
HSELd => HSELd,
HSEL0 => S0_HSEL_SIG,
HSEL1 => S1_HSEL_SIG,
HSEL2 => S2_HSEL_SIG,
REMAP => REMAP
);

mux : ahb_s2m_s3 port map(
HRESETn => HRESETn,
HCLK => HCLK,
HSELd => HSELd,
HSEL0 => S0_HSEL_SIG,
HSEL1 => S1_HSEL_SIG,
HSEL2 => S2_HSEL_SIG,
HRDATA => M_HRDATA,
HRESP => M_HRESP,
HREADY => M_HREADY_SIG, 
HRDATA0 => S0_HRDATA,
HRESP0 => S0_HRESP, 
HREADY0 => S0_HREADY,
HRDATA1 => S1_HRDATA,
HRESP1 => S1_HRESP, 
HREADY1 => S1_HREADY,
HRDATA2 => S2_HRDATA,
HRESP2 => S2_HRESP, 
HREADY2 => S2_HREADY,
HRDATAd => HRDATAd,
HRESPd => HRESPd, 
HREADYd => HREADYd
);

dslv : ahb_default_slave port map (
HRESETn => HRESETn,
HCLK => HCLK, 
HSEL => HSELd, 
HADDR => M_HADDR, 
HTRANS => M_HTRANS, 
HWRITE => M_HWRITE, 
HSIZE => M_HSIZE, 
HBURST => M_HBURST, 
HWDATA => M_HWDATA,
HRDATA => HRDATAd, 
HRESP => HRESPd, 
HREADYin => M_HREADY_SIG, 
HREADYout => HREADYd
);


end ahbls3;

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;


entity ahb_decoder_s3 is
    


generic(
P_NUM : Integer := 3;
P_HSEL0_START : unsigned(31 downto 0) := x"00000000";
P_HSEL0_SIZE : unsigned(31 downto 0) := x"00010000";
P_HSEL0_END : unsigned(31 downto 0) := x"00010000";
P_HSEL1_START : unsigned(31 downto 0) := x"10000000";
P_HSEL1_SIZE : unsigned(31 downto 0) := x"00010000";
P_HSEL1_END : unsigned(31 downto 0) := x"10010000";
P_HSEL2_START : unsigned(31 downto 0) := x"20000000";
P_HSEL2_SIZE : unsigned(31 downto 0) := x"00010000";
P_HSEL2_END : unsigned(31 downto 0) := x"20010000"
);
port(
HADDR : in unsigned(31 downto 0);
HSELd : out unsigned(0 downto 0); -- default slave
HSEL0 : out unsigned(0 downto 0);
HSEL1 : out unsigned(0 downto 0);
HSEL2 : out unsigned(0 downto 0);
REMAP :  in unsigned(0 downto 0)
);
end ahb_decoder_s3;


architecture ahbdec of ahb_decoder_s3 is


signal ihsel : unsigned(2 downto 0);
signal ihseld : unsigned(0 downto 0);
 

begin

ihseld <= to_unsigned(1,1) when ihsel = to_unsigned(0,3) else to_unsigned(0,1);
HSELd <= ihseld;
HSEL0 <= ihsel(1 downto 1) when REMAP = to_unsigned(1,1) else ihsel(0 downto 0);
HSEL1 <= ihsel(0 downto 0) when REMAP = to_unsigned(1,1) else ihsel(1 downto 1);
HSEL2 <= ihsel(2 downto 2);
ihsel(0 downto 0) <= to_unsigned(1,1) when ((P_NUM>0)and(HADDR>=P_HSEL0_START)and(HADDR<P_HSEL0_END)) else to_unsigned(0,1);
ihsel(1 downto 1) <= to_unsigned(1,1) when ((P_NUM>1)and(HADDR>=P_HSEL1_START)and(HADDR<P_HSEL1_END)) else to_unsigned(0,1);
ihsel(2 downto 2) <= to_unsigned(1,1) when ((P_NUM>2)and(HADDR>=P_HSEL2_START)and(HADDR<P_HSEL2_END)) else to_unsigned(0,1);
end ahbdec;

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ahb_s2m_s3 is
port(
HRESETn : in std_logic;
HCLK : in std_logic;
HSELd : in unsigned(0 downto 0);
HSEL0 : in unsigned(0 downto 0);
HSEL1 : in unsigned(0 downto 0);
HSEL2 : in unsigned(0 downto 0);
HRDATA : out unsigned(31 downto 0);
HRESP : out unsigned(1 downto 0);
HREADY : out unsigned(0 downto 0);
HRDATA0 : in unsigned(31 downto 0);
HRESP0 : in unsigned(1 downto 0);
HREADY0 : in unsigned(0 downto 0);
HRDATA1 : in unsigned(31 downto 0);
HRESP1 : in unsigned(1 downto 0);
HREADY1 : in unsigned(0 downto 0);
HRDATA2 : in unsigned(31 downto 0);
HRESP2 : in unsigned(1 downto 0);
HREADY2 : in unsigned(0 downto 0);
HRDATAd : in unsigned(31 downto 0);
HRESPd : in unsigned(1 downto 0);
HREADYd : in unsigned(0 downto 0)
);
end ahb_s2m_s3;

architecture mux of ahb_s2m_s3 is

constant D_HSEL0 : unsigned(3 downto 0) := to_unsigned(1,4);
constant D_HSEL1 : unsigned(3 downto 0) := to_unsigned(2,4);
constant D_HSEL2 : unsigned(3 downto 0) := to_unsigned(4,4);
constant D_HSELd : unsigned(3 downto 0) := to_unsigned(8,4);

signal d_hsel : unsigned(3 downto 0);
signal d_hsel_reg : unsigned(3 downto 0);
signal hreadyout : unsigned(0 downto 0);

begin

d_hsel <= HSELd & HSEL2 & HSEL1 & HSEL0;


process(HCLK)

  begin 
      
     if(HCLK = '1' and HCLK'event) then
	   if(HRESETn = '0') then
        d_hsel_reg <= to_unsigned(0,4);
	   else
	        if(hreadyout = to_unsigned(1,1)) then
		      d_hsel_reg <= d_hsel;
	    	end if;
	 
       end if;
	 end if;
end process;


process(d_hsel_reg, HREADYd, HREADY0, HREADY1, HREADY2)
begin

if(d_hsel_reg = D_HSEL0) then
 HREADY <= HREADY0; 
 hreadyout <= HREADY0;
 elsif(d_hsel_reg = D_HSEL1) then
HREADY <= HREADY1; 
hreadyout <= HREADY1;
 elsif(d_hsel_reg = D_HSEL2) then
HREADY <= HREADY2; 
hreadyout <= HREADY2;
 elsif(d_hsel_reg = D_HSELd) then
HREADY <= HREADYd; 
hreadyout <= HREADYd;
else 
HREADY <= to_unsigned(1,1); 
hreadyout <= to_unsigned(1,1);
end if;

--case(d_hsel_reg) is
--when D_HSEL0 => HREADY <= HREADY0; hreadyout <= HREADY0;
--when D_HSEL1 => HREADY <= HREADY1; hreadyout <= HREADY1;
--when D_HSEL2 => HREADY <= HREADY2; hreadyout <= HREADY2;
--when D_HSELd => HREADY <= HREADYd; hreadyout <= HREADYd;
--when others => HREADY <= to_unsigned(1,1); hreadyout <= to_unsigned(1,1);

--end case;

end process; 


process(d_hsel_reg, HRDATAd, HRDATA0, HRDATA1, HRDATA2)
begin

if(d_hsel_reg = D_HSEL0) then
 HRDATA <= HRDATA0;
 elsif(d_hsel_reg = D_HSEL1) then
HRDATA <= HRDATA1;
 elsif(d_hsel_reg = D_HSEL2) then
HRDATA <= HRDATA2;
 elsif(d_hsel_reg = D_HSELd) then
HRDATA <= HRDATAd;
else 
HRDATA <= to_unsigned(0,32);
end if;

--case (d_hsel_reg) is 
--when D_HSEL0 => HRDATA <= HRDATA0;
--when D_HSEL1 => HRDATA <= HRDATA1;
--when D_HSEL2 => HRDATA <= HRDATA2;
--when D_HSELd => HRDATA <= HRDATAd;
--when others => HRDATA <= to_unsigned(0,32);
--end case;
end process;

process(d_hsel_reg, HRESPd, HRESP0, HRESP1, HRESP2)
begin

if(d_hsel_reg = D_HSEL0) then
 HRESP <= HRESP0;
 elsif(d_hsel_reg = D_HSEL1) then
HRESP <= HRESP1;
 elsif(d_hsel_reg = D_HSEL2) then
HRESP <= HRESP2;
 elsif(d_hsel_reg = D_HSELd) then
HRESP <= HRESPd;
else 
HRESP <= to_unsigned(1, 2);
end if;


--case(d_hsel_reg) is
--when D_HSEL0 => HRESP <= HRESP0;
--when D_HSEL1 => HRESP <= HRESP1;
--when D_HSEL2 => HRESP <= HRESP2;
--when D_HSELd => HRESP <= HRESPd;
--when others => HRESP <= to_unsigned(1, 2);
--end case;

end process;


end mux;

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ahb_default_slave is
port(
HRESETn : in std_logic;
HCLK : in std_logic;
HSEL : in unsigned(0 downto 0);
HADDR : in unsigned(31 downto 0);
HTRANS : in unsigned(1 downto 0);
HWRITE : in unsigned(0 downto 0);
HSIZE : in unsigned(2 downto 0);
HBURST : in unsigned(2 downto 0);
HWDATA : in unsigned(31 downto 0);
HRDATA : out unsigned(31 downto 0);
HRESP : out unsigned(1 downto 0) := to_unsigned(1,2);
HREADYin : in unsigned(0 downto 0);
HREADYout : out unsigned(0 downto 0) := to_unsigned(1,1)
);
end ahb_default_slave;

architecture ds of ahb_default_slave is


type states is (STH_IDLE, STH_WRITE, STH_READ0);


signal state : states := STH_IDLE;


begin

HRDATA <= to_unsigned(0,32);

process(HCLK)

  begin 
          
     if(HCLK = '1' and HCLK'event) then
	  if(HRESETn = '0') then
 		  HRESP <= to_unsigned(0,2);
		  HREADYout <= to_unsigned(1,1);
		  state <= STH_IDLE; 
	  else
		  if(state = STH_IDLE) then
		    if((HSEL = to_unsigned(1,1)) and (HREADYin = to_unsigned(1,1))) then 
		     if((HTRANS = to_unsigned(0,2)) or (HTRANS = to_unsigned(1,2))) then
			    HREADYout <= to_unsigned(1,1);
                HRESP  <= to_unsigned(0,2);				
			    state <= STH_IDLE;
			 elsif((HTRANS = to_unsigned(2,2)) or (HTRANS = to_unsigned(3,2))) then
			    HREADYout <= to_unsigned(0,1);
                HRESP  <= to_unsigned(1,2);	   
				  if(HWRITE = to_unsigned(1,1)) then
				    state <= STH_WRITE;
				  else 
				    state <= STH_READ0;
				  end if;
			 end if;
			 else
			  	HREADYout <= to_unsigned(1,1);
                HRESP  <= to_unsigned(0,2);	
		    end if;
		  end if;
		  
		  
		  if(state = STH_WRITE) then
			  	HREADYout <= to_unsigned(1,1);
                HRESP  <= to_unsigned(1,2);			  
		        state <= STH_IDLE;
		  end if;
		  
		  
		  if(state = STH_READ0) then
			  	HREADYout <= to_unsigned(1,1);
                HRESP  <= to_unsigned(1,2);			  
		        state <= STH_IDLE;		  
		  end if;
		  
		end if;
	 end if;
	 
end process;


end ds;






