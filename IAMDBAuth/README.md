#About neptune_query.py
* If you are making use of a graph database on AWS, then you are likely to want
  a hosted option rather than hosting and maintaining it yourselves,
  AWS Neptune is currently the only choice. 
* Neptune does not make use of User/Pass connections but relies on IAM.
  If IAMDB Auth is enabled then SigV4 signing must be used to connect to Neptune.
* neptune_query.py is a script provided by AWS that has been modified to take ephemeral tokens
  from the instance rather expecting long-lived access tokens.
* This script accepts `sparql`, `gremlin` or `openCypher` commands.
  See the helper message on line 244.
