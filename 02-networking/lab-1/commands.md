## Commands
- In DB VM: 
    - Install mysq-server: 
        `sudo apt install -y mysql-server`
    - Start mysql service: 
        `sudo systemctl enable --now mysql`
    - sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf (update bind-address)
        `bind-address: {db-vm-private-ip}`
        This makes the mysql server listen on the private IP of the db server 
    - Restart mysql service: 
        `sudo systemctl restart mysql`
    - mysql db commands:
        ```bash
        sudo mysql
        CREATE USER 'dbadmin'@'%' IDENTIFIED BY 'Microsoft2025';
        GRANT ALL PRIVILEGES ON *.* TO 'dbadmin'@'%' WITH GRANT OPTION;
        FLUSH PRIVILEGES;
        EXIT;
        ```

- In Web VM
    - Install mysql-client
        `sudo apt install -y mysql-client`

- Connecting from web-vm to mysql server in db-vm
    - ```bash
      mysql -h {db-vm-private-ip} -u dbadmin -p 
      (enter password)
      ```