# DNS Resolution
## DNS Support in VPC
### Enable DNS Support
- In the VPC settings enable DNS Support to enable Route53 resolver connectivity.
- Queries go to Amazon DNS @ 169.254.169.253 or the local IPv4 VPC .2 address.
### Without VPC DNS Support
- This needs a custom DNS Server to be running inside the VPC.

## DNS Hostnames in VPC
### Enable the DNS Hostnames setting in VPC.
- On by default in the default VPC otherwise disabled by default.
- If enabled then EC2 instances get public hostnames, otherwise private DNS hostnames

## Other
- Custom DNS domain names in Private Hosted Zones need both options to be set to function via Route53 Resolver.



