Flex Data
==

Install and configure databases/ stores for flex masters during installation. The script is idempotent; it may be run over and over with out any issue.

Usage
--

To install/ configure the database:

```bash
$ docker run -e DB_HOST=localhost -e DB_MASTERUSERNAME=root -e DB_MASTERPASSWORD=$something -e DB_PASSWORD=$something_else -e CLUSTER_ID=test quay.io/financialtimes/flex-data
```

To cleanup the database and users when a cluster is torn down:

```bash
$ docker run -e DB_HOST=localhost -e DB_MASTERUSERNAME=root -e DB_MASTERPASSWORD=$something -e DB_PASSWORD=$something_else -e CLUSTER_ID=test BUILDOUT=teardown quay.io/financialtimes/flex-data
```
