CC = gcc
CFLAGS = -Iincludes
LIBS = -lpcap

all: check_deps reverse

check_deps:
    @if [ "$(OS)" = "Windows_NT" ]; then \
        powershell.exe -File scripts/check_dependencies.ps1; \
    else \
        ./scripts/check_dependencies.sh; \
    fi

reverse: src/reverse.c
    $(CC) $(CFLAGS) -o reverse src/reverse.c $(LIBS)

clean:
    rm -f reverse

