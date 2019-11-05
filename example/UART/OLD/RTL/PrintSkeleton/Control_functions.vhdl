library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

package Control_functions is

function register_RX_event(DR_reg1: in unsigned ; regs_2: in reg_files) return unsigned;
function check_interrupt(SR_reg : in unsigned ; CR_reg: in unsigned) return unsigned;
function align_flag(reg : in unsigned(31 downto 0) ; flag : in unsigned(31 downto 0)) return unsigned;
function align_control(reg : in unsigned(31 downto 0) ; ctrl : in unsigned(31 downto 0)) return unsigned;
function manage_RX_flags(SR_reg1: in unsigned ; reg_2: in reg_files) return unsigned;
function manage_TX_flags(flags: in tx_flag_values ; SR_reg: in unsigned) return unsigned;
function tx_action(temp: in tx_data ; u_in: in CUtoME_IF) return reg_action;
function tx_no_action(temp: in tx_data ; flags: in tx_flag_values) return reg_action;
function register_CR_command(CR_reg : in unsigned ; u_in : in CUtoME_IF) return unsigned;
function register_SR_command(SR_reg : in unsigned ; u_in : in CUtoME_IF) return unsigned;
function register_TX_command(DR_reg : in unsigned ; u_in : in CUtoME_IF) return unsigned;

end package Control_functions;

package body Control_functions is

function tx_action(temp: in tx_data ; u_in: in CUtoME_IF) return reg_action is
begin

if(u_in.addrIn = to_unsigned(8,32) AND u_in.req = ME_WR) then
 return TX_WR;
else
 return temp.r_act;
end if;

end function tx_action;


function tx_no_action(temp: in tx_data ; flags: in tx_flag_values) return reg_action is
begin

if(flags.txe_flag = SET) then
return NA;
else
return temp.r_act;
end if;

end function tx_no_action;

function manage_RX_flags(SR_reg1: in unsigned ; reg_2: in reg_files) return unsigned is
begin

 if(reg_2.r_act = RX_WR) then
 return (SR_reg1 OR reg_2.SR_reg);
 else 
 return SR_reg1;
 end if;

end function manage_RX_flags;

function manage_TX_flags(flags: in tx_flag_values ; SR_reg: in unsigned) return unsigned is
begin

if(flags.tc_flag = SET AND ((SR_reg(5 downto 5) /= to_unsigned(0,1)) OR (flags.txe_flag = SET))) then
return (SR_reg OR to_unsigned(16, 32) OR to_unsigned(32,32));
elsif((SR_reg(5 downto 5) = to_unsigned(0,1)) AND (flags.txe_flag = SET)) then
return (SR_reg OR to_unsigned(32,32));
else 
return SR_reg;
end if;


end function manage_TX_flags;

function register_RX_event(DR_reg1: in unsigned ; regs_2: in reg_files) return unsigned is
begin



    if(regs_2.r_act = RX_WR) then
     return DR_reg1(31 downto 16) & regs_2.DR_reg(15 downto 8) & DR_reg1(7 downto 0);
    else
     return DR_reg1;
    end if;

end function register_RX_event;


function check_interrupt(SR_reg : in unsigned ; CR_reg: in unsigned) return unsigned is 
begin
    
   if((SR_reg(1 downto 1) = to_unsigned(0,1)) OR (CR_reg(12 downto 12) /= to_unsigned(0,1))) then
      
      if((SR_reg(3 downto 3) = to_unsigned(1,1)) AND (CR_reg(3 downto 3) = to_unsigned(1,1))) then
         return to_unsigned(1,32);
      elsif((SR_reg(4 downto 4) = to_unsigned(1,1)) AND (CR_reg(4 downto 4) = to_unsigned(1,1))) then
         return to_unsigned(1,32);
      elsif((SR_reg(5 downto 5) = to_unsigned(1,1)) AND (CR_reg(5 downto 5) = to_unsigned(1,1))) then
         return to_unsigned(1,32);
      elsif((SR_reg(6 downto 6) = to_unsigned(1,1)) AND (CR_reg(6 downto 6) = to_unsigned(1,1))) then
         return to_unsigned(1,32);
      elsif((SR_reg(7 downto 7) = to_unsigned(1,1)) AND (CR_reg(7 downto 7) = to_unsigned(1,1))) then
         return to_unsigned(1,32);
      else
         return to_unsigned(0,32);
      end if;
   
   else 
    return to_unsigned(0,32);
   end if;
   

end function check_interrupt;


function align_flag(reg : in unsigned(31 downto 0) ; flag : in unsigned(31 downto 0)) return unsigned is
begin
 
if(flag = to_unsigned(1, 32)) then
 return to_unsigned(0,31) & reg(0 downto 0);
elsif(flag = to_unsigned(2, 32)) then
 return to_unsigned(0,31) & reg(1 downto 1);
else 
 return to_unsigned(0,32);
end if;

end function align_flag;


function align_control(reg : in unsigned(31 downto 0) ; ctrl : in unsigned(31 downto 0)) return unsigned is
begin
 
if(ctrl = to_unsigned(256, 32)) then
 return to_unsigned(0,30) & reg(9 downto 8);
elsif(ctrl = to_unsigned(1024, 32)) then
 return to_unsigned(0,30) & reg(11 downto 10);
else 
return to_unsigned(0,32);
end if;

end function align_control;



function register_CR_command(CR_reg : in unsigned ; u_in : in CUtoME_IF) return unsigned is
begin
    
    if((u_in.addrIn = to_unsigned(0,32)) AND (u_in.req = ME_WR) AND (u_in.mask = MT_W)) then
       return u_in.dataIn;
    elsif((u_in.addrIn = to_unsigned(0,32)) AND 
          (u_in.req = ME_WR) AND ((u_in.mask = MT_H) OR (u_in.mask = MT_HU))) then
       return CR_reg(31 downto 16) & u_in.dataIn(15 downto 0); 
    elsif((u_in.addrIn = to_unsigned(2,32)) AND 
          (u_in.req = ME_WR) AND ((u_in.mask = MT_H) OR (u_in.mask = MT_HU))) then
       return u_in.dataIn(15 downto 0) & CR_reg(15 downto 0);
    elsif((u_in.addrIn = to_unsigned(0,32)) AND 
          (u_in.req = ME_WR) AND ((u_in.mask = MT_B) OR (u_in.mask = MT_BU))) then
       return CR_reg(31 downto 8) & u_in.dataIn(7 downto 0);
    elsif((u_in.addrIn = to_unsigned(1,32)) AND 
          (u_in.req = ME_WR) AND ((u_in.mask = MT_B) OR (u_in.mask = MT_BU))) then
       return CR_reg(31 downto 16) & u_in.dataIn(7 downto 0) & CR_reg(7 downto 0);
    elsif((u_in.addrIn = to_unsigned(2,32)) AND 
          (u_in.req = ME_WR) AND ((u_in.mask = MT_B) OR (u_in.mask = MT_BU))) then
       return CR_reg(31 downto 24) & u_in.dataIn(7 downto 0) & CR_reg(15 downto 0);
    elsif((u_in.addrIn = to_unsigned(3,32)) AND 
          (u_in.req = ME_WR) AND ((u_in.mask = MT_B) OR (u_in.mask = MT_BU))) then
        return u_in.dataIn(7 downto 0) & CR_reg(23 downto 0); 
    else
       return CR_reg;
    end if;


end function register_CR_command;

function register_SR_command(SR_reg : in unsigned ; u_in : in CUtoME_IF) return unsigned is
begin
    
    if((u_in.addrIn = to_unsigned(4,32)) AND (u_in.req = ME_WR) AND (u_in.mask = MT_W)) then
       return SR_reg AND (u_in.dataIn OR to_unsigned(40,32));
    elsif((u_in.addrIn = to_unsigned(4,32)) AND (u_in.req = ME_WR) AND ((u_in.mask = MT_H) OR (u_in.mask = MT_HU))) then
       return SR_reg AND (u_in.dataIn OR to_unsigned(40,32));
    elsif((u_in.addrIn = to_unsigned(4,32)) AND (u_in.req = ME_WR) AND ((u_in.mask = MT_B) OR (u_in.mask = MT_BU))) then
       return SR_reg(31 downto 8) & (SR_reg(7 downto 0) AND (u_in.dataIn(7 downto 0) OR to_unsigned(40,8)));
    elsif((u_in.addrIn = to_unsigned(5,32)) AND (u_in.req = ME_WR) AND ((u_in.mask = MT_B) OR (u_in.mask = MT_BU))) then
       return (SR_reg(31 downto 16) & (SR_reg(15 downto 8) AND (u_in.dataIn(7 downto 0))) & SR_reg(7 downto 0));
    elsif((u_in.addrIn = to_unsigned(4,32)) AND (u_in.req = ME_RD) AND (u_in.mask = MT_W)) then
       return SR_reg AND not(to_unsigned(16,32)) AND not(to_unsigned(64,32)) AND  not(to_unsigned(128,32));
    elsif((u_in.addrIn = to_unsigned(4,32)) AND  (u_in.req = ME_RD) AND ((u_in.mask = MT_H) OR (u_in.mask = MT_HU))) then
       return SR_reg AND not(to_unsigned(16,32)) AND not(to_unsigned(64,32)) AND  not(to_unsigned(128,32));
    elsif((u_in.addrIn = to_unsigned(4,32)) AND (u_in.req = ME_RD) AND ((u_in.mask = MT_B) OR (u_in.mask = MT_BU))) then
       return SR_reg AND not(to_unsigned(16,32)) AND not(to_unsigned(64,32)) AND  not(to_unsigned(128,32));
    elsif((u_in.addrIn = to_unsigned(8,32)) AND (u_in.req = ME_RD) AND ((u_in.mask = MT_W) OR (u_in.mask = MT_H) OR (u_in.mask = MT_HU))) then
       return (SR_reg AND not(to_unsigned(8,32)));
    elsif((u_in.addrIn = to_unsigned(9,32)) AND (u_in.req = ME_RD) AND ((u_in.mask = MT_B) OR (u_in.mask = MT_BU))) then
       return (SR_reg AND not(to_unsigned(8,32)));
    elsif((u_in.addrIn = to_unsigned(8,32)) AND (u_in.req = ME_WR)  AND (u_in.mask /= MT_X)) then  
       return (SR_reg AND not(to_unsigned(32, 32)));
    else
       return SR_reg;
    end if;


end function register_SR_command;

function register_TX_command(DR_reg : in unsigned ; u_in : in CUtoME_IF) return unsigned is
begin
    
    if((u_in.addrIn = to_unsigned(8,32)) AND (u_in.req = ME_WR)  AND (u_in.mask /= MT_X)) then
       return (DR_reg(31 downto 8) & u_in.dataIn(7 downto 0));
    else
       return DR_reg;
    end if;


end function register_TX_command;



end package body Control_functions;
