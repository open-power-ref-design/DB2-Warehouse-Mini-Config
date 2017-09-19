
# DB2 Warehouse Mini

## Introduction
This repository is a comprehensive set of instructions, rules, and automation tools for building an OpenPOWER-based DB2 Warehouse Mini config with "locally attached storage" and Spectrum Scale GPFS FPO.

## Cluster Configurations
- **Deployer node (recommended) - Any Ubuntu based Server (Power / x86) with direct access to 1G + 10G and Switch mgmt network **
    - If Deployer node is not available, the setup process can be done manually and proceed to use ./playbooks/tasks for example on how to deploy Db2 Warehouse
- *Mini config - Three (3) S822LC Servers (MTM 8001-22C or Equivalent) **
    - See BOM in [DB2_Warehouse_Mini_BOM.pdf](./docs/DB2_Warehouse_Mini_BOM.pdf).
    - Obstain Spectrum Scale GPFS FPO Standard Edition License and Download images
        https://www.ibm.com/id-en/marketplace/scale-out-file-and-object-storage
    - Obstain dashDB Install Image via DockerHub (https://hub.docker.com/r/dashdb/local/)  or via IBM website (http://ibm.biz/dashDBLocal)
    (https://www.ibm.com/support/knowledgecenter/en/SS6NHC/com.ibm.swg.im.dashdb.doc/admin/local_prereqs-POWER.html)
    - Obstain/Provide additional Software License and Support as needed ..ie OS, Docker

Notes: if you plan to deploy a larger node config,  Please review the DB2 Warehouse sizing guide, and adjust GPFS FPO config accordingly.
This guide does not cover this modifications. Contact IBM for further help.

## Build and Installation
1. Configure and Build the Hardware config as described in [DB2_Warehouse_Mini_Deployment_Guide.pdf](./docs/DB2_Warehouse_Mini_Deployment_Guide.pdf)
2. Run `git clone https://github.ibm.com/anhdang/dashDBLocal-Mini.git`
3. Run `install.sh`
4. Edit the the example ["dashDB.node.config.yml"](./dashDB.node.config.yml) file to match your exact configuration.
 * Review/Update the following Sections: "_reference-architecture_", "_networks_", "_node-templates_".
 * Copied Spectrum GPFS install images (*.deb (Ubuntu) / *.rpm (RHEL/CentOS) ) into ./playbooks/packages/gpfs/ folder
 * Copied DB2 Warehouse install image images to ./playbooks/packages/db2local/ folder or supply valid dockerID credentials in the (./dashDB.node.config.yml) for online download.
 * Review/Update ["./playbooks/db2_playbook.yml"](./playbooks/db2_playbook.yml) as needed

5. Run `deploy.sh dashDB.mini.config.yml` to start deployment process  (or substitute your own custom  "config.yml" )
  * Deploy.sh will execute the following tasks:
      * "Cluster Genesis" performs: OS install and Config basic Network connectivity to all servers.
      * "DB2 Playbook"  [./playbooks/db2_playbook.yml](./playbooks/db2_playbook.yml) performs DB2 Warehouse application deployment includes the following tasks:

- ["./playbooks/tasks/1_create_drive_partition.yml"](./playbooks/tasks/1_create_drive_partition.yml)
- ["./playbooks/tasks/2_install_gpfs.yml"](./playbooks/tasks/2_install_gpfs.yml)
- ["./playbooks/tasks/3_config_gpfs.yml"](./playbooks/tasks/3_config_gpfs.yml)
- ["./playbooks/tasks/4_install_docker.yml"](./playbooks/tasks/4_install_docker.yml)
- ["./playbooks/tasks/5_install_dashDB.yml"](./playbooks/tasks/_5install_dashDB.yml)
