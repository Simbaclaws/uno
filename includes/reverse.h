#ifndef REVERSE_H
#define REVERSE_H

#include <pcap.h>
#include <netinet/ip.h>
#include <arpa/inet.h>

// Function to check if an IP address is private
int is_private_ip(struct in_addr ip);

// Function to add a DROP rule to the firewall
void add_drop_rule(const char *ip);

// Packet handler function
void packet_handler(u_char *user, const struct pcap_pkthdr *pkthdr, const u_char *packet);

#endif // REVERSE_H

