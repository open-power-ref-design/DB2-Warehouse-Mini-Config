# Copyright 2016 IBM Corp.
#
# All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
#
#Cluster Genesis repository 
#
GENESIS_REMOTE="https://github.com/open-power-ref-design-toolkit/cluster-genesis.git"
GENESIS_LOCAL="cluster-genesis"
GENESIS_COMMIT="582332e310170d1317edb5bf82b81d21b0628d4f"
GENESIS_VERSION="release-1.2"
GENESIS_FULL=$(pwd)/$GENESIS_LOCAL

#
#Operations Manager repository 
#
OPSMGR_REMOTE="https://github.com/open-power-ref-design-toolkit/opsmgr.git"
OPSMGR_LOCAL="opsmgr"
OPSMGR_COMMIT="f7449bc318325914b52a0624bfb7f01acd408f90" 
OPSMGR_VERSION="branch-v3"
OPSMGR_FULL=$(pwd)/$OPSMGR_LOCAL


# DB_HOME=$(pwd)
# DASHDB_REPO="https://hub.docker.com/r/ibmdashdb/local"

PACKAGE_DIR="playbooks/packages"

DYNAMIC_INVENTORY=$GENESIS_FULL/"scripts/python/yggdrasil/inventory.py"

ACTIVATE_FILE=".GPFS-activate"
ACTIVATE_FILE=".dashDB-activate"

# CUDA_FILE=${PACKAGE_DIR}/cuda8.deb
# DKMS_FILE=${PACKAGE_DIR}/dkms.deb

#pull cluster-genesis into project directory
./setup_git_repo.sh "${GENESIS_REMOTE}" "${GENESIS_LOCAL}" "${GENESIS_COMMIT}"

#pull OpsMgr into project directory
#./setup_git_repo.sh "${OPSMGR_REMOTE}" "${OPSMGR_LOCAL}" "${OPSMGR_COMMIT}"

#apply any patches to genesis.
./patch_source.sh "${GENESIS_LOCAL}"

mkdir -p ${PACKAGE_DIR}

#Download Cuda Repo
# if [ ! -f ${CUDA_FILE} ];
# then
        # echo "Downloading Cuda repository"
	# wget  ${CUDA_REPO} -O ${CUDA_FILE}
# else
	# echo "SKIPPING: Cuda repo already downloaded"
# fi
# if [ ! -f ${DKMS_FILE} ];
# then
        # echo "Downloading dkms package"
	# wget  ${DKMS_LOCATION} -O ${DKMS_FILE}
# else
	# echo "SKIPPING: dkms package already downloaded"
# fi



#call cluster genesis install script
cd ${GENESIS_LOCAL}
scripts/install.sh
cd ..
export DYNAMIC_INVENTORY
echo "DYNAMIC " $DYNAMIC_INVENTORY
#
# Move variables to activate file to be sourced by deploy.sh
# This allows us to not require the user to export the variables
# manually, and can be run in a separate environment than the
# install.sh script.
#
echo 'DYNAMIC_INVENTORY='$DYNAMIC_INVENTORY > ${ACTIVATE_FILE}
echo 'GENESIS_FULL='$GENESIS_FULL >> ${ACTIVATE_FILE}
#echo 'ACCEL_DB_HOME='$ACCEL_DB_HOME >> ${ACTIVATE_FILE}
#echo 'OPSMGR_FULL='$OPSMGR_FULL >> ${ACTIVATE_FILE}
