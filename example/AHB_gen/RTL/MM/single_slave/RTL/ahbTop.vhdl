library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.ahb_package.all;


entity ahbTop is
port(
	clk:		in std_logic;
	rst:		in std_logic;
	master_in0:		in CUtoAHB_IF;
	master_in0_sync:	 in Boolean;
	master_in0_notify:	 out Boolean;
	master_out0:		out AHBtoCU_IF;
	master_out0_sync:	 in Boolean;
	master_out0_notify:	 out Boolean;
	master_in1:		in CUtoAHB_IF;
	master_in1_sync:	 in Boolean;
	master_in1_notify:	 out Boolean;
	master_out1:		out AHBtoCU_IF;
	master_out1_sync:	 in Boolean;
	master_out1_notify:	 out Boolean;
	slave_in0:		in AHBtoCU_IF;
	slave_in0_sync:	 in Boolean;
	slave_in0_notify:	 out Boolean;
	slave_out0:		out CUtoAHB_IF;
	slave_out0_sync:	 in Boolean;
	slave_out0_notify:	 out Boolean
);
end ahbTop;

architecture top of ahbTop is

component ahb_matrix 
port(
hresetn: in std_logic;
hclk: in std_logic;	

ahb_mst_0_out: in mst_out_t;
ahb_mst_0_in: out mst_in_t;

ahb_mst_1_out: in mst_out_t;
ahb_mst_1_in: out mst_in_t;

ahb_slv_0_out: in slv_out_t;
ahb_slv_0_in: out slv_in_t;

remap: in std_logic
);
end component;


component masterWrapper
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
end component;

component slaveWrapper
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
end component;

signal mst_to_mtx0 : mst_out_t;
signal mtx_to_mst0 : mst_in_t;
signal mst_to_mtx1 : mst_out_t;
signal mtx_to_mst1 : mst_in_t;

signal slv_to_mtx0 : slv_out_t;
signal mtx_to_slv0 : slv_in_t;


signal rstn : std_logic;
signal remap : std_logic;




begin


rstn <= not(rst);
remap <= '0';


mtx : ahb_matrix port map (
hresetn => rstn,
hclk => clk,

ahb_mst_0_out => mst_to_mtx0,
ahb_mst_0_in => mtx_to_mst0,

ahb_mst_1_out => mst_to_mtx1,
ahb_mst_1_in => mtx_to_mst1,

ahb_slv_0_out => slv_to_mtx0,
ahb_slv_0_in => mtx_to_slv0,


remap => remap
);

mst0 : masterWrapper port map (
    clk => clk,
    rst => rst, 
    mst_to_wrp => master_in0,
    mst_to_wrp_sync => master_in0_sync,
    mst_to_wrp_notify => master_in0_notify,
    wrp_to_bus => mst_to_mtx0,
	bus_to_wrp => mtx_to_mst0,
	wrp_to_mst => master_out0,
	wrp_to_mst_sync => master_out0_sync,
	wrp_to_mst_notify => master_out0_notify
);

mst1 : masterWrapper port map (
    clk => clk,
    rst => rst, 
    mst_to_wrp => master_in1,
    mst_to_wrp_sync => master_in1_sync,
    mst_to_wrp_notify => master_in1_notify,
    wrp_to_bus => mst_to_mtx1,
	bus_to_wrp => mtx_to_mst1,
	wrp_to_mst => master_out1,
	wrp_to_mst_sync => master_out1_sync,
	wrp_to_mst_notify => master_out1_notify
);

slv0 : slaveWrapper generic map(ADDR_OFFSET => x"00000000") port map(
    clk => clk,
    rst => rst, 
	   wrp_to_slv => slave_out0,
  wrp_to_slv_sync => slave_out0_sync,
wrp_to_slv_notify => slave_out0_notify,
       slv_to_wrp => slave_in0,
  slv_to_wrp_sync => slave_in0_sync,
slv_to_wrp_notify => slave_in0_notify,
	   bus_to_wrp => mtx_to_slv0,
	   wrp_to_bus => slv_to_mtx0

);



end top;

