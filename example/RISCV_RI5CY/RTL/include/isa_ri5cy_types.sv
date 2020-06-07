package isa_ri5cy_types;

	 import top_level_types::*;
	typedef enum logic [1:0] {
		decode_ph,
		execute_ph,
		fetch_ph,
		w_back_ph
	} Sections;

endpackage