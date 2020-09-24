library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;
use IEEE.math_real.all;


entity Buffer_Channel is
  port(
  clk               : in std_logic;
  rst				: in std_logic;
  consumer			: out signed (31 downto 0);
  consumer_sync     : in bool;
  consumer_notify   : out bool;
  producer0         : in signed (31 downto 0);
  producer0_sync    : in bool;
  producer0_notify  : out bool;
  producer1         : in signed (31 downto 0);
  producer1_sync    : in bool;
  producer1_notify  : out bool;
  producer2         : in signed (31 downto 0);
  producer2_sync    : in bool;
  producer2_notify  : out bool
  );
end Buffer_Channel;

architecture Buffer_Channel_arch of Buffer_Channel is
  --Signals
  signal state0    :   states;
  signal state1    :   states;
  signal state2    :   states;

  signal fifo0     :   int_array;
  signal fifo1     :   int_array;
  signal fifo2     :   int_array;

  --head indicates where to store the next element (incoming data)
  signal head0     :   Unsigned(31 downto 0);
  signal head1     :   Unsigned(31 downto 0);
  signal head2     :   Unsigned(31 downto 0);

  --tail indicates which element should be read next (outgoing data)
  signal tail0     :   Unsigned(31 downto 0);
  signal tail1     :   Unsigned(31 downto 0);
  signal tail2     :   Unsigned(31 downto 0);

  signal next_read :   Unsigned(31 downto 0);

  --Helping Signals for head and tail
  signal next_head0:   Unsigned(31 downto 0);
  signal next_head1:   Unsigned(31 downto 0);
  signal next_head2:   Unsigned(31 downto 0);

  signal next_tail0:   Unsigned(31 downto 0);
  signal next_tail1:   Unsigned(31 downto 0);
  signal next_tail2:   Unsigned(31 downto 0);

  begin
    --helping signals, that make the code (hopefully) more readable
    next_head0 <= (head0 + 1) mod FIFO_SIZE;
    next_head1 <= (head1 + 1) mod FIFO_SIZE;
    next_head2 <= (head2 + 1) mod FIFO_SIZE;
    next_tail0 <= (tail0 + 1) mod FIFO_SIZE;
    next_tail1 <= (tail1 + 1) mod FIFO_SIZE;
    next_tail2 <= (tail2 + 1) mod FIFO_SIZE;


    behaviour : process(clk)
    begin
      if(clk='1' and clk'event) then
        if rst = '1' then
          --Starting state: empty, head=tail=0, no notify or data signals set
          state0           <= EMPTY;
          state1           <= EMPTY;
          state2           <= EMPTY;
          fifo0            <= (others => to_signed(0,32));
          fifo1            <= (others => to_signed(0,32));
          fifo2            <= (others => to_signed(0,32));
          head0            <= (others => '0');
          head1            <= (others => '0');
          head2            <= (others => '0');
          tail0            <= (others => '0');
          tail1            <= (others => '0');
          tail2            <= (others => '0');
          next_read        <= (others => '0');
          consumer         <= (others =>'0');
          consumer_notify  <= false;
          producer0_notify <= false;
          producer1_notify <= false;
          producer2_notify <= false;

        else
          --always unset notify signals by default
          --will be set in the following lines if necessary
          producer0_notify <= false;
          producer1_notify <= false;
          producer2_notify <= false;
          consumer_notify <= false;

          --FIFO0
          --FIFO has no data
          if state0 = EMPTY then
            --only producer is ready to send data, consumer is not ready
            if producer0_sync = true and (consumer_sync = false or (consumer_sync = true and next_read /= to_unsigned(0,32))) then
              --go to state FILLED
              state0                   <= FILLED;
              --increment head modulo FIFO_SIZE
              head0                    <= next_head0;
              --store data at head
              fifo0(to_integer(head0))  <= producer0;
              --check if FIFO is full and go to state FULL instead
              if(next_head0 = tail0) then
                state0   <= FULL;
              end if;
              --acknowledge reception of data
              producer0_notify         <= true;

            --producer and consumer are ready for transmission/reception of data
            elsif producer0_sync = true and consumer_sync = true and next_read = to_unsigned(0,32) then
              --stay in state EMPTY
              state0                   <= EMPTY;
              --increment head modulo FIFO_SIZE
              head0                    <= next_head0;
              --store data at head
              fifo0(to_integer(head0))  <= producer0;
              --increment tail modulo FIFO_SIZE
              tail0                    <= next_tail0;
              --set output to data from producer
              consumer                <= producer0;
              next_read                <= to_unsigned(1,32);

              --acknowledge reception of data and signal outgoing data
              producer0_notify         <= true;
              consumer_notify         <= true;
            end if;

          --FIFO holds some data, but there is still space for more
          elsif state0 = FILLED then
            --only producer is ready to send data, consumer is not ready
            if producer0_sync = true and (consumer_sync = false or (consumer_sync = true and next_read /= to_unsigned(0,32))) then
              --stay in state FILLED
              state0                   <= FILLED;
              --increment head modulo FIFO_SIZE
              head0                    <= next_head0;
              --store data at head
              fifo0(to_integer(head0))  <= producer0;
              --check if FIFO is full and go to state FULL instead
              if(next_head0 = tail0) then
                state0   <= FULL;
              end if;
              --acknowledge reception of data
              producer0_notify         <= true;

            --only consumer is ready to receive data, producer is not ready
            elsif producer0_sync = false and consumer_sync = true and next_read = to_unsigned(0,32) then
              --stay in state FILLED
              state0                   <= FILLED;
              --increment tail modulo FIFO_SIZE
              tail0                    <= next_tail0;
              --set output to data from tail
              consumer                <= fifo0(to_integer(tail0));
              --check if FIFO empty and go to state EMPTY instead
              if(next_tail0 = head0) then
                state0     <= EMPTY;
              end if;

              next_read                <= to_unsigned(1,32);

              --signal outgoing data
              consumer_notify         <= true;

            --producer and consumer are ready for transmission/reception of data
            elsif producer0_sync = true and consumer_sync = true and next_read = to_unsigned(0,32) then
              --stay in state FILLED
              state0                   <= FILLED;
              --send value from tail to consumer and store value from producer at head              --increment both tail and head modulo FIFO_SIZE
              tail0                    <= next_tail0;
              consumer                <= fifo0(to_integer(tail0));
              head0                    <= next_head0;
              fifo0(to_integer(head0))  <= producer0;

              next_read                <= to_unsigned(1,32);

              --acknowledge reception of data and signal outgoing data
              producer0_notify         <= true;
              consumer_notify         <= true;
            end if;

          --FIFO has data and cant store new data
          elsif state0 = FULL then
            --only consumer is ready to receive data, producer is not ready
            if producer0_sync = false and consumer_sync = true and next_read = to_unsigned(0,32) then
              -- go to state FILLED
              state0                   <= FILLED;
              --increment tail modulo FIFO_SIZE
              tail0                    <= next_tail0;
              --set output to data from tail
              consumer                <= fifo0(to_integer(tail0));
              --check if FIFO is empty and go to state EMPTY instead
              if(next_tail0 = head0) then
                state0     <= EMPTY;
              end if;

              next_read                <= to_unsigned(1,32);

              --signal outgoing data
              consumer_notify         <= true;

            --producer and consumer are ready
            elsif producer0_sync = true and consumer_sync = true and next_read = to_unsigned(0,32) then
              --stay in state FULL
              state0                   <= FULL;
              --send value from tail to consumer and store value from producer at head
              --increment both tail and head modulo FIFO_SIZE
              tail0                    <= next_tail0;
              consumer                <= fifo0(to_integer(tail0));
              head0                    <= next_head0;
              fifo0(to_integer(head0))  <= producer0;

              next_read                <= to_unsigned(1,32);

              --acknowledge reception of data and signal outgoing data
              producer0_notify         <= true;
              consumer_notify         <= true;
            end if;
          end if;

          --FIFO1
          --FIFO has no data
          if state1 = EMPTY then
            --only producer is ready to send data, consumer is not ready
            if producer1_sync = true and (consumer_sync = false or (consumer_sync = true and next_read /= to_unsigned(1,32))) then
              --go to state FILLED
              state1                   <= FILLED;
              --increment head modulo FIFO_SIZE
              head1                    <= next_head1;
              --store data at head
              fifo1(to_integer(head1))  <= producer1;
              --check if FIFO is full and go to state FULL instead
              if(next_head1 = tail1) then
                state1   <= FULL;
              end if;
              --acknowledge reception of data
              producer1_notify         <= true;

            --producer and consumer are ready for transmission/reception of data
            elsif producer1_sync = true and consumer_sync = true and next_read = to_unsigned(1,32) then
              --stay in state EMPTY
              state1                   <= EMPTY;
              --increment head modulo FIFO_SIZE
              head1                    <= next_head1;
              --store data at head
              fifo1(to_integer(head1))  <= producer1;
              --increment tail modulo FIFO_SIZE
              tail1                    <= next_tail1;
              --set output to data from producer
              consumer                <= producer1;
              next_read                <= to_unsigned(2,32);

              --acknowledge reception of data and signal outgoing data
              producer1_notify         <= true;
              consumer_notify         <= true;
            end if;

          --FIFO holds some data, but there is still space for more
          elsif state1 = FILLED then
            --only producer is ready to send data, consumer is not ready
            if producer1_sync = true and (consumer_sync = false or (consumer_sync = true and next_read /= to_unsigned(1,32))) then
              --stay in state FILLED
              state1                   <= FILLED;
              --increment head modulo FIFO_SIZE
              head1                    <= next_head1;
              --store data at head
              fifo1(to_integer(head1))  <= producer1;
              --check if FIFO is full and go to state FULL instead
              if(next_head1 = tail1) then
                state1   <= FULL;
              end if;
              --acknowledge reception of data
              producer1_notify         <= true;

            --only consumer is ready to receive data, producer is not ready
            elsif producer1_sync = false and consumer_sync = true and next_read = to_unsigned(1,32) then
              --stay in state FILLED
              state1                   <= FILLED;
              --increment tail modulo FIFO_SIZE
              tail1                    <= next_tail1;
              --set output to data from tail
              consumer                <= fifo1(to_integer(tail1));
              --check if FIFO empty and go to state EMPTY instead
              if(next_tail1 = head1) then
                state1     <= EMPTY;
              end if;

              next_read                <= to_unsigned(2,32);

              --signal outgoing data
              consumer_notify         <= true;

            --producer and consumer are ready for transmission/reception of data
            elsif producer1_sync = true and consumer_sync = true and next_read = to_unsigned(1,32) then
              --stay in state FILLED
              state1                   <= FILLED;
              --send value from tail to consumer and store value from producer at head
              --increment both tail and head modulo FIFO_SIZE
              tail1                    <= next_tail1;
              consumer                <= fifo1(to_integer(tail1));
              head1                    <= next_head1;
              fifo1(to_integer(head1))  <= producer1;

              next_read                <= to_unsigned(2,32);

              --acknowledge reception of data and signal outgoing data
              producer1_notify         <= true;
              consumer_notify         <= true;
            end if;

          --FIFO has data and cant store new data
          elsif state1 = FULL then
            --only consumer is ready to receive data, producer is not ready
            if producer1_sync = false and consumer_sync = true and next_read = to_unsigned(1,32) then
              -- go to state FILLED
              state1                   <= FILLED;
              --increment tail modulo FIFO_SIZE
              tail1                    <= next_tail1;
              --set output to data from tail
              consumer                <= fifo1(to_integer(tail1));
              --check if FIFO is empty and go to state EMPTY instead
              if(next_tail1 = head1) then
                state1     <= EMPTY;
              end if;

              next_read                <= to_unsigned(2,32);

              --signal outgoing data
              consumer_notify         <= true;

            --producer and consumer are ready
            elsif producer1_sync = true and consumer_sync = true and next_read = to_unsigned(1,32) then
              --stay in state FULL
              state1                   <= FULL;
              --send value from tail to consumer and store value from producer at head
              --increment both tail and head modulo FIFO_SIZE
              tail1                    <= next_tail1;
              consumer                <= fifo1(to_integer(tail1));
              head1                    <= next_head1;
              fifo1(to_integer(head1))  <= producer1;

              next_read                <= to_unsigned(2,32);

              --acknowledge reception of data and signal outgoing data
              producer1_notify         <= true;
              consumer_notify         <= true;
            end if;
          end if;

          --FIFO2
          --FIFO has no data
          if state2 = EMPTY then
            --only producer is ready to send data, consumer is not ready
            if producer2_sync = true and (consumer_sync = false or (consumer_sync = true and next_read /= to_unsigned(2,32))) then
              --go to state FILLED
              state2                   <= FILLED;
              --increment head modulo FIFO_SIZE
              head2                    <= next_head2;
              --store data at head
              fifo2(to_integer(head2))  <= producer2;
              --check if FIFO is full and go to state FULL instead
              if(next_head2 = tail2) then
                state2   <= FULL;
              end if;
              --acknowledge reception of data
              producer2_notify         <= true;

            --producer and consumer are ready for transmission/reception of data
            elsif producer2_sync = true and consumer_sync = true and next_read = to_unsigned(2,32) then
              --stay in state EMPTY
              state2                   <= EMPTY;
              --increment head modulo FIFO_SIZE
              head2                    <= next_head2;
              --store data at head
              fifo2(to_integer(head2))  <= producer2;
              --increment tail modulo FIFO_SIZE
              tail2                    <= next_tail2;
              --set output to data from producer
              consumer                <= producer2;
              next_read                <= (others => '0');

              --acknowledge reception of data and signal outgoing data
              producer2_notify         <= true;
              consumer_notify         <= true;
            end if;

          --FIFO holds some data, but there is still space for more
          elsif state2 = FILLED then
            --only producer is ready to send data, consumer is not ready
            if producer2_sync = true and (consumer_sync = false or (consumer_sync = true and next_read /= to_unsigned(2,32))) then
              --stay in state FILLED
              state2                   <= FILLED;
              --increment head modulo FIFO_SIZE
              head2                    <= next_head2;
              --store data at head
              fifo2(to_integer(head2))  <= producer2;
              --check if FIFO is full and go to state FULL instead
              if(next_head2 = tail2) then
                state2   <= FULL;
              end if;
              --acknowledge reception of data
              producer2_notify         <= true;

            --only consumer is ready to receive data, producer is not ready
            elsif producer2_sync = false and consumer_sync = true and next_read /= to_unsigned(0,32) and next_read /= to_unsigned(1,32) then
              --stay in state FILLED
              state2                   <= FILLED;
              --increment tail modulo FIFO_SIZE
              tail2                    <= next_tail2;
              --set output to data from tail
              consumer                <= fifo2(to_integer(tail2));
              --check if FIFO empty and go to state EMPTY instead
              if(next_tail2 = head2) then
                state2     <= EMPTY;
              end if;

              next_read                <= (others => '0');

              --signal outgoing data
              consumer_notify         <= true;

            --producer and consumer are ready for transmission/reception of data
            elsif producer2_sync = true and consumer_sync = true and next_read /= to_unsigned(0,32) and next_read /= to_unsigned(1,32) then
              --stay in state FILLED
              state2                   <= FILLED;
              --send value from tail to consumer and store value from producer at head              --increment both tail and head modulo FIFO_SIZE
              tail2                    <= next_tail2;
              consumer                <= fifo2(to_integer(tail2));
              head2                    <= next_head2;
              fifo2(to_integer(head2))  <= producer2;

              next_read                <= (others => '0');

              --acknowledge reception of data and signal outgoing data
              producer2_notify         <= true;
              consumer_notify         <= true;
            end if;

          --FIFO has data and cant store new data
          elsif state2 = FULL then
            --only consumer is ready to receive data, producer is not ready
            if producer2_sync = false and consumer_sync = true and next_read /= to_unsigned(0,32) and next_read /= to_unsigned(1,32) then
              -- go to state FILLED
              state2                   <= FILLED;
              --increment tail modulo FIFO_SIZE
              tail2                    <= next_tail2;
              --set output to data from tail
              consumer                <= fifo2(to_integer(tail2));
              --check if FIFO is empty and go to state EMPTY instead
              if(next_tail2 = head2) then
                state2     <= EMPTY;
              end if;

              next_read                <= (others => '0');

              --signal outgoing data
              consumer_notify         <= true;

            --producer and consumer are ready
            elsif producer2_sync = true and consumer_sync = true and next_read /= to_unsigned(0,32) and next_read /= to_unsigned(1,32) then
              --stay in state FULL
              state2                   <= FULL;
              --send value from tail to consumer and store value from producer at head
              --increment both tail and head modulo FIFO_SIZE
              tail2                    <= next_tail2;
              consumer                <= fifo2(to_integer(tail2));
              head2                    <= next_head2;
              fifo2(to_integer(head2))  <= producer2;

              next_read                <= (others => '0');

              --acknowledge reception of data and signal outgoing data
              producer2_notify         <= true;
              consumer_notify         <= true;
            end if;
          end if;

        end if;
      end if;
    end process behaviour;
  end Buffer_Channel_arch;
