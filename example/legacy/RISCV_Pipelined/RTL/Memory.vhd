--
-- Created by deutschmann on 17.10.18
--
-- Module: Memory
--
-- Only for simulation purposes. Not part of CPU. Consists of 512 8-bit cells. Little Endian.
-- A .hex file can be specified to be pre-loaded into Memory.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.SCAM_Model_types.all;

entity Memory is
    port(
        clk                  : in  std_logic;
        rst                  : in  std_logic;
        CtlToMem_port        : in  CUtoME_IF;
        CtlToMem_port_sync   : in  bool;
        CtlToMem_port_notify : out bool;
        MemToCtl_port        : out MEtoCU_IF;
        MemToCtl_port_sync   : in  bool;
        MemToCtl_port_notify : out bool
    );
end Memory;


architecture Memory_arch of Memory is

    signal section : Mem_SECTIONS;
    signal ram     : ram_type;

    impure function InitMemFromFile (MemFileName: in string) return ram_type is
        FILE MemFile : text is in MemFileName;
        variable MemFileLine : line;
        variable ram : ram_type;
        variable temp : std_logic_vector (31 downto 0);
        variable j : integer;
        begin
            -- Function for reading .hex file and storing it into Memory (starting at Address 0)
            for i in ram_type'range loop
                j := i mod 4;
                if (j = 0) and not endfile(MemFile) then
                    readline(MemFile, MemFileLine);
                    hread(MemFileLine, temp);
                elsif (j = 0) then
                    temp := (others => '0');
                end if;
                ram(i) := unsigned(temp (j*8+7 downto j*8));
            end loop;
        return ram;
    end function;

begin

    process(clk)

        variable byte_temp : Unsigned (7 downto 0);

    begin

        if (clk='1' and clk'event) then

            if rst = '1' then

                -- Specify Program to be loaded into Memory
                --ram <= (others => (others => '0'));
                ram <= InitMemFromFile("/import/lab/users/hetalani/SCAM/example/RISCV_Test/Programs/Fibonacci_c/main.HEX");
                MemToCtl_port.loadedData <= (others => '0');
                CtlToMem_port_notify <= true;
                MemToCtl_port_notify <= false;
                section <= read;
                byte_temp := (others => '0');

            else

                if section = read then

                    if CtlToMem_port_sync = true then

                        -- READ
                        if CtlToMem_port.req = ME_RD then

                            -- Read Byte
                            if    (CtlToMem_port.addrIn < MEM_SIZE) and (CtlToMem_port.mask = MT_B) then

                                byte_temp := ram(to_integer(CtlToMem_port.addrIn));

                                -- Sign-Extend
                                if (byte_temp (7) = '1') then
                                    MemToCtl_port.loadedData <= X"FFFFFF" & byte_temp;
                                else
                                    MemToCtl_port.loadedData <= X"000000" & byte_temp;
                                end if;

                            -- Read Halfword
                            elsif (CtlToMem_port.addrIn < MEM_SIZE-1) and (CtlToMem_port.mask = MT_H) then

                                byte_temp := ram(to_integer(CtlToMem_port.addrIn) + 1);

                                -- Sign-Extend
                                if (byte_temp (7) = '1') then
                                    MemToCtl_port.loadedData <= X"FFFF" & byte_temp & ram(to_integer(CtlToMem_port.addrIn));
                                else
                                    MemToCtl_port.loadedData <= X"0000" & byte_temp & ram(to_integer(CtlToMem_port.addrIn));
                                end if;

                            -- Read Word
                            elsif (CtlToMem_port.addrIn < MEM_SIZE-3) and (CtlToMem_port.mask = MT_W) then

                                MemToCtl_port.loadedData <= ram(to_integer(CtlToMem_port.addrIn) + 3)
                                                          & ram(to_integer(CtlToMem_port.addrIn) + 2)
                                                          & ram(to_integer(CtlToMem_port.addrIn) + 1)
                                                          & ram(to_integer(CtlToMem_port.addrIn));

                            -- Read Byte Unsigned
                            elsif (CtlToMem_port.addrIn < MEM_SIZE) and (CtlToMem_port.mask = MT_BU) then

                                byte_temp := ram(to_integer(CtlToMem_port.addrIn));

                                MemToCtl_port.loadedData <= X"000000" & byte_temp;

                            -- Read Halfword Unsigned
                            elsif (CtlToMem_port.addrIn < MEM_SIZE-1) and (CtlToMem_port.mask = MT_HU) then

                                byte_temp := ram(to_integer(CtlToMem_port.addrIn) + 1);

                                MemToCtl_port.loadedData <= X"0000" & byte_temp & ram(to_integer(CtlToMem_port.addrIn));

                            end if;

                        -- WRITE
                        elsif CtlToMem_port.req = ME_WR then

                            -- Write Byte
                            if    (CtlToMem_port.addrIn < MEM_SIZE) and (CtlToMem_port.mask = MT_B) then

                                ram(to_integer(CtlToMem_port.addrIn)) <= CtlToMem_port.dataIn (7 downto 0);

                            -- Write Halfword
                            elsif (CtlToMem_port.addrIn < MEM_SIZE-1) and (CtlToMem_port.mask = MT_H) then

                                ram(to_integer(CtlToMem_port.addrIn) + 1) <= CtlToMem_port.dataIn (15 downto 8);
                                ram(to_integer(CtlToMem_port.addrIn))     <= CtlToMem_port.dataIn ( 7 downto 0);

                            -- Write Word
                            elsif (CtlToMem_port.addrIn < MEM_SIZE-3) and (CtlToMem_port.mask = MT_W) then

                                ram(to_integer(CtlToMem_port.addrIn) + 3) <= CtlToMem_port.dataIn (31 downto 24);
                                ram(to_integer(CtlToMem_port.addrIn) + 2) <= CtlToMem_port.dataIn (23 downto 16);
                                ram(to_integer(CtlToMem_port.addrIn) + 1) <= CtlToMem_port.dataIn (15 downto  8);
                                ram(to_integer(CtlToMem_port.addrIn))     <= CtlToMem_port.dataIn ( 7 downto  0);

                            end if;

                        end if;

                        CtlToMem_port_notify <= false;

                        MemToCtl_port_notify <= true;

                        section <= write;

                    end if;

                elsif section = write then

                    if MemToCtl_port_sync = true then

                        CtlToMem_port_notify <= true;

                        MemToCtl_port_notify <= false;

                        section <= read;

                    end if;

                end if; -- SECTION

            end if; -- RST

        end if; -- CLK

     end process;

end Memory_arch;
