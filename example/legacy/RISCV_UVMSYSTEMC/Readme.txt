Remark 1: "peeking"
    Active agent should have a monitor that's capable of "peeking" on the outgoing message to the DUT without actually disturbing that communication.
    * the issue with the blocking communication for example is that the monitor was preceding the DUT to reading the value, and as a result, the DUT wasn't receiving any
        new value.

Remark 2: Different tests for different sequences
    In the current implementation, the TOP has the one test and it's configuring what sequence to use for this one test. what really should happen is creating different
    tests and each will have a specific sequence. In other words, the TOP will be configuring what tests to run.

Remark 3: reset_phase (s.19)
    In the RTL level, reset states assign values to internal and outgoing signals and verification can see all these signals. But in UVM-SYSTEMC, I don't have access to
    the internal variables and the outgoing signals are abstract in a way that we don't check their notify and sync states.
    * Does the "Register Model" give me the option to look at internal variables of the DUT?
    * What we have access to, at the moment, is the outgoing signals (ports or channels) but checking the state of these signals means checking the "notify" and "sync"
        events of these signals! but those are defined as private members of the port class.

Remark 4: What are we verifying?
    Are we supposed to verify the modules on a SIGNAL level or a FUNCTIONAL level?
    * Giving that, the purpose of SCAM is to abstract the system level description from all timing and communication handshakes and focus on the "behavior or
        functionality" of the module (proof of concept), then what we should be verifying is exactly that! Because SCAM already guarantees the "soundness" of my
        properties generation.

Remark 5: Packing inputs and outputs (s.20)
    On a module level, we can pack all inputs and all outputs on corresponding REQ and RSP sequences.
    * But the packing of signals might result in a unified randomness to all the signals packed together.


Remark 6: Standard C++ container classes (s.22)
    Should we use "stacks" and "heaps" to simulate my memory?

Remark 7: UVM verification component (UVC)
    - A reusable verification component (UVC) is a (sub-) environment which consists of one or more agents.
    - The verification component or agents may set or get configuration parameters.
    - An independent sequence, which contains the actual transaction data, is processed by the driver via a sequencer.
    - Each verification component is connected to the DUT using a dedicated interface.

    * Might use such a method if we want to separate different signal interfaces to the dut with different sequences and sequences's items instead of using a packed
        item style.

Remark 8: UVM virtual sequence
    - A virtual sequence encapsulates one or more sequences, which are executed on the sub-sequencers in each UVC agent, which are all connected to the parent virtual
        sequencer.
        * Remark: So each sequence will be targeting a certain DUT interface (signal) (ex. a sequence for "fromMemory_port" and a sequence for "MEIP_port".
                and it's not possible to give different sequences targeting the same interface. meaning, it's not possible to separate instructions sequence from
                loaded data sequence.
    - A virtual sequence can be configured as default sequence in a test, to facilitate automatic execution on a virtual sequencer or a sequencer which belongs to a UVC
        agent.

Remark 9: UVM virtual sequencer
    - A virtual sequencer contains references to its subsequencers such as UVC sequencers or other virtual sequencers.
    - Virtual sequencers process virtual sequences which encapsulate sequences for multiple verification components.
    - Virtual sequencers do not execute transactions on themselves but ‘offload’ this to its subsequencers

Remark 10: UVM test
    - Each UVM test is defined as a dedicated test class, which instantiates the testbench and defines the test sequence(s).
        * exp. test for Register type instructions
        * in some tests we might change the testbench used. i.e. when we are including interrupts as signals to the DUT.
    - Reuse of tests and topologies is possible by deriving tests from a test base class.
        * creating future test can be much easier because you only need to change the sequences (scenarios) for the test.
    - The configuration and factory concept can be used to configure or override UVM components, sequences or sequence items
        * something like this:
            uvm::uvm_config_db<int>::set(NULL, "tb.*", "seq_type", 1);
            uvm::uvm_config_db<instr_constraint_type>::set(NULL, "tb.*", "constraint_type", Reg_Reg);
    - Tests can be selected (passed) as command line option
        * Thought it's said that this is not yet available in UVM-SystemC but we can do this manually

Remark 10: Testing
    The sequence will be feeding instructions of a program to the DUT as items, and every PROGRAM_SECTION number of instructions it will feeding a number of instructions
    to store the registers contents to a specific memory (or just an instantaneous equality check) with the ones coming from golden model. Later, return to the main
    sequence and continue feeding instructions from the official test_program.
        * This methodology will require assurance that our store instructions work properly, among other types of instructions.

    So, the flow of testing a DUT should be something like the folowing:
        1- run_test("test_S") -> it will insure the possibility for storing (exporting) the registers states to the scoreboard
        2- run_test("test_R")
        3- run_test("test_I_I")
        .....
        x- run_test("test_program1")
        x- run_test("test_program2")
        x- run_test("test_program3")
        x- run_test("FreeRTOS") -> the ultimate goal!!!!


Remark: Structure
    Top -> many tests
        test -> one sequence, one testbench
            testbench -> one virtual sequencer, two UVCs
            sequence -> virtual sequencer -> many UVC_agents_sequencers

