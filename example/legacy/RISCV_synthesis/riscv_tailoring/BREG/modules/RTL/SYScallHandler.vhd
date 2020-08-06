--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 30.11.18
--

library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.env_model_types.all;

entity SYScallHandler is
port(    
	clk: in std_logic;
	rst: in std_logic;

	--  blocking_in<MEtoCP_IF> MEtoCO_port_sig
	MEtoCO_port_sig				: in MEtoCU_IF;
	MEtoCO_port_sync		: in boolean;
	MEtoCO_port_notify	: out boolean;

	--  blocking_out<CUtoME_IF> COtoME_port_sig
	COtoME_port_sig				: out CUtoME_IF;
	COtoME_port_sync			: in boolean;
	COtoME_port_notify		: out boolean;

	--  master_in<RegfileSyscallType> reg_syscall_port_sig
	reg_syscall_port_sig				: in RegfileSyscallType;

	--  master_out<RegfileWriteType> syscall_reg_port_sig
	syscall_reg_port_sig					: out RegfileWriteType;
	syscall_reg_port_notify			: out boolean;

	--  blocking_in<boolean> syscall_isa_port_sig
	isa_syscall_port_sig			: in boolean;
	isa_syscall_port_sync	: in boolean;
	isa_syscall_port_notify	: out boolean;

	--  blocking_out<boolean> syscall_isa_port_sig
	syscall_isa_port_sig			: out boolean;
	syscall_isa_port_sync	: in boolean;
	syscall_isa_port_notify	: out boolean
);
end SYScallHandler;

architecture SYScallHandler_arch of SYScallHandler is

type SYSCALL_SECTIONS is (process_ecall, return_to_isa1, return_to_isa2, writing1, writing2, writing_done);
signal section : SYSCALL_SECTIONS;

signal memoryRequest : CUtoME_IF;
signal ans : unsigned (31 downto 0);
signal index : unsigned (31 downto 0);
signal reg_11 : unsigned (31 downto 0);
signal reg_12 : unsigned (31 downto 0);
signal sysRES : boolean;

begin

	process(clk)

	variable requestType : ME_AccessType;

	begin
		if(clk='1' and clk'event) then

			-- Reset Sequence
			if rst = '1' then
				ans <= (others => '0');
				index <= (others => '0');
				memoryRequest.addrIn <= (others => '0');
				memoryRequest.dataIn <= (others => '0');
				memoryRequest.mask <= MT_B;
				memoryRequest.req <= ME_RD;
				reg_11 <= (others => '0');
				reg_12 <= (others => '0');
				sysRES <= false;
				MEtoCO_port_notify <= false;
				isa_syscall_port_notify <= true;
				syscall_isa_port_notify <= false;
				syscall_reg_port_notify <= false;
				COtoME_port_notify <= false;
				section <= process_ecall;
			else

				if (section = process_ecall) then
					if (isa_syscall_port_sync = true) then
						isa_syscall_port_notify <= false;
						reg_11 <= reg_syscall_port_sig.reg_file_11;
						reg_12 <= reg_syscall_port_sig.reg_file_12;
						MEtoCO_port_notify <= false;

						if (reg_syscall_port_sig.reg_file_17 = SYS_exit) then
							sysRES <= false;
							syscall_isa_port_sig <= false;
							syscall_isa_port_notify <= true;

							syscall_reg_port_notify <= false;
							COtoME_port_notify <= false;
							section <= return_to_isa1;

						elsif  (reg_syscall_port_sig.reg_file_17 = SYS_write) then
								ans <= reg_syscall_port_sig.reg_file_12;
								index <= to_unsigned(0,32);
							if (reg_syscall_port_sig.reg_file_12 /= to_unsigned(0,32)) then

								COtoME_port_sig.addrIn <= reg_syscall_port_sig.reg_file_11;
								COtoME_port_sig.dataIn <= to_unsigned(0,32);
								COtoME_port_sig.mask <= MT_BU;
								COtoME_port_sig.req <= ME_RD;

								memoryRequest.addrIn <= reg_syscall_port_sig.reg_file_11;
								memoryRequest.dataIn <= to_unsigned(0,32);
								memoryRequest.mask <= MT_BU;
								memoryRequest.req <= ME_RD;

								COtoME_port_notify <= true;

								syscall_isa_port_notify <= false;
								syscall_reg_port_notify <= false;
								section <= writing1;
							else
								sysRES <= true;
								syscall_isa_port_sig <= true;
								syscall_isa_port_notify <= true;

								syscall_reg_port_sig.dst <= x"00000005";--no need to specify destination
								syscall_reg_port_sig.dstData <= reg_syscall_port_sig.reg_file_12;
								syscall_reg_port_notify <= true;

								COtoME_port_notify <= false;

								section <= writing_done;
							end if;
						else
							sysRES <= true;
							syscall_isa_port_sig <= true;
							syscall_isa_port_notify <= true;

							syscall_reg_port_notify <= false;
							COtoME_port_notify <= false;
							section <= return_to_isa2;

						end if;
					else
						isa_syscall_port_notify <= true;
						MEtoCO_port_notify <= false;
						syscall_isa_port_notify <= false;
						syscall_reg_port_notify <= false;
						COtoME_port_notify <= false;
						section <= process_ecall;
					end if;

				elsif (section = return_to_isa1) then
					if (syscall_isa_port_sync = true) then
						MEtoCO_port_notify <= false;
						isa_syscall_port_notify <= true;
						syscall_isa_port_notify <= false;
						syscall_reg_port_notify <= false;
						COtoME_port_notify <= false;

						section <= process_ecall;
					else
						MEtoCO_port_notify <= false;
						isa_syscall_port_notify <= false;
						syscall_isa_port_notify <= true;
						syscall_reg_port_notify <= false;
						COtoME_port_notify <= false;

						section <= return_to_isa1;
					end if;

				elsif (section = return_to_isa2) then
					if (syscall_isa_port_sync = true) then
						MEtoCO_port_notify <= false;
						isa_syscall_port_notify <= true;
						syscall_isa_port_notify <= false;
						syscall_reg_port_notify <= false;
						COtoME_port_notify <= false;

						section <= process_ecall;
					else
						MEtoCO_port_notify <= false;
						isa_syscall_port_notify <= false;
						syscall_isa_port_notify <= true;
						syscall_reg_port_notify <= false;
						COtoME_port_notify <= false;

						section <= return_to_isa2;
					end if;

				elsif (section = writing1) then
					if (COtoME_port_sync = true) then
						MEtoCO_port_notify <= true;
						isa_syscall_port_notify <= false;
						syscall_isa_port_notify <= false;
						syscall_reg_port_notify <= false;
						COtoME_port_notify <= false;

						section <= writing2;
					else
						MEtoCO_port_notify <= false;
						isa_syscall_port_notify <= false;
						syscall_isa_port_notify <= false;
						syscall_reg_port_notify <= false;
						COtoME_port_notify <= true;

						section <= writing1;
					end if;

				elsif (section = writing2) then
					if (MEtoCO_port_sync = true) then
						MEtoCO_port_notify <= false;

						if ( (index+1) < reg_12 ) then
					    	index <= (index + 1);
							COtoME_port_sig.addrIn <= ( reg_11 + index + 1);
							COtoME_port_sig.dataIn <= to_unsigned(0,32);
							COtoME_port_sig.mask <= MT_BU;
							COtoME_port_sig.req <= ME_RD;

							memoryRequest.addrIn <= ( reg_11 + index + 1);
							memoryRequest.dataIn <= to_unsigned(0,32);
							memoryRequest.mask <= MT_BU;
							memoryRequest.req <= ME_RD;

							COtoME_port_notify <= true;

							isa_syscall_port_notify <= false;
							syscall_isa_port_notify <= false;
							syscall_reg_port_notify <= false;
					    	section <= writing1;

						else
					    	index <= (index + 1);

							sysRES <= true;
							syscall_isa_port_sig <= true;
							syscall_isa_port_notify <= true;

							syscall_reg_port_sig.dst <= x"00000005";--no need to specify destination
							syscall_reg_port_sig.dstData <= ans;
							syscall_reg_port_notify <= true;

							isa_syscall_port_notify <= false;
							COtoME_port_notify <= false;

					    	section <= writing_done;

						end if;
					else
						MEtoCO_port_notify <= true;
						isa_syscall_port_notify <= false;
						syscall_isa_port_notify <= false;
						syscall_reg_port_notify <= false;
						COtoME_port_notify <= false;

						section <= writing2;
					end if;

				elsif (section = writing_done) then
					if (syscall_isa_port_sync = true) then
						MEtoCO_port_notify <= false;
						isa_syscall_port_notify <= true;
						syscall_isa_port_notify <= false;
						syscall_reg_port_notify <= false;
						COtoME_port_notify <= false;

						section <= process_ecall;
					else
						MEtoCO_port_notify <= false;
						isa_syscall_port_notify <= false;
						syscall_isa_port_notify <= true;
						syscall_reg_port_notify <= false;
						COtoME_port_notify <= false;

						section <= writing_done;
					end if;

				end if;

			end if; -- RST
		end if; -- CLK
	end process;
end SYScallHandler_arch;
