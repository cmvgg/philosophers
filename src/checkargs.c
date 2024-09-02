#include "../include/philo.h"

static int	is_numeric(char const *str)
{
	int	i;

	i = 0;
	if (*str == '+')
		str++;
	while (str[i] >= '0' && str[i] <= '9')
		i++;
	if (str[i] == '\0')
		return (TRUE);
	return (FALSE);
}

int	check_args(int ac, char const *const *av)
{
	if (ac < 5)
	{
		write (2, "Error: Too few arguments.\n", 26);
		return (FAILURE);
	}
	if (ac > 6)
	{
		write (2, "Error: Too many arguments.\n", 27);
		return (FAILURE);
	}
	while (ac-- > 1)
	{
		if (is_numeric (av[ac]) == FALSE)
		{
			write (2, "Error: Invalid character.\n", 26);
			return (FAILURE);
		}
		if (ft_atol (av[ac]) > INT_MAX || ft_atol (av[ac]) < 0)
		{
			write (2, "Error: Out of range value.\n", 27);
			return (FAILURE);
		}
	}
	return (SUCCESS);
}
