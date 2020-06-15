#cloud-config
users:
 - default
 - name: ${username}
   gecos: ${username}
   lock_passwd: false
   shell: /bin/bash
   passwd: ${passwd}
   sudo: ALL=(ALL) NOPASSWD:ALL
   ssh_pwauth: True

ssh_pwauth: True