#!/bin/bash

sudo apt-get update -y
sudo apt-get install nginx -y

VM_NAME="$(hostname -s || echo "unknown")"

tee /var/www/html/index.html >/dev/null <<EOF
<html>
<head>
<title>Loadbalanced Virtual Machine Scale Set Demo</title>
</head>
<body>
<h1>Welcome to $VM_NAME</h1>
<p>This page is served by Nginx running on <b>$VM_NAME</b>.</p>
</body>
</html>
EOF