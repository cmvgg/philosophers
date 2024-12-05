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
		@chmod +x test/test_makefile.sh
		#@./test/test_makefile.sh 
		@chmod +x test/test_arguments.sh
		#@./test/test_arguments.sh 
		@chmod +x test/test_concurrency.sh
		#@./test/test_concurrency.sh
		@chmod +x test/test_resources.sh
		@./test/test_resources.sh

clean:
	$(RM) $(OBJS) $(DEPS)

fclean:		clean
				@$(RM) $(NAME) $(OBJS)

fclean2:	fclean
				rm -rf logs
				rm -rf exits
				rm -rf valgrind_reports

re:
	$(MAKE) fclean
	$(MAKE) all

norm:
	norminette | grep -v "OK" || true

.PHONY: all clean fclean re
