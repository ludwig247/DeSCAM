library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.wrp_types.all;

entity ahbLite is
port(
	clk:		in std_logic;
	rst:		in std_logic;
	master_in:		in CUtoAHB_IF;
	master_in_sync:	 in Boolean;
	master_in_notify:	 out Boolean;
	master_out:		out AHBtoCU_IF;
	master_out_sync:	 in Boolean;
	master_out_notify:	 out Boolean;
	slave_in0:		in AHBtoCU_IF;
	slave_in0_sync:	 in Boolean;
	slave_in0_notify:	 out Boolean;
	slave_in1:		in AHBtoCU_IF;
	slave_in1_sync:	 in Boolean;
	slave_in1_notify:	 out Boolean;
	slave_in2:		in AHBtoCU_IF;
	slave_in2_sync:	 in Boolean;
	slave_in2_notify:	 out Boolean;
	slave_out0:		out CUtoAHB_IF;
	slave_out0_sync:	 in Boolean;
	slave_out0_notify:	 out Boolean;
	slave_out1:		out CUtoAHB_IF;
	slave_out1_sync:	 in Boolean;
	slave_out1_notify:	 out Boolean;
	slave_out2:		out CUtoAHB_IF;
	slave_out2_sync:	 in Boolean;
	slave_out2_notify:	 out Boolean
);
end ahbLite;


architecture ahb of ahbLite is

component ahb_lite_s3
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
      REMAP: in unsigned(0 downto 0)
); 
end component;

component slaveWrapper
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
end component;

component masterWrapper
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
end component;

signal mToBus_sig : ahb_mst_out;
signal busToS_sig : ahb_slv_in;
signal busToM_sig : ahb_mst_in;


signal s0toBus_sig : ahb_slv_out;
signal s1toBus_sig : ahb_slv_out;
signal s2toBus_sig : ahb_slv_out;
signal busToM : ahb_mst_in;

signal muxSlaveReadyOut : unsigned(0 downto 0);
signal muxMasterReadyOut : unsigned(0 downto 0);

signal s0_sel_sig : unsigned(0 downto 0);
signal s1_sel_sig : unsigned(0 downto 0);
signal s2_sel_sig : unsigned(0 downto 0);

signal remap : unsigned(0 downto 0);

signal rstn : std_logic;

begin

remap <= to_unsigned(0,1);

rstn <= not(rst);


mwrp : masterWrapper port map(clk, rst, master_in, master_in_sync, master_in_notify, mToBus_sig, busToM_sig, master_out, master_out_sync, master_out_notify);

swrp0 : slaveWrapper port map(clk, rst, slave_out0, slave_out0_sync, slave_out0_notify, s0_sel_sig, muxSlaveReadyOut, slave_in0, slave_in0_sync, slave_in0_notify, busToS_sig, s0toBus_sig);

swrp1 : slaveWrapper generic map (ADDR_OFFSET => x"10000000") port map(clk, rst, slave_out1, slave_out1_sync, slave_out1_notify, s1_sel_sig, muxSlaveReadyOut, slave_in1, slave_in1_sync, slave_in1_notify, busToS_sig, s1toBus_sig);

swrp2 : slaveWrapper generic map (ADDR_OFFSET => x"20000000") port map(clk, rst, slave_out2, slave_out2_sync, slave_out2_notify, s2_sel_sig, muxSlaveReadyOut, slave_in2, slave_in2_sync, slave_in2_notify, busToS_sig, s2toBus_sig);

ahb : ahb_lite_s3 port map(
HRESETn => rstn,
HCLK => clk, 
       M_HADDR => mToBus_sig.haddr,
      M_HTRANS => mToBus_sig.htrans,
      M_HWRITE => mToBus_sig.hwrite,
      M_HSIZE => mToBus_sig.hsize,
      M_HBURST => mToBus_sig.hburst,
      M_HPROT => mToBus_sig.hprot,
      M_HWDATA => mToBus_sig.hwdata,
      M_HRDATA => busToM_sig.hrdata,
      M_HRESP => busToM_sig.hresp,
      M_HREADY => busToM_sig.hready,
      S_HADDR => busToS_sig.haddr,
      S_HTRANS => busToS_sig.htrans,
      S_HSIZE => busToS_sig.hsize,
      S_HBURST => busToS_sig.hburst,
      S_HPROT => busToS_sig.hprot,
      S_HWRITE => busToS_sig.hwrite,
      S_HWDATA => busToS_sig.hwdata,
      S_HREADY => muxSlaveReadyOut,
      S0_HSEL => s0_sel_sig,
      S0_HREADY => s0toBus_sig.hreadyout,
      S0_HRESP => s0toBus_sig.hresp,
      S0_HRDATA => s0toBus_sig.hrdata,
      S1_HSEL => s1_sel_sig,
      S1_HREADY => s1toBus_sig.hreadyout,
      S1_HRESP => s1toBus_sig.hresp,
      S1_HRDATA => s1toBus_sig.hrdata,
      S2_HSEL => s2_sel_sig,
      S2_HREADY => s2toBus_sig.hreadyout,
      S2_HRESP => s2toBus_sig.hresp,
      S2_HRDATA => s2toBus_sig.hrdata,
      REMAP => remap
);



end ahb;