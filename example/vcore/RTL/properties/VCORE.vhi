-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro instr_req_notify : boolean := imem_read_o end macro;

-- DP SIGNALS --
macro instr_in_sig : unsigned := imem_data_i end macro;
macro instr_req_sig : unsigned := imem_addr_o end macro;

-- CONSTRAINTS --
constraint no_reset := reset_n = '1'; end constraint;

macro max_wait_dmem: unsigned  := 3 ; end macro;

constraint bounded_wait := disable iff: not(reset_n);
    if (dmem_enable_o) then
        exists i in 0..(max_wait_dmem-1):
            next(dmem_valid_i,i);
        end exists;
    end if;
end constraint;

-- STATES --
macro fetch_0 : boolean :=  (dmem_enable_o=0 or dmem_valid_i) end macro;
macro decode_1 : boolean := dec_valid end macro;
macro execute_2 : boolean := ex_valid end macro;
macro wb_3 : boolean := wb_valid end macro;

--HELPERS--
/*
macro getDest(inst: unsigned): unsigned :=
	case inst(15 downto 11) is
	when 4 => inst(10 downto 8);
	when 6 => inst(10 downto 8);
	when 0 => inst(4 downto 2);
	when 1 => inst(4 downto 2);
	when 2 => inst(4 downto 2);
	when others => prev(ex_dest_reg);
	end case;
end macro;
*/
macro getWriteBack(inst: unsigned): unsigned :=
	if(inst(15 downto 11) = 0 or inst(15 downto 11) = 1 or inst(15 downto 11) = 2 or inst(15 downto 11) = 4) then 1;
	else 0;
	end if;
end macro;

macro pc_next : unsigned :=
if(dec_valid) then
	if(ex_mispredict) then
		(ex_op_b+(2*ex_pc)(15 downto 0))(15 downto 0);
	else
	   (dec_pc+2)(15 downto 0)
	end if;
else dec_pc end if
end macro;

macro IR : unsigned := instruction_word_reg end macro;

macro virtual_register2(r: unsigned):  unsigned  :=
  if (ex_write_reg and ex_valid and ex_dest_reg = r) then
    ex_read_from_mem? dmem_data_i : ex_result;
  elsif prev(dec_valid,2) and (prev(ex_write_reg and ex_dest_reg = r)) then
    next(regfile(r));
  else
    regfile(r);
  end if;
end macro;

macro getALUresult(opcode: unsigned;op1: unsigned; op2: unsigned): unsigned :=
	if(opcode = 0) then unsigned(not((op1)));
	elsif(opcode = 1) then (unsigned((op1)) + unsigned((op2)))(15 downto 0);
	elsif((opcode = 2)) then unsigned((op1)-(op2))(15 downto 0);
	else (unsigned((op1)) + unsigned((op2)))(15 downto 0);
	end if;
end macro;
/*
macro getOpCode(instr:unsigned): unsigned :=
	  instr(15 downto 11);
end macro;
*/

macro getDest(instr: unsigned) : unsigned :=
	if ((getOpCode(instr) = resize(4,32))) then unsigned(((shift_right(instr,resize(8,32))) and resize(7,32)))
	else unsigned(((shift_right(instr,resize(2,32))) and resize(7,32)))
end if;
end macro;

macro getOpA(instr: unsigned) : unsigned :=
	unsigned(((shift_right(instr,resize(8,32))) and resize(7,32)));
end macro;

macro getOpB(instr: unsigned) : unsigned :=
	unsigned(((shift_right(instr,resize(5,16))) and resize(7,16)));
end macro;

macro getOpCode(instr: unsigned) : unsigned :=
	unsigned((shift_right(instr,resize(11,32))));
end macro;

macro getImm(instr: unsigned) : unsigned :=
	if(getOpCode(instr) /= 7) then 
	unsigned(resize(signed(instr(4 downto 0)),16))
	else 
	unsigned(resize(signed(instr(7 downto 0)),16)*2)
	end if;
end macro;
