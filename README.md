# Isilon_Quota_Gathering

PowerShell scripts that gather **quota and usage information from EMC Isilon clusters**, parse it and load it into
SQL Server for chargeback reporting.

> **Resumen:** scripts que recolectan cuotas y uso de clústeres EMC Isilon, los procesan y los cargan en SQL Server
> para reportes de chargeback.

## Files

| File | What it does |
|---|---|
| `start_gathering.ps1` | Connects to each array over SSH (`plink`) and runs the bash scripts that collect usage (`bashscript/startdu.sh`) |
| `Isilon_Get_Quotas.ps1` | Module: one `Get_Isilon_Quotas_ARRAYnn` function per cluster, then `Merge_all_parsed` and `Insert_to_SQL` |
| `start_chargeback.ps1` | Starts the chargeback run per cluster, reading each cluster's device list from a CSV |
| `Insert_Quotas_into_SQL.ps1` | Loads the parsed quotas into the SQL Server table |
| `Insert_Quotas_into_SQL_MANUAL.ps1` | Same, for a manual run |

The cluster names are generic (`ARRAY01` ... `ARRAY06`): add or rename them to match your clusters.

## Requirements

- Windows PowerShell with the SQL Server tools (`Invoke-Sqlcmd`, `System.Data.SqlClient`).
- [PuTTY `plink.exe`](https://www.chiark.greenend.org.uk/~sgtatham/putty/).
- A SQL Server instance and a database for the results. The scripts use Windows integrated authentication and the
  placeholder `SQLSERVER\INSTANCE`, with a database named `Isilon`.
- One CSV per cluster, semicolon separated, with the columns `dev;ipa;usr;pwd;typ`. **Never commit these files**;
  `.gitignore` skips them.

## Setup

Edit the folders at the top of each script (`D:\Dev\...`) and the SQL Server name, then run `start_gathering.ps1`.

Written in 2018 and 2019. Kept for reference, not actively maintained.