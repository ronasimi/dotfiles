#include <time.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
    char s[9];
    char c[9] = "0";
    int d = 1;
    if(argc > 1) {
        d = atoi(argv[1]);
        if(!d) d = 1;
    }
    do {
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        strftime(s, 24, "CLK""%R", &tm);
        if (strcmp(s,c)!=0) {
            puts(s);
            fflush(stdout);
            strftime(c, 24, "CLK""%R", &tm);
        }
    sleep(d);
    } while(1);
}
