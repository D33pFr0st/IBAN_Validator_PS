#to check if IBANs are valid according to the mod 97 operation. This tool will also work for other strings with the same validation-operation, eg. SCOR
#Note: this does not mean the IBAN exists. This tool simply shows that the IBAN is valid.

#Requirements of CSV-file:
#Delimiter must be ;
#File must contain the columns "IBAN" and "ok" (without the ")

#A file "Results.csv" will be created in the same directory as the source file.
#This file will contain the original data + the results of the validation as an integer: 1 = correct / 0 = IBAN to short / everything else = incorrect

#Example Ibans:
#DE: DE68 2105 0170 0012 3456 78
#Albania: AL47 2121 1009 0000 0002 3569 8741
#Cyprus: CY 17 002 00128 0000001200527600
#Kuwait: KW81CBKU0000000000001234560101
#Luxembourg: LU 28 001 9400644750000
#Norway: NO 93 8601 1117947

#Validation:
#https://de.wikipedia.org/wiki/Internationale_Bankkontonummer#Validierung
#https://en.wikipedia.org/wiki/International_Bank_Account_Number#Modulo_operation_on_IBAN


#File Select
Add-Type -AssemblyName System.Windows.Forms

$FileSelector = New-Object System.Windows.Forms.OpenFileDialog
$FileSelector.Title = "Select a File"
$FileSelector.InitialDirectory = [Environment]::GetFolderPath('Desktop')

# Set the filter to specify the types of files you want to display
$FileSelector.Filter = "CSV files (*.csv)|*.csv|All files (*.*)|*.*"

# Show the file selector window and check if the user clicked the OK button
if ($FileSelector.ShowDialog() -eq 'OK') {
    $SelectedFile = $FileSelector.FileName
    Write-Host "Selected file: $SelectedFile"
}
else {
    Write-Host "No file selected."
}



# Import
$P = Import-Csv -Path $SelectedFile -Delimiter ';'
$P | Format-Table
[array]$IBANs = $P | select IBAN


for ($j=0; $j -lt $IBANs.Length; $j++){
$IBAN = ($IBANs[$j].IBAN)

if($IBAN.Length -gt 4){

#Preparation
$IBAN = $IBAN -replace '\s',''
$first = $IBAN.substring(0,4)
$num = $IBAN.substring(4)
$num += $first

$var = ""
for ($i = 0; $i -lt $num.Length; $i++)
{
    $char = $num.substring($i,1)
    if($char -match '[0-9]'){
	#echo $char
    }else{$char = ([int][char]$char - 55)}
    $var += $char
}

#Calculation
$string = $var
while($string.Length -gt 20)
{
	$mod1 = ($string.substring(0,9) % 97)
	$string = ([string]$mod1 + [string]$string.substring(9))
	#echo $string
}
$ok = $string % 97


#Output
$P[$j].ok = $ok

echo ------------------------------------------------
if($ok -eq 1){echo "$IBAN is OK."}
else{"$IBAN is not OK."}
echo "Checksum = $ok"

}else{Write-Host "IBAN too short", $P[$j].ok = 0}

}

#Export back to File
$s = Get-Item $SelectedFile
$path = $s.DirectoryName
$P | Export-Csv -Path $path\Results.csv -UseCulture

Read-Host("Finished...") 
