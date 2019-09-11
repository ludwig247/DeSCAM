--
-- CREATED BY: SALAHEDDIN HETALANI (salaheddinhetalani@gmail.com) ON 23 OCT, 2018
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Core is
    port(
        clk                : in  std_logic;
        rst                : in  std_logic;
        CUtoME_port        : out CUtoME_IF;
        CUtoME_port_sync   : in  bool;
        CUtoME_port_notify : out bool;
        MEtoCU_port        : in  MEtoCU_IF;
        MEtoCU_port_sync   : in  bool;
        MEtoCU_port_notify : out bool
    );
end Core;


architecture Core_arch of Core is

    --------------- CONTROL UNIT ----------------
    component Control_unit is
        port(
            clk                : in  std_logic;
            rst                : in  std_logic;

            CUtoME_port        : out CUtoME_IF;
            CUtoME_port_sync   : in  bool;
            CUtoME_port_notify : out bool;
            MEtoCU_port        : in  MEtoCU_IF;
            MEtoCU_port_sync   : in  bool;
            MEtoCU_port_notify : out bool;

            CUtoDE_port        : out CUtoDE_IF;
            DEtoCU_port        : in  DEtoCU_IF;

            CUtoDP_port        : out CUtoDP_IF;
            CUtoDP_port_notify : out bool;
            DPtoCU_port        : in  DPtoCU_IF
        );
    end component;

    ------------------ DECODER ------------------
    component Decoder is
        port(
            CUtoDE_port        : in  CUtoDE_IF;
            DEtoCU_port        : out DEtoCU_IF
        );
    end component;

    ----------------- DATA PATH -----------------
    component Data_path is
        port(
            clk                : in  std_logic;
            rst                : in  std_logic;
            CUtoDP_port        : in  CUtoDP_IF;
            CUtoDP_port_sync   : in  bool;
            DPtoCU_port        : out DPtoCU_IF
        );
    end component;

    ------------------ SIGNALS ------------------
    signal CUtoDE_port_sig : CUtoDE_IF;
    signal DEtoCU_port_sig : DEtoCU_IF;
    signal CUtoDP_port_sig : CUtoDP_IF;
    signal CUtoDP_comm     : bool;
    signal DPtoCU_port_sig : DPtoCU_IF;

begin

    --------------- INSTANTIATION ---------------
    CU: Control_unit
        port map (
            clk                => clk,
            rst                => rst,
            CUtoME_port        => CUtoME_port,
            CUtoME_port_sync   => CUtoME_port_sync,
            CUtoME_port_notify => CUtoME_port_notify,
            MEtoCU_port        => MEtoCU_port,
            MEtoCU_port_sync   => MEtoCU_port_sync,
            MEtoCU_port_notify => MEtoCU_port_notify,
            CUtoDE_port        => CUtoDE_port_sig,
            DEtoCU_port        => DEtoCU_port_sig,
            CUtoDP_port        => CUtoDP_port_sig,
            CUtoDP_port_notify => CUtoDP_comm,
            DPtoCU_port        => DPtoCU_port_sig
        );

    DE: Decoder
        port map (
            CUtoDE_port        => CUtoDE_port_sig,
            DEtoCU_port        => DEtoCU_port_sig
        );

    DP: Data_path
        port map (
            clk                => clk,
            rst                => rst,
            CUtoDP_port        => CUtoDP_port_sig,
            CUtoDP_port_sync   => CUtoDP_comm,
            DPtoCU_port        => DPtoCU_port_sig
        );

end Core_arch;
