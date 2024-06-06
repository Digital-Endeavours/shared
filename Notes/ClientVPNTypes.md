# Client VPN Types
## User auth against
- Microsoft Active Directory
- Manage Directory (AD Service in AWS)
- On Premise AD (this needs a connector to AWS)
### Mutual Authentication
- Auth using certificates, service certificates need to be uploaded to AWS Certificate Manager
- One Certificate per user is required.
## SSO
- AWS IAM Identity Centre, previously known as AWS SSO
- SAML 2.0. IDP passes token back the same token once authenticated and then passes it to the VPN endpoint.
