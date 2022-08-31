/* vb-util.c : Boite a Outil Reseau Verbeux
 *
*/

#include "vb-util.h"

/* Ecriture d'au plus count octets dans fd provenant de buf.
 * Renvoie le resultat de write(). 
*/
ssize_t vb_write (int fd, const void *buf, size_t count)
{
    ssize_t r = write (fd, buf, count);
    if (r < 0) perror (__func__);
    return r;
}

/* Lecture d'au plus count octets dans fd et memorisation dans buf.
 * Renvoie le resultat de read(). 
*/
ssize_t vb_read (int fd, void *buf, size_t count)
{
    ssize_t r = read (fd, buf, count);
    if (r < 0) perror (__func__);
    else if (r == 0 && count != 0)
        fprintf (stderr, "%s: EOF detected for fd %d\n", __func__, fd);
    return r;
}

int vb_connect(int soc, struct sockaddr_un* sa) {
	int r = connect(soc, (struct sockaddr *) sa, sizeof(struct sockaddr_un));
	if (r < 0) perror(__func__);
	return r;
}

/* Attachement d'une socket de domaine AF_UNIX a une adresse sockaddr_un.
 * Renvoie le resultat de bind().
*/
int vb_bind_un (int soc, struct sockaddr_un *sa)
{
    int r = bind(soc, (struct sockaddr *) sa, sizeof(struct sockaddr_un));
    if (r < 0) perror (__func__);
    return r;
}

/* Cree une socket du domaine AF_UNIX selon le type, fabrique une adresse 
 * locale sa avec path puis attache la socket a sa.
 * Renvoie la socket attachee >= 0, sinon -1 erreur. 
*/
int vb_create_socket_un (int type, const char *path, struct sockaddr_un *sa, int mode)
{
    int soc = socket (AF_UNIX, type, 0);
    if (soc < 0) { perror ("socket un"); return -1; }
    
    sa->sun_family = AF_UNIX;
    strncpy (sa->sun_path, path, UNIX_PATH_MAX);
    sa->sun_path[UNIX_PATH_MAX-1] = 0;

	if(mode) {
    	if (vb_bind_un (soc, sa) < 0) { close (soc); return -1; }
	} else {
		if (vb_connect (soc, sa) < 0) { close (soc); return -1; }
	}

    fprintf (stderr, "%s: socket \"%s\" opened\n", __func__, sa->sun_path);
    return soc;
}

/* Transforme la socket ouverte soc de type SOCK_STREAM en socket d'ecoute.
 * max_pending est la taille de la file des connexions en attente.
 * Renvoie le resultat de listen().
*/
int vb_listen (int soc, int max_pending)
{
    int r = listen (soc, max_pending);
    if (r < 0) perror (__func__);
    return r;
}

/* Accepte une connexion en attente.
 * Renvoie le resultat de accept. 
 */
int vb_accept_un (int soc, struct sockaddr_un *sa)
{
    socklen_t adrlen = sizeof(struct sockaddr_un);
    int r = accept (soc, (struct sockaddr *) sa, &adrlen);
    if (r < 0) perror (__func__);
    return r;
}


