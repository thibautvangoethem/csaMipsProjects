#deze functie voert het equevalent van een swith statement in c++ in
#gebruikte registers $v0,$s0,$s1,$ra,$a0
#gemaakt door thibaut van Goethem

main:
li $v0,5 #leest een int naar $v0
syscall
move $s0,$v0 #verplaatst de geleesde int naar $s0
li $s1,0 #is zoals de int a=0 in c++, het plaatst een 0 op $s1
j switch #gaat naar functie switch

switch: #deze functie roept iedere keer een test op voor iedere case
jal test0 #gaat naar functie test0 en zet de huidige pc(program counter) in $ra
jal test1 #gaat naar functie test1 en zet de huidige pc in $ra
jal test2 #gaat naar functie test2 en zet de huidige pc in $ra
jal default #gaat naar functie default en zet de huidige pc in $ra

test0: #test of $s0 is gelijk aan nul, zoja dan zet het $s1 op 9
bne $s0,0,return #gaat naar functie return als $s0 niet 0 is
li $s1,9
j end 

test1: #test of $s0 is gelijk aan één, zoja dan zet het $s1 op 6
bne $s0,1,return #gaat naar functie return als $s0 niet 1 is
li $s1,6
j end

test2: #test of $s0 is gelijk aan twee, zoja dan zet het $s1 op 8
bne $s0,2,return #gaat naar functie return als $s0 niet 2 is
li $s1,8
j end
 
default: #zet $s1 gelijk aan 7 wanneer de andere cases vals zijn 
li $s1,7
j end

return:#Deze functie roept simpelweg het commande jr op dat terug gaat naar de waarde die opgeslagen is in de programm counter
jr $ra

end:
la $a0($s1) #laad hetgeen op $s1 staat naar $a0
li $v0, 1 #print nummer op plaats a0
syscall
li $v0,10 #eindigt het programma
syscall
#end of mips4.asm
 

