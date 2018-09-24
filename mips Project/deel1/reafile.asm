#dit programma leest een file en print alles wat in deze file zit
#gebruikte register:
.data
filename: .asciiz "iets.txt"
buffer: .space 2048
.text

main:
li $v0,13
la $a0,filename
li $a1,0
li $a2,0
syscall
move $s0,$v0
li $v0,14
move $a0,$s0
la $a1,buffer
li $a2,2048
syscall
li $v0,16
move $a0,$s0
syscall

li $v0,4
la $a0,buffer
syscall
li $v0,10
syscall

