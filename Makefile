NAME		:= philo

SRC_DIR     := src
DST_DIR     := obj
SRCS		:= \
	main.c       \
	checkargs.c  \
	init.c       \
	simulator.c  \
	simulation.c \
	time_utils.c \
	sim_utils.c  \
	utils.c
SRCS        := $(SRCS:%=$(SRC_DIR)/%)
OBJS        := $(SRCS:$(SRC_DIR)/%.c=$(DST_DIR)/%.o)

CC          := cc
CFLAGS      := -Wall -Wextra -Werror
LDLIBS      := -lpthread

RM          := rm -f

all: $(NAME)

$(NAME): $(OBJS)
	$(CC) $(OBJS) $(LDLIBS) -o $(NAME)

$(DST_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

run_test: all
		chmod +x test/test_makefile.sh
		./test/test_makefile.sh 
		
clean:
	$(RM) $(OBJS) $(DEPS)

fclean:		clean
				@$(RM) $(NAME) $(OBJS)

fclean2:	fclean
				rm -f outfile_shell
				rm -f in.txt
				rm -f outfile_pipex
				rm -rf logs
				rm -rf exits

re:
	$(MAKE) fclean
	$(MAKE) all

norm:
	norminette | grep -v "OK" || true

.PHONY: all clean fclean re
