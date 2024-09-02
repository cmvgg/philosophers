#include "../include/philo.h"

static int	start_eating(t_philo *self)
{
	pthread_mutex_lock (&self->fork[min (self->lfork, self->rfork)]);
	print (self, "has taken a fork");
	if (self->lfork == self->rfork)
	{
		pthread_mutex_unlock (&self->fork[min (self->lfork, self->rfork)]);
		return (FAILURE);
	}
	pthread_mutex_lock (&self->fork[max (self->lfork, self->rfork)]);
	print (self, "has taken a fork");
	print (self, "is eating");
	return (SUCCESS);
}

static int	finish_eating(t_philo *self)
{
	print (self, "is sleeping");
	pthread_mutex_unlock (&self->fork[max (self->lfork, self->rfork)]);
	pthread_mutex_unlock (&self->fork[min (self->lfork, self->rfork)]);
	msleep (self->data->time_slp);
	return (SUCCESS);
}

static int	eating(t_philo *self)
{
	if (start_eating (self) != SUCCESS)
		return (FAILURE);
	pthread_mutex_lock (&self->data->mutex[MEALS]);
	self->last_meal = ft_abs_time ();
	self->meals_counter++;
	pthread_mutex_unlock (&self->data->mutex[MEALS]);
	if (done_check (self))
	{
		finish_eating (self);
		return (FAILURE);
	}
	msleep (self->data->time_eat);
	finish_eating (self);
	return (SUCCESS);
}

void	*simulation(void *arg)
{
	t_philo	*self;

	self = (t_philo *) arg;
	if (self->id % 2 == 0)
	{
		print (self, "is thinking");
		msleep (self->data->time_eat);
	}
	while (1)
	{
		if (death_check(self))
			break ;
		if (eating (self) != SUCCESS)
			break ;
		print (self, "is thinking");
		msleep (self->data->time_thk);
	}
	return (NULL);
}
