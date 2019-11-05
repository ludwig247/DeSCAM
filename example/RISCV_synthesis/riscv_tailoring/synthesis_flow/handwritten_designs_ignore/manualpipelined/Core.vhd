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
        COtoME_port_sig        : out CUtoME_IF;
        COtoME_port_sync   : in  boolean;
        COtoME_port_notify : out boolean;
        MEtoCO_port_sig        : in  MEtoCU_IF;
        MEtoCO_port_sync   : in  boolean;
        MEtoCO_port_notify : out boolean
    );
end Core;


architecture Core_arch of Core is

    --------------- CONTROL UNIT ----------------
    component Control_unit is
        port(
            clk                : in  std_logic;
            rst                : in  std_logic;

            CUtoME_port_sig        : out CUtoME_IF;
            CUtoME_port_sync   : in  boolean;
            CUtoME_port_notify : out boolean;
            MEtoCU_port_sig        : in  MEtoCU_IF;
            MEtoCU_port_sync   : in  boolean;
            MEtoCU_port_notify : out boolean;

            CUtoDE_port_sig        : out CUtoDE_IF;
            DEtoCU_port_sig        : in  DEtoCU_IF;

            CUtoDP_port_sig        : out CUtoDP_IF;
            CUtoDP_port_notify : out boolean;
            DPtoCU_port_sig        : in  DPtoCU_IF
        );
    end component;

    ------------------ DECODER ------------------
    component Decoder is
        port(
            CUtoDE_port_sig        : in  CUtoDE_IF;
            DEtoCU_port_sig        : out DEtoCU_IF
        );
    end component;

    ----------------- DATA PATH -----------------
    component Data_path is
        port(
            clk                : in  std_logic;
            rst                : in  std_logic;
            CUtoDP_port_sig        : in  CUtoDP_IF;
            CUtoDP_port_sync   : in  boolean;
            DPtoCU_port_sig        : out DPtoCU_IF
        );
    end component;

    ------------------ SIGNALS ------------------
    signal CUtoDE_port_sig : CUtoDE_IF;
    signal DEtoCU_port_sig : DEtoCU_IF;
    signal CUtoDP_port_sig : CUtoDP_IF;
    signal CUtoDP_comm     : boolean;
    signal DPtoCU_port_sig : DPtoCU_IF;

begin

    --------------- INSTANTIATION ---------------
    CU: Control_unit
        port map (
            clk                => clk,
            rst                => rst,
            CUtoME_port_sig        => COtoME_port_sig,
            CUtoME_port_sync   => COtoME_port_sync,
            CUtoME_port_notify => COtoME_port_notify,
            MEtoCU_port_sig        => MEtoCO_port_sig,
            MEtoCU_port_sync   => MEtoCO_port_sync,
            MEtoCU_port_notify => MEtoCO_port_notify,
            CUtoDE_port_sig        => CUtoDE_port_sig,
            DEtoCU_port_sig        => DEtoCU_port_sig,
            CUtoDP_port_sig        => CUtoDP_port_sig,
            CUtoDP_port_notify => CUtoDP_comm,
            DPtoCU_port_sig        => DPtoCU_port_sig
        );

    DE: Decoder
        port map (
            CUtoDE_port_sig        => CUtoDE_port_sig,
            DEtoCU_port_sig        => DEtoCU_port_sig
        );

    DP: Data_path
        port map (
            clk                => clk,
            rst                => rst,
            CUtoDP_port_sig        => CUtoDP_port_sig,
            CUtoDP_port_sync   => CUtoDP_comm,
            DPtoCU_port_sig        => DPtoCU_port_sig
        );

end Core_arch;
