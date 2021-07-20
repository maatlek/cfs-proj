#.(UNINSTALL PROGRAMS)

$package = "jdk8","mysql","mongodb"

Get-Package -ProviderName chocolateyGet | Where-Object {$package.Contains($($_.name))} | Uninstall-Package

#if installed with windowsinstaller on programs
Get-Package -ProviderName Programs | Where-Object {$package.Contains($($_.name))} | Uninstall-Package