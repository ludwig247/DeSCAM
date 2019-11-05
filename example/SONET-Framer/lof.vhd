

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

USE work.myOSA_pkg.ALL;

entity myOSAlof is
  generic (sdh_rate : integer := sdh_rate_is(stm256_8));

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
  
end myOSAlof;

architecture arch of myOSAlof is
  --declerations
  signal if_cnt  : unsigned(4 downto 0) := (others => '0');
  signal oof_cnt : unsigned(4 downto 0) := (others => '0');
                                                                  
begin
  --behavior

  -- set lof when the oof_cnt reaches lofset
  -- increase the oof_cnt for each oof and the if for each non-oof
  -- reset the oof_cnt:
    -- mode 0 : when a non-oof comes
    -- mode 1 : when the if_cnt reaches lofreset
  -- reset the if_cnt when a oof comes

  process(clk_dp, reset_dp)
  begin
    if (reset_dp = '1') then
      sdh_lof <= '0';
      if_cnt  <= (others => '0');
      oof_cnt <= (others => '0');
    elsif (rising_edge(clk_dp)) then

      if (lof_pulse = '1') then
        if (sdh_oof = '1') then
          if_cnt <= (others => '0');
          if (oof_cnt < lofset) then
            oof_cnt <= oof_cnt + 1;
          else
            sdh_lof <= '1';
          end if;
        else

          if (lofmo = '0') then --non-integrating mode
            oof_cnt <= (others => '0');
            if (if_cnt < lofreset) then
              if_cnt <= if_cnt + 1;
            else
              sdh_lof <= '0';
            end if;
          else --integrating mode
            if (if_cnt < lofreset) then
              if_cnt <= if_cnt + 1;
            else
              oof_cnt <= (others => '0');
              sdh_lof <= '0';
            end if;
          end if;
          
        end if;
      end if;
     
    end if;
  end process;

  
  
end arch;



CONFIGURATION myOSAlof_cfg OF myOSAlof IS
    FOR arch
    END FOR;
END myOSAlof_cfg;

