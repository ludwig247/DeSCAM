library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.ahb_package.all;

entity s2qed_top is
port(
	clk:		            in std_logic;
	rst:		            in std_logic;

	ahb1_master_in0:		in CUtoAHB_IF;
	ahb1_master_in0_sync:	in Boolean;
	ahb1_master_out0_sync:	in Boolean;
	
    ahb1_master_in1:		in CUtoAHB_IF;
	ahb1_master_in1_sync:	in Boolean;
	ahb1_master_out1_sync:	in Boolean;
    
    ahb1_master_in2:		in CUtoAHB_IF;
	ahb1_master_in2_sync:	in Boolean;
	ahb1_master_out2_sync:	in Boolean;

	    ahb1_master_in3:		in CUtoAHB_IF;
	ahb1_master_in3_sync:	in Boolean;
	ahb1_master_out3_sync:	in Boolean;
	
    ahb1_slave_in0:		    in AHBtoCU_IF;
	ahb1_slave_in0_sync:	in Boolean;
	ahb1_slave_out0_sync:	in Boolean;
	
    ahb1_slave_in1:		    in AHBtoCU_IF;
	ahb1_slave_in1_sync:	in Boolean;
	ahb1_slave_out1_sync:	in Boolean;
	
    ahb1_slave_in2:		    in AHBtoCU_IF;
	ahb1_slave_in2_sync:	in Boolean;
	ahb1_slave_out2_sync:	in Boolean;
	-------------------------------------------------
    ahb2_master_in0:		in CUtoAHB_IF;
	ahb2_master_in0_sync:	in Boolean;
	ahb2_master_out0_sync:	in Boolean;
	
    ahb2_master_in1:		in CUtoAHB_IF;
	ahb2_master_in1_sync:	in Boolean;
	ahb2_master_out1_sync:	in Boolean;
	
    ahb2_master_in2:		in CUtoAHB_IF;
	ahb2_master_in2_sync:	in Boolean;
	ahb2_master_out2_sync:	in Boolean;

    ahb2_master_in3:		in CUtoAHB_IF;
	ahb2_master_in3_sync:	in Boolean;
	ahb2_master_out3_sync:	in Boolean;
	
    ahb2_slave_in0:		    in AHBtoCU_IF;
	ahb2_slave_in0_sync:	in Boolean;
	ahb2_slave_out0_sync:	in Boolean;
	
    ahb2_slave_in1:		    in AHBtoCU_IF;
	ahb2_slave_in1_sync:	in Boolean;
	ahb2_slave_out1_sync:	in Boolean;
	
    ahb2_slave_in2:		    in AHBtoCU_IF;
	ahb2_slave_in2_sync:	in Boolean;
	ahb2_slave_out2_sync:	in Boolean
);
end s2qed_top;

architecture s2qed_arch of s2qed_top is

component ahbTop
port(
	clk:		        in std_logic;
	rst:		        in std_logic;

	master_in0:		    in CUtoAHB_IF;
	master_in0_sync:	in Boolean;
	master_out0_sync:	in Boolean;

	master_in1:		    in CUtoAHB_IF;
	master_in1_sync:	in Boolean;
	master_out1_sync:	in Boolean;

	master_in2:		    in CUtoAHB_IF;
	master_in2_sync:	in Boolean;
	master_out2_sync:	in Boolean;

	master_in3:		    in CUtoAHB_IF;
	master_in3_sync:	in Boolean;
	master_out3_sync:	in Boolean;
	
    master_out0_notify:	out Boolean;
	master_in0_notify:	out Boolean;
	master_out0:		out AHBtoCU_IF;
	
    master_out1_notify:	out Boolean;
	master_in1_notify:	out Boolean;
	master_out1:		out AHBtoCU_IF;
    
    master_out2_notify:	out Boolean;
	master_in2_notify:	out Boolean;
	master_out2:		out AHBtoCU_IF;

    master_out3_notify:	out Boolean;
	master_in3_notify:	out Boolean;
	master_out3:		out AHBtoCU_IF;
	
    slave_in0:		    in AHBtoCU_IF;
	slave_in0_sync:	    in Boolean;
	slave_out0_sync:	in Boolean;
	slave_in0_notify:	out Boolean;
	slave_out0:		    out CUtoAHB_IF;
    slave_out0_notify:	out Boolean;

    slave_in1:		    in AHBtoCU_IF;
	slave_in1_sync:	    in Boolean;
	slave_out1_sync:	in Boolean;
	slave_in1_notify:	out Boolean;
	slave_out1:		    out CUtoAHB_IF;
    slave_out1_notify:	out Boolean;
    
    slave_in2:		    in AHBtoCU_IF;
	slave_in2_sync:	    in Boolean;
	slave_out2_sync:	in Boolean;
	slave_in2_notify:	out Boolean;
	slave_out2:		    out CUtoAHB_IF;
    slave_out2_notify:	out Boolean
);
end component;


    signal ahb1_master_in0_notify    : Boolean;
    signal ahb1_master_out0          : AHBtoCU_IF;
    signal ahb1_master_out0_notify   : Boolean;
    signal ahb1_master_in1_notify    : Boolean;
    signal ahb1_master_out1          : AHBtoCU_IF;
    signal ahb1_master_out1_notify   : Boolean;
    signal ahb1_master_in2_notify    : Boolean;
    signal ahb1_master_out2          : AHBtoCU_IF;
    signal ahb1_master_out2_notify   : Boolean;
    signal ahb1_master_in3_notify    : Boolean;
    signal ahb1_master_out3          : AHBtoCU_IF;
    signal ahb1_master_out3_notify   : Boolean;
    signal ahb1_slave_in0_notify     : Boolean;
    signal ahb1_slave_out0           : CUtoAHB_IF;
    signal ahb1_slave_out0_notify    : Boolean;
    signal ahb1_slave_in1_notify     : Boolean;
    signal ahb1_slave_out1           : CUtoAHB_IF;
    signal ahb1_slave_out1_notify    : Boolean;
    signal ahb1_slave_in2_notify     : Boolean;
    signal ahb1_slave_out2           : CUtoAHB_IF;
    signal ahb1_slave_out2_notify    : Boolean;
    
    signal ahb2_master_in0_notify    : Boolean;
    signal ahb2_master_out0          : AHBtoCU_IF;
    signal ahb2_master_out0_notify   : Boolean;
    signal ahb2_master_in1_notify    : Boolean;
    signal ahb2_master_out1          : AHBtoCU_IF;
    signal ahb2_master_out1_notify   : Boolean;
    signal ahb2_master_in2_notify    : Boolean;
    signal ahb2_master_out2          : AHBtoCU_IF;
    signal ahb2_master_out2_notify   : Boolean;
    signal ahb2_master_in3_notify    : Boolean;
    signal ahb2_master_out3          : AHBtoCU_IF;
    signal ahb2_master_out3_notify   : Boolean;

    signal ahb2_slave_in0_notify     : Boolean;
    signal ahb2_slave_out0           : CUtoAHB_IF;
    signal ahb2_slave_out0_notify    : Boolean;
    signal ahb2_slave_in1_notify     : Boolean;
    signal ahb2_slave_out1           : CUtoAHB_IF;
    signal ahb2_slave_out1_notify    : Boolean;
    signal ahb2_slave_in2_notify     : Boolean;
    signal ahb2_slave_out2           : CUtoAHB_IF;
    signal ahb2_slave_out2_notify    : Boolean;
begin

    ahb1: ahbTop port map(
           master_in0         =>  ahb1_master_in0          
          ,master_in0_sync    =>  ahb1_master_in0_sync   
          ,master_in0_notify  =>  ahb1_master_in0_notify 
          ,master_out0        =>  ahb1_master_out0       
          ,master_out0_sync   =>  ahb1_master_out0_sync  
          ,master_out0_notify =>  ahb1_master_out0_notify
          ,master_in1         =>  ahb1_master_in1        
          ,master_in1_sync    =>  ahb1_master_in1_sync   
          ,master_in1_notify  =>  ahb1_master_in1_notify 
          ,master_out1        =>  ahb1_master_out1       
          ,master_out1_sync   =>  ahb1_master_out1_sync  
          ,master_out1_notify =>  ahb1_master_out1_notify
          ,master_in2         =>  ahb1_master_in2        
          ,master_in2_sync    =>  ahb1_master_in2_sync   
          ,master_in2_notify  =>  ahb1_master_in2_notify 
          ,master_out2        =>  ahb1_master_out2       
          ,master_out2_sync   =>  ahb1_master_out2_sync  
          ,master_out2_notify =>  ahb1_master_out2_notify
	  ,master_in3         =>  ahb1_master_in3       
          ,master_in3_sync    =>  ahb1_master_in3_sync   
          ,master_in3_notify  =>  ahb1_master_in3_notify 
          ,master_out3        =>  ahb1_master_out3      
          ,master_out3_sync   =>  ahb1_master_out3_sync  
          ,master_out3_notify =>  ahb1_master_out3_notify
          ,slave_in0          =>  ahb1_slave_in0         
          ,slave_in0_sync     =>  ahb1_slave_in0_sync    
          ,slave_in0_notify   =>  ahb1_slave_in0_notify  
          ,slave_out0         =>  ahb1_slave_out0        
          ,slave_out0_sync    =>  ahb1_slave_out0_sync   
          ,slave_out0_notify  =>  ahb1_slave_out0_notify 
          ,slave_in1          =>  ahb1_slave_in1         
          ,slave_in1_sync     =>  ahb1_slave_in1_sync    
          ,slave_in1_notify   =>  ahb1_slave_in1_notify  
          ,slave_out1         =>  ahb1_slave_out1        
          ,slave_out1_sync    =>  ahb1_slave_out1_sync   
          ,slave_out1_notify  =>  ahb1_slave_out1_notify 
          ,slave_in2          =>  ahb1_slave_in2         
          ,slave_in2_sync     =>  ahb1_slave_in2_sync    
          ,slave_in2_notify   =>  ahb1_slave_in2_notify  
          ,slave_out2         =>  ahb1_slave_out2        
          ,slave_out2_sync    =>  ahb1_slave_out2_sync   
          ,slave_out2_notify  =>  ahb1_slave_out2_notify 
          ,rst                =>  rst
          ,clk                =>  clk
          ); 

    ahb2: ahbTop port map(
           master_in0         =>  ahb2_master_in0          
          ,master_in0_sync    =>  ahb2_master_in0_sync   
          ,master_in0_notify  =>  ahb2_master_in0_notify 
          ,master_out0        =>  ahb2_master_out0       
          ,master_out0_sync   =>  ahb2_master_out0_sync  
          ,master_out0_notify =>  ahb2_master_out0_notify
          ,master_in1         =>  ahb2_master_in1        
          ,master_in1_sync    =>  ahb2_master_in1_sync   
          ,master_in1_notify  =>  ahb2_master_in1_notify 
          ,master_out1        =>  ahb2_master_out1       
          ,master_out1_sync   =>  ahb2_master_out1_sync  
          ,master_out1_notify =>  ahb2_master_out1_notify
          ,master_in2         =>  ahb2_master_in2        
          ,master_in2_sync    =>  ahb2_master_in2_sync   
          ,master_in2_notify  =>  ahb2_master_in2_notify 
          ,master_out2        =>  ahb2_master_out2       
          ,master_out2_sync   =>  ahb2_master_out2_sync  
          ,master_out2_notify =>  ahb2_master_out2_notify
	  ,master_in3         =>  ahb2_master_in3       
          ,master_in3_sync    =>  ahb2_master_in3_sync   
          ,master_in3_notify  =>  ahb2_master_in3_notify 
          ,master_out3        =>  ahb2_master_out3      
          ,master_out3_sync   =>  ahb2_master_out3_sync  
          ,master_out3_notify =>  ahb2_master_out3_notify
          ,slave_in0          =>  ahb2_slave_in0         
          ,slave_in0_sync     =>  ahb2_slave_in0_sync    
          ,slave_in0_notify   =>  ahb2_slave_in0_notify  
          ,slave_out0         =>  ahb2_slave_out0        
          ,slave_out0_sync    =>  ahb2_slave_out0_sync   
          ,slave_out0_notify  =>  ahb2_slave_out0_notify 
          ,slave_in1          =>  ahb2_slave_in1         
          ,slave_in1_sync     =>  ahb2_slave_in1_sync    
          ,slave_in1_notify   =>  ahb2_slave_in1_notify  
          ,slave_out1         =>  ahb2_slave_out1        
          ,slave_out1_sync    =>  ahb2_slave_out1_sync   
          ,slave_out1_notify  =>  ahb2_slave_out1_notify 
          ,slave_in2          =>  ahb2_slave_in2         
          ,slave_in2_sync     =>  ahb2_slave_in2_sync    
          ,slave_in2_notify   =>  ahb2_slave_in2_notify  
          ,slave_out2         =>  ahb2_slave_out2        
          ,slave_out2_sync    =>  ahb2_slave_out2_sync   
          ,slave_out2_notify  =>  ahb2_slave_out2_notify 
          ,rst                =>  rst
          ,clk                =>  clk
          ); 


end s2qed_arch;

