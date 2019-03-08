#include <time.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
    char s[24];
    int d = 1;
    if(argc > 1) {
        d = atoi(argv[1]);
        if(!d) d = 1;
    }
    do {
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        strftime(s, 24, "DAY""%a %b %d", &tm);
        puts(s);
        fflush(stdout);
        sleep(d);
    } while(1);
}
