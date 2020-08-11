
--*******************************************************************
--**                                                             ****
--**  AHB system generator                                       ****
--**                                                             ****
--**  Author: Federico Aglietti                                  ****
--**          federico.aglietti@opencores.org                   ****
--**                                                             ****
--*******************************************************************
--**                                                             ****
--** Copyright (C) 2004 Federico Aglietti                        ****
--**                    federico.aglietti@opencores.org         ****
--**                                                             ****
--** This source file may be used and distributed without        ****
--** restriction provided that this copyright statement is not   ****
--** removed from the file and that any derivative work contains ****
--** the original copyright notice and the associated disclaimer.****
--**                                                             ****
--**     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ****
--** EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ****
--** TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ****
--** FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ****
--** OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ****
--** INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ****
--** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ****
--** GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ****
--** BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ****
--** LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ****
--** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ****
--** OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ****
--** POSSIBILITY OF SUCH DAMAGE.                                 ****
--**                                                             ****
--*******************************************************************
library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_misc.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;

use work.ahb_package.all;
use work.ahb_configure.all;
use work.ahb_components.all;

entity ahb_matrix is
port(
hresetn: in std_logic;
hclk: in std_logic;	

ahb_mst_0_out: in mst_out_t;
ahb_mst_0_in: out mst_in_t;

ahb_mst_1_out: in mst_out_t;
ahb_mst_1_in: out mst_in_t;

ahb_mst_2_out: in mst_out_t;
ahb_mst_2_in: out mst_in_t;

ahb_mst_3_out: in mst_out_t;
ahb_mst_3_in: out mst_in_t;

ahb_slv_0_out: in slv_out_t;
ahb_slv_0_in: out slv_in_t;

ahb_slv_1_out: in slv_out_t;
ahb_slv_1_in: out slv_in_t;

ahb_slv_2_out: in slv_out_t;
ahb_slv_2_in: out slv_in_t;

remap: in std_logic
	);
end;

architecture rtl of ahb_matrix is

signal mst_out_arb_0_v: mst_in_v_t(3 downto 0);
signal mst_in_arb_0_v: mst_out_v_t(3 downto 0);
signal slv_out_arb_0_v: slv_in_v_t(2 downto 0);
signal slv_in_arb_0_v: slv_out_v_t(2 downto 0);
signal addr_arb_matrix: addr_matrix_t(0 downto 0);
signal addr_ahbbrg_matrix: addr_matrix_t(1 downto 0);
signal addr_apbbrg_matrix: addr_matrix_t(1 downto 0);

begin


ahb_mst_0_in <= mst_out_arb_0_v(3);
mst_in_arb_0_v(3) <= ahb_mst_0_out;
ahb_mst_1_in <= mst_out_arb_0_v(2);
mst_in_arb_0_v(2) <= ahb_mst_1_out;
ahb_mst_2_in <= mst_out_arb_0_v(1);
mst_in_arb_0_v(1) <= ahb_mst_2_out;
ahb_mst_3_in <= mst_out_arb_0_v(0);
mst_in_arb_0_v(0) <= ahb_mst_3_out;
ahb_slv_2_in <= slv_out_arb_0_v(2);
slv_in_arb_0_v(2) <= ahb_slv_2_out;
ahb_slv_1_in <= slv_out_arb_0_v(1);
slv_in_arb_0_v(1) <= ahb_slv_1_out;
ahb_slv_0_in <= slv_out_arb_0_v(0);
slv_in_arb_0_v(0) <= ahb_slv_0_out;

ahb_arb0: ahb_arbiter 
generic map(
num_arb => 0,
num_arb_msts => 4,
num_slvs => 3,
def_arb_mst => 0,
alg_number => 0)
port map(
  hresetn => hresetn,
  hclk => hclk,
  remap => remap,
  mst_in_v => mst_in_arb_0_v(3 downto 0),
  mst_out_v => mst_out_arb_0_v(3 downto 0),
  slv_in_v => slv_in_arb_0_v(2 downto 0),
  slv_out_v => slv_out_arb_0_v(2 downto 0));


end rtl;

