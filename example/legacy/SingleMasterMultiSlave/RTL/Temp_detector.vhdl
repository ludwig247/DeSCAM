library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Temp_detector is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	adc_in:		in int;
	sample_event_sync:	 in std_logic;
	sample_event_notify:	 out std_logic;
	temp_out:		out int);
end Temp_detector;



architecture Temp_detector_arch of Temp_detector is
signal section: Temp_detector_SECTIONS;
			 signal adc_value_signal:int;
			 signal avg_temp_signal:int;
			 signal avg_temp_last_signal:int;
			 signal measured_sum_ok_signal:int;
			 signal sample_cnt_signal:int;
			 signal sample_cnt_ok_signal:int;
			 signal sample_event_notify_tmp:std_logic;
			 signal computing:int;
			 
begin	
	sample_event_notify <= sample_event_notify_tmp;
		
	 process(clk)
	 variable compute: int;
	 variable correct_sample:bool;
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			section <=UPDATE;
			adc_value_signal<=0;
			avg_temp_signal<=20;
			avg_temp_last_signal<=20;
			measured_sum_ok_signal<=0;
			sample_cnt_signal<=0;
			sample_cnt_ok_signal<=0;
			temp_out <= 20;
			sample_event_notify_tmp <= '1';
			computing <= 0;
		 else
	     correct_sample := adc_in >= 1 and adc_in <= 39 and abs(avg_temp_last_signal - adc_in)<=9;
             if section = CHECK then
			if(not(sample_cnt_signal = 15)) then
				section <= MEASURE;
				sample_event_notify_tmp <= '1'; 
				sample_cnt_signal <= sample_cnt_signal + 1;
				adc_value_signal <= adc_in;
				if(correct_sample) then
					sample_cnt_ok_signal <= sample_cnt_ok_signal + 1;
					measured_sum_ok_signal <= measured_sum_ok_signal + adc_in;
				end if;
			elsif(sample_cnt_signal = 15 and sample_cnt_ok_signal <= 9) then
					section <= UPDATE;
					adc_value_signal <= adc_in;
					measured_sum_ok_signal <= 0;
					sample_cnt_signal <= 0;
					sample_cnt_ok_signal <= 0;
					temp_out <= avg_temp_last_signal;
					adc_value_signal <= adc_in;
					avg_temp_signal <= avg_temp_last_signal;
	
			elsif(sample_cnt_signal = 15 and sample_cnt_ok_signal <= 10 and not(correct_sample)) then
					section <= UPDATE;
					adc_value_signal <= adc_in;
					measured_sum_ok_signal <= 0;
					avg_temp_signal <= avg_temp_last_signal;
					sample_cnt_signal <= 0;
					sample_cnt_ok_signal <= 0;
					temp_out <= avg_temp_last_signal;
					adc_value_signal <= adc_in;
			elsif(sample_cnt_signal = 15 and sample_cnt_ok_signal >= 10 and (correct_sample)) then
					section <= UPDATE;
					adc_value_signal <= adc_in;
					compute := (measured_sum_ok_signal + adc_in) / (sample_cnt_ok_signal+1);
					avg_temp_signal <= compute;
					avg_temp_last_signal <= compute;
					temp_out <= compute;
					measured_sum_ok_signal <= 0;
					sample_cnt_signal <= 0;
					sample_cnt_ok_signal <= 0;
					
			elsif(sample_cnt_signal = 15 and sample_cnt_ok_signal >= 11 and not(correct_sample)) then
					section <= UPDATE;
					adc_value_signal <= adc_in;
					compute := measured_sum_ok_signal / sample_cnt_ok_signal;
					avg_temp_signal <= compute;
					avg_temp_last_signal <= compute;
					temp_out <= compute;
					measured_sum_ok_signal <= 0;
					sample_cnt_signal <= 0;
					sample_cnt_ok_signal <= 0;
					
			end if;
			--elsif(sample_cnt_signal = 15 and sample_cnt_ok_signal >= 11) then 
				
                     
             elsif section = MEASURE then
			if(sample_event_sync = '1') then 
				section <= CHECK;	
				sample_event_notify_tmp <= '0';
			end if;
             elsif section = UPDATE then
			section <= MEASURE;
			sample_event_notify_tmp <= '1'; 
                     
            end if;
         end if;
     end if;
	 end process;
end Temp_detector_arch;

