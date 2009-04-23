/*
 * Copyright (C) 2002,2003 Julien Danjou <julien@jdanjou.org>
 * 
 * This is free software; you can redistribute it and/or modify it 
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2, or (at your option) any
 * later version.
 * 
 * This is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * 
 */


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/io.h>
#include <sys/types.h>
#include <signal.h>
#include <pthread.h>

#include "parportled.h"

static unsigned char lights;

int current_blinking_led[MAXLED];

int blink_thread = -1;


void led_print_debug(char s, char *f)
{	fprintf(stderr, "%s -> %d\n",f,s); }

int led_setperm()
{
	/* Return 1 if the process has not the root perm */
	if(geteuid() != 0) return 1;

	/* Return -1 if the process fails accessing device */
	return ioperm(BASEPORT,1,1);
}

void led_off_all()
{
  outb(0x0, BASEPORT); 
}

void led_on_all()
{
  outb(0xff, BASEPORT); 
}
