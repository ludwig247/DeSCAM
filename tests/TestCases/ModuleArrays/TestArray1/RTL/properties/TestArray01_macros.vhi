-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro m_in_sync : boolean := m_in_sync_d end macro;
macro m_out_sync : boolean := m_out_sync_d end macro;
macro m_in_notify : boolean := m_in_notify_d end  macro;
macro m_out_notify : boolean := m_out_notify_d end  macro;


-- DP SIGNALS --
macro m_in_sig : signed := m_in end macro;
macro m_out_sig : signed := m_out end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --


-- STATES --
macro state_1 : boolean := (currentstate = IDLE) end macro;
macro state_2 : boolean := (currentstate = WRITEVALUE) end macro;


