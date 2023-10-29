# Cronicle

## How to handle with the SSH keys ?
Mounting a .ssh volumes from my host inside the container and exposing the whole content of my keys involve security considerations. I expose specific SSH keys to my container: Here is a step-by-step guide:

* Create a new directory on my host machine and copy the specific SSH keys that I want to expose to my Docker container into this directory. For example, if I want to expose id_rsa_specific:
```bash
mkdir specific_ssh
cp ~/.ssh/id_rsa_specific ./specific_ssh/
```
* Mount a volume for the specific_ssh directory into the .ssh directory in my Docker container:
```bash
volumes:
      - ./specific_ssh:~/.ssh
```

Please note that this method exposes only the specific SSH keys in the specific_ssh directory to your Docker container, and not all SSH keys in the .ssh directory of your host machine.

## How to apply my own configuration ?
You can customize the configuration file by modifying the `conf/config.json` file. When the container is up you can copy the file into the container and restart Cronicle for the changes to be taken into account.
```bash
docker cp .conf/config.json cronicle:/opt/cronicle/conf/
docker exec -d -it cronicle bash /opt/cronicle/bin/control.sh restart
```

### How to handle the log retention period ?
You can customize the log retention period by modifying the `job_data_expire_days` parameter in the configuration file. This parameter determines how many days to keep job data (logs, stats, etc.) before it is deleted.
After modifying the configuration file, save your changes and restart Cronicle for the changes to take effect. Please note that handling logs involves storage considerations. Be careful not to set a very high value for `job_data_expire_days` as it could consume a lot of disk space.

### How to disable the debug mode ?
The value for the debug mode can be modified in the configuration file `conf/config.json`. Look for the debug_level poperty and reduce the number to a lowesdt number to reduce the amount of log detail. For example setting it to 1 will only log errors. After modifying the configuration file, save your changes and restart Cronicle for the changes to take effect.
