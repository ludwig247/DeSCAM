DeSCAM - Overview
============
A full documentation is found in

[doc/Manual.pdf](https://github.com/ludwig247/DeSCAM/blob/master/doc/Manual.pdf) 

including:
-   a full explaintion of the desired designflow
-   description of the used SystemC subset
-   semantic understanding of the system-level
-   ideas and concepts of the tool

In the following a short introduction of the tool is provided.

Installation
============

Download the most current version of DeSCAM :

    git clone https://github.com/ludwig247/DeSCAM
    cd DeSCAM
    git fetch --all
    git pull origin master

Make sure your environments provides the following tools:
-   Libraries in /usr/lib or /usr/local: tinfo, z, pthread, dl, rt

-   CMake, version 3.0 or higher,

-   unzip,

-   g++, version 4.8 or higher.

Before installing , open and configure the shell script by providing the
paths to , cmake3 and python3 at the top of the file. 
Afterwards, run the shell script to compile and install. 
Installation is tested with Ubuntu 16.04LTS and Ubuntu 12.04LTS. 



Introduction 
============

This manual describes *Property-Driven Design* (PDD), a new top-down
hardware design methodology. It borrows ideas from so-called
*Test-Driven Development* (TDD), a software design paradigm
aiming at writing high-quality code while maintaining high productivity.
Before we delve into PDD, let us first review TDD and discuss some
important aspects of it.

The core idea of TDD is that before you write code for a function you
need to write the test for that function first. Writing tests guides the
software engineer through the design process. At any point during the
design process, the written code is covered by some test. Initially, the
tests are very abstract, as are the implementations of the functions.
The functions are refined concurrently with the tests, adding more and
more behavior, until the final scope and functionality has been reached.
The flow for designing a new feature with TDD is:

1.  Create tests that describe the desired behavior of the feature.

2.  Choose a test and implement code that fulfills the test.

3.  Check if all previously checked tests are still valid.

4.  Return to *2* until all tests hold on the design.

The software design process is finished when all tests hold for the
design. This approach allows for an incremental software design process
and results in fewer design bugs, complete test coverage and a
documentation of the code.

**Property-Driven Design (PDD)** takes this idea to hardware design.
Tests are replaced by formal properties. However, the designer doesn't
need to write the tests. Instead, abstract properties are generated
automatically from a high-level description. The PDD flow starts with a
verified description of the component at the *Electronic System Level*
(ESL). From this description the tests are generated automatically in
form of interval properties (e.g., SVA,
ITL)by our tool (\"**S**ystem**C** **A**bstract **M**odel\"). When
writing RTL code, the designer only needs to refine the properties by
adding information about data types and clock cycle-accurate timing. The
general flow is similar to TDD: Properties are refined step by step. The
designer chooses a property and implements the hardware that fulfills
the property. Once all properties hold on the design the hardware design
process is finished.

The design entry point of PDD is the ESL.
Te desired flow which consists of three major steps. 
The first step is analyzing the ESL
description with and refactoring it according to the provided feedback.
The resulting model is now considered the golden reference for the
subsequent steps. The second step is the generation of abstract
properties from this model with .

Once the properties are there, the RTL design phase begins. Property by
property is refined and VHDL code is written that implements the
behavior described by the property. Properties are checked, debugged and
eventually proven using commercially available property checking
technology.

One novelty of PDD is that the generated properties ensure that the RTL
design has the same I/O behavior as the ESL design. As explained in our
papers on PDD, the methodology ensures that the ESL description is a
formally proven, sound abstraction of the RTL design. This allows the
designer to use the ESL design as the golden model and verification
results at the system level hold for the RTL without further proof.

This has the advantage that global design decisions can be made already
at the electronic system level. If the ESL design works correctly so
will the RTL design implemented from it. However, also any system-level
bug will appear in the RTL. As ESL and RTL are no longer decoupled, it
is important that the ESL is thoroughly verified before PDD-based RTL
implementation is started.

Section Walk-Through will provide a step-by-step-walk-through
of PDD for a simple example.


Walk-Through {#sec:walk-through}
============

Step 1: ESL Analysis and Refactoring {#sec:walk-through-step1}
------------------------------------

    struct Example: public sc_module{
      //Constructor
      Example(sc_module_name name):
              value(9){SC_THREAD(fsm);}
      SC_HAS_PROCESS(Example);

      //Ports
      blocking_in<int> b_in;
      blocking_out<bool> b_out;

      //Variables
      int value;

      //Finite State Machine
      void fsm(){
      while(true){
        b_in->read(value);
        if(value > 10){
          b_out->write(true);
        }else b_out->write(false);
      }}
    };

The PDD-methodology starts with a system-level design serving as golden
reference for the following design process. Here, SystemC is used as
system-level design entry language. A system is composed of a set of
communicating modules. At the system level the main focus is on
describing and verifying the *communication* between modules. Each of
these modules is later transformed into a set of properties.

The example shows the description of a SystemC module,
named *Example*, with one input and one output. The inputs and outputs
are connected with other modules via *channels* describing the
underlying communication protocol. In this module, the inputs (*b\_in*)
and outputs (*b\_out*) use a *blocking* interface. Blocking, in this
context, means that the underlying communication protocol implements a
four-phase handshake. Thus, the message is transmitted if and only if
both sides are ready for communication.

The behavior of the module is described within the method *fsm* that is
registered as a thread with the SystemC scheduler and is executed
infinitely often. The module reads a value from the input *b\_in* and
stores the result in the variable *value*. If *value* is >*10* the
output port sends *true*, otherwise *false*.

As you might already suspect from examining the example, it is not possible to use arbitrary
SystemC constructs when following the PDD paradigm. Only a certain
subset of SystemC is allowed, and the code needs to follow a certain
structure and coding rules. The reason is that SystemC, per se, does not
have a clear semantics with respect to cycle-accurate RTL
implementation. The semantics need to be introduced by restricting the
use of language constructs to what we call the "designable subset" of
SystemC. This subset will be described and detailed in the following.

Let's continue with our first walk-through of PDD. We assume that our
SystemC module has passed verification on the ESL and is considered
ready for implementation. The SystemC code is analyzed using . We run
the tool from the command line as `DeSCAM --file <path-to-file> -PrintAML` The
following example shows the output of DeSCAM when no errors are found:

    ############################
    Module: Example
    ############################

    ======================
    PPA generation:
    ----------------------
    [...] Metrics of PPA generation

    ======================
    Instances
    ----------------------
    [...] Connection between modules
    [...] No connections for single modules

    ======================
    AML: Example
    ----------------------
    [...] Pseudo-representation of the module

The pseudo-code underneath *\"AML: Example\"* shows an abstract
representation of the module. The language used here is called
*\"Abstract Model Language\"* and is based on the specification
described as 
[EBNF](https://www.eit.uni-kl.de/fileadmin/eis/PPA/designflow/AML-syntax.txt) .
We use this DSL as an intermediate format in our flow.

The file *WalkThrough\_with\_error.h* contains a statement that is not
part of the subset and the output of *DeSCAM* reports the error. If a
statement is found to be not part of the subset it is ignored for the
abstract model.

    ======================
    Errors: Translation of Stmts for module Example
    ----------------------
    - test.push_back(value)
      -E- push_back() is not a supported method!

For example, using a on system level is beneficial when it comes to
executing the simulation on the CPU but it is not transferable to a
hardware system, because memory implementations have a static and known
size. Thus, the statement is reported by DeSCAM as not being part of the
subset. The designer must now make a decision,

-   whether or not the statement is important for the module behavior,

-   whether the SystemC description has to be modified,

-   or whether the statement can be safely ignored as it has no effect
    on the behavior (e.g., a ).

Step 2: Property Generation 
---------------------------

Once the code is stable and deemed ready for RTL implementation, we can
generate the initial set of abstract properties using . This is the
second step of PDD in which we generate the properties with our tool
*DeSCAM*. A single SystemC module or a system of SystemC modules serves as
the input to the tool. The tool parses the files and generates an
abstract model that is used for the generation of the properties. In
order to generate the properties run . The flag invokes property
generation in ITL (*InTerval Language*). ITL is a property specification
language available for the OneSpin property checker. We
support it because the language is quite intuitive and apt to specifying
the kind of properties used in PDD. Of course, also other property
specification languages can be used in PDD. Currently, besides ITL, also
support SystemVerilog Assertion (SVA). For SVA
generation run the tool with the option . For a full list of possible
commands run .

In this section, we will provide only a quick overview over the
generated abstract properties. For a more detailed explanation refer to
the provided manual in doc/. 
In order to link the abstract objects of the system level to a concrete
RTL implementation we introduce *macros*. The RT designer refines these
macros by replacing the with concrete information from the RT design.
For and the following macros are generated:

    -- SYNC AND NOTIFY SIGNALS
    macro b_in_notify :boolean:= MACRO_BODY end macro; 
    macro b_in_sync   :boolean:= MACRO_BODY end macro; 
    macro b_out_notify:boolean:= MACRO_BODY end macro; 
    macro b_out_sync  :boolean:= MACRO_BODY end macro; 
    -- DP SIGNALS -- 
    macro b_in_sig : int := MACRO_BODY end macro; 
    macro b_out_sig : bool := MACRO_BODY end macro; 

There are two types of macros -- synchronization macros for event
signalling, and data path macros for transporting the message content.
The synchronization macro names have the suffixes and . Thes signals are
of Boolean type and implement the four-phase handshake. The generated
data path macro names have the suffix . The return type of these macros
is the type of the transported message. The designer specifies, by
refining these macros, how the abstract message is encoded at the RTL.

The protocol for sending (receiving) a message with a four-phase
handshake is:

-   The writer (reader) set the outgoing notify signal to *true*.

-   The writer (reader) waits until the incoming sync signal evaluates
    to *true*.

-   The message is exchanged by writing (reading) the datapath signal.

-   After message exchange, the writer (reader) unsets the notify signal

-   End of the transmission.

At the system level the handshaking is implicitly implemented through
events and, thus, not visible to the user, whereas at the RTL there has
to be an explicit implementation of the handshaking.

In our methodology, the generated properties capture the full I/O
behavior of the system-level design. The system-level thread is
transformed into a special finite state machine (*FSM*). This FSM
represents a *path predicate abstraction* (*PPA*) 
of the RTL design to be implemented. The states of the FSM represent the
points of communication between modules, and the transitions between
states represent the computations inside the module, as specified by the
properties.

The provided example contains three communication calls
(line 17, 19, 20). For each of these calls, a state is created. These
states are called *important states*, because they represent important
control points of the hardware.

When refining the property suite, the designer needs to fill in the
corresponding state macros in order to specify what conditions in the
RTL hardware represent the states. In order to do so it is allowed to
use internal signals as well as outputs.

    -- STATES -- 
    macro run_0 : boolean :=  end macro;
    macro run_1 : boolean :=  end macro;
    macro run_2 : boolean :=  end macro;

There is a directed edge between two important states if there exists an
execution path between the corresponding communication calls at the
system level. Each edge translates into an interval property describing
the actions taken in the RTL when moving from one important state to the
next. The following property starts in the important state , which is
the state after reset.

    property run_0_read_0 is
    dependencies: no_reset;
    for timepoints:
      t_end = t+1; -- CHANGE HERE
    assume: 
      at t: run_0;
      at t: (b_in_sig >= 11);
      at t: b_in_sync;
    prove:
      at t_end: run_1;
      at t_end: b_out_sig=true;
      during[t+1,t_end]: b_in_notify=false;
      during[t+1,t_end-1]: b_out_notify=false;
      at t_end: b_out_notify = true;
    end property;

The property run\_0\_read\_0 describes the execution path between
line 17 and line 19 of
Figure [\[lst:walk-through\]](#lst:walk-through){reference-type="ref"
reference="lst:walk-through"}.

If the input is available (b\_in\_sync == true) and the input value is
greater or equal 11 the hardware moves to important state . In the value
of is set to *true* and the counterpart is notified by raising . The
property assumes that:

-   The hardware is in state ,

-   a new input is available (b\_in\_sync == true),

-   and the value of the received message is greater or equal 11
    ( >= 11).

Then, it is proven that:

-   The hardware moves to important state ,

-   the value of is set to *true*,

-   and the outgoing message is offered by raising .

The hardware remains in state until the recipient of the message accepts
the handshake and the message is passed.

In case the module has to wait for the communication partner, a *wait*
property is generated automatically for each blocking communication that
enforces the hardware to remain in the same important state until the
respective signal is active.

Step 3: Hardware Implementation {#sec:walk-through-step3}
-------------------------------

Now, the RT designer has the task to specify how the abstract
system-level objects are implemented by the RT-design by filling in the
macros. For example, the macro represents the incoming value. The
designer has full freedom in how to implement a representation of this
data. The designer maps the corresponding RTL signals to the property by
providing a body for this macro.

Let us suppose that the incoming message be transported by the input
signal and, thus, the macro is refined into

    macro b_in_sig : int := 
      RT_design/value_in 
    end macro; 

It could also be that a message is transported by two different RT
signals and the resulting value is the sum of those two signals. The
designer would, accordingly, provide this information in the macro body:

    macro b_in_sig : int := 
      RT_design/input1 + RT_design/input2
    end macro; 

In case there exists no previous implementation, the RT designer has the
option to generate a VHDL template by running . This template contains a
package with all used data types and a bare-bone VHDL implementation
matching the properties. The template is not a synthesized design and
thus doesn't contain any behavioral components.

In order to start the hardware design process, load your VHDL template
or empty design and the accompanying properties with the property
checker. The first property to prove is the reset property. The design
process continues with implementing all operations starting in the
important state after reset. The RT designer refines the important state
macros for the currently implemented operations during the design
process.
