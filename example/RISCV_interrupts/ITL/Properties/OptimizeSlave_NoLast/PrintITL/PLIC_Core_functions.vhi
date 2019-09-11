

-- FUNCTIONS --
macro getId(enabled: unsigned;pind_1: boolean;pind_2: boolean;prio_1: unsigned;prio_2: unsigned;traverse_id: unsigned;traverse_prio: unsigned) : unsigned := 
	if ((pind_1 and ((enabled and resize(1,32)) > resize(0,32))) and (pind_2 and ((enabled and resize(2,32)) > resize(0,32))) and (prio_2 > prio_1)) then unsigned(resize(2,32))
	elsif ((pind_1 and ((enabled and resize(1,32)) > resize(0,32))) and (pind_2 and ((enabled and resize(2,32)) > resize(0,32))) and not((prio_2 > prio_1))) then unsigned(resize(1,32))
	elsif ((pind_1 and ((enabled and resize(1,32)) > resize(0,32))) and not((pind_2 and ((enabled and resize(2,32)) > resize(0,32))))) then unsigned(resize(1,32))
	elsif (not((pind_1 and ((enabled and resize(1,32)) > resize(0,32)))) and (pind_2 and ((enabled and resize(2,32)) > resize(0,32))) and (prio_2 > traverse_prio)) then unsigned(resize(2,32))
	elsif (not((pind_1 and ((enabled and resize(1,32)) > resize(0,32)))) and (pind_2 and ((enabled and resize(2,32)) > resize(0,32))) and not((prio_2 > traverse_prio))) then unsigned(traverse_id)
	else unsigned(traverse_id)
end if;
end macro; 

macro getPriority(enabled: unsigned;pind_1: boolean;pind_2: boolean;prio_1: unsigned;prio_2: unsigned;traverse_prio: unsigned) : unsigned := 
	if ((pind_1 and ((enabled and resize(1,32)) > resize(0,32))) and (pind_2 and ((enabled and resize(2,32)) > resize(0,32))) and (prio_2 > prio_1)) then unsigned(prio_2)
	elsif ((pind_1 and ((enabled and resize(1,32)) > resize(0,32))) and (pind_2 and ((enabled and resize(2,32)) > resize(0,32))) and not((prio_2 > prio_1))) then unsigned(prio_1)
	elsif ((pind_1 and ((enabled and resize(1,32)) > resize(0,32))) and not((pind_2 and ((enabled and resize(2,32)) > resize(0,32))))) then unsigned(prio_1)
	elsif (not((pind_1 and ((enabled and resize(1,32)) > resize(0,32)))) and (pind_2 and ((enabled and resize(2,32)) > resize(0,32))) and (prio_2 > traverse_prio)) then unsigned(prio_2)
	elsif (not((pind_1 and ((enabled and resize(1,32)) > resize(0,32)))) and (pind_2 and ((enabled and resize(2,32)) > resize(0,32))) and not((prio_2 > traverse_prio))) then unsigned(traverse_prio)
	else unsigned(traverse_prio)
end if;
end macro; 

macro manageInt_Claim(claimed: unsigned;claimed_status: boolean;pind_id: unsigned;pind_int: boolean) : boolean := 
	if (claimed_status and ((claimed = resize(1,32)) and (pind_id = resize(1,32)))) then (false)
	elsif (claimed_status and not(((claimed = resize(1,32)) and (pind_id = resize(1,32)))) and ((claimed = resize(2,32)) and (pind_id = resize(2,32)))) then (false)
	elsif (claimed_status and not(((claimed = resize(1,32)) and (pind_id = resize(1,32)))) and not(((claimed = resize(2,32)) and (pind_id = resize(2,32))))) then (pind_int)
	else (pind_int)
end if;
end macro; 

