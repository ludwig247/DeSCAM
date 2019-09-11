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
        clk                : in  std_logic;
        rst                : in  std_logic;
        COtoME_port        : in  COtoME_IF;
        COtoME_port_sync   : in  bool;
        COtoME_port_notify : out bool;
        MEtoCO_port        : out MEtoCO_IF;
        MEtoCO_port_sync   : in  bool;
        MEtoCO_port_notify : out bool
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
                ram <= InitMemFromFile("/import/lab/users/hetalani/SCAM/example/RISCV_Test/Programs/test_1.hex");
                MEtoCO_port.loadedData <= (others => '0');
                COtoME_port_notify <= true;
                MEtoCO_port_notify <= false;
                section <= read;
                byte_temp := (others => '0');

            else

                if section = read then

                    if COtoME_port_sync = true then

                        -- READ
                        if COtoME_port.req = ME_RD then

                            -- Read Byte
                            if    (COtoME_port.addrIn < MEM_SIZE) and (COtoME_port.mask = MT_B) then

                                byte_temp := ram(to_integer(COtoME_port.addrIn));

                                -- Sign-Extend
                                if (byte_temp (7) = '1') then
                                    MEtoCO_port.loadedData <= X"FFFFFF" & byte_temp;
                                else
                                    MEtoCO_port.loadedData <= X"000000" & byte_temp;
                                end if;

                            -- Read Halfword
                            elsif (COtoME_port.addrIn < MEM_SIZE-1) and (COtoME_port.mask = MT_H) then

                                byte_temp := ram(to_integer(COtoME_port.addrIn) + 1);

                                -- Sign-Extend
                                if (byte_temp (7) = '1') then
                                    MEtoCO_port.loadedData <= X"FFFF" & byte_temp & ram(to_integer(COtoME_port.addrIn));
                                else
                                    MEtoCO_port.loadedData <= X"0000" & byte_temp & ram(to_integer(COtoME_port.addrIn));
                                end if;

                            -- Read Word
                            elsif (COtoME_port.addrIn < MEM_SIZE-3) and (COtoME_port.mask = MT_W) then

                                MEtoCO_port.loadedData <= ram(to_integer(COtoME_port.addrIn) + 3)
                                                        & ram(to_integer(COtoME_port.addrIn) + 2)
                                                        & ram(to_integer(COtoME_port.addrIn) + 1)
                                                        & ram(to_integer(COtoME_port.addrIn));

                            -- Read Byte Unsigned
                            elsif (COtoME_port.addrIn < MEM_SIZE) and (COtoME_port.mask = MT_BU) then

                                byte_temp := ram(to_integer(COtoME_port.addrIn));

                                MEtoCO_port.loadedData <= X"000000" & byte_temp;

                            -- Read Halfword Unsigned
                            elsif (COtoME_port.addrIn < MEM_SIZE-1) and (COtoME_port.mask = MT_HU) then

                                byte_temp := ram(to_integer(COtoME_port.addrIn) + 1);

                                MEtoCO_port.loadedData <= X"0000" & byte_temp & ram(to_integer(COtoME_port.addrIn));

                            end if;

                        -- WRITE
                        elsif COtoME_port.req = ME_WR then

                            -- Write Byte
                            if    (COtoME_port.addrIn < MEM_SIZE) and (COtoME_port.mask = MT_B) then

                                ram(to_integer(COtoME_port.addrIn)) <= COtoME_port.dataIn (7 downto 0);

                            -- Write Halfword
                            elsif (COtoME_port.addrIn < MEM_SIZE-1) and (COtoME_port.mask = MT_H) then

                                ram(to_integer(COtoME_port.addrIn) + 1) <= COtoME_port.dataIn (15 downto 8);
                                ram(to_integer(COtoME_port.addrIn))     <= COtoME_port.dataIn ( 7 downto 0);

                            -- Write Word
                            elsif (COtoME_port.addrIn < MEM_SIZE-3) and (COtoME_port.mask = MT_W) then

                                ram(to_integer(COtoME_port.addrIn) + 3) <= COtoME_port.dataIn (31 downto 24);
                                ram(to_integer(COtoME_port.addrIn) + 2) <= COtoME_port.dataIn (23 downto 16);
                                ram(to_integer(COtoME_port.addrIn) + 1) <= COtoME_port.dataIn (15 downto  8);
                                ram(to_integer(COtoME_port.addrIn))     <= COtoME_port.dataIn ( 7 downto  0);

                            end if;

                        end if;

                        COtoME_port_notify <= false;

                        MEtoCO_port_notify <= true;

                        section <= write;

                    end if;

                elsif section = write then

                    if MEtoCO_port_sync = true then

                        COtoME_port_notify <= true;

                        MEtoCO_port_notify <= false;

                        section <= read;

                    end if;

                end if; -- SECTION

            end if; -- RST

        end if; -- CLK

     end process;

end Memory_arch;