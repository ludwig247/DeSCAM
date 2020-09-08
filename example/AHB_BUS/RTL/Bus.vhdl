library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;
use IEEE.math_real.all;


entity Bus_Channel is
  port(
  clk                   : in std_logic;
  rst		            : in std_logic;
  master0_write		    : in bus_req_t;
  master0_read		    : out bus_resp_t;
  master0_sync          : in bool;
  master0_notify        : out bool;
  master1_write		    : in bus_req_t;
  master1_read		    : out bus_resp_t;
  master1_sync          : in bool;
  master1_notify        : out bool;
  slave0_read           : out bus_req_t;
  slave0_read_sync      : in bool;
  slave0_read_notify    : out bool;
  slave0_write          : in bus_resp_t;
  slave0_write_sync     : in bool;
  slave0_write_notify   : out bool;
  slave1_read           : out bus_req_t;
  slave1_read_sync      : in bool;
  slave1_read_notify    : out bool;
  slave1_write          : in bus_resp_t;
  slave1_write_sync     : in bool;
  slave1_write_notify   : out bool
  );
end Bus_Channel;

architecture Bus_arch of Bus_Channel is
  --Signals
  signal fromReset      : bool;
  signal state_sig      : states;
  signal master_id_sig  : Signed(31 downto 0);
  signal slave_id_sig   : Signed(31 downto 0);
  signal req_sig        : bus_req_t;
  signal resp_sig       : bus_resp_t;

  begin
    behaviour : process(clk)
    variable state      : states;
    variable master_id  : Signed(31 downto 0);
    variable slave_id   : Signed(31 downto 0);
    variable req        : bus_req_t;
    variable resp       : bus_resp_t;
    begin
      if(clk='1' and clk'event) then
        if rst = '1' then
          --signal reset
          fromReset <= true;
          state_sig <= MASTER_REQ;
          master_id_sig <= to_signed(10,32);
          slave_id_sig <= to_signed(10,32);
          req_sig <= req_init;
          resp_sig <= resp_init;

          --variable reset
          state                 := MASTER_REQ;
          master_id             := to_signed(10,32);
          slave_id              := to_signed(10,32);
          req                   := req_init;
          resp                  := resp_init;
          --output reset
          master0_read          <= resp_init;
          master0_notify        <= false;
          master1_read          <= resp_init;
          master1_notify        <= false;
          slave0_read           <= req_init;
          slave0_read_notify    <= false;
          slave0_write_notify   <= false;
          slave1_read           <= req_init;
          slave1_read_notify    <= false;
          slave1_write_notify   <= false;

        else
          --always unset notify signals by default
          master0_notify        <= false;
          master1_notify        <= false;
          slave0_read_notify    <= false;
          slave0_write_notify   <= false;
          slave1_read_notify    <= false;
          slave1_write_notify   <= false;

          fromReset <= false;

          state     := state_sig;
          master_id := master_id_sig;
          slave_id  := slave_id_sig;
          req       := req_sig;
          resp      := resp_sig;

          if (state = MASTER_REQ) then
            if(master1_sync = true) then
                master_id := to_signed(1,32);
                if(master1_write.haddr >= SLAVE0_START and master1_write.haddr < SLAVE0_END) then
                    slave_id := to_signed(0,32);
                else
                    slave_id := to_signed(1,32);
                end if;
                req := master1_write;
                state := SLAVE_REQ;
            end if;
            if(master0_sync = true) then
                master_id := to_signed(0,32);
                if(master0_write.haddr >= SLAVE0_START and master0_write.haddr < SLAVE0_END) then
                    slave_id := to_signed(0,32);
                else
                    slave_id := to_signed(1,32);
                end if;
                req := master0_write;
                state := SLAVE_REQ;
            end if;
          end if;
          if (state = SLAVE_REQ) then
            if(slave0_read_sync = true and slave_id = 0) then
                slave0_read         <= req;
                slave0_read_notify  <= true;
                state := SLAVE_RESP;
            elsif(slave1_read_sync = true and slave_id = 1) then
                slave1_read         <= req;
                slave1_read_notify  <= true;
                state := SLAVE_RESP;
            end if;
          end if;
          if (state = SLAVE_RESP) then
            if(slave0_write_sync = true and slave_id = 0) then
                resp := slave0_write;
                slave0_write_notify <= true;
                state := MASTER_RESP;
            elsif(slave1_write_sync = true and slave_id = 1) then
                resp := slave1_write;
                slave1_write_notify <= true;
                state := MASTER_RESP;
            end if;
          end if;
          if (state = MASTER_RESP) then
            if(master0_sync = true and master_id = 0) then
                master0_read <= resp;
                master0_notify <= true;
                state := MASTER_REQ;
                slave_id := to_signed(10,32);
                master_id := to_signed(10,32);
            elsif(master1_sync = true and master_id = 1) then
                master1_read <= resp;
                master1_notify <= true;
                state := MASTER_REQ;
                slave_id := to_signed(10,32);
                master_id := to_signed(10,32);
            end if;
          end if;

          state_sig     <= state;
          master_id_sig <= master_id;
          slave_id_sig  <= slave_id;
          req_sig       <= req;
          resp_sig      <= resp;

        end if;
      end if;
    end process behaviour;
  end Bus_arch;

