/*
 * Copyright (c) 2015 Wind River Systems, Inc.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

/**
 * @file
 * @brief ISR table for static ISR declarations for ARM
 *
 * Software ISR table for ARM
 */

#include <toolchain.h>
#include <sections.h>
#include <arch/cpu.h>

_ASM_FILE_PROLOGUE

/*
 * enable preprocessor features, such
 * as %expr - evaluate the expression and use it as a string
 */
.altmacro

/*
 * Define an ISR table entry
 * Define symbol as weak and give the section .gnu.linkonce
 * prefix. This allows linker overload the symbol and the
 * whole section by the one defined by a device driver
 */
.macro _isr_table_entry_declare index
	WDATA(_isr_irq\index)
	.section .gnu.linkonce.isr_irq\index
	_isr_irq\index: .word 0xABAD1DEA, _irq_spurious
.endm

/*
 * Declare the ISR table
 */
.macro _isr_table_declare from, to
	counter = \from
	.rept (\to - \from + 1)
		_isr_table_entry_declare %counter
		counter = counter + 1
	.endr
.endm

GTEXT(_irq_spurious)
GDATA(_sw_isr_table)

.section .isr_irq0
.align
_sw_isr_table:

_isr_table_declare 0 CONFIG_NUM_IRQS

