OUTPUT_ARCH( "riscv" )

_STACK_SIZE = DEFINED(_STACK_SIZE) ? _STACK_SIZE : 0x1000;
_HEAP_SIZE = DEFINED(_HEAP_SIZE) ? _HEAP_SIZE : 0x1000;

/*****************************************************************************
 * Define memory layout
 ****************************************************************************/
MEMORY {
	imem : ORIGIN = 0x00000000, LENGTH = 0x00020000
	dmem : ORIGIN = 0x00020000, LENGTH = 0x00020000
}

/* Specify the default entry point to the program */

ENTRY(_mstart)

/*****************************************************************************
 * Define the sections, and where they are mapped in memory 
 ****************************************************************************/
SECTIONS {
	.text : {
	    *boot.o(.text);
		*(.text);
		*(.text.*);
	} > imem

	.init : {
	   KEEP (*(.init))
	} > imem

    .fini : {
       KEEP (*(.fini))
    } > imem

    .rodata : {
       __rodata_start = .;
       *(.rodata)
       *(.rodata.*)
       *(.gnu.linkonce.r.*)
       __rodata_end = .;
	} > dmem

	.sbss : {
	   __sbss_start = .;
	   *(.sbss)
	   *(.sbss.*)
	   *(.gnu.linkonce.sb.*)
	   __sbss_end = .;
	} > dmem
	
    .sdata : {
        _gp = . + 0x800;
        *(.srodata.cst16) *(.srodata.cst8) *(.srodata.cst4) *(.srodata.cst2) *(.srodata*)
        *(.sdata .sdata.* .gnu.linkonce.s.*)
     }	> dmem

	.data : {
	   . = ALIGN(4);
	   __data_start = .;
	   *(.data)
	   *(.data.*)
	   *(.gnu.linkonce.d.*)
	   __data_end = .;
	} > dmem

    .bss : {
       . = ALIGN(4);
       __bss_start = .;
       *(.bss)
       *(.bss.*)
       *(.gnu.linkonce.b.*)
       *(COMMON)
       . = ALIGN(4);
       __bss_end = .;
    } > dmem

    /* Generate Stack and Heap definitions */

    .heap : {
       . = ALIGN(4);
       _heap = .;
       _heap_start = .;
       . += _HEAP_SIZE;
       _heap_end = .;
    } > dmem

    .stack : {
       _stack_end = .;
       . += _STACK_SIZE;
       . = ALIGN(4);
       _stack = .;
       __stack = _stack;
    } > dmem
    
    _end = .;
}
