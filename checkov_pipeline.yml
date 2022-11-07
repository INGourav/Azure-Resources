trigger:
  - cosmosdb

variables:
- name: tf_folder
  value: $(System.DefaultWorkingDirectory)/tf

pool:
  vmImage: ubuntu-latest

steps:
- bash: pip3 install checkov
  displayName: 'Install checkov'
  name: 'install_checkov'

- powershell: Set-Location -Path $(System.DefaultWorkingDirectory)\tf; ls
  displayName: 'ps location'
  name: 'ps_location'
  
- bash: checkov --directory $(System.DefaultWorkingDirectory)/tf
  displayName: 'verify modules with checkov'
  name: 'checkov_module_check'
