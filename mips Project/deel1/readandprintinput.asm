#dit programma leest om de 2 seconden een input en print deze dan uit
#gebruikte registers:
#$s0 om de tijd om te wachten op te slaan
#$v0 om syscalls commando's op te roepen
#$a0 voor argumenen meet te geven aan deze syscal commando's
#$t0 om te testen of er nput is in het keyboard
#$t1 ook om te testen of er input is in het keyboard
#$t2 om De nieuwe input op te slaan
#$t3 om de nieuwe input op te slaan
li $s0 2000 #laat het aantal milliseconde het moet wachten voor het weer input vraagt
.data
ask: .asciiz "please enter a character"
break: .asciiz "\n"
.text
main:
li $v0,4  #print een linebreak uit
la $a0,break
syscall
li $t0,0xffff0000 #haalt de waarde uit 0xffff0000, deze waarde geeft weer of er input is
lw $t1,($t0) #zet deze waarde in $t1
beq $t1,1,print #als deze waarde 1 is dan is er input en moet deze geprint worden
la $a0($s0) #als er geen input is dan wacht het 2 seconden
li $v0,32
syscall
li $v0,4 #hier vraagt de computer voor input
la $a0,ask
syscall
j main #start de loop opnieuw
print:
li $t2,0xffff0004 #haalt de nieuwe keyboard input uit 0xffff0004
lw $t3,($t2
li $v0,11 #het print deze char uit met syscall commando 11
la $a0($t3)
syscall
#j main #Dit is voor wanneer je eeuwig wilt blijven voortgaan, als dit in comments staat dan stop het programma
end:
li $v0,10
syscall


