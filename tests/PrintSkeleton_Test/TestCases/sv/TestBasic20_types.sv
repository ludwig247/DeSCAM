package testbasic20_types;

	 import top_level_types::*;
	typedef enum logic {
		section_a,
		section_b
	} Sections;

	typedef enum logic [1:0] {
		green,
		red,
		yellow
	} color_t;

endpackage