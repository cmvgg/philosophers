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
MAKEFLAGS   += --no-print-directory
DIR_DUP     = mkdir -p $(@D)

all: $(NAME)

$(NAME): $(OBJS)
	$(CC) $(OBJS) $(LDLIBS) -o $(NAME)

$(DST_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	$(RM) $(OBJS) $(DEPS)

fclean: clean
	$(RM) $(NAME)

re:
	$(MAKE) fclean
	$(MAKE) all

norm:
	norminette | grep -v "OK" || true

.PHONY: runv runh run test_eval test_custom malloc_test
