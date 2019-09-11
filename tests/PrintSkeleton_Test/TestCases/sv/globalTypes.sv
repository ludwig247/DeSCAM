package scam_model_types;

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
		logic y;
	} CompoundType;

	typedef struct {
		logic b;
		integer unsigned w;
	} global_compound_type;

	typedef integer int_5 [0:4];

	typedef struct {
		integer x;
		integer unsigned y;
	} record_t;

	typedef struct {
		integer x;
		integer unsigned y;
	} test_compound;

endpackage
