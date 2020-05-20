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
--use work.SCAM_Model_types.all;

entity Memory is
port(    
    clk                  : in  std_logic;
    rst                  : in  std_logic;
    CtlToMem_port_addrIn : in  Unsigned (31 downto 0);
    CtlToMem_port_dataIn : in  Unsigned (31 downto 0);
    CtlToMem_port_mask   : in  Unsigned ( 2 downto 0);
    CtlToMem_port_req    : in  std_logic;
    CtlToMem_port_sync   : in  std_logic;
    CtlToMem_port_notify : out std_logic;
    MemToCtl_port        : out Unsigned (31 downto 0);
    MemToCtl_port_sync   : in  std_logic;
    MemToCtl_port_notify : out std_logic);

end Memory;


architecture Memory_arch of Memory is

    signal section : std_logic;
    type ram_type is array (0 to 511) of Unsigned (7 downto 0);
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
     if(clk='1' and clk'event) then

         if rst = '1' then

             -- Specify Program to be loaded into Memory 
             --ram <= (others => (others => '0'));
             ram <= InitMemFromFile("/import/lab/users/mehmedag/DeSCAM_Remote/DeSCAM/example/RISCV_Test_ELF/Instruction_Power_Tests/lowPower/enc_i_i_low.hex");
             section <= '0';
             MemToCtl_port <= (others => '0');
             CtlToMem_port_notify <= '1';
             MemToCtl_port_notify <= '0';
             byte_temp := (others => '0');

         else

            if section = '0' then

                 if CtlToMem_port_sync = '1' then

                 
                    -- READ
                    if CtlToMem_port_req = '0'  then

                        -- Read Byte
                        if    (CtlToMem_port_addrIn < 512) and (CtlToMem_port_mask = "000") then

                            byte_temp := ram(to_integer(CtlToMem_port_addrIn));

                            -- Sign-Extend
                            if (byte_temp (7) = '1') then
                                MemToCtl_port <= X"FFFFFF" & byte_temp;
                            else
                                MemToCtl_port <= X"000000" & byte_temp;
                            end if;

                        -- Read Halfword
                        elsif (CtlToMem_port_addrIn < 511) and (CtlToMem_port_mask = "010") then

                            byte_temp := ram(to_integer(CtlToMem_port_addrIn) + 1);

                            -- Sign-Extend
                            if (byte_temp (7) = '1') then
                                MemToCtl_port <= X"FFFF" & byte_temp & ram(to_integer(CtlToMem_port_addrIn));
                            else
                                MemToCtl_port <= X"0000" & byte_temp & ram(to_integer(CtlToMem_port_addrIn));
                            end if;

                        -- Read Word
                        elsif (CtlToMem_port_addrIn < 509) and (CtlToMem_port_mask = "100") then

                            MemToCtl_port <= ram(to_integer(CtlToMem_port_addrIn) + 3)
                                           & ram(to_integer(CtlToMem_port_addrIn) + 2)
                                           & ram(to_integer(CtlToMem_port_addrIn) + 1)
                                           & ram(to_integer(CtlToMem_port_addrIn));
                        end if;

                        CtlToMem_port_notify <= '0';

                        MemToCtl_port_notify <= '1';

                        section <= '1';

           
                    -- WRITE
                    elsif CtlToMem_port_req = '1' then

                        -- Write Byte
                        if    (CtlToMem_port_addrIn < 512) and (CtlToMem_port_mask = "000") then

                            ram(to_integer(CtlToMem_port_addrIn)) <= CtlToMem_port_dataIn (7 downto 0);

                        -- Write Halfword
                        elsif (CtlToMem_port_addrIn < 511) and (CtlToMem_port_mask = "010") then

                            ram(to_integer(CtlToMem_port_addrIn) + 1) <= CtlToMem_port_dataIn (15 downto 8);
                            ram(to_integer(CtlToMem_port_addrIn))     <= CtlToMem_port_dataIn ( 7 downto 0);

                        -- Write Word
                        elsif (CtlToMem_port_addrIn < 509) and (CtlToMem_port_mask = "100") then

                            ram(to_integer(CtlToMem_port_addrIn) + 3) <= CtlToMem_port_dataIn (31 downto 24);
                            ram(to_integer(CtlToMem_port_addrIn) + 2) <= CtlToMem_port_dataIn (23 downto 16);
                            ram(to_integer(CtlToMem_port_addrIn) + 1) <= CtlToMem_port_dataIn (15 downto  8);
                            ram(to_integer(CtlToMem_port_addrIn))     <= CtlToMem_port_dataIn ( 7 downto  0);

                        end if;

                        CtlToMem_port_notify <= '0';

                        MemToCtl_port_notify <= '1';

                        section <= '1';

                    end if; 

                 end if;

            elsif section = '1' then

                if MemToCtl_port_sync = '1' then

                    MemToCtl_port_notify <= '0';

                    CtlToMem_port_notify <= '1';

                    section <= '0';

                end if;

            end if; -- SECTION

         end if; -- RST

     end if; -- CLK

     end process;
end Memory_arch;
