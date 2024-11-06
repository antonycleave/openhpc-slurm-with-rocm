
SLURM_VERSION = 23.11.10
SLURM_TAR_URL = https://download.schedmd.com/slurm/slurm-$(SLURM_VERSION).tar.bz2
DEST_DIR = ./rpmbuild/SOURCES
TAR_FILE = $(DEST_DIR)/slurm-$(SLURM_VERSION).tar.bz2
IMAGE_NAME = slurm-build
IMAGE_TAG = $(SLURM_VERSION)
IMAGE_FULL_TAG = $(IMAGE_NAME):$(IMAGE_TAG)

# Default target
all: download docker_build

# Target to download the source code
download: $(TAR_FILE)
$(TAR_FILE):
	@echo "Downloading slurm-$(SLURM_VERSION).tar.bz2"
	@mkdir -p $(DEST_DIR)
	@curl -sSo $(TAR_FILE) $(SLURM_TAR_URL)
	@echo "Download complete."

# Target to build the Docker image
docker_build:
	@echo "Building Docker image..."
	@docker build -t $(IMAGE_FULL_TAG) .
	@echo "Docker build complete."
# todo add target to run this
# 'sudo docker run -v .\:/host slurm-build:23.11.10 /bin/bash -c "cp /root/rpmbuild/RPMS/*/*.rpm /host"'
clean:
	@echo "removing source tarball"
	@rm -f $(TAR_FILE)
	@echo "Clean complete."
  # TODO
  # imageref=$(sudo docker image ls slurm-build:23.11.10 -q) && [ -n "$imageref" ] && docker image rm $imageref
