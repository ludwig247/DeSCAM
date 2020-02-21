//Generate reset property from constructor
FIFO<T>::FIFO (const char *name, unsigned int size) :
        sc_prim_channel(name),
        fifo_size(size),
        state(EMPTY),
        tail(0),
        head(0)
{
    buffer = new T[size];
}

property reset is
assume:
	reset_sequence;
prove:
	at t: state_empty;
	at t: buffer(0) = resize(0,32);
	at t: buffer(1) = resize(0,32);
	at t: buffer(2) = resize(0,32);
	at t: head = resize(0,32);
	at t: tail = resize(0,32);
	at t: consumer_notify = false;
	at t: producer_notify = false;
	at t: consumer_sig = 0;
end property;

//Generate operation properties
struct Property{
  //assumptions
  A={},
  //commitments
  C={};
}
//possible states
S = {EMPTY,FILLED,FULL};
//function calls
I = {read,write, etc.};
//generate all possible permutions of function calls that could happen
F = generate_all_permutations(I);
//all properties
Property P[|S|*|F|];

//loop index
i=0;
for each state in S
{
  //Inner loop index
  j=0;
  for each permutation in F
  {
    //correct index in property array
    current = i+j;

    //add state
    P[current].A.add("at t: state = ",state);

    //communication ports
    //Write Access? -> producer_sync and producer_notify
    if permutation.contains("write"){
      P[current].A.add("at t: producer_sync = true;");
      P[current].C.add("at t_end: producer_notify = true;");
    }
    else{
      P[current].A.add("at t: producer_sync = false;");
      P[current].C.add("at t_end: producer_notify = false;");
    }
    //Read Access? -> consumer_sync and consumer_notify
    if permutation.contains("read"){
      P[current].A.add("at t: consumer_sync = true;");
      P[current].C.add("at t_end: consumer_notify = true");
    }
    else{
      P[current].A.add("at t: consumer_sync = false;");
      P[current].C.add("at t_end: consumer_notify = false");
    }

    //data path

    //Inner loop increment
    j++;
  }
  //Outer loop Increment
  i=i+4; //4=|F|
}

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



//data path ???
//conditions: e.g. if state = EMPTY, write is not possible
//consequences: e.g. if write is executed, input is stored at head and head is incremented
//if (p.write){
//add conditions for write to A; add consequences for write to C;
//}
//else {
//add conditions for no write to A; add consequences for no write to C;
//};
//if (p.read){
//add conditions for read to A; add consequences for read to C;
//}
//else{
//add conditions for no read to A; add consequences for no read to C;
//};
//if (mismatch between conditions and state) delete property; else save P;
