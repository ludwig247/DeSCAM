library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;
use IEEE.math_real.all;


entity FIFO_Channel is
  port(
  clk               : in std_logic;
  rst							  : in std_logic;
  consumer					: out signed (31 downto 0);
  consumer_sync     : in bool;
  consumer_notify   : out bool;
  producer          : in signed (31 downto 0);
  producer_sync     : in bool;
  producer_notify   : out bool
  );
end FIFO_Channel;

architecture FIFO_Channel_arch of FIFO_Channel is
  --Signals
  signal state    :   states;
  signal fifo     :   int_array;
  --head indicates where to store the next element (incoming data)
  signal head     :   Unsigned(FIFO_WIDTH-1 downto 0);
  --tail indicates which element should be read next (outgoing data)
  signal tail     :   Unsigned(FIFO_WIDTH-1 downto 0);

  --Helping Signals for head and tail
  signal next_head:   Unsigned(FIFO_WIDTH-1 downto 0);
  signal next_tail:   Unsigned(FIFO_WIDTH-1 downto 0);

  begin
    --helping signals, that make the code (hopefully) more readable
    next_head <= (head + 1) mod FIFO_SIZE;
    next_tail <= (tail + 1) mod FIFO_SIZE;

    behaviour : process(clk)
    begin
      if(clk='1' and clk'event) then
        if rst = '1' then
          --Starting state: empty, head=tail=0, no notify or data signals set
          state           <= EMPTY;
          fifo            <= (others => to_signed(0,32));
          head            <= (others => '0');
          tail            <= (others => '0');
          consumer        <= (others =>'0');
          consumer_notify <= false;
          producer_notify <= false;

        else
          --always unset notify signals by default
          --will be set in the following lines if necessary
          producer_notify <= false;
          consumer_notify <= false;

          --FIFO has no data
          if state = EMPTY then
            --only producer is ready to send data, consumer is not ready
            if producer_sync = true and consumer_sync = false then
              --go to state FILLED
              state                   <= FILLED;
              --increment head modulo FIFO_SIZE
              head                    <= next_head;
              --store data at head
              fifo(to_integer(head))  <= producer;
              --check if FIFO is full and go to state FULL instead
              if(next_head = tail) then
                state   <= FULL;
              end if;
              --acknowledge reception of data
              producer_notify         <= true;

            --producer and consumer are ready for transmission/reception of data
            elsif producer_sync = true and consumer_sync = true then
              --stay in state EMPTY
              state                   <= EMPTY;
              --give value from producer directly to consumer
              consumer                <= producer;
              --acknowledge reception of data and signal outgoing data
              producer_notify         <= true;
              consumer_notify         <= true;
            end if;

          --FIFO holds some data, but there is still space for more
          elsif state = FILLED then
            --only producer is ready to send data, consumer is not ready
            if producer_sync = true and consumer_sync = false then
              --stay in state FILLED
              state                   <= FILLED;
              --increment head modulo FIFO_SIZE
              head                    <= next_head;
              --store data at head
              fifo(to_integer(head))  <= producer;
              --check if FIFO is full and go to state FULL instead
              if(next_head = tail) then
                state   <= FULL;
              end if;
              --acknowledge reception of data
              producer_notify         <= true;

            --only consumer is ready to receive data, producer is not ready
            elsif producer_sync = false and consumer_sync = true then
              --stay in state FILLED
              state                   <= FILLED;
              --increment tail modulo FIFO_SIZE
              tail                    <= next_tail;
              --set output to data from tail
              consumer                <= fifo(to_integer(tail));
              --check if FIFO empty and go to state EMPTY instead
              if(next_tail = head) then
                state     <= EMPTY;
              end if;
              --signal outgoing data
              consumer_notify         <= true;

            --producer and consumer are ready for transmission/reception of data
            elsif producer_sync = true and consumer_sync = true then
              --stay in state FILLED
              state                   <= FILLED;
              --send value from tail to consumer and store value from producer at head              --increment both tail and head modulo FIFO_SIZE
              tail                    <= next_tail;
              consumer                <= fifo(to_integer(tail));
              head                    <= next_head;
              fifo(to_integer(head))  <= producer;
              --acknowledge reception of data and signal outgoing data
              producer_notify         <= true;
              consumer_notify         <= true;
            end if;

          --FIFO has data and cant store new data
          elsif state = FULL then
            --only consumer is ready to receive data, producer is not ready
            if producer_sync = false and consumer_sync = true then
              -- go to state FILLED
              state                   <= FILLED;
              --increment tail modulo FIFO_SIZE
              tail                    <= next_tail;
              --set output to data from tail
              consumer                <= fifo(to_integer(tail));
              --check if FIFO is empty and go to state EMPTY instead
              if(next_tail = head) then
                state     <= EMPTY;
              end if;
              --signal outgoing data
              consumer_notify         <= true;

            --producer and consumer are ready
            elsif producer_sync = true and consumer_sync = true then
              --stay in state FULL
              state                   <= FULL;
              --send value from tail to consumer and store value from producer at head
              --increment both tail and head modulo FIFO_SIZE
              tail                    <= next_tail;
              consumer                <= fifo(to_integer(tail));
              head                    <= next_head;
              fifo(to_integer(head))  <= producer;
              --acknowledge reception of data and signal outgoing data
              producer_notify         <= true;
              consumer_notify         <= true;
            end if;
          end if;
        end if;
      end if;
    end process behaviour;
  end FIFO_Channel_arch;
