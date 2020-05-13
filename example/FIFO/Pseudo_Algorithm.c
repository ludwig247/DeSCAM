
generate reset property from SystemC constructor or config file
states_to_check  = {initial_state};
state set S = {initial_state};

while (!states_to_check.empty())
  for each p in permutation
    Property P with assumptions A and commitments C;
    //state variables
    add all state variables to A;

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
          if a statement is a wait(sc_event):
            put f and the current line/node of execution in the blocked set B
            and use the already changed state variables for the next functions
          if a statement is a sc_event.notify():
            put all functions, that are triggered by the event, from B into R
          if f reaches a return remove it from the queue
    }
    store all changes in state variables in commitments C
    check if new state is not equal to one of set S
    then store new state in set states_to_check and add it to S

    store property P and start with next one
  end
  remove state from states_to_check
end

//example

//From constructor or config file
reset_property is
assume:
	reset_sequence;
prove:
at t: state = EMPTY;
at t: head = 0;
at t: tail = 0;
at t: consumer_notify = false; //blocking protocol reset
at t: producer_notify = false; //blocking protocol reset
end ;

//Initial state
S0 = {state = EMPTY, head = 0, tail = 0, consumer_notify = false,  producer_notify = false};
states_to_check = S0;
S = S0;

//Start of loop
states_to_check.empty() == false
p = {!read, write};
generate new Property P with assumptions A and commitments C;

add state variables to A:
at t: state = EMPTY;
at t: head = 0;
at t: tail = 0;

add producer and consumer sync to A and notify to C with regard to p:
at t: producer_sync = true;
at t: consumer_sync = false;
at t_end: producer_notify = true;
at t_end: consumer_notify = false;

ready queue R = {write};
R.empty() == false
scheduler starts evaluating next function of R => write
in S0 wait() is not reached
in S0 notify() is reached
=> activate all other function that wait for this event => no functions
then write reaches return => remove write from R
R.empty() == true
store changes in state variables to C:
at t_end: state = FILLED;
at t_end: head = (head + 1) % fifo_size;
at t_end: tail = tail_at_t;
at t_end: buffer[head_at_t] = val;

new state S1 is not equal to one of the other states (S0)
so add it to states_to_check and add it to S

store Property P in some file

start with next p = {write,read}; //state is still S0

generate new Property P with assumptions A and commitments C;

add state variables to A:
at t: state = EMPTY;
at t: head = 0;
at t: tail = 0;

add producer and consumer sync to A and notify to C with regard to p:
at t: producer_sync = true;
at t: consumer_sync = true;
at t_end: producer_notify = true;
at t_end: consumer_notify = true;

ready queue R = {read, write};
R.empty() == false
scheduler starts evaluating next function of R => read
in S0 we reach wait();
remove read from R and put read into blocked set B and store the line/node of execution
return control to scheduler

scheduler starts evaluating next function of R => write
in S0 wait() is not reached
in S0 notify() is reached
=> activate all other function that wait for this event => put read into R
then write reaches return => remove write from R

scheduler starts evaluating next function of R => read
wait() is not reached
notify() is reached => activate all other functions that wait => no functions
then read reaches return and will be removed from R;

R.empty() == true
store changes in state variables to C:
at t_end: state = EMPTY;
at t_end: (head = (head_at_t + 1) % fifo_size);
at t_end: (tail = (tail_at_t + 1) % fifo_size);
at t_end: buffer[head_at_t] = val;
at t_end: out = val;
at t_end: consumer_notify = true;
at t_end: producer_notify = true;

new state S2 is not equal to S0 or S1
so add it to states_to_check and add it to S

store Property in some file

start with next p

.
.
.
