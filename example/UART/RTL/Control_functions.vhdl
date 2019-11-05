library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

package Control_functions is

function parity_bit(bitcount: unsigned) return unsigned;
function set_tx(data: unsigned) return unsigned;
function countones(reg : unsigned(7 downto 0)) return unsigned; 
function register_RX_event(DR_reg1: unsigned ; DR_reg2: unsigned ; SR_reg2 : unsigned) return unsigned;
function check_interrupt(SR_reg : unsigned ; CR_reg: unsigned) return unsigned;
function manage_RX_flags(SR_reg1: unsigned ; SR_reg2: unsigned) return unsigned;
function manage_TX_flags(flags: unsigned(1 downto 0) ; SR_reg: unsigned) return unsigned;
function tx_action(temp: tx_data ; u_in: CUtoME_IF) return reg_action;
function tx_no_action(temp: tx_data ; flags: unsigned(1 downto 0)) return reg_action;
function register_CR_command(CR_reg : unsigned ; u_in : CUtoME_IF) return unsigned;
function register_SR_command(SR_reg : unsigned ; u_in : CUtoME_IF) return unsigned;
function register_TX_command(DR_reg : unsigned ; u_in : CUtoME_IF) return unsigned;

end package Control_functions;

package body Control_functions is

function parity_bit(bitcount: unsigned) return unsigned is
begin
  
  if((bitcount mod to_unsigned(2,32)) /= ZERO) then
    return PARBIT;
  else
    return ZERO;
  end if;

end parity_bit;

function set_tx(data: unsigned) return unsigned is
begin

  return (resize((data(7 downto 0) & to_unsigned(0,1)),32) or parity_bit(countones(data(7 downto 0))) or STOP_BIT);

end set_tx;


function countones(reg : unsigned(7 downto 0)) return unsigned is
begin

return resize((reg(0 downto 0) and to_unsigned(1,1)),32) + resize((reg(1 downto 1) and to_unsigned(1,1)),32) + resize((reg(2 downto 2) and to_unsigned(1,1)),32) + 
       resize((reg(3 downto 3) and to_unsigned(1,1)),32) + resize((reg(4 downto 4) and to_unsigned(1,1)),32) + resize((reg(5 downto 5) and to_unsigned(1,1)),32) + 
	   resize((reg(6 downto 6) and to_unsigned(1,1)),32) + resize((reg(7 downto 7) and to_unsigned(1,1)),32);


end countones;

function tx_action(temp: tx_data ; u_in: in CUtoME_IF) return reg_action is
begin

if(u_in.addrIn = DR_ADDR AND u_in.req = ME_WR) then  --DR address starts at TX
 return TX_WR;
else
 return temp.r_act;
end if;

end function tx_action;


function tx_no_action(temp: tx_data ; flags: unsigned(1 downto 0)) return reg_action is
begin

if(flags = to_unsigned(1,2)) then
return NA;
else
return temp.r_act;
end if;

end function tx_no_action;

function manage_RX_flags(SR_reg1: unsigned ; SR_reg2: unsigned) return unsigned is
begin

return SR_reg1 or SR_reg2;

end function manage_RX_flags;

function manage_TX_flags(flags: unsigned(1 downto 0) ; SR_reg: unsigned) return unsigned is
begin

if(flags = to_unsigned(2,2)) then
  if((SR_reg(5 downto 5) /= to_unsigned(0,1))) then 
return (SR_reg OR TC_flag OR TXE_flag);
else 
return SR_reg;
end if;
elsif((SR_reg(5 downto 5) = to_unsigned(0,1)) AND (flags = to_unsigned(1,2))) then
return (SR_reg OR TXE_flag);
else 
return SR_reg;
end if;


end function manage_TX_flags;

function register_RX_event(DR_reg1: unsigned ; DR_reg2: unsigned ; SR_reg2: unsigned) return unsigned is
begin



    if((SR_reg2 and RXNE_flag) /= ZERO) then
     return DR_reg1(31 downto 16) & DR_reg2(15 downto 8) & DR_reg1(7 downto 0);
    elsif(((SR_reg2 and PE_flag) /= ZERO) or ((SR_reg2 and FE_flag) /= ZERO)) then
     return DR_reg1(31 downto 24) & DR_reg2(23 downto 16) & DR_reg1(15 downto 0); 
    else 
     return DR_reg1;
    end if;

end function register_RX_event;


function check_interrupt(SR_reg : unsigned ; CR_reg: unsigned) return unsigned is 
begin
    
   if((SR_reg(1 downto 1) = to_unsigned(0,1)) OR (CR_reg(12 downto 12) /= to_unsigned(0,1))) then  -- not IP bit or IP override
      
      if((SR_reg(3 downto 3) = to_unsigned(1,1)) AND (CR_reg(3 downto 3) = to_unsigned(1,1))) then  -- RXNE and RXNEIE
         return to_unsigned(1,32);
      elsif((SR_reg(4 downto 4) = to_unsigned(1,1)) AND (CR_reg(4 downto 4) = to_unsigned(1,1))) then --TC and TCIE
         return to_unsigned(1,32);
      elsif((SR_reg(5 downto 5) = to_unsigned(1,1)) AND (CR_reg(5 downto 5) = to_unsigned(1,1))) then --TXE and TXEIE
         return to_unsigned(1,32);
      elsif((SR_reg(6 downto 6) = to_unsigned(1,1)) AND (CR_reg(6 downto 6) = to_unsigned(1,1))) then --PE and PEIE
         return to_unsigned(1,32);
      elsif((SR_reg(7 downto 7) = to_unsigned(1,1)) AND (CR_reg(7 downto 7) = to_unsigned(1,1))) then --FE and FEIE
         return to_unsigned(1,32);
      else
         return to_unsigned(0,32);
      end if;
   
   else 
    return to_unsigned(0,32);
   end if;
   

end function check_interrupt;




function register_CR_command(CR_reg : unsigned ; u_in : CUtoME_IF) return unsigned is
begin
    
    if((u_in.addrIn = to_unsigned(0,32)) AND (u_in.req = ME_WR) AND (u_in.mask = MT_W)) then --CR reg has address local address 0-3
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

function register_SR_command(SR_reg : unsigned ; u_in : CUtoME_IF) return unsigned is
begin
    
    if((u_in.addrIn = to_unsigned(4,32)) AND (u_in.req = ME_WR) AND (u_in.mask = MT_W)) then
       return SR_reg AND (u_in.dataIn OR SR_MASK);
    elsif((u_in.addrIn = to_unsigned(4,32)) AND (u_in.req = ME_WR) AND ((u_in.mask = MT_H) OR (u_in.mask = MT_HU))) then
       return SR_reg AND (u_in.dataIn OR SR_MASK);
    elsif((u_in.addrIn = to_unsigned(4,32)) AND (u_in.req = ME_WR) AND ((u_in.mask = MT_B) OR (u_in.mask = MT_BU))) then
       return SR_reg(31 downto 8) & (SR_reg(7 downto 0) AND (u_in.dataIn(7 downto 0) OR to_unsigned(40,8))); --SR_MASK
    elsif((u_in.addrIn = to_unsigned(5,32)) AND (u_in.req = ME_WR) AND ((u_in.mask = MT_B) OR (u_in.mask = MT_BU))) then
       return (SR_reg(31 downto 16) & (SR_reg(15 downto 8) AND (u_in.dataIn(7 downto 0))) & SR_reg(7 downto 0));
    elsif((u_in.addrIn = to_unsigned(4,32)) AND (u_in.req = ME_RD) AND (u_in.mask = MT_W)) then
       return SR_reg AND not(TC_flag) AND not(PE_flag) AND  not(FE_flag);
    elsif((u_in.addrIn = to_unsigned(4,32)) AND  (u_in.req = ME_RD) AND ((u_in.mask = MT_H) OR (u_in.mask = MT_HU))) then
       return SR_reg AND not(TC_flag) AND not(PE_flag) AND  not(FE_flag);
    elsif((u_in.addrIn = to_unsigned(4,32)) AND (u_in.req = ME_RD) AND ((u_in.mask = MT_B) OR (u_in.mask = MT_BU))) then
       return SR_reg AND not(TC_flag) AND not(PE_flag) AND  not(FE_flag);
    elsif((u_in.addrIn = to_unsigned(8,32)) AND (u_in.req = ME_RD) AND ((u_in.mask = MT_W) OR (u_in.mask = MT_H) OR (u_in.mask = MT_HU))) then
       return (SR_reg AND not(RXNE_flag));
    elsif((u_in.addrIn = to_unsigned(9,32)) AND (u_in.req = ME_RD) AND ((u_in.mask = MT_B) OR (u_in.mask = MT_BU))) then
       return (SR_reg AND not(RXNE_flag));
    elsif((u_in.addrIn = to_unsigned(8,32)) AND (u_in.req = ME_WR)  AND (u_in.mask /= MT_X)) then  
       return (SR_reg AND not(TXE_flag));
    else
       return SR_reg;
    end if;


end function register_SR_command;

function register_TX_command(DR_reg : unsigned ; u_in : CUtoME_IF) return unsigned is
begin
    
    if((u_in.addrIn = DR_ADDR) AND (u_in.req = ME_WR)  AND (u_in.mask /= MT_X)) then
       return (DR_reg(31 downto 8) & u_in.dataIn(7 downto 0));
    else
       return DR_reg;
    end if;


end function register_TX_command;



end package body Control_functions;
