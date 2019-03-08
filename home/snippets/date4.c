#include <time.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
    char s[24];
    char c[24] = "0";

    do {
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        strftime(s, 24, "DAY""%a %b %d", &tm);
        if (strcmp(s,c)!=0) {
            puts(s);
            fflush(stdout);
            strftime(c, 24, "DAY""%a %b %d", &tm);
        }
        sleep(3600 - 60 * tm.tm_min - tm.tm_sec);
    } while(1);
}
