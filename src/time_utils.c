#include "../include/philo.h"

unsigned long	ft_abs_time(void)
{
	struct timeval	time;
	unsigned long	s;
	unsigned long	u;

	if (gettimeofday (&time, NULL) == -1)
		write (2, "Error: GETTIMEOFDAY(2)\n", 24);
	s = time.tv_sec * 1000;
	u = time.tv_usec / 1000;
	return (s + u);
}

unsigned long	rel_time(unsigned long begin)
{
	unsigned long	abs_time;

	abs_time = ft_abs_time ();
	return (abs_time - begin);
}

void	msleep(unsigned long msec)
{
	usleep (msec * 1000);
}
