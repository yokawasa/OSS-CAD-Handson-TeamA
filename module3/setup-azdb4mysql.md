# Create Azure Database for MySQL account and configure

## Create Azure Database for MySQL account

Here is how to create Azure Database for MySQL account from Azure CLI:
```
 az mysql server create --name <your account name> \
   --resource-group <your reousrce group> \
   --location japanwest \
　 --admin-user <admin user name> --admin-password *** \
   --performance-tier Basic --compute-units 50
```
(Service Tier: Basic, Region: Japan West, Compute Units:50 )

Once the account creation is completed, you'll have the following the server name for the account:
<youraccoutname>.mysql.database.azure.com

## Configure

- Firewall (allow full IP range for testing）
```
az mysql server firewall-rule create --resource-group <your resource group> \
   --server <your account name> --name AllowFullRangeIP \
   --start-ip-address 0.0.0.0 --end-ip-address 255.255.255.255
```

- SSL-enforcement (disable for testing)
```
 az mysql server update --resource-group <your resource group> \
   --name <your account name> --ssl-enforcement Disabled
```

## Check the access

Check the access to mysql with mysql client command like this:
```
 mysql -u <admin-user-name>@<account-name> -p -h <accout-name>.mysql.database.azure.com
```

## LINKS
- [Create an Azure Database for MySQL server by using the Azure portal](https://docs.microsoft.com/en-us/azure/mysql/quickstart-create-mysql-server-database-using-azure-portal)
- [Create an Azure Database for MySQL server using Azure CLI](https://docs.microsoft.com/en-us/azure/mysql/quickstart-create-mysql-server-database-using-azure-cli)
- [Azure CLI command for MySQL](https://docs.microsoft.com/en-us/cli/azure/mysql
)
