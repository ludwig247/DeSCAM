-- @lang=vhi @ts=8

completeness main_cluster is

dependencies: no_reset, no_split_retry, bounded_slave_out0_sync, bounded_slave_in0_sync;

determination_assumptions:
determined(rst);
determined(mst_to_mtx0);
determined(mst_to_mtx1);
determined(slave_in0_sync);
determined(slave_out0_sync);
determined(slave_in0);
determined(master0_stage);
determined(master1_stage);

determination_requirements:
determined(slave_out0_notify);

if(slave_out0_notify) then determined(slave_out0) end if;

if((slave_in0_notify and slave_in0_sync) or (prev(slave_in0_notify) and prev(slave_in0_sync) and prev(rst) = '0')) then--- TODO: need to be determined from defslave too somehow
determined(mtx_to_mst0.hresp),
determined(mtx_to_mst1.hresp)
end if;



if(prev(slave_in0_notify) and prev(slave_in0_sync) and prev(rst) = '0') then ---since output from defslave is supposedly undefined then this probably doesnt need to be defined there
determined(mtx_to_mst0.hrdata),
determined(mtx_to_mst1.hrdata)
end if;



determined(mtx_to_mst0.hready);
determined(mtx_to_mst1.hready);
determined(mtx_to_mst0.hgrant), end_offset=-1;
determined(mtx_to_mst1.hgrant), end_offset=-1;

determined(slave_in0_notify);

reset_property: reset;


property_graph:

reset -> from_idle_state_to_idle_state, from_idle_state_to_nonseq_m1, from_idle_state_to_nonseq_m0;

from_idle_state_to_idle_state -> from_idle_state_to_idle_state, from_idle_state_to_nonseq_m0, from_idle_state_to_nonseq_m1;

-------------------------------------------------------------
-------------------------------------------------------------
-----------------------MASTER 0 BRANCH----------------------- 

from_idle_state_to_nonseq_m0 -> from_nonseq_m0_to_slave0_m0_idle_m1, from_nonseq_m0_to_slave0_m0_nonseq_m1, 
                                from_nonseq_m0_to_defslave_m0_idle_m1, from_nonseq_m0_to_defslave_m0_nonseq_m1;

-------------------------------------------------------------------
-------------------------from_nonseq_m0_to_slave0_m0_idle_m1 branch

from_nonseq_m0_to_slave0_m0_idle_m1 -> slave0_m0_idle_m1_start;

slave0_m0_idle_m1_start-> from_slave0_m0_idle_m1_to_idle_state, from_slave0_m0_idle_m1_to_nonseq_m1;

---

from_slave0_m0_idle_m1_to_idle_state -> from_idle_state_to_idle_state, from_idle_state_to_nonseq_m0, from_idle_state_to_nonseq_m1; ----END

from_slave0_m0_idle_m1_to_nonseq_m1 -> from_nonseq_m1_to_slave0_m1_idle_m0, from_nonseq_m1_to_slave0_m1_nonseq_m0, 
                                      from_nonseq_m1_to_defslave_m1_idle_m0, from_nonseq_m1_to_defslave_m1_nonseq_m0;




------------------------------------------------------------------------------
--------------------------------from_nonseq_m0_to_slave0_m0_idle_m1 branch end




-------------------------------------------------------------------
-------------------------from_nonseq_m0_to_slave0_m0_nonseq_m1 branch


from_nonseq_m0_to_slave0_m0_nonseq_m1 -> slave0_m0_nonseq_m1_start;

slave0_m0_nonseq_m1_start -> from_slave0_m0_nonseq_m1_to_slave0_m1, from_slave0_m0_nonseq_m1_to_defslave_m1;

---

from_slave0_m0_nonseq_m1_to_slave0_m1 -> slave0_m1_idle_m0_start;
from_slave0_m0_nonseq_m1_to_defslave_m1 -> from_defslave_m1_idle_m0_to_idle_m0_error_m1; 


-------------------------------------------------------------------------
-------------------------from_nonseq_m0_to_slave0_m0_nonseq_m1 branch end

-------------------------------------------------------------------
-------------------------from_nonseq_m0_to_defslave_m0_idle_m1 branch

from_nonseq_m0_to_defslave_m0_idle_m1 -> from_defslave_m0_idle_m1_to_idle_m1_error_m0;
from_defslave_m0_idle_m1_to_idle_m1_error_m0 -> from_error_m0_idle_m1_to_idle_state, from_error_m0_idle_m1_to_nonseq_m1;

-------------------------------------------------------------------------
-------------------------from_nonseq_m0_to_defslave_m0_idle_m1 branch end




---------------------------------------------------------------------------
-------------------------from_nonseq_m0_to_defslave_m0_nonseq_m1 branch

from_nonseq_m0_to_defslave_m0_nonseq_m1 -> from_defslave_m0_nonseq_m1_to_nonseq_m1_error_m0;
from_defslave_m0_nonseq_m1_to_nonseq_m1_error_m0 -> from_error_m0_nonseq_m1_to_slave0_m1, from_error_m0_nonseq_m1_to_defslave_m1;

---------------------------------------------------------------------------
-------------------------from_nonseq_m0_to_defslave_m0_nonseq_m1 branch end


---------------------------------------------------------------------------
--------------------------------from m0 error states branch

from_error_m0_idle_m1_to_idle_state -> from_idle_state_to_idle_state, from_idle_state_to_nonseq_m0, from_idle_state_to_nonseq_m1; ----END

from_error_m0_idle_m1_to_nonseq_m1 -> from_nonseq_m1_to_slave0_m1_idle_m0, from_nonseq_m1_to_slave0_m1_nonseq_m0, 
                                from_nonseq_m1_to_defslave_m1_idle_m0, from_nonseq_m1_to_defslave_m1_nonseq_m0; 

from_error_m0_nonseq_m1_to_slave0_m1 -> slave0_m1_idle_m0_start;
from_error_m0_nonseq_m1_to_defslave_m1 -> from_defslave_m1_idle_m0_to_idle_m0_error_m1; 

---------------------------------------------------------------------------
--------------------------------from m0 error states branch end


-------------------------------------------------------------
-------------------------------------------------------------
--------------------MASTER 0 BRANCH END----------------------





-------------------------------------------------------------
-------------------------------------------------------------
-----------------------MASTER 1 BRANCH-----------------------



from_idle_state_to_nonseq_m1 -> from_nonseq_m1_to_slave0_m1_idle_m0, from_nonseq_m1_to_slave0_m1_nonseq_m0, 
                                from_nonseq_m1_to_defslave_m1_idle_m0, from_nonseq_m1_to_defslave_m1_nonseq_m0;


-------------------------------------------------------------------
-------------------------from_nonseq_m0_to_slave0_m0_idle_m1 branch

from_nonseq_m1_to_slave0_m1_idle_m0 -> slave0_m1_idle_m0_start;

slave0_m1_idle_m0_start-> from_slave0_m1_idle_m0_to_idle_state, from_slave0_m1_idle_m0_to_nonseq_m0;

---

from_slave0_m1_idle_m0_to_idle_state -> from_idle_state_to_idle_state, from_idle_state_to_nonseq_m0, from_idle_state_to_nonseq_m1; ----END

from_slave0_m1_idle_m0_to_nonseq_m0 -> from_nonseq_m0_to_slave0_m0_idle_m1, from_nonseq_m0_to_slave0_m0_nonseq_m1, 
                                      from_nonseq_m0_to_defslave_m0_idle_m1, from_nonseq_m0_to_defslave_m0_nonseq_m1;


------------------------------------------------------------------------------
--------------------------------from_nonseq_m0_to_slave0_m0_idle_m1 branch end




-------------------------------------------------------------------
-------------------------from_nonseq_m0_to_slave0_m0_nonseq_m1 branch


from_nonseq_m1_to_slave0_m1_nonseq_m0 -> slave0_m1_nonseq_m0_start;

slave0_m1_nonseq_m0_start -> from_slave0_m1_nonseq_m0_to_slave0_m0, from_slave0_m1_nonseq_m0_to_defslave_m0;

---

from_slave0_m1_nonseq_m0_to_slave0_m0 -> slave0_m0_idle_m1_start;
from_slave0_m1_nonseq_m0_to_defslave_m0 -> from_defslave_m0_idle_m1_to_idle_m1_error_m0; 



-------------------------------------------------------------------------
-------------------------from_nonseq_m0_to_slave0_m0_nonseq_m1 branch end

-------------------------------------------------------------------
-------------------------from_nonseq_m0_to_defslave_m0_idle_m1 branch

from_nonseq_m1_to_defslave_m1_idle_m0 -> from_defslave_m1_idle_m0_to_idle_m0_error_m1;
from_defslave_m1_idle_m0_to_idle_m0_error_m1 -> from_error_m1_idle_m0_to_idle_state, from_error_m1_idle_m0_to_nonseq_m0;

-------------------------------------------------------------------------
-------------------------from_nonseq_m0_to_defslave_m0_idle_m1 branch end




---------------------------------------------------------------------------
-------------------------from_nonseq_m0_to_defslave_m0_nonseq_m1 branch

from_nonseq_m1_to_defslave_m1_nonseq_m0 -> from_defslave_m1_nonseq_m0_to_nonseq_m0_error_m1;
from_defslave_m1_nonseq_m0_to_nonseq_m0_error_m1 -> from_error_m1_nonseq_m0_to_slave0_m0, from_error_m1_nonseq_m0_to_defslave_m0;

---------------------------------------------------------------------------
-------------------------from_nonseq_m0_to_defslave_m0_nonseq_m1 branch end


---------------------------------------------------------------------------
--------------------------------from m1 error states branch

from_error_m1_idle_m0_to_idle_state -> from_idle_state_to_idle_state, from_idle_state_to_nonseq_m0, from_idle_state_to_nonseq_m1; ----END

from_error_m1_idle_m0_to_nonseq_m0 -> from_nonseq_m0_to_slave0_m0_idle_m1, from_nonseq_m0_to_slave0_m0_nonseq_m1, 
                                from_nonseq_m0_to_defslave_m0_idle_m1, from_nonseq_m0_to_defslave_m0_nonseq_m1; 

from_error_m1_nonseq_m0_to_slave0_m0 -> slave0_m0_idle_m1_start;
from_error_m1_nonseq_m0_to_defslave_m0 -> from_defslave_m0_idle_m1_to_idle_m1_error_m0; 

---------------------------------------------------------------------------
--------------------------------from m1 error states branch end


-------------------------------------------------------------
-------------------------------------------------------------
--------------------MASTER 1 BRANCH END----------------------



end completeness;