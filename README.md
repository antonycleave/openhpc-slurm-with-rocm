## Quick start
on a system with docker preinstalled
```
make clean
make
docker run -v .\:/host slurm-build:23.11.10 /bin/bash -c "cp /root/rpmbuild/RPMS/*/*.rpm /host"'
```
you may need to remove an existing image with `imageref=$(sudo docker image ls slurm-build:23.11.10 -q) && [ -n "$imageref" ] && docker image rm $imageref`