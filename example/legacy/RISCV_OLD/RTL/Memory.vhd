--
-- Created by deutschmann on 13.02.18
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
    CtlToMem_port        : in  MemoryAccess;
    CtlToMem_port_sync   : in  bool;
    CtlToMem_port_notify : out bool;
    MemToCtl_port        : out Unsigned (31 downto 0);
    MemToCtl_port_sync   : in  bool;
    MemToCtl_port_notify : out bool;
    MemToDec_port        : out Unsigned (31 downto 0);
    MemToDec_port_sync   : in  bool;
    MemToDec_port_notify : out bool);

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
     if(clk='1' and clk'event) then

         if rst = '1' then

             section <= read;
             --ram <= (others => (others => '0'));
             ram <= InitMemFromFile("/import/lab/users/deutschmann/SCAM/example/RISCV_Test/Programs/fibonacci.hex");
             MemToCtl_port <= (others => '0');
             MemToDec_port <= (others => '0');
             CtlToMem_port_notify <= true;
             MemToCtl_port_notify <= false;
             MemToDec_port_notify <= false;
             byte_temp := (others => '0');

         else

            if section = read then

                 if CtlToMem_port_sync = true then


                    -- Read Instruction
                    if    CtlToMem_port.req = MEM_RD_I  then

                        if (CtlToMem_port.addrIn < 509) and (CtlToMem_port.mask = MT_W) then

                            MemToDec_port <= ram(to_integer(CtlToMem_port.addrIn) + 3)
                                           & ram(to_integer(CtlToMem_port.addrIn) + 2)
                                           & ram(to_integer(CtlToMem_port.addrIn) + 1)
                                           & ram(to_integer(CtlToMem_port.addrIn));

                        end if;

                        CtlToMem_port_notify <= false;

                        MemToDec_port_notify <= true;

                        section <= writeDec;


                    -- LOAD
                    elsif CtlToMem_port.req = MEM_LOAD  then

                        -- Load Byte
                        if    (CtlToMem_port.addrIn < 512) and (CtlToMem_port.mask = MT_B) then

                            byte_temp := ram(to_integer(CtlToMem_port.addrIn));

                            -- Sign-Extend
                            if (byte_temp (7) = '1') then
                                MemToCtl_port <= X"FFFFFF" & byte_temp;
                            else
                                MemToCtl_port <= X"000000" & byte_temp;
                            end if;

                        -- Load Halfword
                        elsif (CtlToMem_port.addrIn < 511) and (CtlToMem_port.mask = MT_H) then

                            byte_temp := ram(to_integer(CtlToMem_port.addrIn) + 1);

                            -- Sign-Extend
                            if (byte_temp (7) = '1') then
                                MemToCtl_port <= X"FFFF" & byte_temp & ram(to_integer(CtlToMem_port.addrIn));
                            else
                                MemToCtl_port <= X"0000" & byte_temp & ram(to_integer(CtlToMem_port.addrIn));
                            end if;

                        -- Load Word
                        elsif (CtlToMem_port.addrIn < 509) and (CtlToMem_port.mask = MT_W) then

                            MemToCtl_port <= ram(to_integer(CtlToMem_port.addrIn) + 3)
                                           & ram(to_integer(CtlToMem_port.addrIn) + 2)
                                           & ram(to_integer(CtlToMem_port.addrIn) + 1)
                                           & ram(to_integer(CtlToMem_port.addrIn));
                        end if;

                        CtlToMem_port_notify <= false;

                        MemToCtl_port_notify <= true;

                        section <= writeCtl;

           
                    -- STORE
                    elsif CtlToMem_port.req = MEM_STORE then

                        -- Store Byte
                        if    (CtlToMem_port.addrIn < 512) and (CtlToMem_port.mask = MT_B) then

                            ram(to_integer(CtlToMem_port.addrIn)) <= CtlToMem_port.dataIn (7 downto 0);

                        -- Store Halfword
                        elsif (CtlToMem_port.addrIn < 511) and (CtlToMem_port.mask = MT_H) then

                            ram(to_integer(CtlToMem_port.addrIn) + 1) <= CtlToMem_port.dataIn (15 downto 8);
                            ram(to_integer(CtlToMem_port.addrIn))     <= CtlToMem_port.dataIn ( 7 downto 0);

                        -- Store Word
                        elsif (CtlToMem_port.addrIn < 509) and (CtlToMem_port.mask = MT_W) then

                            ram(to_integer(CtlToMem_port.addrIn) + 3) <= CtlToMem_port.dataIn (31 downto 24);
                            ram(to_integer(CtlToMem_port.addrIn) + 2) <= CtlToMem_port.dataIn (23 downto 16);
                            ram(to_integer(CtlToMem_port.addrIn) + 1) <= CtlToMem_port.dataIn (15 downto  8);
                            ram(to_integer(CtlToMem_port.addrIn))     <= CtlToMem_port.dataIn ( 7 downto  0);

                        end if;

                        section <= read;

                    end if; 

                 end if;

            elsif section = writeDec then

                if MemToDec_port_sync = true then

                    MemToDec_port_notify <= false;

                    CtlToMem_port_notify <= true;

                    section <= read;

                end if;

            elsif section = writeCtl then

                if MemToCtl_port_sync = true then

                    MemToCtl_port_notify <= false;

                    CtlToMem_port_notify <= true;

                    section <= read;

                end if;

            end if; -- SECTION

         end if; -- RST

     end if; -- CLK

     end process;
end Memory_arch;
