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

entity memory is
    port(
        clk                : in  std_logic;
        rst                : in  std_logic;
        CUtoME_port        : in  CUtoME_IF;
        CUtoME_port_sync   : in  bool;
        CUtoME_port_notify : out bool;
        MEtoCU_port        : out MEtoCU_IF;
        MEtoCU_port_sync   : in  bool;
        MEtoCU_port_notify : out bool
    );
end memory;


architecture memory_arch of memory is

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

    process(clk, rst)

        variable byte_temp : Unsigned (7 downto 0);

    begin
        if rst = '1' then
            -- Specify Program to be loaded into Memory
            --ram <= (others => (others => '0'));
            ram <= InitMemFromFile("/import/home/morkunas/SCAM/example/RISCV_Test/Programs/store.hex");
            MEtoCU_port.loadedData <= (others => '0');
            CUtoME_port_notify <= true;
            MEtoCU_port_notify <= false;
            section <= read;
            byte_temp := (others => '0');
        elsif (clk='1' and clk'event) then


                if section = read then

                    if CUtoME_port_sync = true then

                        -- READ
                        if CUtoME_port.req = ME_RD then

                            -- Read Byte
                            if    (CUtoME_port.addrIn < MEM_SIZE) and (CUtoME_port.mask = MT_B) then

                                byte_temp := ram(to_integer(CUtoME_port.addrIn));

                                -- Sign-Extend
                                if (byte_temp (7) = '1') then
                                    MEtoCU_port.loadedData <= X"FFFFFF" & byte_temp;
                                else
                                    MEtoCU_port.loadedData <= X"000000" & byte_temp;
                                end if;

                            -- Read Halfword
                            elsif (CUtoME_port.addrIn < MEM_SIZE-1) and (CUtoME_port.mask = MT_H) then

                                byte_temp := ram(to_integer(CUtoME_port.addrIn) + 1);

                                -- Sign-Extend
                                if (byte_temp (7) = '1') then
                                    MEtoCU_port.loadedData <= X"FFFF" & byte_temp & ram(to_integer(CUtoME_port.addrIn));
                                else
                                    MEtoCU_port.loadedData <= X"0000" & byte_temp & ram(to_integer(CUtoME_port.addrIn));
                                end if;

                            -- Read Word
                            elsif (CUtoME_port.addrIn < MEM_SIZE-3) and (CUtoME_port.mask = MT_W) then

                                MEtoCU_port.loadedData <= ram(to_integer(CUtoME_port.addrIn) + 3)
                                                        & ram(to_integer(CUtoME_port.addrIn) + 2)
                                                        & ram(to_integer(CUtoME_port.addrIn) + 1)
                                                        & ram(to_integer(CUtoME_port.addrIn));

                            -- Read Byte Unsigned
                            elsif (CUtoME_port.addrIn < MEM_SIZE) and (CUtoME_port.mask = MT_BU) then

                                byte_temp := ram(to_integer(CUtoME_port.addrIn));

                                MEtoCU_port.loadedData <= X"000000" & byte_temp;

                            -- Read Halfword Unsigned
                            elsif (CUtoME_port.addrIn < MEM_SIZE-1) and (CUtoME_port.mask = MT_HU) then

                                byte_temp := ram(to_integer(CUtoME_port.addrIn) + 1);

                                MEtoCU_port.loadedData <= X"0000" & byte_temp & ram(to_integer(CUtoME_port.addrIn));

                            end if;
                            
                            CUtoME_port_notify <= false;
    
                            MEtoCU_port_notify <= true;
    
                            section <= write;

                        -- WRITE
                        elsif CUtoME_port.req = ME_WR then

                            -- Write Byte
                            if    (CUtoME_port.addrIn < MEM_SIZE) and (CUtoME_port.mask = MT_B) then

                                ram(to_integer(CUtoME_port.addrIn)) <= CUtoME_port.dataIn (7 downto 0);

                            -- Write Halfword
                            elsif (CUtoME_port.addrIn < MEM_SIZE-1) and (CUtoME_port.mask = MT_H) then

                                ram(to_integer(CUtoME_port.addrIn) + 1) <= CUtoME_port.dataIn (15 downto 8);
                                ram(to_integer(CUtoME_port.addrIn))     <= CUtoME_port.dataIn ( 7 downto 0);

                            -- Write Word
                            elsif (CUtoME_port.addrIn < MEM_SIZE-3) and (CUtoME_port.mask = MT_W) then

                                ram(to_integer(CUtoME_port.addrIn) + 3) <= CUtoME_port.dataIn (31 downto 24);
                                ram(to_integer(CUtoME_port.addrIn) + 2) <= CUtoME_port.dataIn (23 downto 16);
                                ram(to_integer(CUtoME_port.addrIn) + 1) <= CUtoME_port.dataIn (15 downto  8);
                                ram(to_integer(CUtoME_port.addrIn))     <= CUtoME_port.dataIn ( 7 downto  0);

                            end if;

                        end if;

                        --CUtoME_port_notify <= false;

                        --MEtoCU_port_notify <= true;

                        --section <= write;

                    end if;

                elsif section = write then

                    if MEtoCU_port_sync = true then

                        CUtoME_port_notify <= true;

                        MEtoCU_port_notify <= false;

                        section <= read;

                    end if;

                end if; -- SECTION

            end if;

     end process;

end memory_arch;