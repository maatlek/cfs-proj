On Azure Portal the required regions are created and each infra componenets are configured/added to provide the final infrastructure as per the case study.

# Creating Resources by Region
## SEA Resource Group
The resources for the EUS Resource Group is created as follows:
1. A resource group is created named `Nilavembu_SEA`:
	- The resource group is created under `Southeast Asia` region.
	- Necessary Tags are provided to differentiate other resources.

![](./images/Pasted%20image%2020210715095451.png)

Once the resource group is created, other necessary resources are created as follows:
- Virtual Network (`sea-web-vnet` = 10.1.0.0/16 & `sea-j-vnet` = 10.2.0.0/16)
	- Subnet (`sea-web-subnet` = 10.1.0.0/24 & `sea-j-subnet` = 10.2.0.0/24)
	- Common Network Security Group (`sea-app-nsg`)
- Availaibility Set
- Virtual Machine
	- 2 Web Servers (`webserver1` & `webserver2`)
		- Under subnet (address space = 10.1.0.0/24)
		- Network Interface
		- Allowed connectivity from the Load Balancer from the Internet 
		- Backup of Web Servers in a Recovery Service Vault (`webserver-backup`)
	- Jump Host Server (`jumpserver`)
		- Under subnet (address space = 10.2.0.0/24)
		- Network Interface
		- Public IP Address, to allow connections over the internet (with FQDN)
- Load Balancer `sea-LB`
	- To Allow Connections from the Public Internet to the Virtual Machines created.
	- With Client Affinity


### Virtual Network
2 Different Virtual Networks are created:
- For webservers

![](./images/Pasted%20image%2020210716000357.png)

#### Subnet
Similarly the Network Interface for webservers are attached to the `sea-web-subnet`. For the jump server as `sea-jump-subnet`.

![](./images/Pasted%20image%2020210716000424.png)

#### Network Security Group
Network Security Group is created to allow RDP from the Internet for all the Virtual Machines.

![](./images/Pasted%20image%2020210716001755.png)

##### Application Security Group
An Application Security Group is created to allow logical grouping of applications, and then used with Network Security Group to allow the connections to a those reseources inside the Application Security Group.

On a Web Server the Network Interface is added to the Application Security Group. On a Network Security Group - ports for RDP are allowed, a rule is set as below:

![](./images/Pasted%20image%2020210716001832.png)

### Availability Set
An Availabillity Set is created to avoid downtime due to Planned or Unplanned Maintenance. The set is created for 2 Web Servers, thus below is configured:

For 2 webserver, 2 different fault domain is set.

![](./images/Pasted%20image%2020210715102625.png)


### Virtual Machine

#### Web Server
As a part of case study 2 webservers, as follows:

- Server : Webserver1

![](./images/Pasted%20image%2020210716000741.png)

- Server : Webserver11

![](./images/Pasted%20image%2020210716000610.png)

##### Alerts
Alerts are generated when the CPU PErcentage is above 80%. Below configurations are done. They are created for both the web servers.

Below Scope and Conditions are selected:

![](./images/Pasted%20image%2020210716002643.png)

And the following action is created:

![](./images/Pasted%20image%2020210716002711.png)

Alert Rule is named and severity set to Warning:

![](./images/Pasted%20image%2020210716002805.png)


#### Jump Server
The Jump server is needed to upload contents to the Web Servers that are created. Thus configured with below default configuration:

![](./images/Pasted%20image%2020210716000658.png)

Additionally, creating a DNS Name for the server, to provide RDP through the server FQDN rather than the dynamic IP assigned to it:

![](./images/Pasted%20image%2020210715122848.png)

### Recovery Service Vault
The webservers are backed up to the Recovery Service Vault. A weekly policy is used to retain the backups for 3 Weeks.


![](./images/Pasted%20image%2020210716000854.png)

The below policy is used.

![](./images/Pasted%20image%2020210715184021.png)

Based on the scheduled policy, the backup is done.


The servers can be backed up - in the same recovery vault we can create replication, to replicate the same in time of failover.

The VMs are replicated to a standby VM in the nearest region.

### Load Balancer
A Load Balancer is set to provide port 80/443 connections on the internet to the webservers, which is not configured with any Public IP.

The FrontEnd IP is configured:

![](./images/Pasted%20image%2020210715141911.png)

Backend Pool is configured associated with all the webservers:

![](./images/Pasted%20image%2020210716001207.png)

Create Health Probe to check the health of the webservers:

![](./images/Pasted%20image%2020210715143341.png)

Create Load Balancing Rules to the route appropriate traffic to the webserver:

![](./images/Pasted%20image%2020210715143320.png)

To provide the Client Affinity over the web, its configured with session persistence with Client IP and Protocol in the load balancing rule:

![](./images/Pasted%20image%2020210715143536.png)

After addition of load balancer, we IP changes to the Front End IP of the Load Balancer:

![](./images/Pasted%20image%2020210716214117.png)


## EUS Resource Group
The resources for the EUS Resource Group is created as follows, as same as the above resource group created:
1. A resource group is created named `Nilavembu_EUS`:
	- The resource group is created under `East US` region.
	- Necessary Tags are provided to differentiate other resources.

![](./images/Pasted%20image%2020210714165626.png)

Once the Resource Group is created the below is created:
- Virtual Network (`eus-vnet` = 10.3.0.0/16)
	- Subnets under the Virtual Network (`eus-subnet` = 10.3.0.0/24)
	- with peering to Southeast Asia Resource Group
	- Common Network Security Group (`eus-app-nsg`)
- Virtual Machine (`server11`)
	- Network Interface
	- Public IP (Static)
		- or can be configured with dnsname `server11.*`


### Virtual Network
A Virtual Network is configured to work with the Address Space as specified below:

![](./images/Pasted%20image%2020210716214334.png)

Virtual Network Peering is also setup to allow connection from the Southeast Asia Region to the East US Region.


#### Subnet
A Subnet is created under the Virtual Network as a best practice with the specifications as below:

![](./images/Pasted%20image%2020210716214422.png)

### Virtual Machine
A Virtual Machine is created as with the following settings.

![](./images/Pasted%20image%2020210716214511.png)

#### Network Interface
The Virtual Machine is associated with the Internal IP configured as - 10.3.0.4

And attaching the Network Security Group `eus-nsg` to allow only connections within the Virtual Network `eus-vnet` over RDP and not any other apart from it. 

The same interface is attached to a Public IP over the Internet.

##### Public IP Address
A Public IP Address is configured to be accessible over the internet.

![](./images/Pasted%20image%2020210715231009.png)

#### Network Security Group
Network Security Group is provided to restrict connections from other resources except those within the virtual network.

![](./images/Pasted%20image%2020210715230052.png)

Additionally the servers are allowed to be communicated through the Public IP over port 80 and 443, as a part of providing a web service.

#### Vnet Peering
We establish a peering between virtual network from the `eus-vnet` to `sea-vnet`. Provided they both are different non-overlapping IP Addresses.

![](./images/Pasted%20image%2020210716184317.png)

With successful peering, the connection is more secure and can allow cross-connection without the internet.


# Stroage Requirements
Storage Requirements allow users to access business documents. Storage Account is created to allow users to access the files and documents needed for their business.

Storage Account is created for different regions:
- Storage Account (`nilsestorage`)
	- with Key Access Vault to allow certain applications from outside the network
	- Storage Account is created with Zone Redudancy to avoid multiple datacenter failures, where files are replicated to different availability zones.

![](./images/Pasted%20image%2020210716003033.png)


- Storage Account (`nileustorage`)
	- with Key Access Vault to allow certain applications from outside the network
	- A Storage Account on the East US region is to be created with data resilliency with a single DataCenter Failure. A replication strategy - Geo Redudant based storage is created to allow

![](./images/Pasted%20image%2020210716002943.png)

### Syncing with Local Folders

#### File Share
We can allow sharing of the files through file shares

![](./images/Pasted%20image%2020210716210756.png)

We can then connect with required SMB File Share, with PowerShell or Active Directory based setup, as below:

![](./images/Pasted%20image%2020210716211018.png)

#### azcopy for containers
For Local ACcount sync with storage accounts, esp. for Sales Manager, we run the below on the local computer.

```batch
azcopy login

azcopy sync "C:\Users\mkadmin\Desktop" "https://nilsestorage.blob.core.windows.net/images" 

### through SAS

azcopy sync "C:\Users\mkadmin\Desktop\sales_secret" "https://nilsestorage.blob.core.windows.net/sales/Check_sales?sp=racwdlmeop&st=2021-07-16T15:29:07Z&se=2021-07-16T23:29:07Z&spr=https&sv=2020-08-04&sr=d&sig=VEsJcyRUN7%2Fl0%2BX4rGFWM8%2BA%2FpCT2esrqPyTXZI3OB4%3D&sdd=1" --recursive=true

```


### Allowing Secure Connections Only
Secure Connections can be made to the services with service endpoints. This allows connections only from secure locations (within microsoft backbone) to the services, and internet is avoided as whole.

On the storage account `sea-vnet` below service points are created is made:

![](./images/Pasted%20image%2020210717105632.png)

The services are then made to be allowed only from those connections on the firewall settings of the storage account `nilsestorage`.

![](./images/Pasted%20image%2020210717105822.png)

The same is replicated for the storage account in EUS Region. From the selected private IP subnets connections are secure and thus allowed connection only from them.


# Azure Resource Management
Resources for Azure can be managed by users through RBAC. 

- For managing all the Virtual Machines in the Resource Group, we provide Virtual Machine Contributor to the user, for both the resource group.

![](./images/Pasted%20image%2020210716011258.png)

- Thus at subscription level :

![](./images/Pasted%20image%2020210717112748.png)

- To Manage all the Backups only in EUS Region, below configuration is made and added to a user.

![](./images/Pasted%20image%2020210716011929.png)



# Additoinal Setup
## Traffic Manager
We additionally add Traffic Manager to access websites based on regions. Below Endpoints are setup:

![](./images/Pasted%20image%2020210717103441.png)

For `sea-region` --> Setting Load Balancer Front End IP
For `eus-region` --> Setting server11 Public IP

Final Verification, over the internet:

![](./images/Pasted%20image%2020210717120436.png)