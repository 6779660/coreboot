/*
 *	Memory map:
 *
 *	CONFIG_ROMSTAGE_BASE	: text segment
 *				: rodata segment
 *				: data segment
 *				: bss segment
 *				: stack
 *				: heap
 */
/*
 * Bootstrap code for the STPC Consumer
 * Copyright (c) 1999 by Net Insight AB. All Rights Reserved.
 */

/*
 *	Written by Johan Rydberg, based on work by Daniel Kahlin.
 *      Rewritten by Eric Biederman
 *  2005.12 yhlu add ramstage cross the vga font buffer handling
 */

/* We use ELF as output format. So that we can debug the code in some form. */
/*
 INCLUDE ldoptions
 */

/* We use ELF as output format. So that we can debug the code in some form. */
OUTPUT_FORMAT("elf64-littleaarch64", "elf64-littleaarch64", "elf64-littleaarch64")
OUTPUT_ARCH(aarch64)
INCLUDE ldoptions

PHDRS
{
	to_load PT_LOAD;
}

ENTRY(stage_entry)

SECTIONS
{
	. = CONFIG_ROMSTAGE_BASE;

	.romtext . : {
		_start = .;
		*(.text.stage_entry);
		*(.text.startup);
		*(.text);
		*(.text.*);
	} : to_load

	.romdata . : {
		*(.rodata);
		*(.rodata.*);
		*(.machine_param);
		*(.data);
		*(.data.*);
		. = ALIGN(8);
		_erom = .;
	}

	__image_copy_end = .;

	/* bss does not contain data, it is just a space that should be zero
	 * initialized on startup. (typically uninitialized global variables)
	 * crt0.S fills between _bss and _ebss with zeroes.
	 */
	.bss . : {
		. = ALIGN(8);
		_bss = .;
		*(.bss)
		*(.bss.*)
		*(.sbss)
		*(.sbss.*)
		_ebss = .;
	}

	_end = .;

	/* arm64 chipsets need to define CONFIG_ROMSTAGE_STACK_(TOP|BOTTOM) */
	_stack = CONFIG_ROMSTAGE_STACK_BOTTOM;
	_estack = CONFIG_ROMSTAGE_STACK_TOP;

	preram_cbmem_console = CONFIG_CONSOLE_PRERAM_BUFFER_BASE;

	/* Discard the sections we don't need/want */
	/DISCARD/ : {
		*(.comment)
		*(.note)
		*(.comment.*)
		*(.note.*)
		*(.eh_frame);
	}
}
