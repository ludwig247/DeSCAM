package scam_model_types;

	import scam_model_types::*;
	typedef enum logic {
		read,
		write
	} Mode;

	typedef enum logic {
		a,
		b
	} global_enum;

	typedef enum logic {
		m,
		n
	} global_enum_class;

	typedef struct {
		Mode mode;
		integer x;
		bit y;
	} CompoundType;

	typedef struct {
		bit b;
		bit[31:0] w;
	} global_compound_type;

	typedef integer int_2 [0:1];

	typedef integer int_5 [0:4];

	typedef struct {
		integer x;
		bit[31:0] y;
	} record_t;

	typedef struct {
		integer x;
		bit[31:0] y;
	} test_compound;

endpackage