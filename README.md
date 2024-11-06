# Uno Networking Tool

## Overview

**Uno** is a command-line networking tool written in C that listens to all inbound network traffic from any non-private address range, logs the traffic, rejects it, and sends it back to its origin. The tool is named "reverse" and can be configured to run on different network interfaces.

### Caution:
When using this tool your firewall will get a rule for rejecting all incoming traffic. This should only be used on computers that are meant as honeypots and don't require actual networking.

## Prerequisites

Ensure you have the following dependencies installed:

- `libpcap` development libraries

### On Debian-based systems (e.g., Ubuntu):
```bash
sudo apt-get install libpcap-dev
```
### On Red Hat-based systems (e.g., Fedora):
```bash
sudo dnf install libpcap-devel
```
### On macOS:
```bash
brew install libpcap
```
### On Windows:
Ensure you have `winget` installed. Then, run the following command to install Npcap:
```powershell
winget install -e --id Nmap.Npcap
```
## Building the Tool

Clone the repository and navigate to the project directory:

git clone https://github.com/simbaclaws/uno.git

cd uno

Run the dependency check script:

### On Unix-like systems:
```bash
chmod +x scripts/check_dependencies.sh
./scripts/check_dependencies.sh
```
### On Windows:
```powershell
.\scripts\check_dependencies.ps1
```
Build the tool using `make`:
```bash
make
```
## Installing the Tool

To install the tool into the correct path, run the following command:

### On Unix-like systems:
```bash
sudo make install
```
### On Windows:

Run the following command in a PowerShell window with admin privileges:
```powershell
make install
```

This will copy the `reverse.exe` file to `C:\Program Files\Uno`.


## Running the Tool

Run the tool with the specified network interface:

### On Unix-Like systems:

This tool requires root privileges.
```bash
sudo reverse -i <network_interface>
```

### On Windows:

Run the following command in a powershell window with admin privileges:

```powershell
"C:\Program Files\Uno\reverse.exe" -i <network_interface>
```

Replace `<network_interface>` with the appropriate network interface on your system (e.g., `eth0`).

### Command Line Flags

- `-i <interface>`: Specifies the network interface to listen on.
- `-r <repeat_count>`: Specifies the number of times to send the packet back. The default is 1.

### Example Usage

To run the tool on the `eth0` interface and send each packet back 5 times:

### On Unix-like systems:
```bash
sudo reverse -i eth0 -r 5
```
### On Windows:

Run the following command in a PowerShell window with admin privileges:
```powershell
'C:\Program Files\Uno\reverse.exe' -i eth0 -r 5
```
## Project Structure
```
/uno
|-- includes/
|   |-- reverse.h
|-- src/
|   |-- reverse.c
|-- scripts/
|   |-- check_dependencies.sh
|   |-- check_dependencies.ps1
|-- Makefile
|-- README.md
|-- LICENSE
```
## License

This project is licensed under the GPL License. See the `LICENSE` file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## Acknowledgements

- libpcap
- Npcap

