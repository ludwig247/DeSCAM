package globallocal_types;

	import scam_model_types::*;
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
		bit y;
	} local_compound_type;

endpackage