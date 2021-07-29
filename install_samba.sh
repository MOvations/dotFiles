#!/bin/bash

sudo apt-get install samba samba-common-bin
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.old

echo
read -p 'Enter full directory path to share: ' pathvar
read -p 'Name this share volume: ' namevar
read -p 'Give usefull comments about this share: ' commentvar
hs=$HOSTNAME

sudo cat <<EOF >> /etc/samba/smb.conf
[global]
   server string = File Server
   workgroup = $hs
   security = user
   map to guest = Bad User
   name resolve order = bcast host
   include = /etc/samba/shares.conf
EOF


# creating two shares for their respective purposes - modify as required
sudo cat <<EOF >> /etc/samba/shares.conf
[$namevar-Public]
   comment = $commentvar
   path = $pathvar
   force user = smbuser
   force group = smbgroup
   create mask = 0664
   force create mode = 0664
   directory mask = 0775
   force directory mode = 0775
   public = yes
   writable = yes

[$namevar-Protected]
   path = $pathvar
   comment = $commentvar
   force user = smbuser
   force group = smbgroup
   create mask = 0664
   force create mode = 0664
   directory mask = 0775
   force directory mode = 0775
   public = yes
   writable = no

EOF

# change owndership of the share to the dummy user
sudo groupadd --system smbgroup
sudo useradd --system --no-create-home --group smbgroup -s /bin/false smbuser

# Change Ownership to smbuser
sudo chown -R smbuser:smbgroup $namevar
sudo chmod -R g+w $namevar

# restart the smb service and check status
sudo systemctl restart smbd
sudo systemctl status smbd
