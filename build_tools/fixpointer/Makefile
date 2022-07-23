CFLAGS := -O2 -s -std=c99 -Wall -Wextra -pedantic -fno-ident

fixpointer: fixpointer.c
	$(CC) $(CFLAGS) -I. $(CPPFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)
