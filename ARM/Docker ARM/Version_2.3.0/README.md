# Provisioning Formula

## Quick-start Instructions

1. Deplopy a formula template to a lab using the following commands:
   ```bash
    az account set -s 'MAM-ENB-CBZ-DEV-CAC'
	az deployment group create -g <RgName> --template-file "~/Cloud_Enablement-DevOps/Formulas/<formulaName>.json" --parameters existingLabName=<labName> BlobFuse_scriptFileArguments="<StorageAccountName> <StorageContainerName> <StorageAccountKey>"

    ```
	Where,
    * `<LabName>` - Name of the Lab to be created, dtl-<userId>-<number e.g. 001>
    * `<RgName>` - Name for the new resource group where the lab will be created
	
	For example:
	Oracle DB Server
    ```bash
	az deployment group create -g rg-dtl-dev-cac --template-file "~/Cloud_Enablement-DevOps/Formulas/oracleVM.json" --parameters existingLabName=dtl-gravenc2-001 BlobFuse_scriptFileArguments="maxtest001 orabcntr1 nHxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxA=="
    ```
    Docker Workstation
    ```bash
    az deployment group create -g rg-dtl-dev-cac --template-file "~/Cloud_Enablement-DevOps/Formulas/dockerVM.json" --parameters existingLabName=dtl-gravenc2-001
    ```

### Best Practice Reminders : Linux VMs
1. Disk Performance - Stripe multiple P30 to aggregate performance (recommend using at least 2x P30 for Data. Each P30 Premium Managed Disk provides 1TB, 5000 IOPS, 200 MB/sec throughput)
* And use separate disks/volumes for Data and Logs
```bash
LVM sudo lvcreate --extents 100%FREE --stripes 3 --name data-lv01 data-vg01
```
ref: 
- [Azure VM - Configure LVM](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/configure-lvm)
- [Azure Managed Disk - Choosing Disk Types](https://docs.microsoft.com/en-us/azure/virtual-machines/disks-types)
- [Azure Premium Storage - Design for Performance](https://docs.microsoft.com/en-us/azure/virtual-machines/premium-storage-performance)

2. Disk Performance - Caching
ref:
- [Designing for High Performance - Disk Caching](https://docs.microsoft.com/en-us/azure/virtual-machines/premium-storage-performance#disk-caching)
- [Oracle Database in Azure - Disk Caching - set SYSTEM, TEMP, UNDO set NONE. For DATA set NONE unless database is read intensive then use READ-ONLY](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/oracle/oracle-design#disk-cache-settings)
