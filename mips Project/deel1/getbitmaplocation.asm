#Dit programma leest een input van de vorm(x,y) en geeft dan de plaats van de pixel terug
#standaart voor de bitmap staat hieronder, als je deze wilt aanpassen moet je ook de dat aanpassen
#display width =512
#display height=512
#1 pixel = 16X16
#gebruikte registers:
#$t1-$t4:opslaan bitmap data
#$v0: oproepen syscall commando's
#$a0: opslaan argumenten voor syscalls
#$s0-$s5: opslaan berekeningen/input
.data
linebreak: .asciiz "\n"
askgetal1: .asciiz "type de eerste coordinaat"
askgetal2: .asciiz "type de tweede coordinaat"
fout: .asciiz "de coordinaat ligt niet in het veld"
.text
li $t1,16 #pixelheight
li $t2,16 #pixelwidth
li $t3,512 #displayheight
li $t4,512 #displaywidht

main:
leescoordinaat:
li $v0,4 #print de tekst om input te vragen
la $a0,askgetal1
syscall
li $v0,5 #leest integer input en zet dit in $s0
syscall
move $s0,$v0
li $v0,4
la $a0,askgetal2 #print de tekst om voor de tweede keer input te vragen
syscall
li $v0,5 #lees integer input en zet dit in $s1
syscall
move $s1,$v0

berekenaddres:
div $t3,$t1 #Deel displayhoogte door pixelhoogte (aantal verticale pixels)
mflo $s2 #zet de uitkomst hiervan in $s2
div $t4,$t2 #Deel siplaybreedte door de pixelbreedte (aantal horizontale pixels)
mflo $s3 #zet de uitkomst hiervan in $s3
mult $s1,$s3 #vermenigvuldig de 2 de input(y-coordinaat) met de $s3(aantal verticale piwels)
mflo $s4
jal fouttest
add $s4,$s4,$s0 #voeg aan het vorig product $s0 bij(De x-waarde)
li $t0,4
mult $s4,$t0 #vermenigvuldig alles met 4 omdat er een pixel om de 4 bits is in de bitmap
mflo $s4
la $s5($gp) #neemt het hudiig addres en zet het in $s5 
add $s5,$s5,$s4 #Voeg de uitkomst van de vorige berekeningen bij het huidig addres=nieuw addres
li $v0,34 #print het nieuwe addres
la $a0($s5)
syscall
j end
fouttest: #deze functie test of de coordinaat in het veld ligt
blt $s0,0,foutmelding
blt $s1,0,foutmelding
bgt $s1,$s3,foutmelding
bgt $s0,$s4,foutmelding
jr $ra

foutmelding:#Deze functie geetf weer dat de coordinaat juist is
li $v0,4
la $a0,fout
syscall

end:#eindigt het programma
li $v0,10
syscall
	
