/* bor-util.h : Boite a Outil Reseau
 *
 *
 * This program is free software under the terms of the
 * GNU Lesser General Public License (LGPL) version 2.1.
*/

#ifndef VB_UTIL__H
#define VB_UTIL__H


#include <stdio.h>      /* printf, fgets */
#include <stdlib.h>     /* exit */
#include <unistd.h>     /* close */
#include <string.h>     /* strlen */
#include <sys/types.h>  /* open, socket, bind, sendto, recvfrom, wait */
#include <signal.h>     /* sigaction */
#include <sys/wait.h>   /* wait */
#include <sys/stat.h>   /* open */
#include <fcntl.h>      /* open */
#include <sys/socket.h> /* socket, bind, sendto, recvfrom, getsockname */
#include <sys/un.h>     /* socket domaine AF_UNIX */
#include <netinet/ip.h> /* socket domaine AF_INET */
#include <arpa/inet.h>  /* inet_ntoa */
#include <netdb.h>      /* gethostbyname */
#include <sys/time.h>   /* gettimeofday */
#include <time.h>       /* time, gettimeofday */
#include <errno.h>      /* errno */

#define UNIX_PATH_MAX 104



ssize_t vb_read (int fd, void *buf, size_t count);
ssize_t vb_write (int fd, const void *buf, size_t count); 

int vb_listen (int soc, int max_pending);

int vb_create_socket_un (int type, const char *path, struct sockaddr_un *sa, int mode);
int vb_bind_un (int soc, struct sockaddr_un *sa);
int vb_accept_un (int soc, struct sockaddr_un *sa); 

/* Solution de repli pour __func__ */
#if __STDC_VERSION__ < 199901L
# if __GNUC__ >= 2
#  define __func__ __FUNCTION__
# else
#  define __func__ "<unknown>"
# endif
#endif

#endif /* VB_UTIL__H */

