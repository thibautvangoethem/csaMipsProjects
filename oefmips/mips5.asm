#deze functie leest een in en zegt dan of het een primgetal of niet is
#gebruikte registers: $v0,$s0,$t0,$a0,$t1,
#gemaakt door thibaut van Goethem
.data
prime: .asciiz "prime"
noprime: .asciiz "Noprime"
.text
main:
li $v0,5 #leest een int naar $v0
syscall
move $s0,$v0 #verplaatst de geleesde int naar $s0
li $t0,2 #het tijdelijke getal waardoor we alle getallen van 2 tot $s0-1 gaan delen
beq $s0,1,isprime #test of het getal het randgeval 1 is

test:#deze functie test of $s0 gedeeld door $t0 een rest heeft aan0
div $s0,$t0 #deelt $s0 door $t0 en zet de uitkomst in lo en de rest in hi
mfhi $t1 #zet hetgeen in hi in $t1
beq $t1,0,notprime #test of $t1 gelijk is aan 0 want dan is $s0 geen priemgetal

increment: #deze functie voegt 1 toe aan $t0
add $t0,$t0,1

testequal: #test of $t0 gelijk is aan $s0 want dan moet het programma stoppen
beq $t0,$s0,isprime
j test #als ze niet gelijk zijn dan test het opnieuw

isprime: #Deze functie print "prime"
la $a0,prime
li $v0,4
syscall
j exit

notprime:#Deze fucntie print "Noprime"
la $a0,noprime
li $v0,4
syscall

exit: #deze functie eindigt het programma
li $v0,10
syscall
#end of mips5.asm
