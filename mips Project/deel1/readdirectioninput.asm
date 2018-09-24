#dit programma leest om de 2 seconden een input en print dan up,down,left,right naargelang deze input
li $s0 2000 #laad het aantal miliseconden dat het moet wachten voor het programma opnieuw start
.data
break: .asciiz "\n"
up: .asciiz "up"
down: .asciiz "down"
left: .asciiz "left"
right: .asciiz "right"
.text
main:
li $t0,0xffff0000 #checkt eerst of er input is door te zie of hetgeen in 0xffff0000 zit gelijk is aan 1
lw $t1,($t0)
beq $t1,1,load #als er inout is dan gaat het naar load
j main #anders start het de loop opnieuw

print:#deze functie print hetgeen in $s0 zit, hetgeen wat erin zit hangt af van de keyboard input
li $v0,4 #print een linebreak
la $a0,break
syscall
la $a0($s0) #print hetgeen in $s0 zit
li $v0,4
syscall
j main #start de loop opnieuw

load:
li $t2,0xffff0004 #laad de keyboard input in $t2
lw $t3,($t2) #zet deze input in $t3
beq $t3,122,setup #als $t3 ascii waarde 122 is dan is dit een z en moet "up" in $s0 komen
beq $t3,115,setdown #als $t3 ascii waarde 115 is dan is dit een s en moet "down" in $s0 komen
beq $t3,113,setleft #als $t3 ascii waarde 113 is dan is dit een q en moet "left" in $s0 komen
beq $t3,100,setright #als $t3 ascii waarde 100 is dan is dit een d en moet "right" in $s0 komen
beq $t3,120,end #als $t3 ascii waarde 120 is dan is dit een x en moet het programma stoppen
j main #als het geen van de vorige is dan start het de loop opnieuw

#in de volgende functies gaat het telkens het juiste in $s0 zetten en naar de print gaan
setup:
la $s0,up
j print

setdown:
la $s0,down
j print

setright:
la $s0,right
j print

setleft:
la $s0,left
j print

end: #deze functie stopt het programma
li $v0,10
syscall
