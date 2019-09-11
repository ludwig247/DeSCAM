
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

package myOSA_pkg is

  constant c_framemarker  : unsigned(31 DOWNTO 0):= "11110110111101100010100000101000";
  
  type t_sdh_rate is (
    stm0_1,--NOT SUPPORTED
    stm1_1,--NOT SUPPORTED
    stm4_1,
    stm4_4,--NOT SUPPORTED
    stm16_4,
    stm16_16,--NOT SUPPORTED
    stm64_4,
    stm64_16,
    stm256_8,
    stm256_16,
    stm16_1,
    stm16_2);
  type t_sdh_rate_is is array(t_sdh_rate'LEFT to t_sdh_rate'RIGHT) of integer;

  constant sdh_rate_is : t_sdh_rate_is := (
    stm0_1 => 0,
    stm1_1 => 1,
    stm4_1 => 2,
    stm4_4 => 3,
    stm16_4 => 4,
    stm16_16 => 5,
    stm64_4 => 6,
    stm64_16 => 7,
    stm256_8 => 8,
    stm256_16 => 9,
    stm16_1 => 10,
    stm16_2 => 11);

subtype t_nbr_of_sdh_appl is integer range 0 to 11;
type t_sdh_msb is array(t_nbr_of_sdh_appl) OF natural;


--FRAME COUNTER
-- 9 rows      -> 0 to 8   -> 4bits
-- 270 columns -> 0 to 269 -> 9bits

-- here each block is split additonally in cycles
--> the number of cycles depends on the application
-- e.g., an stm256_8 is a stm256 frame split over 8 cycles
--   (so the datawidth needed would be 256/8)

constant dp_sdh_msb : t_sdh_msb :=
  (0 => 7,   --stm0_1 --NOT SUPPORTED
   1 => 7,   --stm1_1 --NOT SUPPORTED
   2 => 31,  --stm4_1
   3 => 7,   --stm4_4  --NOT SUPPORTED
   4 => 31,  --stm16_4
   5 => 7,   --stm16_16 --NOT SUPPORTED
   6 => 127, --stm64_4
   7 => 31,  --stm64_16
   8 => 255, --stm256_8
   9 => 127, --stm256_16
   10 => 127,--stm16_1
   11 => 63);--stm16_2

CONSTANT frm_sdh_msb : t_sdh_msb :=
  (0 => 10, --stm0_1 : special case ...consider!
   1 => 12, --stm1_1
   2 => 12, --stm4_1
   3 => 14, --stm4_4
   4 => 14,--stm16_4
   5 => 16,--stm16_16
   6 => 14,--stm64_4
   7 => 16,--stm64_16
   8 => 15,--stm256_8
   9 => 16,--stm256_16
   10 => 12,--stm16_1
   11 => 13);--stm16_2


  constant max_cycle : t_sdh_msb :=
  (0 => 0, --stm0_1 : special case ...consider!
   1 => 0, --stm1_1
   2 => 0, --stm4_1
   3 => 3, --stm4_4
   4 => 3,--stm16_4
   5 => 15,--stm16_16
   6 => 3,--stm64_4
   7 => 15,--stm64_16
   8 => 7,--stm256_8
   9 => 15,--stm256_16
   10 => 0,--stm16_1
   11 => 1);--stm16_2


  function byte_merge_mux(
    data_a : in unsigned;
    data_b  : in unsigned;
    mux_sel : in unsigned
    )
    return unsigned;

  function increment_frmcnt(
    cnt     : in unsigned;
    sdh_rate: in integer
    )
    return unsigned;


  function frm_is_lofpulse(
    cnt : in unsigned;
    sdh_rate : in integer
    )
    return std_ulogic;

    function frm_is_outpulse(
    cnt : in unsigned;
    sdh_rate : in integer
    )
    return std_ulogic;
  

end myOSA_pkg;




package body myOSA_pkg is

  function frm_is_lofpulse(
    cnt : in unsigned;
    sdh_rate : in integer
    )
    return std_ulogic is

    begin
      
      ASSERT(cnt'LENGTH = frm_sdh_msb(sdh_rate)+1)
        report "error in frm_is_lofpulse, cnt size missmatch"
        severity failure;

      if (
        cnt(frm_sdh_msb(sdh_rate) downto frm_sdh_msb(sdh_rate)-3) = 0 and           --row 0
        cnt(frm_sdh_msb(sdh_rate)-4 downto frm_sdh_msb(sdh_rate)-12) = 3 and        --coloumn 3
        (frm_sdh_msb(sdh_rate) <= 12 or cnt(frm_sdh_msb(sdh_rate)-13 downto 0) = 0) --row 0
        ) then
          return '1';
        else
          return '0';
        end if;
      
    end function frm_is_lofpulse;


    function frm_is_outpulse(
    cnt : in unsigned;
    sdh_rate : in integer
    )
    return std_ulogic is

    begin
      ASSERT(cnt'LENGTH = frm_sdh_msb(sdh_rate)+1)
        report "error in frm_is_outpulse, cnt size missmatch"
        severity failure;

      if ( -- cycle before 0
        cnt(frm_sdh_msb(sdh_rate) downto frm_sdh_msb(sdh_rate)-3) = 8 and           --row 8
        cnt(frm_sdh_msb(sdh_rate)-4 downto frm_sdh_msb(sdh_rate)-12) = 269 and        --coloumn 269
        (frm_sdh_msb(sdh_rate) <= 12 or cnt(frm_sdh_msb(sdh_rate)-13 downto 0) = max_cycle(sdh_rate)) --row (last)
        ) then
          return '1';
        else
          return '0';
        end if;
      
    end function frm_is_outpulse;


    
  function increment_frmcnt(
    cnt      : in unsigned;
    sdh_rate : in integer
    )
    return unsigned is

    variable tmp : unsigned(cnt'RANGE);
    variable cycle_rollover : bit;
    
    begin

      ASSERT(cnt'LENGTH = frm_sdh_msb(sdh_rate)+1)
        report "error in increment_frmcnt, size missmatch"
        severity failure;


    if (frm_sdh_msb(sdh_rate) > 12) then

      if (cnt(frm_sdh_msb(sdh_rate)-13 downto 0) = max_cycle(sdh_rate)) then
        tmp(frm_sdh_msb(sdh_rate)-13 downto 0) := (others => '0');
        cycle_rollover := '1';
      else
        tmp(frm_sdh_msb(sdh_rate)-13 downto 0) :=
          1 + cnt(frm_sdh_msb(sdh_rate)-13 downto 0);
        tmp(frm_sdh_msb(sdh_rate) downto frm_sdh_msb(sdh_rate)-12) :=
          cnt(frm_sdh_msb(sdh_rate) downto frm_sdh_msb(sdh_rate)-12);
        cycle_rollover := '0';
      end if;
    else
      cycle_rollover := '1';
    end if;

    if (cycle_rollover = '1') then
      if (cnt(frm_sdh_msb(sdh_rate)-4 downto frm_sdh_msb(sdh_rate)-12) = 269) then
        tmp(frm_sdh_msb(sdh_rate)-4 downto frm_sdh_msb(sdh_rate)-12) := (others => '0');

        if (cnt(frm_sdh_msb(sdh_rate) downto frm_sdh_msb(sdh_rate)-3) = 8) then
          tmp(frm_sdh_msb(sdh_rate) downto frm_sdh_msb(sdh_rate)-3) := (others => '0');
        else
          tmp(frm_sdh_msb(sdh_rate) downto frm_sdh_msb(sdh_rate)-3) :=
            1 + cnt(frm_sdh_msb(sdh_rate) downto frm_sdh_msb(sdh_rate)-3);
        end if;
        
      else
        tmp(frm_sdh_msb(sdh_rate)-4 downto frm_sdh_msb(sdh_rate)-12) :=
          1 + cnt(frm_sdh_msb(sdh_rate)-4 downto frm_sdh_msb(sdh_rate)-12);
        tmp(frm_sdh_msb(sdh_rate) downto frm_sdh_msb(sdh_rate)-3) :=
          cnt(frm_sdh_msb(sdh_rate) downto frm_sdh_msb(sdh_rate)-3);
      end if;
    end if;

    return tmp;
        
    end function increment_frmcnt;






  
  
  function byte_merge_mux(
    data_a  : in unsigned;
    data_b  : in unsigned;
    mux_sel : in unsigned
    )
    return unsigned is
        constant nBytes : positive := (data_a'LENGTH) / 8;
        variable toRet         : unsigned(data_a'RANGE);
    begin
      ASSERT((data_a'LENGTH) = (data_b'LENGTH))
        report "error in byte_merge_mux, data of different size"
        severity failure;
      ASSERT(((data_a'LENGTH) rem 8) = 0)
        report "error in byte_merge_mux, size is not a multiple of bytes"
        severity failure;
      ASSERT(mux_sel'LENGTH = nBytes)
        report "error in byte_merge_mux, select signal and data signal of non matching size"
        severity failure;

        toRet           := data_a; --copy of a, replace where 1 with b
        mux_loop: for byteCnt in 0 to nBytes - 1 loop
          if mux_sel(byteCnt) = '1' then
            toRet((byteCnt*8)+7 downto  (byteCnt*8)) := data_b( (byteCnt*8)+7 downto  (byteCnt*8));
          end if;
        end loop mux_loop;

        return toRet;
    end function byte_merge_mux;
        
end myOSA_pkg;
