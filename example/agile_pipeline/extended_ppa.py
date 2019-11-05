
def compute_next_states(states):
	#1) states is a tuple with an entry of the state of each stage 
	#2) consider all outgoing operations for each stage_state of the tuple 
	#3) the conjunction of all outgoing operation describes the new stage_state


def solve_conflict(operation_s1,operation_s2):

	#1) determine conflicting operation
		#here conflicting means, that one of the operations tries to access a resource that's already in use 
		#if there is a tie, then the "lower" stage gets priority 
	if(self_loop(non_conflicting) && staring_state(conflicting) == wait-state):
		#split conflicting operation into two operarions:
			#1. operation starting and ending in start_state of conflicting operation
				#with assumptions of nc-operation
			#2. original conflicting-operation with assumptions of non-conflicting operation
	else: 
		#1) create a wait state
		#2)split conflicting operation into three operations:
			#1. operation starting in start_state of conflicting operation and ending in wait-state
				#with assumptions of nc-operation and c-operation
			#2. operation starting and ending in the states of the conflicting operation:
				#with assumptions of !nc-operation and c-operation
			#3. operation starting in wait and ending in end_state of conflicting with no assumptions


def states computeEPPA(states,PPA):
	for state in states:
		operations = all_pairs_of_operations(state)
		for operation in operations:
			next_state = compute_next_state(operation)
			if next_state not in states:	
					if(conflicting(next_state)):
						solve_conflict(PPA,operation)
						return states
					else:
						new_states =+ next_state
	return new_states;	
	
	



states += state_after_reset()
states_old = {}
while(states_old<states):
	states_old = states
	new_states = computeEPPA(new_states)
	states += new_states




########################################
#1
states = [(A,W)]
operations = [(2,8),(3,8)]
	(2,8): next_state = (A,A)
			conflicting! solve_conflict((2,8))

#2
states = [(A,W)]
operations = [(2,9),(3,10)]
	(3,10): next_state = (B,A)
		conflicting! solve_conflict((3,10))
#3
states = [(A,W)]
operations = [(2,9),(3,10)]
	(3,11): next_state = (B,W2)

#4
states = [(B,W2)]
operations = [(4,13),(5,13)]
	(4,13): next_state = (B,B)
	conflicting! solve_conflict((4,13))
	

