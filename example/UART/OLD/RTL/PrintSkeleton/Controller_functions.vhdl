library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

package C_functions is

function response_data(reg: in reg_files) return unsigned;
function register_SR_event(tcomp: in bool ; regs_1: in reg_files ; regs_2: in reg_files) return unsigned;
function register_RX_event(regs_1: in reg_files ; regs_2: in reg_files) return unsigned;
function clear_SR_flags(reg: in reg_files) return unsigned;
function check_interrupt(reg : in reg_files) return unsigned;
function get_flag(reg : in unsigned(31 downto 0) ; flag : in unsigned(31 downto 0)) return unsigned;
function register_CR_command(regs : in reg_files ; u_in : in CUtoME_IF) return unsigned;
function register_SR_command(regs : in reg_files ; u_in : in CUtoME_IF) return unsigned;
function register_TX_command(regs : in reg_files ; u_in : in CUtoME_IF) return unsigned;
function register_action(u_in : in CUtoME_IF) return reg_action;

end package C_functions;

package body C_functions is

function response_data(reg: in reg_files) return unsigned is
begin

  if(reg.r_act = CR_RD) then
    return reg.CR_reg;
  elsif(reg.r_act = SR_RD) then
    return reg.SR_reg;
  elsif(reg.r_act = RX_RD) then
    return to_unsigned(0,24) & reg.RX_reg;
  else
    return to_unsigned(0,32);
  end if;

end function;

function register_SR_event(tcomp: in bool ; reg_2: in reg_files ; reg_3: in reg_files) return unsigned is
begin

   if((tcomp = true) AND (reg_3.r_act = RX_WR)) then
     return reg_2.SR_reg OR to_unsigned(16, 32) OR reg_3.SR_reg;
   elsif((tcomp = false) AND (reg_3.r_act = RX_WR)) then
    return reg_2.SR_reg OR reg_3.SR_reg;
   elsif((tcomp = true) AND (reg_3.r_act /= RX_WR)) then
    return reg_2.SR_reg OR to_unsigned(16, 32);
   else
    return reg_2.SR_reg;
   end if;

end function register_SR_event;

function register_RX_event(regs_1: in reg_files ; regs_2: in reg_files) return unsigned is
begin

    if(regs_2.r_act = RX_WR) then
     return regs_2.RX_reg;
    else
     return regs_1.RX_reg;
    end if;

end function register_RX_event;

function clear_SR_flags(reg: in reg_files) return unsigned is
begin

if(reg.r_act = SR_RD) then
   return reg.SR_reg AND not(to_unsigned(16,32)) AND not(to_unsigned(64,32)) AND  not(to_unsigned(128,32));
elsif(reg.r_act = RX_RD) then
    return reg.SR_reg AND not(to_unsigned(8, 32));
else
    return reg.SR_reg;
end if;


end function clear_SR_flags;

function check_interrupt(reg : in reg_files) return unsigned is 
begin
    
   if((reg.SR_reg(1 downto 1) = to_unsigned(0,1)) OR (reg.CR_reg(9 downto 9) = to_unsigned(0,1))) then
      
      if((reg.SR_reg(3 downto 3) = to_unsigned(1,1)) AND (reg.CR_reg(3 downto 3) = to_unsigned(1,1))) then
         return to_unsigned(1,1);
      elsif((reg.SR_reg(4 downto 4) = to_unsigned(1,1)) AND (reg.CR_reg(4 downto 4) = to_unsigned(1,1))) then
         return to_unsigned(1,1);
      elsif((reg.SR_reg(5 downto 5) = to_unsigned(1,1)) AND (reg.CR_reg(5 downto 5) = to_unsigned(1,1))) then
         return to_unsigned(1,1);
      elsif((reg.SR_reg(6 downto 6) = to_unsigned(1,1)) AND (reg.CR_reg(6 downto 6) = to_unsigned(1,1))) then
         return to_unsigned(1,1);
      elsif((reg.SR_reg(7 downto 7) = to_unsigned(1,1)) AND (reg.CR_reg(7 downto 7) = to_unsigned(1,1))) then
         return to_unsigned(1,1);
      else
         return to_unsigned(0,1);
      end if;
   
   else 
    return to_unsigned(0,1);
   end if;
   

end function check_interrupt;


function get_flag(reg : in unsigned(31 downto 0) ; flag : in unsigned(31 downto 0)) return unsigned is
begin
  if((reg and flag) /= to_unsigned(0,32)) then
  return to_unsigned(1, 1);
  else
  return to_unsigned(0, 1);
  end if;


end function get_flag;


function register_CR_command(regs : in reg_files ; u_in : in CUtoME_IF) return unsigned is
begin
    
    if((u_in.addrIn = to_unsigned(1,32)) AND (u_in.req = ME_WR) AND (u_in.mask = MT_W)) then
       return u_in.dataIn;
    else
       return regs.CR_reg;
    end if;


end function register_CR_command;

function register_SR_command(regs : in reg_files ; u_in : in CUtoME_IF) return unsigned is
begin
    
    if((u_in.addrIn = to_unsigned(2,32)) AND (u_in.req = ME_WR) AND (u_in.mask = MT_W)) then
       return regs.SR_reg AND (u_in.dataIn OR to_unsigned(40,32));
    elsif((u_in.addrIn = to_unsigned(3,32)) AND (u_in.req = ME_RD) AND (u_in.mask = MT_BU)) then
       return (regs.SR_reg AND not(to_unsigned(8,32)));
    elsif((u_in.addrIn = to_unsigned(4,32)) AND (u_in.req = ME_WR) AND (u_in.mask = MT_BU)) then  
       return (regs.SR_reg AND not(to_unsigned(16, 32)));
    else
       return regs.SR_reg;
    end if;


end function register_SR_command;

function register_TX_command(regs : in reg_files ; u_in : in CUtoME_IF) return unsigned is
begin
    
    if((u_in.addrIn = to_unsigned(4,32)) AND (u_in.req = ME_WR) AND (u_in.mask = MT_BU)) then
       return u_in.dataIn(7 downto 0);
    else
       return regs.TX_reg;
    end if;


end function register_TX_command;

function register_action(u_in : in CUtoME_IF) return reg_action is
begin

    if((u_in.addrIn = to_unsigned(1,32)) AND (u_in.req = ME_WR) AND (u_in.mask = MT_W)) then
       return CR_WR;
    elsif((u_in.addrIn = to_unsigned(1,32)) AND (u_in.req = ME_RD) AND (u_in.mask = MT_W)) then
       return CR_RD;
    elsif((u_in.addrIn = to_unsigned(2,32)) AND (u_in.req = ME_WR) AND (u_in.mask = MT_W)) then
       return SR_WR;
    elsif((u_in.addrIn = to_unsigned(2,32)) AND (u_in.req = ME_RD) AND (u_in.mask = MT_W)) then
       return SR_RD;
    elsif((u_in.addrIn = to_unsigned(3,32)) AND (u_in.req = ME_RD) AND (u_in.mask = MT_BU)) then
       return RX_RD;
    elsif((u_in.addrIn = to_unsigned(4,32)) AND (u_in.req = ME_WR) AND (u_in.mask = MT_BU)) then  
       return TX_WR;
    else
       return NA;
    end if;


end function register_action;

end package body C_functions;

