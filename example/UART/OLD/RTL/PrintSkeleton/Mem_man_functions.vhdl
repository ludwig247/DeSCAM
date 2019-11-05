library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

package Mem_man_functions is

function response_data(reg: in reg_files ; req: in CUtoME_IF) return unsigned;

end package Mem_man_functions;

package body Mem_man_functions is

function response_data(reg: in reg_files ; req: in CUtoME_IF) return unsigned is
begin

if((req.addrIn = to_unsigned(0, 32)) AND (req.mask = MT_W)) then
  return to_unsigned(0,32); --reg.CR_reg; what is wrong here? vhi optimizes away these conditions
elsif((req.addrIn = to_unsigned(0, 32)) AND ((req.mask = MT_H) OR (req.mask = MT_HU))) then
  return to_unsigned(0,16) & reg.CR_reg(15 downto 0);
elsif((req.addrIn = to_unsigned(2, 32)) AND ((req.mask = MT_H) OR (req.mask = MT_HU))) then
  return to_unsigned(0,16) & reg.CR_reg(31 downto 16);
elsif((req.addrIn = to_unsigned(0, 32)) AND ((req.mask = MT_B) OR (req.mask = MT_BU))) then
  return to_unsigned(0,24) & reg.CR_reg(7 downto 0);
elsif((req.addrIn = to_unsigned(1, 32)) AND ((req.mask = MT_B) OR (req.mask = MT_BU))) then
  return to_unsigned(0,24) & reg.CR_reg(15 downto 8);
elsif((req.addrIn = to_unsigned(2, 32)) AND ((req.mask = MT_B) OR (req.mask = MT_BU))) then
  return to_unsigned(0,24) & reg.CR_reg(23 downto 16);
elsif((req.addrIn = to_unsigned(3, 32)) AND ((req.mask = MT_B) OR (req.mask = MT_BU))) then
  return to_unsigned(0,24) & reg.CR_reg(31 downto 24);
elsif((req.addrIn = to_unsigned(4, 32)) AND (req.mask = MT_W)) then
  return to_unsigned(0,32); --reg.SR_reg;
elsif((req.addrIn = to_unsigned(4, 32)) AND ((req.mask = MT_H) OR (req.mask = MT_HU))) then
  return to_unsigned(0,16) & reg.SR_reg(15 downto 0);
elsif((req.addrIn = to_unsigned(6, 32)) AND ((req.mask = MT_H) OR (req.mask = MT_HU))) then
  return to_unsigned(0,16) & reg.SR_reg(31 downto 16);
elsif((req.addrIn = to_unsigned(4, 32)) AND ((req.mask = MT_B) OR (req.mask = MT_BU))) then
  return to_unsigned(0,24) & reg.SR_reg(7 downto 0);
elsif((req.addrIn = to_unsigned(5, 32)) AND ((req.mask = MT_B) OR (req.mask = MT_BU))) then
  return to_unsigned(0,24) & reg.SR_reg(15 downto 8);
elsif((req.addrIn = to_unsigned(6, 32)) AND ((req.mask = MT_B) OR (req.mask = MT_BU))) then
  return to_unsigned(0,24) & reg.SR_reg(23 downto 16);
elsif((req.addrIn = to_unsigned(7, 32)) AND ((req.mask = MT_B) OR (req.mask = MT_BU))) then
  return to_unsigned(0,24) & reg.SR_reg(31 downto 24);
elsif((req.addrIn = to_unsigned(8, 32)) AND (req.mask = MT_W)) then
  return to_unsigned(0,32); --reg.DR_reg;
elsif((req.addrIn = to_unsigned(8, 32)) AND ((req.mask = MT_H) OR (req.mask = MT_HU))) then
  return to_unsigned(0,16) & reg.DR_reg(15 downto 0);
elsif((req.addrIn = to_unsigned(10, 32)) AND ((req.mask = MT_H) OR (req.mask = MT_HU))) then
  return to_unsigned(0,16) & reg.DR_reg(31 downto 16);
elsif((req.addrIn = to_unsigned(8, 32)) AND ((req.mask = MT_B) OR (req.mask = MT_BU))) then
  return to_unsigned(0,24) & reg.DR_reg(7 downto 0);
elsif((req.addrIn = to_unsigned(9, 32)) AND ((req.mask = MT_B) OR (req.mask = MT_BU))) then
  return to_unsigned(0,24) & reg.DR_reg(15 downto 8);
elsif((req.addrIn = to_unsigned(10, 32)) AND ((req.mask = MT_B) OR (req.mask = MT_BU))) then
  return to_unsigned(0,24) & reg.DR_reg(23 downto 16);
elsif((req.addrIn = to_unsigned(11, 32)) AND ((req.mask = MT_B) OR (req.mask = MT_BU))) then
  return to_unsigned(0,24) & reg.DR_reg(31 downto 24);
else
return to_unsigned(0,32);
end if;

end function response_data;

end package body Mem_man_functions;