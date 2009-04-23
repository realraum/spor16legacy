#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

#include <parportled.h>

/* Get the current statistics on the cpu */


int loop(void)
{
  FILE *pstat;
  int load;
  int lights[MAXLED];
  int blink=0;
	

//	led_off_all();
	
//		for(load = 0; load <= ; load++)
//			lights[1] = 1;

  led_on(1);

		//led_set_on(lights);
		
//	led_on_all();	

  return(0);
}

int main(int argc, char **argv)
{

      loop();
	
  return(EXIT_SUCCESS);
}
