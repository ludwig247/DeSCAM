
/*constraint no_reset :=
  reset_dp = 0;
end constraint;*/

constraint constantConfReg :=
  lofmo = prev(lofmo) and
  lofset = 10 and
  lofreset = 10;
end constraint;


macro NOT_LOF_S : boolean :=
  sdh_lof = 0;
end macro;

macro LOF_S : boolean :=
  sdh_lof = 1;
end macro;


macro OOF_cnt : unsigned :=
  lof_map/oof_cnt;
end macro;

macro IF_cnt : unsigned :=
  lof_map/if_cnt
end macro;



property reset_lof is
dependencies: no_reset;
assume: reset_sequence;
prove:
  at t: OOF_cnt = 0;
  at t: IF_cnt = 0;
  at t: sdh_lof = 0;
  at t: NOT_LOF_S;
right_hook: t;
end property;


property no_pulse is
dependencies: no_reset, constantConfReg;
assume:
  at t: not e_lof_pulse;
prove:
  at t+1: OOF_cnt = prev(OOF_cnt);
  at t+1: IF_cnt = prev(IF_cnt);
  at t+1: sdh_lof = prev(sdh_lof);
  at t+1: if prev(NOT_LOF_S) then NOT_LOF_S; end if;
  at t+1: if prev(LOF_S) then LOF_S; end if;
left_hook: t;
right_hook: t+1;
end property;



property nLOF_if_mode0 is
dependencies: no_reset, constantConfReg;
assume:
  at t: NOT_LOF_S;
  at t: lofmo =0;
  --at t: OOF_cnt <= lofset;
  at t: not sdh_oof;
  at t: e_lof_pulse;
prove:
  at t+1: OOF_cnt = 0;
  at t+1: IF_cnt = if prev(IF_cnt) >= lofreset then prev(IF_cnt); else prev(IF_cnt)+1; end if;
  at t+1: sdh_lof = 0;
  at t+1: NOT_LOF_S;
left_hook: t;
right_hook: t+1;
end property;

property nLOF_if_mode1 is
dependencies: no_reset, constantConfReg;
assume:
  at t: NOT_LOF_S;
  at t: lofmo =1;
  --at t: OOF_cnt <= lofset;
  at t: not sdh_oof;
  at t: e_lof_pulse;
prove:
  at t+1: OOF_cnt = if prev(IF_cnt) >= lofreset then 0; else prev(OOF_cnt); end if;
  at t+1: IF_cnt = if prev(IF_cnt) >= lofreset then prev(IF_cnt); else prev(IF_cnt)+1; end if;
  at t+1: sdh_lof = 0;
  at t+1: NOT_LOF_S;
left_hook: t;
right_hook: t+1;
end property;


property nLOF_oof is
dependencies: no_reset, constantConfReg;
assume:
  at t: NOT_LOF_S;
  at t: e_lof_pulse;
  at t: sdh_oof;
  at t: OOF_cnt < lofset;
prove:
  at t+1: OOF_cnt = prev(OOF_cnt)+1;
  at t+1: IF_cnt = 0;
  at t+1: sdh_lof = 0;
  at t+1: NOT_LOF_S;

left_hook: t;
right_hook: t+1;
end property;

-- This property differs to the original property,
-- additional trigger sdh_oof was added
-- in other words the functionality differs slightly to the original implementation,
-- this is, however, how it was specified!
--(also implies that nLOF_if_mode? is changed from "OOF_cnt < lofset" to "OOF_cnt <= lofset") But that is always true so removed..
property nLOF_to_LOF is
dependencies: no_reset, constantConfReg;
assume:
  at t: NOT_LOF_S;
  at t: e_lof_pulse;
  at t: sdh_oof;
  at t: OOF_cnt >= lofset;
prove:
  at t+1: IF_cnt = if prev(sdh_oof) then 0; else 1; end if;
  at t+1: sdh_lof = 1;
  at t+1: LOF_S;
left_hook: t;
right_hook: t+1;
end property;





property LOF_oof is
dependencies: no_reset, constantConfReg;
assume:
  at t: LOF_S;
  at t: e_lof_pulse;
  at t: sdh_oof;
prove:
  at t+1: IF_cnt = 0;
  at t+1: sdh_lof = 1;
  at t+1: LOF_S;
left_hook: t;
right_hook: t+1;
end property;


property LOF_if is
dependencies: no_reset, constantConfReg;
assume:
  at t: LOF_S;
  at t: e_lof_pulse;
  at t: not sdh_oof;
  at t: IF_cnt < lofreset;
prove:
  at t+1: IF_cnt = prev(IF_cnt)+1;
  at t+1: sdh_lof = 1;
  at t+1: LOF_S;
left_hook: t;
right_hook: t+1;
end property;


property LOF_to_nLOF is
dependencies: no_reset, constantConfReg;
assume:
  at t: LOF_S;
  at t: e_lof_pulse;
  at t: not sdh_oof;
  at t: IF_cnt >= lofreset;
prove:
  at t+1: OOF_cnt = 0;
  at t+1: IF_cnt = prev(IF_cnt);
  at t+1: sdh_lof = 0;
  at t+1: NOT_LOF_S;
left_hook: t;
right_hook: t+1;
end property;







completeness myOSAlof is

dependencies: constantConfReg;

inputs: 
  reset_dp,
  sdh_oof,
  e_lof_pulse,

  lofmo,
  lofset,
  lofreset;

determination_requirements:

  determined(sdh_lof);

  determined(IF_cnt);
  if NOT_LOF_S then
    determined(OOF_cnt);
  end if;

reset_property: reset_lof;

property_graph:
        to_NOT_LOF := reset_lof, no_pulse, nLOF_if_mode0, nLOF_if_mode1, nLOF_oof, LOF_to_nLOF;
	from_NOT_LOF := no_pulse, nLOF_if_mode0, nLOF_if_mode1, nLOF_oof, nLOF_to_LOF;

	to_LOF:= no_pulse, nLOF_to_LOF, LOF_oof, LOF_if;
	from_LOF := no_pulse, LOF_oof, LOF_if, LOF_to_nLOF;


	to_NOT_LOF -> from_NOT_LOF;
	to_LOF -> from_LOF;

end completeness;


