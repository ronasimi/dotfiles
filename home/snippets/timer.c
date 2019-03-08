#include <time.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
    int d = 1;
    if(argc > 1) {
        d = atoi(argv[1]);
        if(!d) d = 1;
    }
    do {
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        printf("%d\n",
                tm.tm_min);
	fflush(stdout);
        sleep(d);
    } while(1);
}
