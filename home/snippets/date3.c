#include <time.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
    char s[24];
    do {
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        strftime(s, 24, "DAY""%a %b %d", &tm);
        puts(s);
        fflush(stdout);
        sleep(3600 - 60 * tm.tm_min - tm.tm_sec);
    } while(1);
}
