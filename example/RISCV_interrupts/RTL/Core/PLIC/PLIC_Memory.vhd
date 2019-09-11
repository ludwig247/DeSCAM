--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 30.11.18
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity PLIC_Memory is
	port(
		clk						: in  std_logic;
		rst						: in  std_logic;

		-- blocking_in<CUtoME_IF> COtoME_port;
		COtoME_port			: in  CUtoME_IF;
		COtoME_port_sync	: in  boolean;
		COtoME_port_notify	: out boolean;

		-- blocking_out<MEtoCU_IF> MEtoCO_port
		MEtoCO_port			: out MEtoCU_IF;
		MEtoCO_port_sync	: in  boolean;
		MEtoCO_port_notify	: out boolean;

		--  master_out<unsigned int> toCore_Priority_Int_1
		toCore_Priority_Int_1			: out unsigned (31 downto 0);
		toCore_Priority_Int_1_notify	: out bool;


		--  master_out<unsigned int> toCore_Priority_Int_2
		toCore_Priority_Int_2			: out unsigned (31 downto 0);
		toCore_Priority_Int_2_notify	: out bool;

		--  master_out<unsigned int> toCore_Enabled
		toCore_Enabled			: out unsigned (31 downto 0);
		toCore_Enabled_notify	: out bool;

		--  master_out<unsigned int> toCore_Threshold
		toCore_Threshold			: out unsigned (31 downto 0);
		toCore_Threshold_notify	: out bool;

		--  master_out<unsigned int> toCore_Claimed
		toCore_Claimed			: out unsigned (31 downto 0);
		toCore_Claimed_notify	: out bool;

		--  master_out<unsigned int> toGatewayPending_1
		toGatewayPending_1			: out bool;
		toGatewayPending_1_notify	: out bool;

		--  master_out<unsigned int> toGatewayPending_2
		toGatewayPending_2			: out bool;
		toGatewayPending_2_notify	: out bool;

		--  master_in<unsigned int> fromCore_MaxPriority
		-- fromCore_MaxPriority			: in unsigned (31 downto 0);
		--  master_in<unsigned int> fromCore_MaxID
		fromCore_MaxID			: in unsigned (31 downto 0)
	);
end PLIC_Memory;

architecture PLIC_Memory_arch of PLIC_Memory is
	-- Memory Management type and signal
	type mem_sections_type is (read, write_prio_1, write_prio_2, write_enabled, write_threshold, write_claim);
	signal section : mem_sections_type;

	signal memoryRequest : CUtoME_IF;
	signal memoryResponse : MEtoCU_IF;

	-- Memory Mapped registers
	signal ClaimComplete		: unsigned (31 downto 0);
	signal enabled_data			: unsigned (31 downto 0);
	signal priority_Int_1_data	: unsigned (31 downto 0);
	signal priority_Int_2_data	: unsigned (31 downto 0);
	signal threshold_data		: unsigned (31 downto 0);

begin

	process(clk)

		variable COtoME_port_n : bool;
		variable MEtoCO_port_n : bool;
		variable toCore_Claimed_n : bool;
		variable toCore_Enabled_n : bool;
		variable toCore_Priority_Int_1_n : bool;
		variable toCore_Priority_Int_2_n : bool;
		variable toCore_Threshold_n : bool;
		variable toGatewayPending_1_n : bool;
		variable toGatewayPending_2_n : bool;

		variable ClaimComplete_temp : unsigned (31 downto 0);

		begin
			if(clk='1' and clk'event) then
				if rst = '1' then
					ClaimComplete <= (others => '0');
					memoryResponse.loadedData <= (others => '0');
					enabled_data <= (others => '0');
					priority_Int_1_data <= (others => '0');
					priority_Int_2_data <= (others => '0');
					threshold_data <= (others => '0');
					COtoME_port_notify <= true;
					MEtoCO_port_notify <= false;
					toCore_Claimed_notify <= false;
					toCore_Enabled_notify <= false;
					toCore_Priority_Int_1_notify <= false;
					toCore_Priority_Int_2_notify <= false;
					toCore_Threshold_notify <= false;
					toGatewayPending_1_notify <= false;
					toGatewayPending_2_notify <= false;
					section <= read;
				else

					COtoME_port_n := false;
					MEtoCO_port_n := false;
					toCore_Claimed_n := false;
					toCore_Enabled_n := false;
					toCore_Priority_Int_1_n := false;
					toCore_Priority_Int_2_n := false;
					toCore_Threshold_n := false;
					toGatewayPending_1_n := false;
					toGatewayPending_2_n := false;

					ClaimComplete_temp := ClaimComplete;

					if section = read then
						if COtoME_port_sync = true then
							if(ClaimComplete /= fromCore_MaxID) then
								ClaimComplete_temp := fromCore_MaxID;
							end if;

							if (COtoME_port.req = ME_RD) then -- READ

								if (COtoME_port.addrIn = PLIC_Priority_ADDR) then
									memoryResponse.loadedData <= priority_Int_1_data;
									MEtoCO_port.loadedData <= priority_Int_1_data;
									MEtoCO_port_n := true;
									section <= write_prio_1;

								elsif (COtoME_port.addrIn = PLIC_Priority_ADDR + 4) then
									memoryResponse.loadedData <= priority_Int_2_data;
									MEtoCO_port.loadedData <= priority_Int_2_data;
									MEtoCO_port_n := true;
									section <= write_prio_2;

								elsif (COtoME_port.addrIn = PLIC_Interrupt_Enables_ADDR) then
									memoryResponse.loadedData <= enabled_data;
									MEtoCO_port.loadedData <= enabled_data;
									MEtoCO_port_n := true;
									section <= write_enabled;

								elsif (COtoME_port.addrIn = PLIC_Threshold_ADDR) then
									memoryResponse.loadedData <= threshold_data;
									MEtoCO_port.loadedData <= threshold_data;
									MEtoCO_port_n := true;
									section <= write_threshold;

								elsif (COtoME_port.addrIn = PLIC_Claim_Complete_ADDR) then
									memoryResponse.loadedData <= ClaimComplete_temp;
									MEtoCO_port.loadedData <= ClaimComplete_temp;
									MEtoCO_port_n := true;
									toCore_Claimed <= ClaimComplete_temp;
									toCore_Claimed_n := true;
									section <= write_claim;

								else
									memoryResponse.loadedData <= (others => '0');
									COtoME_port_n := true;
									section <= read;

								end if;


							elsif (COtoME_port.req = ME_WR) then -- WRITE
								memoryResponse.loadedData <= (others => '0');

								if (COtoME_port.addrIn = PLIC_Priority_ADDR) then
									priority_Int_1_data <= COtoME_port.dataIn;
									toCore_Priority_Int_1 <= COtoME_port.dataIn;
									toCore_Priority_Int_1_n := true;

								elsif (COtoME_port.addrIn = PLIC_Priority_ADDR + 4) then
									priority_Int_2_data <= COtoME_port.dataIn;
									toCore_Priority_Int_2 <= COtoME_port.dataIn;
									toCore_Priority_Int_2_n := true;

								elsif (COtoME_port.addrIn = PLIC_Pending_ADDR) then
									toGatewayPending_1 <= true;
									toGatewayPending_1_n := true;

								elsif (COtoME_port.addrIn = PLIC_Pending_ADDR + 4) then
									toGatewayPending_2 <= true;
									toGatewayPending_2_n := true;

								elsif (COtoME_port.addrIn = PLIC_Interrupt_Enables_ADDR) then
									enabled_data <= COtoME_port.dataIn;
									toCore_Enabled <= COtoME_port.dataIn;
									toCore_Enabled_n := true;

								elsif (COtoME_port.addrIn = PLIC_Threshold_ADDR) then
									threshold_data <= COtoME_port.dataIn;
									toCore_Threshold <= COtoME_port.dataIn;
									toCore_Threshold_n := true;

								elsif (COtoME_port.addrIn = PLIC_Claim_Complete_ADDR) then
									ClaimComplete_temp := COtoME_port.dataIn;

								--else
								--	memoryResponse.loadedData <= (others => '0');

								end if;

								COtoME_port_n := true;
								section <= read;

							else

								memoryResponse.loadedData <= (others => '0');
								COtoME_port_n := true;
								section <= read;
							end if;

						else
							COtoME_port_n := true;
						end if;

					elsif ( (section = write_prio_1) or (section = write_prio_2) or
							(section = write_enabled) or (section = write_threshold) or
							(section = write_claim) ) then
						if MEtoCO_port_sync = true then
							memoryResponse.loadedData <= (others => '0');
							MEtoCO_port_n := false;
							COtoME_port_n := true;
							section <= read;
						else
							MEtoCO_port_n := true;
						end if;

					end if; -- SECTION

					COtoME_port_notify <= COtoME_port_n;
					MEtoCO_port_notify <= MEtoCO_port_n;
					toCore_Claimed_notify <= toCore_Claimed_n;
					toCore_Enabled_notify <= toCore_Enabled_n;
					toCore_Priority_Int_1_notify <= toCore_Priority_Int_1_n;
					toCore_Priority_Int_2_notify <= toCore_Priority_Int_2_n;
					toCore_Threshold_notify <= toCore_Threshold_n;
					toGatewayPending_1_notify <= toGatewayPending_1_n;
					toGatewayPending_2_notify <= toGatewayPending_2_n;

					ClaimComplete <= ClaimComplete_temp;

				end if; -- RST
			end if; -- CLK
	end process;
end PLIC_Memory_arch;
