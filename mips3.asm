#deze functie leest een int n en dan print hij een trap van n hoogte waar de trappen van links naar recht van 1 naar n gaan
#gebruikte registers:$v0,$s0,$t0,$t1,$t2,$a0
#gemaakt door thibaut van Goethem

.data
linebreak: .asciiz "\n" #wordt gebruikt om een linebreak op te roepen
.text

main:
li $v0,5 #leest een int naar $v0
syscall
move $s0,$v0 #verplaatst de geleesde int naar $s0
li $t0,1 #zet $t0 op 1, deze gaat gebruikt worden voor de uitserste loop
li $t1,1 #zet $t op 1, deze gaat gebruikt worden voor de inerste loop

print: #dit print $t1
li $v0,1 #roept de code om een int te printen op
la $a0($t1) #zet $a0 gelijk aan de waarde in $t1(inerste loop)
syscall

test: #dit test of $t0 en $t1 gelijk zijn om te zien of de inerste loop moet stoppen
beq $t0,$t1,incrementouter #als $t0 gelijk is aan $t1 dan is een van de inerste loops gedaan en moeten we naar de uiterste loop gaan om iets te doen
add $t1,$t1,1 #voegt 1 toe aan $t1 om het volgende cijfer te printen
j print  #gaat terug naar print om het volgende getal te printen

incrementouter: #voegt 1 toe aan $t0 en zet $t1 op 1, hierna test het of het programma verder moet gaan of niet
li $v0,4 #roept de code op om een string te printen
la $a0,linebreak #plaats de linebreak in $a0, zo wordt er dus feitelijk een linebreak gedaan
syscall 
add $t0,$t0,1 #voegt 1 toe aan $t0 om de volgende inerset loop 1 langer te laten zijn
li $t1,1 #zet $t1 op 1 zodat de inerste loop opnieuw kan opgeroepen worden
sgt $t2,$t0,$s0 #test ofdat $t0 groter is dan $s0(het getal dat je in het begin typte), zoja dan moet het programma stoppen
beq $t2,1,endloop #dus als $t0 groter is dan $s0 dan gaat het naar endloop, dit stopt het programma
j print #als het programma niet moet stoppen gaat het gewoon terug naar print om de innerste loop opnieuw te starten

endloop: #eindigt het programma
li $v0, 10
syscall
#end of mips3.asm
