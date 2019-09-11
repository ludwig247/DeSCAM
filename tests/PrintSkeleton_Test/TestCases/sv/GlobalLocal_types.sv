package globallocal_types;

	typedef enum logic {
		run
	} GlobalLocal_SECTIONS;

	typedef enum logic {
		x,
		y
	} local_enum;

	typedef enum logic {
		d,
		e
	} local_enum_class;

	typedef struct {
		global_enum fest;
		integer x;
		logic y;
	} local_compound_type;

endpackage
