if(!(Test-Path -Path "C:/byond")){
    bash tools/ci/download_byond.sh
    [System.IO.Compression.ZipFile]::ExtractToDirectory("C:/byond.zip", "C:/")
    Remove-Item C:/byond.zip
}

bash tgui/bin/tgui --build

&"C:/byond/bin/dm.exe" -max_errors 0 lobotomy-corp13.dme
exit $LASTEXITCODE
