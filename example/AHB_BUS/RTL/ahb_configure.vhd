
library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.ahb_package.all;

package ahb_configure is

--***************************************************************
-- definition of custom amba system parameters
--***************************************************************

--***************************************************************
-- AMBA SLAVES address configuration space
--***************************************************************
--For every slave define HIGH and LOW address, before and after (r)emap 

constant n_u: addr_t := (0, 0);


constant pslv_matrix: addr_matrix_t(1 downto 0) := (
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u),
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u));

constant  ahb_slv0: addr_t := (65535, 0);
constant  ahb_slv1: addr_t := (131071, 65536);
constant  ahb_slv2: addr_t := (196608, 131072);
constant rahb_slv0: addr_t := (65535, 0);
constant rahb_slv1: addr_t := (131071, 65536);
constant rahb_slv2: addr_t := (196608, 131072);

constant slv_matrix: addr_matrix_t(1 downto 0) := (
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,rahb_slv2,rahb_slv1,rahb_slv0),
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,ahb_slv2,ahb_slv1,ahb_slv0));

constant arb_matrix: addr_matrix_t(1 downto 0):= (
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,ahb_slv2,ahb_slv1,ahb_slv0),
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,ahb_slv2,ahb_slv1,ahb_slv0));

constant rarb_matrix: addr_matrix_t(1 downto 0):= (
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,rahb_slv2,rahb_slv1,rahb_slv0),
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,rahb_slv2,rahb_slv1,rahb_slv0));

constant ahbbrg_matrix: addr_matrix_t(1 downto 0) := (
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u),
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u));

constant rahbbrg_matrix: addr_matrix_t(1 downto 0) := (
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u),
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u));

constant apbbrg_matrix: addr_matrix_t(1 downto 0) := (
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u),
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u));

constant rapbbrg_matrix: addr_matrix_t(1 downto 0) := (
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u),
(n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u,n_u));



end;

package body ahb_configure is
end;

