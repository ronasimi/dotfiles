#include <time.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
    char s[24];
    do {
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        strftime(s, 24, "CLK""%R", &tm);
        puts(s);
        fflush(stdout);
        sleep(60 - tm.tm_sec);
    } while(1);
}
