
library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.regmap_env_pkg.ALL;

USE work.myOSA_pkg.ALL;


ENTITY myOSA IS
    GENERIC (
        sdh_rate : integer := sdh_rate_is(stm256_8)
    );
    PORT (
        clk_dp        : IN     std_ulogic; -- data path clock
        reset_dp      : IN     std_ulogic;
        
        data_in       : IN     unsigned(dp_sdh_msb(sdh_rate) DOWNTO 0);
        data_master   : IN     unsigned(dp_sdh_msb(sdh_rate) DOWNTO 0);
        select_master : IN     unsigned(((dp_sdh_msb(sdh_rate)+1)/8) - 1 DOWNTO 0);
        data_out      : BUFFER unsigned(dp_sdh_msb(sdh_rate) DOWNTO 0);

        frm_out       : BUFFER unsigned(frm_sdh_msb(sdh_rate) DOWNTO 0);
        frm_out_pulse : OUT std_ulogic;
        pm_pulse      : IN     std_ulogic;
        sdh_lof       : BUFFER std_ulogic;
        sdh_oof       : BUFFER std_ulogic;

        dlosinh       : BUFFER std_ulogic; -- New port for OSAAIS generation
        lofinh        : BUFFER std_ulogic; -- New port for OSAAIS generation
        osaais        : IN     std_ulogic; -- New port for OSAAIS generation
        osaaisins     : BUFFER std_ulogic; -- New port for OSAAIS generation       

        uc_in         : IN     t_ctlid_to;   --  Data from the CTLID
        uc_out        : BUFFER t_ctlid_from; --  Data to the CTLID
        blk_sel_en    : IN     unsigned(1 DOWNTO 0); --  Block select signal
        regloc        : IN     std_ulogic    --  Asynchronous reset by loc
    );
END myOSA;



ARCHITECTURE str OF myOSA IS

    COMPONENT osa93_reg_wrap
        PORT (                          -- user defined ports
            dlosinh       : BUFFER std_ulogic; -- New port for OSAAIS generation
            ffrmmo        : BUFFER std_ulogic;
            frc_resync    : BUFFER std_ulogic;
            frc_resync_in : IN     std_ulogic;
            lof           : IN     std_ulogic;
            lofese        : IN     std_ulogic;
            lofinh        : BUFFER std_ulogic; -- New port for OSAAIS generation
            lofmo         : BUFFER std_ulogic;
            lofreset      : BUFFER unsigned(4 DOWNTO 0);
            lofset        : BUFFER unsigned(4 DOWNTO 0);
            oof           : IN     std_ulogic;
            oofese        : IN     std_ulogic;
            osaais        : IN     std_ulogic; -- New port for OSAAIS generation
            osaaisins     : BUFFER std_ulogic; -- New port for OSAAIS generation
                                               -- common microcontroller ports
            mc_in         : IN     t_ctlid_to;
            mc_out        : BUFFER t_ctlid_from;
            -- ports to be connected specific for block
            clock         : IN     std_ulogic; -- read reg clock 
            read_reset    : BUFFER std_ulogic; -- regmap reset
            regloc        : IN     std_ulogic; -- loss of clock
            blk_sel_en    : IN     unsigned(1 DOWNTO 0) -- enables
        );
    END COMPONENT;

    component myOSAese is
      port (
        clk_dp : in std_ulogic;
        reset_dp : in std_ulogic;
        new_sync : in std_ulogic; 
        frc_resync : in std_ulogic;
        frc_resync_in : out std_ulogic;
        pm_pulse : in std_ulogic;
        sdh_lof  : in std_ulogic;
        sdh_oof  : in std_ulogic;
        lofese   : out std_ulogic;
        oofese   : out std_ulogic
        );
    end component;

    component myOSAoof
      generic (sdh_rate : integer);
       port (
       clk_dp : in std_ulogic;
       reset_dp : in std_ulogic;
       data_in : in unsigned(dp_sdh_msb(sdh_rate) downto 0);
       data_master : in unsigned(dp_sdh_msb(sdh_rate) downto 0);
       select_master : in unsigned((((dp_sdh_msb(sdh_rate)+1)/8)-1) downto 0);
       ffrmmo : in std_ulogic;
       data_out : buffer unsigned(dp_sdh_msb(sdh_rate) downto 0);
       frm_out : buffer unsigned(frm_sdh_msb(sdh_rate) downto 0);
       frm_out_pulse : out std_ulogic;
       lof_pulse : out std_ulogic;
       new_sync : out std_ulogic; 
       sdh_oof : buffer std_ulogic
       );
    end component;

    component myOSAlof
      generic (sdh_rate : integer);
      port (
        clk_dp : in std_ulogic;
        reset_dp : in std_ulogic;
        lofmo    : in std_ulogic;
        lofset   : in unsigned(4 downto 0);
        lofreset : in unsigned(4 downto 0);
        lof_pulse : in std_ulogic;
        sdh_oof : in std_ulogic;
        sdh_lof : buffer std_ulogic
        );      
    end component;

    constant const_low : std_ulogic := '0';

    SIGNAL e_lof_pulse      : std_ulogic;
    SIGNAL ffrmmo           : std_ulogic;
    SIGNAL lofset           : unsigned(4 DOWNTO 0);
    SIGNAL lofreset         : unsigned(4 DOWNTO 0);
    SIGNAL lofmo            : std_ulogic;
    SIGNAL lofese           : std_ulogic;
    SIGNAL oofese           : std_ulogic;
    SIGNAL new_sync         : std_ulogic;
    SIGNAL frc_resync       : std_ulogic;
    SIGNAL frc_resync_in    : std_ulogic;

BEGIN

      ese_map: myOSAese
        PORT MAP (
            clk_dp           => clk_dp,
            reset_dp         => reset_dp,
            new_sync         => new_sync, --in from oof (needed for frc_resync_in)
            frc_resync       => frc_resync, -- out from uP
            frc_resync_in    => frc_resync_in, --delayed version, in to uP
            pm_pulse => pm_pulse, --global in, once a second pulse
            sdh_lof => sdh_lof,
            sdh_oof => sdh_oof,
            lofese => lofese, --to uP
            oofese => oofese --to uP
        );

    lof_map: myOSAlof
        GENERIC MAP (sdh_rate => sdh_rate)
        PORT MAP (
            clk_dp           => clk_dp,
            reset_dp         => reset_dp,
            lofmo => lofmo, --from uP
            lofset => lofset,--from uP
            lofreset => lofreset,--from uP
            lof_pulse => e_lof_pulse, --from myOSAoof
            sdh_oof => sdh_oof, --from myOSAoof
            sdh_lof => sdh_lof --global out AND to uP
        );


    oof_map: myOSAoof
        GENERIC MAP (sdh_rate => sdh_rate)
        PORT MAP (
            clk_dp           => clk_dp,
            reset_dp         => reset_dp,
            data_in => data_in,
            data_master => data_master,
            select_master => select_master,
            ffrmmo => ffrmmo, --from uP
            data_out => data_out,
            frm_out => frm_out,
            frm_out_pulse => frm_out_pulse,
            lof_pulse => e_lof_pulse, --to lof
            new_sync => new_sync, --needed as output to produce frc_resync_in in ese
            sdh_oof => sdh_oof --global out AND to lof AND to uP
        );


    regmap: osa93_reg_wrap
        PORT MAP (
            dlosinh       => dlosinh,
            ffrmmo        => ffrmmo,
            frc_resync    => frc_resync,
            frc_resync_in => frc_resync_in,
            lof           => sdh_lof,
            lofese        => lofese,
            lofinh        => lofinh,
            lofmo         => lofmo,
            lofreset      => lofreset,
            lofset        => lofset,
            oof           => sdh_oof,
            oofese        => oofese,
            osaais        => osaais,
            osaaisins     => osaaisins,
            mc_in         => uc_in,
            mc_out        => uc_out,
            clock         => clk_dp,
            read_reset    => OPEN,
            regloc        => regloc,
            blk_sel_en    => blk_sel_en
        );

    
END str;


CONFIGURATION myOSA_cfg OF myOSA IS
    FOR str
        FOR ese_map: myOSAese
            USE CONFIGURATION work.myOSAese_cfg;
        END FOR;
        FOR lof_map: myOSAlof
            USE CONFIGURATION work.myOSAlof_cfg;
        END FOR;
        FOR oof_map: myOSAoof
            USE CONFIGURATION work.myOSAoof_cfg;
        END FOR;
        FOR regmap: osa93_reg_wrap
            USE CONFIGURATION work.osa93_reg_wrap_cfg;
        END FOR;
    END FOR;
END myOSA_cfg;

