ARG releasetag=9
FROM  docker.io/library/rockylinux:$releasetag
ARG ROCMVERS=6.2.2
ARG OhpcMajorVers=3
ARG OhpcUpdateDir=updates # this can be changed to a SPECIFIC update as required e.g. update.3.1 the default updates (plural) is a symlink to the current release
ARG SLURM_VERSION=23.11.10
WORKDIR /root/rpmbuild
COPY ./rpmbuild/./ /root/rpmbuild
######## add AMD ROCM repo using correct version
COPY <<-EOF /etc/yum.repos.d/rocm.repo
[ROCm-${ROCMVERS}]
name=ROCm-${ROCMVERS}
baseurl=https://repo.radeon.com/rocm/el9/${ROCMVERS}/main
enabled=1
priority=50
gpgcheck=1
gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
EOF

####### add AMD OpenHPC repo using correct version
COPY <<-OHPCREPOEOF /etc/yum.repos.d/OpenHPC.repo
[OpenHPC]
async = 1
baseurl = https://repos.openhpc.community/OpenHPC/${OhpcMajorVers}/EL_9
gpgcheck = 1
gpgkey = https://github.com/openhpc/ohpc/raw/refs/heads/${OhpcMajorVers}.x/components/admin/ohpc-release/SOURCES/RPM-GPG-KEY-OpenHPC-3

name = OpenHPC-3 - Base

[OpenHPC-updates]
async = 1
baseurl = https://repos.openhpc.community/OpenHPC/${OhpcMajorVers}/${OhpcUpdateDir}/EL_9
gpgcheck = 1
gpgkey = https://github.com/openhpc/ohpc/raw/refs/heads/${OhpcMajorVers}.x/components/admin/ohpc-release/SOURCES/RPM-GPG-KEY-OpenHPC-3
name = OpenHPC-3 - Updates

OHPCREPOEOF
RUN curl -sSf -o /root/rpmbuild/SOURCES/slurm-${SLURM_VERSION}.tar.bz2 https://download.schedmd.com/slurm/slurm-${SLURM_VERSION}.tar.bz2 && \
    dnf -y install epel-release && \
    /usr/bin/crb enable && \
    dnf -y install @Development\ Tools  dbus-devel freeipmi-devel gtk2-devel http-parser-devel json-c-devel libcurl-devel libjwt-devel libyaml-devel mariadb-devel munge-devel numactl-devel pam-devel readline-devel lua-devel perl-ExtUtils-MakeMaker ohpc-buildroot hwloc-ohpc pmix-ohpc rocm-smi-lib bzip2

RUN source /etc/profile.d/lmod.sh && \
    rpmbuild -ba /root/rpmbuild/SPECS/slurm.spec
