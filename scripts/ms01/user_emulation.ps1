$dirPath = "C:\xampp\htdocs\uploads"
cd $dirPath
$docFiles = Get-ChildItem -Path $dirPath -Filter *.doc
foreach ($file in $docFiles) {
    Start-Process $file.FullName
}
ping -n 10 127.0.0.1
tskill winword
