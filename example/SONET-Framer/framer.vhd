


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

USE work.myOSA_pkg.ALL;


------------SDH RATES---------------------
 --   stm0_1    --NOT SUPPORTED
 --   stm1_1    --NOT SUPPORTED
 --   stm4_1
 --   stm4_4    --NOT SUPPORTED
 --   stm16_4
 --   stm16_16  --NOT SUPPORTED
 --   stm64_4   --(also supported in orig)
 --   stm64_16
 --   stm256_8  --(also supported in orig)
 --   stm256_16
 --   stm16_1
 --   stm16_2
------------------------------------------

entity myOSAoof is
  generic (sdh_rate : integer := sdh_rate_is(stm256_8));

  port (
    clk_dp : in std_ulogic;
    reset_dp : in std_ulogic;

--    data_valid : in std_ulogic; --Do not understand what the use of such a
--    signal should be in this context. It is also not meantioned in the spec.
--    Therefore left it out

    data_in : in unsigned(dp_sdh_msb(sdh_rate) downto 0);
    data_master : in unsigned(dp_sdh_msb(sdh_rate) downto 0);
    select_master : in unsigned((((dp_sdh_msb(sdh_rate)+1)/8)-1) downto 0);

    ffrmmo : in std_ulogic;

    data_out : buffer unsigned(dp_sdh_msb(sdh_rate) downto 0);
    frm_out : buffer unsigned(frm_sdh_msb(sdh_rate) downto 0);
    
    frm_out_pulse : out std_ulogic; --from spec: "pulse which indicates the
                                       --position before the first byte of a
                                       --fram" ---I guess it is set high in the
                                       --clock cycle before the frm_out=0
    --frm_in_pulse : out std_ulogic; --indicates that next byte is the first
                                      --byte of the INPUT datapath frame....
                                      --hmmm, is there any delay here? delay
                                      --removed so replace with a single
                                      --frm_pulse? NOT WELL DEFINED SINCE THE
                                      --INCOMING BYTE IS POSSIBLY UNALIGNED...,
                                      --what can possibly be the use of this?
    lof_pulse : out std_ulogic; --row 0, coloumn 3 (from spec), cycle 0 
                                --..so it works for all rates

    new_sync : out std_ulogic; -- needed for the generation of frc_resync_in
    
    sdh_oof : buffer std_ulogic
    );
  
end myOSAoof;

architecture arch of myOSAoof is
  
  --declerations

  type t_mode is (FRAMESEARCH, PROVE_SYNC, SYNC);
  signal mode : t_mode := FRAMESEARCH;
    
  signal data_muxed_in : unsigned(dp_sdh_msb(sdh_rate) downto 0);

  signal databuffer : unsigned(dp_sdh_msb(sdh_rate) + dp_sdh_msb(sdh_rate) downto 0);--two words minus 1, bit needed for data_out

  signal alignfound : integer range 0 to dp_sdh_msb(sdh_rate);-- needed_frm_buffersize(sdh_rate) - c_framemarker'LENGTH;
  signal last_alignfound : integer range 0 to dp_sdh_msb(sdh_rate);-- needed_frm_buffersize(sdh_rate) - c_framemarker'LENGTH;
  signal markerfound : bit := '0';

  signal curr_align : integer range 0 to dp_sdh_msb(sdh_rate);--needed_frm_buffersize(sdh_rate) - c_framemarker'LENGTH;

  signal miss_cnt : integer range 0 to 4;

  signal expect_at : unsigned(frm_sdh_msb(sdh_rate) downto 0); --stores the expected position, needed for ffrmmo (else always 0)

  signal reset_frm_out : bit := '0';
  
  signal search_enable : bit := '1';
                                                                  
begin
  --behavior

  data_muxed_in <= byte_merge_mux(data_in, data_master, select_master); -- no delay, opposed to the original

  process(clk_dp, reset_dp)
  begin
    if (reset_dp = '1') then
      databuffer <= (others => '0');
    elsif (rising_edge(clk_dp)) then
      databuffer(dp_sdh_msb(sdh_rate) downto 0) <= data_muxed_in;
      
      databuffer(databuffer'LENGTH-1 downto dp_sdh_msb(sdh_rate)+1) <=
        databuffer(dp_sdh_msb(sdh_rate)-1 downto 0);

    end if;
  end process;


  lof_pulse <= frm_is_lofpulse(frm_out, sdh_rate); -- in first cycle when row=0, coloumn=3
  frm_out_pulse <= frm_is_outpulse(frm_out, sdh_rate); --set in last cyle before 0

  --frm_out counter process
  process(clk_dp, reset_dp)
  begin
    if (reset_dp = '1') then
      frm_out <= (others => '0');
    elsif (rising_edge(clk_dp)) then
      if (reset_frm_out='1') then
        frm_out(0) <= '1';
        frm_out(frm_sdh_msb(sdh_rate) downto 1) <= (others => '0');
      else
        frm_out <= increment_frmcnt(frm_out, sdh_rate);        
      end if;
    end if;
  end process;


  --data_out process, realignment of data_muxed_in (taken from databuffer based on curr_align)
  data_out <= databuffer(curr_align + dp_sdh_msb(sdh_rate) downto curr_align);

  --sdh_oof is set everywhere except in SYNC
  sdh_oof <= '0' when mode=SYNC else '1';


  --search for the framemarker
  process(search_enable, databuffer)
    variable markerfound_v : bit;
    variable foundat_v : integer range 0 to dp_sdh_msb(sdh_rate);
  begin
    if (search_enable = '1') then

      markerfound_v := '0';
      foundat_v := 0;

      for i in 0 to dp_sdh_msb(sdh_rate) loop
        
        if (  databuffer(31+i downto i) = c_framemarker) then
          markerfound_v := '1';
          foundat_v := i;
        end if;
        
      end loop;

      if (markerfound_v = '1') then
        markerfound <= '1';
        alignfound <= foundat_v;
      else
        markerfound <= '0';
        alignfound <= 0;
      end if;
        
    else
      markerfound <= '0';
      alignfound <= 0;
    end if;
  end process;

  search_enable <= '1' when mode=FRAMESEARCH else
                   '1' when frm_out = expect_at else
                   '0';
  

  process(clk_dp, reset_dp)
    variable reset_frm_out_var : bit;
  begin
    if (reset_dp = '1') then
      mode <= FRAMESEARCH;
      reset_frm_out <= '0';

      new_sync <= '0';

      expect_at <= (others => '0');
      curr_align <= 0;
      last_alignfound <= 0;
      miss_cnt <= 0;
      
    elsif (rising_edge(clk_dp)) then
      reset_frm_out_var := '0';
      new_sync <= '0';
      
      if (mode = FRAMESEARCH and markerfound='1') then

        mode <= PROVE_SYNC;
        if ffrmmo='1' then --in fast frame mode, reset frm_out directly
          reset_frm_out_var := '1';
          expect_at <= (others => '0');
          curr_align <= alignfound;
        else
          expect_at <= frm_out;
        end if;
        last_alignfound <= alignfound;
        
      elsif (mode = PROVE_SYNC and frm_out = expect_at and reset_frm_out='0') then 
                                                     
        if (markerfound='1' and alignfound = last_alignfound) then
          mode <= SYNC;
          miss_cnt <= 0;
          reset_frm_out_var := '1';
          expect_at <= (others => '0');
          curr_align <= alignfound;
          new_sync <= '1';
        else
          mode <= FRAMESEARCH;
        end if;


      elsif (mode = SYNC  and frm_out = expect_at and reset_frm_out='0') then

        if (markerfound='1' and alignfound = curr_align) then
          mode <= SYNC;
          miss_cnt <= 0;
        else
          if (miss_cnt = 4) then --5 misses in a row then start over
            mode <= FRAMESEARCH;
          else
            miss_cnt <= miss_cnt + 1;
          end if;
        end if;
        
      end if;

      reset_frm_out <= reset_frm_out_var;
    end if; --end rising clk_dp edge
  end process;


  
  
end arch;


CONFIGURATION myOSAoof_cfg OF myOSAoof IS
    FOR arch
    END FOR;
END myOSAoof_cfg;
