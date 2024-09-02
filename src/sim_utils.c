#include "../include/philo.h"

void	print(t_philo *philo, char const *const a)
{
	pthread_mutex_lock (&philo->data->mutex[PRINT]);
	if (*a == 'd' || (!death_check (philo) && !done_check (philo)))
		printf("%lu %d %s\n", rel_time(philo->data->simbegin), philo->id, a);
	pthread_mutex_unlock (&philo->data->mutex[PRINT]);
}

void	died(t_data *data)
{
	pthread_mutex_lock (&data->mutex[DIED]);
	data->died = TRUE;
	pthread_mutex_unlock (&data->mutex[DIED]);
}

void	done(t_data *data)
{
	pthread_mutex_lock (&data->mutex[DONE]);
	data->done = TRUE;
	pthread_mutex_unlock (&data->mutex[DONE]);
}

int	death_check(t_philo *philo)
{
	pthread_mutex_lock (&philo->data->mutex[DIED]);
	if (philo->data->died)
	{
		pthread_mutex_unlock (&philo->data->mutex[DIED]);
		return (TRUE);
	}
	pthread_mutex_unlock (&philo->data->mutex[DIED]);
	return (FALSE);
}

int	done_check(t_philo *philo)
{
	pthread_mutex_lock (&philo->data->mutex[DONE]);
	if (philo->data->done)
	{
		pthread_mutex_unlock (&philo->data->mutex[DONE]);
		return (TRUE);
	}
	pthread_mutex_unlock (&philo->data->mutex[DONE]);
	return (FALSE);
}
