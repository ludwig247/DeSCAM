


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


--- Functionality simply copied from the original
--- (Simple procedure for error resporting once a second)
entity myOSAese is
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
end myOSAese;



architecture arch of myOSAese is

    SIGNAL s_resync       : std_ulogic;
    SIGNAL s_resync_pulse : std_ulogic;
  
  begin


    resync_reg: PROCESS 

        VARIABLE last_s_resync : std_ulogic;
        
    BEGIN
        WAIT UNTIL clk_dp'EVENT AND clk_dp = '1';
        
        IF reset_dp = '1' THEN
            last_s_resync  := '0';
            frc_resync_in  <= '0';
            s_resync_pulse <= '0';
        --ELSIF data_valid_int = '1' THEN -- Stop processing at 0 (hold values)
          ELSE
            -- edge detection on rising edge of s_resync
            IF last_s_resync = '0' AND s_resync = '1' THEN
                frc_resync_in  <= '1';
                s_resync_pulse <= '1';
            -- feedback if resync done
            --ELSIF sync_found_twice = '1' AND start_new_search <= '0' then
            --in power opt version this is gone, new sync means rather a
            --swithch of modes... from oof
            else if new_sync = '1' then
                frc_resync_in  <= '0';
                s_resync_pulse <= '0';
            ELSE
                s_resync_pulse <= '0';
            END IF;
            -- shift register
            last_s_resync := s_resync;
        END IF;
        end if;
    END PROCESS resync_reg;

    

    

    event_reg: PROCESS

        VARIABLE oof_reg       : std_ulogic;
        VARIABLE lof_reg       : std_ulogic;
        VARIABLE frc_resync_sp : std_ulogic;
        VARIABLE s_pm_pulse    : unsigned(1 DOWNTO 0);

    BEGIN
        WAIT UNTIL clk_dp'EVENT AND clk_dp = '1';
        IF reset_dp = '1' THEN            --  reset values
            oof_reg       := '0';
            lof_reg       := '0';
            oofese        <= '0';
            lofese        <= '0';
            s_resync      <= '0';
            frc_resync_sp := '0';
        ELSE
            -- Synchronizer for frc_resync
            s_resync      <= frc_resync_sp;
            frc_resync_sp := frc_resync;
            -- Event generation on second pulse pm_pulse
            -- update after one second
            IF (s_pm_pulse(0) = '1' AND s_pm_pulse(1) = '0') THEN
                oofese    <= oof_reg;
                lofese    <= lof_reg;
                oof_reg   := '0';
                lof_reg   := '0';
            ELSE
                oofese    <= '0';
                lofese    <= '0';
                IF sdh_oof = '1' THEN   --  store event in one second
                    oof_reg := '1';
                END IF;
                IF sdh_lof = '1' THEN   --  store event in one second
                    lof_reg := '1';
                END IF;
            END IF;
        END IF;
        -- shift pm_pulse into sync_reg
        s_pm_pulse(1) := s_pm_pulse(0);
        s_pm_pulse(0) := pm_pulse;
    END PROCESS event_reg;

end arch;


CONFIGURATION myOSAese_cfg OF myOSAese IS
    FOR arch
    END FOR;
END myOSAese_cfg;
