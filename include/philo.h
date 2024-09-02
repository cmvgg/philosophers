#ifndef PHILO_H
# define PHILO_H

# define _DEFAULT_SOURCE
# define _GNU_SOURCE
# define _BSD_SOURCE

# include <pthread.h>
# include <stdio.h>
# include <stdlib.h>
# include <string.h>
# include <sys/time.h>
# include <unistd.h>
# include <limits.h>

typedef enum e_mutexes
{
	PRINT,
	MEALS,
	DONE,
	DIED,
	M_NUM
}	t_mutexes;

typedef enum e_bool
{
	FALSE,
	TRUE
}	t_bool;

typedef enum e_exit
{
	SUCCESS,
	FAILURE
}	t_exit;

typedef struct s_data
{
	int					philo_nb;
	int					time_die;
	int					time_eat;
	int					time_slp;
	int					time_thk;
	int					must_eat;

	unsigned long		simbegin;
	int					done;
	int					died;
	pthread_mutex_t		*mutex;

}					t_data;

typedef struct s_philo
{
	int					id;
	unsigned long		last_meal;
	int					meals_counter;
	int					lfork;
	int					rfork;
	pthread_mutex_t		*fork;
	t_data				*data;

}				t_philo;

// utils.c

long			ft_atol(char const *str);
int				min(int a, int b);
int				max(int a, int b);

// sim_utils.c

void			print(t_philo *philo, char const *const a);
void			died(t_data *data);
void			done(t_data *data);
int				death_check(t_philo *philo);
int				done_check(t_philo *philo);

// time_utils.c

unsigned long	ft_abs_time(void);
unsigned long	rel_time(unsigned long begin);
void			msleep(unsigned long msec);

// simulation.c

void			*simulation(void *arg);

//simulator.c

int				simulator(t_philo *philo, t_data *data);

// init.c

int				init_philo(t_philo **philo, t_data *data);
int				init_data_mutexes(t_data **data);
int				init_data(t_data **data, int ac, char const *const *av);
int				init(t_philo **p, t_data **d, int ac, char const *const *av);

// checkargs.c

int				check_args(int ac, char const *const *argv);

// main.c

int				main(int ac, char const *const *argv);

#endif