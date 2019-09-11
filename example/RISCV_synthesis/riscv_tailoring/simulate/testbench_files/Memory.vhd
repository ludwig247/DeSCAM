--
-- Created by deutschmann on 13.02.18
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
        clk                     : in  std_logic;
        rst                     : in  std_logic;
        COtoME_port_sig    	: in  CUtoME_IF;
        COtoME_port_sync      : in  boolean;
        COtoME_port_notify    : out boolean;
        MEtoCO_port_sig      	: out MEtoCU_IF;
        MEtoCO_port_sync      : in  boolean;
        MEtoCO_port_notify    : out boolean
    	);
end Memory;

architecture Memory_arch of Memory is
	-- Memory size in Byte
	constant MEM_SIZE : integer := 65536;

    -- Define types
    type ram_type is array (0 to (MEM_SIZE-1)) of unsigned (7 downto 0);
    type mem_sections_type is (read, write);
    
    -- Define signals
    signal section : mem_sections_type;
    signal ram     : ram_type;

impure function InitMemFromFile (MemFileName: in string) return ram_type is
    file MemFile : text is in MemFileName;
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
     variable byte_temp : unsigned (7 downto 0);
     begin
     if(clk='1' and clk'event) then
         if rst = '1' then
             -- Specify Program to be loaded into Memory 
             --ram <= (others => (others => '0'));
             ram <= InitMemFromFile("/import/lab/users/morkunas/SCAM/example/RISCV_synthesis/riscv_tailoring/simulate/testbench_files/program.hex");
             section <= read;
             MEtoCO_port_sig.loadedData <= (others => '0');
             COtoME_port_notify <= true;
             MEtoCO_port_notify <= false;
             byte_temp := (others => '0');
         else
            if section = read then
                 if COtoME_port_sync = true then
                    if COtoME_port_sig.req = ME_RD then
                        -- READ
                        -- Read Byte
                        if    (COtoME_port_sig.addrIn < MEM_SIZE) and (COtoME_port_sig.mask = MT_B) then
                            byte_temp := ram(to_integer(COtoME_port_sig.addrIn));
                            -- Sign-Extend
                            if (byte_temp (7) = '1') then
                                MEtoCO_port_sig.loadedData <= X"FFFFFF" & byte_temp;
                            else
                                MEtoCO_port_sig.loadedData <= X"000000" & byte_temp;
                            end if;
                        elsif (COtoME_port_sig.addrIn < MEM_SIZE-1) and (COtoME_port_sig.mask = MT_H) then
                            -- Read Halfword
                            byte_temp := ram(to_integer(COtoME_port_sig.addrIn) + 1);
                            -- Sign-Extend
                            if (byte_temp (7) = '1') then
                                MEtoCO_port_sig.loadedData <= X"FFFF" & byte_temp & ram(to_integer(COtoME_port_sig.addrIn));
                            else
                                MEtoCO_port_sig.loadedData <= X"0000" & byte_temp & ram(to_integer(COtoME_port_sig.addrIn));
                            end if;
                        elsif (COtoME_port_sig.addrIn < MEM_SIZE-3) and (COtoME_port_sig.mask = MT_W) then
                            -- Read Word
                            MEtoCO_port_sig.loadedData <= ram(to_integer(COtoME_port_sig.addrIn) + 3)
                                           & ram(to_integer(COtoME_port_sig.addrIn) + 2)
                                           & ram(to_integer(COtoME_port_sig.addrIn) + 1)
                                           & ram(to_integer(COtoME_port_sig.addrIn));
                        end if;
                        COtoME_port_notify <= false;
                        MEtoCO_port_notify <= true;
                        section <= write;
                    elsif COtoME_port_sig.req = ME_WR then
                        -- WRITE
                        if (COtoME_port_sig.addrIn < MEM_SIZE) and (COtoME_port_sig.mask = MT_B) then
                            -- Write Byte
                            ram(to_integer(COtoME_port_sig.addrIn)) <= COtoME_port_sig.dataIn (7 downto 0);
                        elsif (COtoME_port_sig.addrIn < MEM_SIZE-1) and (COtoME_port_sig.mask = MT_H) then
                            -- Write Halfword
                            ram(to_integer(COtoME_port_sig.addrIn) + 1) <= COtoME_port_sig.dataIn (15 downto 8);
                            ram(to_integer(COtoME_port_sig.addrIn))     <= COtoME_port_sig.dataIn ( 7 downto 0);
                        elsif (COtoME_port_sig.addrIn < MEM_SIZE-3) and (COtoME_port_sig.mask = MT_W) then
                            -- Write Word
                            ram(to_integer(COtoME_port_sig.addrIn) + 3) <= COtoME_port_sig.dataIn (31 downto 24);
                            ram(to_integer(COtoME_port_sig.addrIn) + 2) <= COtoME_port_sig.dataIn (23 downto 16);
                            ram(to_integer(COtoME_port_sig.addrIn) + 1) <= COtoME_port_sig.dataIn (15 downto  8);
                            ram(to_integer(COtoME_port_sig.addrIn))     <= COtoME_port_sig.dataIn ( 7 downto  0);
                        end if;
                        section <= read;
                    end if; 
                 end if;
            elsif section = write then
                if MEtoCO_port_sync = true then
                    MEtoCO_port_notify <= false;
                    COtoME_port_notify <= true;
                    section <= read;
                end if;
            end if; -- SECTION
         end if; -- RST
     end if; -- CLK
    
     end process;
end Memory_arch;
