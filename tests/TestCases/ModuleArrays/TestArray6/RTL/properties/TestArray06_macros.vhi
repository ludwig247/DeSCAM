-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro b_out_sync : boolean := b_out_sync_d end macro;
macro b_out_notify : boolean := b_out_notify_d end  macro;


-- DP SIGNALS --
macro b_out_sig : unsigned := b_out end macro;
macro m_in_sig : unsigned_4 := m_in end macro;
macro m_in_sig_0 : unsigned := m_in(0) end macro;
macro m_in_sig_1 : unsigned := m_in(1) end macro;
macro m_in_sig_2 : unsigned := m_in(2) end macro;
macro m_in_sig_3 : unsigned := m_in(3) end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --


-- STATES --
macro state_1 : boolean := true end macro;


