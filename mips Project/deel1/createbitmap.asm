#dit programma maakt een 32x32 rode bitmap aan
li $t0,0x00ff0000 #de kleur rood wordt in $t0 gezet
li $t1,0x00FFFF00 #de kleur geel wordt in $t1 gezet
li $t2,0	#het getal 0 wordt in $t2 gezet dit register wordt gebruikt om de loop te latten lopen

loop: #deze functie gaat constant lopen tot het 1024 keer geloopt heeft
beq $t2,1024,stop #als er 1024 keer geloopt is dan stopt het programma
ble $t2,32,drawyellow #als er minder dan 32 keer geloopt is moet er een geel vakje komen(bovenkant)
bge $t2,992,drawyellow #als er meer dan 992 keer geloopt is moet er een geel vakje komen(onderkant)
li $t4,32 #zet het getal 32 in $t4
div $t2,$t4 #deelt het loopregister door het register met het getal 32
mfhi $t3 #zet de rest van deze deling in register $t3
beq $t3,0,drawyellow #als de rest 0 is dan moet er een geel vakje komen(linkerkant)
beq $t3,31,drawyellow #als de rest 31 dan moet er een geel vakje komen(rechterkant)

drawred:#als alle testen in de vorige functie false waren dan moet er een rood vakje komen
sw $t0($gp) #zet rood op vakje met de positie die in $gp zit
addi $gp,$gp,4 #telt 4 op bij $go zodat het de volgende keer het volgende vakje kiest
addi $t2,$t2,1 #voegt 1 toe aan de loop
j loop	#gaat terug naar loop
drawyellow:#deze functie doet hetzelfde als de vorige maar dan met geel
sw $t1($gp)
addi $gp,$gp,4
addi $t2,$t2,1
j loop
stop: #dit stop het programma
li $v0,10
syscall
