# After moving /var/lib/docker to /home/docker

sudo semanage fcontext -a -t container_var_lib_t "/home/docker(/.*)?"
sudo semanage fcontext -a -t container_ro_file_t "/home/docker/.*/config\.env"
sudo semanage fcontext -a -t container_ro_file_t "/home/docker/init(/.*)?"
sudo semanage fcontext -a -t container_ro_file_t "/home/docker/overlay(/.*)?"
sudo semanage fcontext -a -t container_ro_file_t "/home/docker/overlay2(/.*)?"
sudo semanage fcontext -a -t container_ro_file_t "/home/docker/containers/.*/hosts"
sudo semanage fcontext -a -t container_log_t     "/home/docker/containers/.*/.*\.log"
sudo semanage fcontext -a -t container_ro_file_t "/home/docker/containers/.*/hostname"
