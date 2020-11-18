--
-- Copyright(c) OneSpin Solutions GmbH all rights reserved
--

library ieee;
use ieee.std_logic_1164.all;

package sdram_types is
  
  type state_t is (idle, ra, row_act, sr1, sr2, sr3, sr4,
                   br1, br2, br3, br4, br5, br6, br7,
                   sw1, bw1, bw2, bw3, bw4, pr);

  subtype ctrl_t is std_ulogic_vector(3 downto 0); -- cs_n, ras_n, cas_n, we_n

  constant nop :    ctrl_t := "1111";
  constant activ:   ctrl_t := "0011";
  constant write:   ctrl_t := "0100";
  constant read:    ctrl_t := "0101";
  constant prech:   ctrl_t := "0010";
  constant stop:    ctrl_t := "0110";

end sdram_types;

library ieee;
use ieee.std_logic_1164.all;
use work.sdram_types.all;

entity sdramif is port(
  reset:              in  std_ulogic;
  clk:                in  std_ulogic;

  -- processor interface
  read_request_i:     in  std_ulogic;
  write_request_i:    in  std_ulogic;
  burst_single_i:     in  std_ulogic;

  ready_o:            out std_ulogic;
  read_data_o:        out std_ulogic_vector(31 downto 0);

  address_i:          in  std_ulogic_vector(23 downto 0);
  write_data_i:       in  std_ulogic_vector(31 downto 0);

  -- sdram interface
  cs_n_o:             out std_ulogic;
  ras_n_o:            out std_ulogic;
  cas_n_o:            out std_ulogic;
  we_n_o:             out std_ulogic;

  sdram_addr_o:       out std_ulogic_vector(11 downto 0);
  sdram_write_data_o: out std_ulogic_vector(31 downto 0);
  sdram_read_data_i:  in  std_ulogic_vector(31 downto 0)
  );
end sdramif;

architecture rtl of sdramif is

  signal state, next_state: state_t; 
  signal same_row: std_ulogic;
  signal issue_row_addr: std_ulogic;
  signal issue_col_addr: std_ulogic;
  signal issue_wdata: std_ulogic;
  signal sdram_ctrl: ctrl_t;
  signal next_ctrl: ctrl_t;
  signal capture_rdata: std_ulogic;
  signal last_row: std_ulogic_vector(11 downto 0);
  signal acc_rw, start_rw : std_ulogic;
  signal store_last_row: std_ulogic;
  signal next_ready, ready_s: std_ulogic;

begin

  sequential: process(clk, reset)
  begin
    if reset = '1' then
      state <= idle;
      sdram_ctrl <= nop;
      sdram_addr_o <= X"000";
      read_data_o <= X"0000_0000";
      sdram_write_data_o <= X"0000_0000";
      ready_s <= '0';
      acc_rw <= '0';
      last_row <= X"000";
    elsif (clk = '1' and clk'event) then
      state <= next_state;
      sdram_ctrl <= next_ctrl;
      ready_s <= next_ready;
      if issue_row_addr = '1' then
        sdram_addr_o <= address_i(23 downto 12);
      end if;
      if issue_col_addr = '1' then
        sdram_addr_o <= address_i(11 downto 0);
      end if;
      if store_last_row = '1' then
        last_row <= address_i(23 downto 12);
      end if;
      if capture_rdata = '1' then
        read_data_o <= sdram_read_data_i;
      end if;
      if issue_wdata = '1' or start_rw='1' then
        sdram_write_data_o <= write_data_i;
      end if;
      if start_rw = '1' then
        acc_rw <= '1';
      end if;
      if state=sw1 then
        acc_rw <= '0';
      end if;
    end if; 
  end process;

  same_row <= '1' when (address_i(23 downto 12) = last_row ) else 
			  '0'; 

  combinational: process(state, read_request_i, write_request_i, 
						 same_row, burst_single_i, ready_s, acc_rw)
  begin
    next_ctrl <= nop;
    issue_row_addr <= '0';
    issue_col_addr <= '0';
    issue_wdata <= '0';
    next_state <= state;
    capture_rdata <= '0';
    store_last_row <= '0';
    next_ready <= ready_s;
    start_rw <= '0'; 
    
    case state is
      when idle => 
        if (read_request_i = '1' or write_request_i = '1') then
          issue_row_addr <= '1';
          next_ctrl <= activ;
          next_state <= ra;
          store_last_row <= '1';
        end if;

      when ra => 
        next_state <= row_act;

      when row_act =>
        if (((read_request_i = '0') and (write_request_i = '0')) or
             (same_row = '0')) then
          -- precharge
          next_state <= pr;
          next_ctrl <= prech;
        elsif ((read_request_i = '1') and (burst_single_i = '0') and
               (acc_rw = '0')) then
          -- single read
          start_rw <= write_request_i;
          issue_col_addr <= '1';
          next_ctrl <= read;
          next_state <= sr1;
        elsif ((write_request_i = '1') and (burst_single_i = '0')) then
          -- single write
          issue_col_addr <= '1';
          issue_wdata <= not acc_rw;
          next_ctrl <= write;
          next_ready <= '1';
          next_state <= sw1;
        elsif ((read_request_i = '1') and (write_request_i = '0') and
               (burst_single_i = '1')) then
          -- burst read
          issue_col_addr <= '1';
          next_ctrl <= read;
          next_state <= br1;
        else
          -- burst write
          issue_col_addr <= '1';
          issue_wdata <= '0';
          next_ctrl <= nop;
          next_state <= bw1;
          next_ready <= '1';
        end if;
        
      when sr1 =>
        next_state <= sr2;        
        next_ctrl <= stop;
      when sr2 =>
        next_state <= sr3;
      when sr3 =>
        capture_rdata <= '1';
        next_ready <= not acc_rw;
        next_state <= sr4;
      when sr4 =>
        next_ready <= '0';
        next_state <= row_act;

      when br1 =>
        next_state <= br2;
      when br2 =>
        next_state <= br3;
      when br3 =>
        capture_rdata <= '1';
        next_ready <= '1';
        next_state <= br4;
      when br4 =>
        capture_rdata <= '1';
        next_state <= br5;
      when br5 =>
        capture_rdata <= '1';
        next_state <= br6;
      when br6 =>
        capture_rdata <= '1';
        next_state <= br7;
      when br7 => 
        next_ready <= '0';
        next_state <= row_act;

      when sw1 => 
        next_ready <= '0';
        next_ctrl <= stop;
        next_state <= row_act;

      when bw1 =>
        next_ctrl <= write;
        next_state <= bw2;
        next_ready <= '1';
        issue_wdata <= '1';
      when bw2 =>
        next_state <= bw3;
        issue_wdata <= '1';
      when bw3 =>
        next_state <= bw4;
        issue_wdata <= '1';
      when bw4 =>
        next_ready <= '0';
        next_state <= row_act;
        issue_wdata <= '1';

      when others =>
        next_state <= idle;

    end case;
  end process;
    
  cs_n_o  <= sdram_ctrl(3);
  ras_n_o <= sdram_ctrl(2);
  cas_n_o <= sdram_ctrl(1);
  we_n_o  <= sdram_ctrl(0); 
  ready_o <= ready_s;
  
end rtl;
