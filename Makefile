CC = gcc
CFLAGS = -Iincludes
LIBS = -lpcap
PREFIX = /usr/local

all: check_deps reverse

check_deps:
    @if [ "$(OS)" = "Windows_NT" ]; then \
        powershell.exe -File scripts/check_dependencies.ps1; \
    else \
        ./scripts/check_dependencies.sh; \
    fi

reverse: src/reverse.c
    $(CC) $(CFLAGS) -o reverse src/reverse.c $(LIBS)

install: reverse
    @if [ "$(OS)" = "Windows_NT" ]; then \
        echo "Installing on Windows..."; \
        powershell.exe -Command "New-Item -Path 'C:\Program Files\Uno' -ItemType Directory -Force"; \
        powershell.exe -Command "Copy-Item -Path .\reverse.exe -Destination 'C:\Program Files\Uno\reverse.exe' -Force"; \
    else \
        echo "Installing on Unix-like system..."; \
        install -d $(PREFIX)/bin; \
        install -m 755 reverse $(PREFIX)/bin/reverse; \
    fi

clean:
		@if [ "$(OS)" = "Windows_NT" ]; then \
        powershell.exe -Command "Remove-Item -Path .\reverse.exe -Force"; \
    else \
        rm -f reverse; \
    fi
