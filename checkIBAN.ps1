#to check if IBANS and StructuredCustomerReferences (SCOR) are OK

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

$IBAN = Read-Host("Enter IBAN or 'X' to exit the script") 

while(-not ($IBAN -eq "X")){

if($IBAN.Length -gt 5){

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
$string = $var 

while($string.Length -gt 20)
{
	$mod1 = ($string.substring(0,9) % 97)
	$string = ([string]$mod1 + [string]$string.substring(9))
}
$ok = $string % 97

if($ok -eq 1){echo "$IBAN is OK."}
else{"$IBAN is not OK."}
echo "Checksum = $ok"

}else{Write-Host "IBAN too short"}

$IBAN = Read-Host("Enter IBAN or 'X' to exit the script") 
}

exit