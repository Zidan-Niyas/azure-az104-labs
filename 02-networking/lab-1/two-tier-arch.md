## Architecture
- Subscription: Personal Lab
- Resource Group: rg-dev-eus2
- 1 virtual network (vnet-dev-eus2-01)
- 2 subnets:
    - web subnet (snet-dev-eus2-web-01)
    - db subnet (snet-dev-eus2-db-01)
- 2 Virtual Machines
    - web-01 (in web subnet, with public IP)
    - db-01 (in db subnet, no public IP)


## New Concepts Learned

1. A VM with no public ip will have no outbound access, so it will need a NAT Gateway in its subnet for outbound access
    Explaination: 
    - Context: The 'db-vm' in the subnet 'snet-dev-eus2-db-01' was created without an attached public ip (db's are normally setup in a way not accessible via the public internet)
    - Problem: When i tried to do 'sudo apt update' from the serial console of the db vm, the packages were not getting installed, because outbound traffic was blocked/notpossible
    - The reason for this: if a vm has no public ip, the packets that leave the vm can't route through the internet only using the vm's private IP, there needs to be something in the middle that converts the private IP to a public IP so that we are able to talk to the internet, that's where the NAT (network address translator) gateway comes in.
    - Solution: create a NAT Gateway in the same resource group and vnet as the db vm and add this NAT gateway to the db vm's subnet 'snet-dev-eus2-db-01'

2. Network Security Groups (two-tier setup for webserver and dbserver)
    - web-vm allows http connections from the internet [inbound - allow]
    - db-vm allows requests to the mysql service on its machine(port 3306) from the web-vm [inbound - allow]
    - web-vm & db-vm denies any requests to the port range 70-10000 on its machine [inbound - deny]
    - web-vm & db-vm denies all outbound traffic to the internet from its machine [outbound -deny]

    So now, the web-vm is open to the internet while the db-vm is blocked from being accessed from the internet. The db-vm can be accessed only from the webserver.
    


## Commands
- In DB VM: 
    - Install mysq-server: 
        sudo apt install -y mysql-server
    - Start mysql service: 
        sudo systemctl enable --now mysql
    - sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf
        - bind-address: 10.0.1.4 (db server private ip)  --> This makes the mysql server listen on the private IP of the db server 
    - Restart mysql service: 
        sudo systemctl restart mysql
    - mysql db commands:
        sudo mysql
        CREATE USER 'dbadmin'@'%' IDENTIFIED BY 'Microsoft2025';
        GRANT ALL PRIVILEGES ON *.* TO 'dbadmin'@'%' WITH GRANT OPTION;
        FLUSH PRIVILEGES;
        EXIT;

- In Web VM
    - Install mysql-client
        sudo apt install -y mysql-client