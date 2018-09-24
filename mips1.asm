#mips1.asm: een programma dat een integer leest en dan uitprint het hoeveelste mips programma dit is
#gemaakt door thibaut van Goethem
# Registers gebruikt:$V0,$t1,$a0
.data

string1: .asciiz "this is my "
string2: .asciiz "-th Mips program"
.text 

main:
    li $v0, 5 #lees input naar v0
    syscall 
    move $t1, $v0#verplaats een int naar v0
    li $v0, 4 #roept de syscall code voor het uitprinten van een string op
    la $a0, string1 #laad string1 naar $a0
    syscall 
    la $a0($t1) #laad hetgeen op $t1 staat naar $a0
    li $v0, 1 #print nummer op plaats a0
    syscall
     li $v0, 4 #roept de syscal code voor het uitprinten van een string terug op
    la $a0, string2 #laad string2 naar $a0
    syscall 
    
exit:
li $v0, 10 #eindigt het programma
syscall
# end of mips1.asm 
