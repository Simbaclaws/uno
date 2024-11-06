CC = gcc
CFLAGS = -Iincludes
LIBS = -lpcap
PREFIX = /usr/local

all: reverse

reverse: src/reverse.c
    @if [ "$(OS)" = "Windows_NT" ]; then \
        if ! winget list | findstr /i "Npcap" > nul; then \
            echo "Npcap not found. Installing..."; \
            winget install -e --id Nmap.Npcap; \
        else \
            echo "Npcap is already installed."; \
        fi; \
    else \
        if command -v apt-get >/dev/null; then \
            if ! dpkg -s libpcap-dev >/dev/null 2>&1; then \
                echo "libpcap-dev not found. Installing..."; \
                sudo apt-get update; \
                sudo apt-get install -y libpcap-dev; \
            else \
                echo "libpcap-dev is already installed."; \
            fi; \
        elif command -v dnf >/dev/null; then \
            if ! rpm -q libpcap-devel >/dev/null 2>&1; then \
                echo "libpcap-devel not found. Installing..."; \
                sudo dnf install -y libpcap-devel; \
            else \
                echo "libpcap-devel is already installed."; \
            fi; \
        elif command -v brew >/dev/null; then \
            if ! brew list libpcap >/dev/null 2>&1; then \
                echo "libpcap not found. Installing..."; \
                brew install libpcap; \
            else \
                echo "libpcap is already installed."; \
            fi; \
        else \
            echo "Package manager not supported. Please install libpcap manually."; \
            exit 1; \
        fi; \
    fi
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

