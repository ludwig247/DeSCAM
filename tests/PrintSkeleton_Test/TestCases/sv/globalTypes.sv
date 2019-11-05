package scam_model_types;

	typedef enum logic {
		a,
		b
	} global_enum;

	typedef enum logic {
		m,
		n
	} global_enum_class;

	typedef struct {
		logic b;
		integer unsigned w;
	} global_compound_type;

	typedef integer int_5 [0:4];

endpackage