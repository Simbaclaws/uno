#include "reverse.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <getopt.h>

// Function to check if an IP address is private
int is_private_ip(struct in_addr ip) {
    uint32_t addr = ntohl(ip.s_addr);
    return (addr >> 24 == 10) || // 10.0.0.0/8
           (addr >> 20 == 0xAC1) || // 172.16.0.0/12
           (addr >> 16 == 0xC0A8) || // 192.168.0.0/16
           (addr >> 24 == 127); // 127.0.0.0/8
}

// Function to add a REJECT rule to the firewall
void add_reject_rule(const char *ip) {
    char command[256];

    // Example for iptables (Linux)
    snprintf(command, sizeof(command), "iptables -A INPUT -s %s -j REJECT --reject-with icmp-port-unreachable", ip);
    system(command);

    // Example for Windows Firewall (Windows)
    snprintf(command, sizeof(command), "netsh advfirewall firewall add rule name=\"Reject %s\" dir=in action=block remoteip=%s", ip, ip);
    system(command);
}


void packet_handler(u_char *user, const struct pcap_pkthdr *pkthdr, const u_char *packet) {
    struct ip *ip_header = (struct ip *)(packet + 14); // Ethernet header is 14 bytes

    // Log the incoming packet
    FILE *logfile = fopen("traffic.log", "a");
    if (logfile == NULL) {
        perror("Unable to open log file");
        return;
    }
    fprintf(logfile, "Incoming packet from %s to %s\n", inet_ntoa(ip_header->ip_src), inet_ntoa(ip_header->ip_dst));

    // Check if the source IP is non-private
    if (!is_private_ip(ip_header->ip_src)) {
        // Add a DROP rule for the source IP
        add_reject_rule(inet_ntoa(ip_header->ip_src));

        // Send the packet back to the sender
        struct sockaddr_in dest;
        int sock = socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
        if (sock < 0) {
            perror("Socket creation failed");
            fclose(logfile);
            return;
        }
        dest.sin_family = AF_INET;
        dest.sin_addr = ip_header->ip_src;
        sendto(sock, packet, pkthdr->len, 0, (struct sockaddr *)&dest, sizeof(dest));
        close(sock);

        // Log the sent packet
        fprintf(logfile, "Sent packet back to %s\n", inet_ntoa(ip_header->ip_src));
    }

    fclose(logfile);
}

int main(int argc, char *argv[]) {
    char *dev = NULL;
    char errbuf[PCAP_ERRBUF_SIZE];
    pcap_t *handle;
    int opt;

    // Parse command line arguments
    while ((opt = getopt(argc, argv, "i:")) != -1) {
        switch (opt) {
            case 'i':
                dev = optarg;
                break;
            default:
                fprintf(stderr, "Usage: %s -i <interface>\n", argv[0]);
                exit(EXIT_FAILURE);
        }
    }

    if (dev == NULL) {
        fprintf(stderr, "Usage: %s -i <interface>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    handle = pcap_open_live(dev, BUFSIZ, 1, 1000, errbuf);
    if (handle == NULL) {
        fprintf(stderr, "Couldn't open device %s: %s\n", dev, errbuf);
        return 2;
    }

    pcap_loop(handle, 0, packet_handler, NULL);

    pcap_close(handle);
    return 0;
}

