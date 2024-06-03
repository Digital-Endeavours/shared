# AWS Data Transfer 
- There are 3 options to perform this. 
- All have the option to use the Data Transfer Service Endpoint or use Route53 for directing traffic.
- All seemlessly store data in S3 or EFS via an IAM Role. 
- The FTP service is not secured but must be inside a VPC. 
- FTPS = FTP over SSL
- SFTP = Secure FTP. 
- All of these can be authenticated using LDAP, Okta, Active Directory. 
