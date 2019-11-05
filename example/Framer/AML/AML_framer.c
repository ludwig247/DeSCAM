const int missThreshold_c = 1;

MODULE framer {
  in<int position> marker;
  out<bool> oof;
  
  FSM framer {
    states = {FRMSRCH, PROVE, SYNC};
	var<int> nMiss;
	var<int> alignment;
  @init:
    nextstate = FRMSRCH;
    nMiss = 0;
	oof = true;
	
  @FRMSRCH:
    read(marker);
	if (pending(oof)) { write(oof); }
	alignment = marker.position;
	nextstate = PROVE;
  @PROVE:
    read(marker);
	if (pending(oof)) { write(oof); }
	if (alignment == marker.position) {
	  nMiss = 0;
	  oof = false;
	  nextstate = SYNC;
	} else {
	  nextstate = FRMSRCH;
	}
  @SYNC:
    read(marker);
	if (pending(oof)) { write(oof); }
	if (alignment == marker.position) {
	  nMiss = 0;
	} else {
	  nMiss++;
	  if (nMiss > missThreshold_c) {
	    oof = true;
	    nextstate = FRMSRCH;
	  }
	}
	
  }
};

MODULE monitor {
  in<bool> oof;
  in<bool intmod, int set, int reset> setup;
  out<bool> lof;
	
  FSM behavior {
    states = {REGULAR, INTEGRATING};
    var<int> OOFcnt;
    var<int> IFcnt;
    var<int> set;
    var<int> reset;
  @init:
    nextstate = REGULAR;
    OOFcnt = 0;
    IFcnt = 0;
    lof = false;
    set = 7;
    reset = 7;
  @REGULAR:	
    read(oof);
    if (oof) {
      IFcnt = 0;
      if (OOFcnt >= set) {
        lof = true;
      } else {
        OOFcnt++; }
    } else {
      OOFcnt = 0;
      if (IFcnt >= reset) {
        lof = false;
      } else {
        IFcnt++; }
    }
    write(lof);
    if (pending(setup)){
      read(setup);
      set = setup.set;
      reset = setup.reset;
      if (setup.intmod) {
        nextstate = INTEGRATING; }
    }	
  @INTEGRATING:
    read(oof);
    if (oof) {
      IFcnt = 0;
      if (OOFcnt >= set) {
        lof = true;
      } else {
        OOFcnt++; }
    } else {
      if (IFcnt >= reset) {
        OOFcnt = 0;
        lof = false;
      } else {
        IFcnt++; }
    }
    write(lof);
    if (pending(setup)){
      read(setup);
      set = setup.set;
      reset = setup.reset;
      if (not setup.intmod) {
        nextstate = REGULAR;}
    }
  }
};
