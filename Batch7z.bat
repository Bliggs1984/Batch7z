@Echo OFF
SetLocal EnableDelayedExpansion

Rem //  7-Zip Executable Path
Set sevenZip="C:\utils\7-Zip\7z.exe"

Rem // Set number of cores to 24
Set cores=24

Rem // START: NewLine Variable Hack
Set newLine=^


Rem // END: NewLine Variable Hack !! DO NOT DELETE 2 EMPTY LINES ABOVE !!

Rem //  Set ErrorLog Variables
Set errorCount=0
Set separator=--------------------------------------------------------
Set errorLog=!newLine!!newLine!!separator!!newLine!!newLine!
Set errorPrefix=ERROR @:
Set successMessage=All Files Were Successfully Archived and Originals Removed

Rem //  Loop Through Each Argument
for %%x in (%*) do (
    SetLocal EnableDelayedExpansion
    Set "sourcePath=%%~fx"
    Set "archivePath=%%~dpnx.zip"

    Rem //  Print Separator To Divide 7-Zip Output
    echo !newLine!!newLine!!separator!!newLine!!newLine!

    Rem //  Add Files To Zip Archive using 24 cores and delete originals
    "!sevenZip!" a -tzip -mmt=24 -sdel "!archivePath!" "!sourcePath!"

    Rem //  Check if archiving was successful
    if !ErrorLevel! equ 0 (
        echo Successfully archived and removed: "!sourcePath!"
    ) else (
        Rem //  Log Errors
        Set /A errorCount+=1
        Set "errorLog=!errorLog!!newLine!!errorPrefix!"!sourcePath!""
    )
    EndLocal
)

Rem //  Print ErrorLog
if !errorCount! equ 0 (
    Set "errorLog=!errorLog!!newLine!!successMessage!"
)
Echo !errorLog!!newLine!!newLine!!newLine!

Rem //  Keep Window Open To View ErrorLog
pause