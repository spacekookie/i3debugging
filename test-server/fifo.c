#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>

void main() {
   int fd;
   char * myfifo = "/tmp/i3debugger";

   mkfifo(myfifo, 0777);
   fd = open(myfifo, O_WRONLY/* | O_NONBLOCK*/);       
   write(fd, "testing", sizeof("testing") );    
}
