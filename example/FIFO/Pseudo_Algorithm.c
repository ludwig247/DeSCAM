
generate reset property from SystemC constructor or config file
states_to_check  = {initial_state};

while (!states_to_check.empty())
  for each p in permutation
    Property P;
    assumptions A;
    commitments C;

    //state variables
    add all state variables to A
    //communication ports
    if (p.write) add producer_sync to A; add producer_notify to C;
    else add !producer_sync to A; add !producer_notify to C;
    if (p.read) add consumer_sync to A; add consumer_notify to C;
    else add !consumer_sync to A; add !consumer_notify to C;

    //evaluate AST for current state and function tuple
    create a ready queue R with all functions that are present in the current tuple
    while (!R.empty()){
        invoke scheduler that will start the next function f from R
        evaluate f with current state:
        if a statement is a wait(sc_event): put f and the current line/node of execution in the blocked set B
        if a statement is a sc_event.notify(): put all functions, that are triggered by the event, from B into R
        if f reaches a return remove it from the queue
    }
    store all changes in state variables in commitments C
    check if new state is not equal to one of the existing states
    then store new state in set states_to_check

    store property P and start with next one
  end
  remove state from states_to_check
end
