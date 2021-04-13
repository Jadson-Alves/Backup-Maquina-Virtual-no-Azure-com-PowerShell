##############################
### Backup máquina virtual ###
##############################    

# Criar o Grupo de Recursos
New-AzResourceGroup -name "RG-Backup" `-Location "EastUs"

# Verificar Recovery Service Vault criados
Get-AzRecoveryServicesVault | Select name

# Criar o Recovery Service Vault
New-AzRecoveryServicesVault -Name "RecoveryVaultBackup" -ResourceGroupName "RG-Backup" -Location "EastUS" 
Get-AzRecoveryServicesVault -Name RecoveryVaultBackup | Set-AzRecoveryServicesVaultContext

# Especificar o tipo de redundância de armazenamento
$rsvault = Get-AzRecoveryServicesVault -Name  "RecoveryVaultBackup"
Set-AzRecoveryServicesBackupProperties -Vault $rsvault -BackupStorageRedundancy "LocallyRedundant"

# Criar a politica de Backup
$policy = Get-AzRecoveryServicesBackupProtectionPolicy -Name DefaultPolicy

# Habilitar o backup para VM
Enable-AzRecoveryServicesBackupProtection -ResourceGroupName RG-dev-jadsonalves -Name dev-VM002 -Policy $policy

# Executar o Backup
$container = Get-AzRecoveryServicesBackupContainer -ContainerType AzureVM -FriendlyName dev-VM002
$item = Get-AzRecoveryServicesBackupItem -Container $container -WorkloadType AzureVM
Backup-AzRecoveryServicesBackupItem -Item $item

# Verificar o Status do Backup
Get-AzRecoveryServicesBackupJob

