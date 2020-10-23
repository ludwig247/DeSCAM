package top_level_types;

	 import top_level_types::*;
	typedef enum logic {
		a,
		b
	} global_enum;

	typedef enum logic {
		m,
		n
	} global_enum_class;

	typedef struct {
		bit b;
		bit[31:0] w;
	} global_compound_type;

	typedef integer int_5 [0:4];

endpackage