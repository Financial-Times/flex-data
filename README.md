Flex Data
==

Install and configure databases/ stores for flex masters during installation. The script is idempotent; it may be run over and over with out any issue.

Usage
--

```bash
$ docker run -e DB_HOST=localhost -e DB_MASTERUSERNAME=root -e DB_MASTERPASSWORD=$something -e DB_PASSWORD=$something_else -e CLUSTER_ID=test quay.io/financialtimes/flex-data
```
