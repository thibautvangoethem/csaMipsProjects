#mips2.asm: een programma dat een loop invoert die tot 10 telt en dit altijd print
#registers gebruikt: $t0,$t1,$t2,$a0,$v0
#gemaakt door thibaut van Goethem
.data
enter: .asciiz "\n" #initialiseert een string voor een linebreak

.text
main:
li $t0,0 #zet $t0 op waarde 0
li $t1,10 #zet $t1 op waarde 10
j loop #gaat naar branch loop om de loop te starten
increment: #Deze functie incrementeert $t0 met 1
add $t0,$t0,1 #add 1 bij $t0
print: #deze functie print $t0 en dan een line break
la $a0($t0) #laad $a0 met de waarde in $t0
li $v0, 1 #roept de syscal command op om een int te printen
syscall
li $v0,4	#roept de syscall command op om een string te printen
la $a0, enter       # laad het woord enter(dit is een linebreak) op $a0
syscall
loop:
slt $t2,$t0,$t1	#zet $t2 op 1 als de waarde in $t0 kleiner is dan de waarde in $t1 en vice versa
beq $t2,1,increment #test ofdat $t2 gelijk is aan 1(dus $t0 kleiener dan $t1), als dit waar is dan jumpt hij naar functie increment en start hij de loop opnieuw
endloop: #eindigt de loop en het programma
li $v0,10
syscall
#end of mips2.asm
