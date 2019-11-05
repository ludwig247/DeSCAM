--
-- CREATED BY: SALAHEDDIN HETALANI (salaheddinhetalani@gmail.com) ON 29 Jan, 2019
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Core is
    port(
        clk                : in  std_logic;
        rst                : in  std_logic;
        COtoME_port        : out COtoME_IF;
        COtoME_port_sync   : in  bool;
        COtoME_port_notify : out bool;
        MEtoCO_port        : in  MEtoCO_IF;
        MEtoCO_port_sync   : in  bool;
        MEtoCO_port_notify : out bool
    );
end Core;


architecture Core_arch of Core is

    --------------- CONTROL UNIT ----------------
    component Control_unit is
        port(
            clk                : in  std_logic;
            rst                : in  std_logic;

            CUtoME_port        : out COtoME_IF;
            CUtoME_port_sync   : in  bool;
            CUtoME_port_notify : out bool;
            MEtoCU_port        : in  MEtoCO_IF;
            MEtoCU_port_sync   : in  bool;
            MEtoCU_port_notify : out bool;

            CUtoDE_port        : out CUtoDE_IF;
            DEtoCU_port        : in  DEtoCU_IF;

            CUtoRF_port        : out CUtoRF_IF;
            CUtoRF_port_notify : out bool;
            RFtoCU_port        : in  RFtoCU_IF;

            CUtoAL_port        : out CUtoAL_IF;
            ALtoCU_port        : in  ALtoCU_IF
        );
    end component;

    ------------------ DECODER ------------------
    component Decoder is
        port(
            CUtoDE_port        : in  CUtoDE_IF;
            DEtoCU_port        : out DEtoCU_IF
        );
    end component;

    ----------------- REGISTER FILE -----------------
    component Register_file is
        port(
            clk                : in  std_logic;
            rst                : in  std_logic;
            CUtoRF_port        : in  CUtoRF_IF;
            CUtoRF_port_sync   : in  bool;
            RFtoCU_port        : out RFtoCU_IF
        );
    end component;

    ------------------ ALU ------------------
    component ALU is
        port(
            CUtoAL_port        : in  CUtoAL_IF;
            ALtoCU_port        : out ALtoCU_IF
        );
    end component;

    ------------------ SIGNALS ------------------
    signal CUtoDE_port_sig : CUtoDE_IF;
    signal DEtoCU_port_sig : DEtoCU_IF;
    signal CUtoRF_port_sig : CUtoRF_IF;
    signal CUtoRF_comm     : bool;
    signal RFtoCU_port_sig : RFtoCU_IF;
    signal CUtoAL_port_sig : CUtoAL_IF;
    signal ALtoCU_port_sig : ALtoCU_IF;

begin

    --------------- INSTANTIATION ---------------
    CU: Control_unit
        port map (
            clk                => clk,
            rst                => rst,
            CUtoME_port        => COtoME_port,
            CUtoME_port_sync   => COtoME_port_sync,
            CUtoME_port_notify => COtoME_port_notify,
            MEtoCU_port        => MEtoCO_port,
            MEtoCU_port_sync   => MEtoCO_port_sync,
            MEtoCU_port_notify => MEtoCO_port_notify,
            CUtoDE_port        => CUtoDE_port_sig,
            DEtoCU_port        => DEtoCU_port_sig,
            CUtoRF_port        => CUtoRF_port_sig,
            CUtoRF_port_notify => CUtoRF_comm,
            RFtoCU_port        => RFtoCU_port_sig,
            CUtoAL_port        => CUtoAL_port_sig,
            ALtoCU_port        => ALtoCU_port_sig
        );

    DE: Decoder
        port map (
            CUtoDE_port        => CUtoDE_port_sig,
            DEtoCU_port        => DEtoCU_port_sig
        );

    RF: Register_file
        port map (
            clk                => clk,
            rst                => rst,
            CUtoRF_port        => CUtoRF_port_sig,
            CUtoRF_port_sync   => CUtoRF_comm,
            RFtoCU_port        => RFtoCU_port_sig
        );

    AL: ALU
        port map (
            CUtoAL_port        => CUtoAL_port_sig,
            ALtoCU_port        => ALtoCU_port_sig
        );

end Core_arch;
