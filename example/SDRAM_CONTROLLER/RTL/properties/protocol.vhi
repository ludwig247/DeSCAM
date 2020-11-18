-- @lang=vhi @ts=8

-- protocol macros
macro sdram_nop : boolean :=
    (cs_n_o = '1') and
    (ras_n_o = '1') and
    (cas_n_o = '1') and
    (we_n_o = '1');     
end macro;

macro sdram_active : boolean :=
    (cs_n_o = '0') and
    (ras_n_o = '0') and
    (cas_n_o = '1') and
    (we_n_o = '1');     
end macro;

macro sdram_write : boolean :=
    (cs_n_o = '0') and
    (ras_n_o = '1') and
    (cas_n_o = '0') and
    (we_n_o = '0');     
end macro;

macro sdram_read : boolean :=
    (cs_n_o = '0') and
    (ras_n_o = '1') and
    (cas_n_o = '0') and
    (we_n_o = '1');     
end macro;

macro sdram_prech : boolean :=
    (cs_n_o = '0') and
    (ras_n_o = '0') and
    (cas_n_o = '1') and
    (we_n_o = '0');     
end macro;

macro sdram_stop : boolean :=
    (cs_n_o = '0') and
    (ras_n_o = '1') and
    (cas_n_o = '1') and
    (we_n_o = '0');     
end macro;
