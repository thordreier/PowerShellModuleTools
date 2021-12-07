exit # Don't just run this file

# Build module
.\Build.ps1

# Build and install module
.\Build.ps1 -InstallModule

# Build and install module for all users
.\Build.ps1 -InstallModule -InstallModulePath AllUsers
