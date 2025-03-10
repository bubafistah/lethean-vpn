# Lethean VPN daemon
This repository contains code needed to setup and run an exit node on the Lethean Virtual Private Network (VPN).

**The exit node is currently only supported on Linux.**

## Design
ITNS (aka LTHN) VPN dispatcher is a tool that orchestrates all other modules (proxy, VPN, config, etc.). It does not provide any VPN functionality by itself.
The dispatcher uses system packages whenever possible but it runs all instances manually after invoking. 
The dispatcher has two distinct modes of operation: proxy and VPN.

### Proxy mode (mandatory)
In proxy mode, it runs a preconfigured instance of haproxy which acts as frontend for clients (authenticated by ITNS payments), and uses another HTTP proxy as the backend.
Squid is the simplest HTTP proxy to use as a backend, but any other HTTP proxy would work fine as well. Easy-deploy scripts autoconfigure squid as the backend.

### VPN mode (optional)
If you decide to run ITNS VPN dispatcher in VPN mode, it starts an OpenVPN server authenticated by ITNS payments.

### Session management
The dispatcher orchestrates all proxy and VPN instances by managing authentication and session creation. 
In huge sites, this could generate significant load. Session management can be turned off. In such cases, sessions which are alive after a client's payment is spent will not be terminated automatically.

### Security of your network and filtering
VPN dispatcher should not be used as security filter. It only manages connections, encrypts data and receive payments.
We try to make it as secure and robust as possible but if you want to be absolutely sure that traffic from dispatcher server cannot flow to your infrastructure, use backend proxy ACLs or iptables.

#### Outgoing taffic
This is traffic generated by remote VPN users. So be careful here. Secure your infrastructure:

 * For proxy mode, entire security is proxy based because traffic is routed there. Please configure your upstream HTTP proxy to filter traffic.
 * For VPN mode, you must use local iptables or another packet filtering on openvpn node.

#### Incoming traffic
Here you can manage which IPs can use your VPN service.

 * You can use */opt/lthn/etc/src_allow.ips* to limit source IPs for your service. It is probably not usable for real world, but you can for example create testing node ana allow traffic only from your IPs. 
 * You can explicitly disable some IPs in */opt/lthn/etc/src_deny.ips*
 * Regardless of above settings, dispatcher can automatically deny some IPs in future, if there is excessive or dangerous traffic.

## Requirements
 * python3
 * python3-pip
 * haproxy
 * squid or other HTTP proxy
 * openvpn (optional)
 * sudo installed and configured

There are more required python classes but they will be installed automatically during install.

On debian, use standard packager:
```bash
sudo apt-get install python3 python3-pip haproxy

```
