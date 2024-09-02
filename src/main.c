#include "../include/philo.h"

static void	clear_memory(t_philo *philo, t_data *data)
{
	if (data && data->mutex)
		free (data->mutex);
	if (data)
		free (data);
	if (philo && philo->fork)
		free (philo->fork);
	if (philo)
		free (philo);
}

static int	edgecases(int ac, char const *const *av)
{
	if ((ac == 6 && ft_atol (av[5]) == 0))
		return (TRUE);
	if (ft_atol (av[1]) == 0)
		return (TRUE);
	return (FALSE);
}

int	main(int ac, char const *const *av)
{
	t_data	*data;
	t_philo	*philo;

	data = NULL;
	philo = NULL;
	if (check_args (ac, av) != SUCCESS)
		return ((void)clear_memory (philo, data), EXIT_FAILURE);
	if (edgecases (ac, av))
		return ((void)clear_memory (philo, data), EXIT_SUCCESS);
	if (init (&philo, &data, ac, av) != SUCCESS)
		return ((void)clear_memory (philo, data), EXIT_FAILURE);
	if (simulator (philo, data) != SUCCESS)
		return ((void)clear_memory (philo, data), EXIT_FAILURE);
	return ((void)clear_memory (philo, data), EXIT_SUCCESS);
}
