/*
 * Copyright 2014 Google Inc.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but without any warranty; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
 */

#include <exception.h>
#include <gdb.h>
#include <libpayload.h>

struct gdb_regs
{
	u64 x[32];
	struct fp_reg
	{
		u64 quad[2];
	} __attribute__((packed)) f[32];
	u32 fpcr;
	u32 fpsr;
	u32 spsr;
} __attribute__((packed));

static const u8 type_to_signal[] = {
	[EXC_INV]    = GDB_SIGILL,
	[EXC_SYNC]   = GDB_SIGTRAP,
	[EXC_IRQ]    = GDB_SIGSEGV,
	[EXC_FIQ]    = GDB_SIGSEGV,
	[EXC_SERROR] = GDB_SIGSEGV
};

static int gdb_exception_hook(u32 type)
{
	return -1;
}

void gdb_arch_init(void)
{
	exception_install_hook(&gdb_exception_hook);
}

void gdb_arch_enter(void)
{
}

int gdb_arch_set_single_step(int on)
{
	/* GDB seems to only need this on x86, ARM works fine without it. */
	return -1;
}

void gdb_arch_encode_regs(struct gdb_message *message)
{
}

void gdb_arch_decode_regs(int offset, struct gdb_message *message)
{
}
