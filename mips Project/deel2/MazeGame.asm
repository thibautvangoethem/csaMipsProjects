#Dit programma is een simpel doolhofspel waar een doolhof van breedte 32 wordt gelezen en je hierin kan bewegen
#Het programma stop als je x typt of als je aan het einde geraakt
#De file dat het doolhof voorstelt moet hieronder bij de variabele filename getypt worden
.globl main
.data
filename: .asciiz "maze2.txt"
fout: .asciiz "de coordinaat ligt niet in het veld"
win: .asciiz "you win!"
buffer: .space 2048
.text


main:
	jal readfile	#een functie die de file lees
	la $a0($v0)	#zet deze file in register $a0
	li $t0,0	#Dit wordt de counter voor de kollommen
	li $t1,0	#Dit wordt de counter voor de rijen
	li $t2,0	#Dit wordt de counter die helpt met over de string te itereren$
	jal drawmainloop
	la $s0($v0)	#slaagt de x-positie van de speler op in $s0
	la $s1($v1)	#slaagt de y-positie van de speler op in $s1
	la $a0($s0)	#laadt de x-waarde n $a0 voor mee te geven als argument
	la $a1($s1)	#laadt de y-waarde n $a1 voor mee te geven als argument
	
	jal gamemainloop
	
	j endprogramm

	
	
readfile: #Deze functe leest een file en zet het in $v0
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 8	# allocate 16 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address

	
	li $v0,13 	#roept het commando op voor het openen van een file
	la $a0,filename	#laadt de file in $a0
	li $a1,0	
	li $a2,0
	syscall
	move $s0,$v0	#Zet de file in $v0
	li $v0,14
	move $a0,$s0	#zet de file in $a0
	la $a1,buffer	
	li $a2,2048
	syscall		#leest de eerst 2048 chars van de file en zet deze in buffer als string
	la $v0,buffer
	
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old frame pointer from current fra
	lw	$fp, ($sp)	# restore old frame pointer
	jr	$ra
	
	
drawmainloop: #Dit is de hoofdloop die over de file itereert
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 8	# allocate 16 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	la $s0($a0) 	#zet de file in $s0
	li $s5,1024	#max aantal kollomen
	drawloop: 	#loop waarnaar feitelijk gejumped wordt
		la $a0($t0)	#zet de x-coordinaat in $a0
		la $a1($t1)	#zet de y-coordinaat in $a1
		jal getbitmaplocation	#haalt de bitmaplocate en zet de in $v0
		la $s1($v0)	#slaagt de bitmpalocatie op in $s1
		bgt $t2,1056,enddraw
		lb $s2, 0($s0)		#haalt een byte uit een string en zet deze in $s2
		addi $s0,$s0,1	#voegt 1 toe aan de string counter zodat het de volgende loop de volgende char neemt
		addi $t2,$t2,1	#voegt 1 toe aan de loop die test of het tekenen moet eindigen
		addi $t0,$t0,1	#voegt 1 toe aan de x waarden
		beq $s2,10,incrementrij	#als het character een linebreak is dan gaat het naar deze functie die ervoor zorft dat je naar de volgende rij gaat
		
		
		colourtest:	#Deze functie gaat testen welke kleur er op de bitmap moet komen naargelang het character
		beq $s2,119,loadblue	
		beq $s2,112,loadblack
		beq $s2,99,loadwhite
		beq $s2,101,loadred
		beq $s2,115,loadyellow
		beq $s2,117,loadgreen
		li $v0,0x000000ff #als er geen letter meer is
		storecolor:
		sw $v0($s1)	#Zet deze kleur op de bitmap
		
		j drawloop 	#start de loop opnieuw
	
	enddraw:	#Deze functie eindigt het tekenen van de bitmpa en restored de stackframe en springt terug naar het vorig addres
	la 	$v0($s6)
	la	$v1($s7)
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old frame pointer from current fra
	lw	$fp, ($sp)	# restore old frame pointer
	jr	$ra
incrementrij:	#deze functie voegt  toe aan de rij en zet de kollomcounter terug op 0
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of 
	subu	$sp, $sp, 8	# allocate 16 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	li $t0,0	#zet kollom op nul
	addi $t1,$t1,1	#voeg 1 toe aan rij
	

	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old frame pointer from current fra
	lw	$fp, ($sp)	# restore old frame pointer
	jr	$ra
loadred:	#Deze functie laad de kleur rood in $v0
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 8	# allocate 16 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	li $v0,0x00ff0000
	li $s2,0
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old frame pointer from current fra
	lw	$fp, ($sp)	# restore old frame pointer
	j	 storecolor
	
loadblue:	#Deze functie laad de kleur geel in $v0
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 8	# allocate 16 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	li $v0,0x000000ff
	li $s2,0
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old frame pointer from current fra
	lw	$fp, ($sp)	# restore old frame pointer
	j	storecolor
loadblack:	#Deze functie laad de kleur zwart in $v0
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 8	# allocate 16 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	li $v0,0x00000000
	li $s2,0
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old frame pointer from current fra
	lw	$fp, ($sp)	# restore old frame pointer
	j	storecolor
loadyellow:	#Deze functie laad de kleur geel in $v0 en laadt de spelerrij n $s5 en de spelerkollom in $s6
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 8	# allocate 16 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sub $s6,$t0,1	#zet de x-positie van het geel vakje in $s6
	la $s7($t1)	#zet de y-positie van het geel vakje in $s7
	li $v0,0x00ffff00
	li $s2,0
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old frame pointer from current fra
	lw	$fp, ($sp)	# restore old frame pointer
	j	storecolor
	
loadgreen:	#Deze functie laad de kleur groen in $v0
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 8	# allocate 16 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	li $v0,0x0000ff00
	li $s2,0
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old frame pointer from current fra
	lw	$fp, ($sp)	# restore old frame pointer
	j	storecolor
	
loadwhite:	#Deze functie laad de kleur wit in $v0
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 8	# allocate 16 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	li $v0,0x00ffffff
	li $s2,0
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old frame pointer from current fra
	lw	$fp, ($sp)	# restore old frame pointer
	j	storecolor
	

getbitmaplocation: #Deze functie gaat de locatie van een pixel in de bitmap berekenen
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 44	# allocate 20 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sw 	$s0, -8($fp) 	#houdt alle argumenten van het vorige programma bij
	sw 	$t0, -12($fp)	
	sw 	$t1, -16($fp)
	sw 	$t2, -20($fp)   
	sw 	$t3, -24($fp)   
	sw	$s3, -28($fp)  
	sw	$s4, -32($fp)  
	sw	$s1, -36($fp)
	sw	$s2, -40($fp)

	la $t0,32	 #aantal verticale pixels
	la $t1,32	#aantal horizontale pixels
	mult $a1,$t1 #vermenigvuldig de 2 de input(y-coordinaat) met de $s3(aantal verticale piwels)
	mflo $s0
	add $s0,$s0,$a0 #voeg aan het vorig product $s0 bij(De x-waarde)
	li $t2,4
	mult $s0,$t2 #vermenigvuldig alles met 4 omdat er een pixel om de 4 bits is in de bitmap
	mflo $s0
	la $s1($gp) #neemt het hudiig addres en zet het in $s5 
	add $s1,$s1,$s0 #Voeg de uitkomst van de vorige berekeningen bij het huidig addres=nieuw addres
	la $v0($s1)
	
	lw	$ra, -4($fp)    # get return address from frame
	lw	$s0, -8($fp) 	# zet alle varibialen van de loop terug op hun plaats
	lw 	$t0, -12($fp)
	lw 	$t1, -16($fp)
	lw 	$t2, -20($fp) 
	lw 	$t3, -24($fp) 
	lw 	$s3, -28($fp)
	lw 	$s4, -32($fp)    
	lw 	$s1, -36($fp)
	lw 	$s2, -40($fp)    
	move	$sp, $fp        # get old frame pointer from current fra
	lw	$fp, ($sp)	# restore old frame pointer
	jr	$ra

updateposition:
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 28	# allocate 20 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sw 	$s0, -8($fp) 	#houdt alle argumenten van het vorige programma bij
	sw 	$s1, -12($fp)	
	sw	$s2, -16($fp)
	sw	$s3, -20($fp)
	sw	$s4, -24($fp)
	sub 	$s3,$a2,$a0	#trekt de x-coordinaten van elkaar af
	sub 	$s4,$a3,$a1	#trekt de y coordinaten van elkaar af
	la 	$t0($a0)	#slaagt alle coordinaten in een t register op
	la 	$t1($a1)	
	la	$t2($a2)
	la	$t3($a3)
	la	$a0($t2)	#haalt de bitmaplocatie van de tweede locatie
	la	$a1($t3)	
	jal 	getbitmaplocation	#bereken de locatie van de nieuwe coordinaat
	lw 	$s5($v0)	#laadt de kleur van de nieuwe locatie in $s5
	la	$s6($v0)	#slaat de nieuwe locatie ook op
	li 	$t4,0x000000ff	#het test of de kleur blauw is want dan moet het niet updaten
	beq 	$s5,$t4,dontupdate
	li	$t5,0x0000ff00	#het test of de kleur groen is want dan is het spel gedaan en moet het programma stoppen
	beq	$s5,$t5,wingame
	
	testnextto:	#Deze functie test of de neiuwe locatie naast de vorige ligt, hiervoor worden $s3 en $s4 gebruikt die hiervoor waren berekent
		testup:
		bne $s3,0,testright
		bne $s4 1,testdown
		jal update
		j goback
	
		testdown:
		bne $s3,0,testright
		bne $s4,-1, testright
		jal update
		j goback
	
		testright:
		bne $s3,-1,testleft
		bne $s4,0,dontupdate
		jal update
		j goback
		
		testleft:
		bne $s3,1 ,dontupdate
		bne $s4,0,dontupdate
		jal update
		j goback
	
	update:	#Deze functie update de kleur op de bitmap als deze verandert moet worden
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 8	# allocate 16 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	
	li	$t4,0x00ffff00	#zet de kleur geel in $t4
	sw	$t4($s6)	#sal geel op op de neiuwe locatie
	la	$v0($t2)	#haalt de nieuwe locatie en zet deze in de twee $v registers want dat moet deze functie teruggeven
	la	$v1($t3)
	la	$a0($t0)
	la	$a1($t1)
	la	$t7($v0)	#slaagt tijdelijk het $v0 register op want deze gaat aangepast worden in getbitmaplocaton
	jal 	getbitmaplocation
	li	$t4,0x00000000	#zet de kleur zwart in $t4
	sw	$t4($v0)	#zet zwart terug op de vorige positie
	la	$v0($t7)	#zet $v0 terug naar hetgeen het was voor het oproepen van de functei getbitmaploction
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old frame pointer from current fra
	lw	$fp, ($sp)	# restore old frame pointer
	jr	$ra
	dontupdate:	#Deze functie zet gewoon de oude locatie in de $v registers want de positie wordt niet geupdate
	la	$v0($t0)
	la	$v1($t1)
	j 	goback 
	goback: #Deze functie zet alle register terug op hetgeen het was voor het oproepen van de functie updatepositie en jumpt dan naar $ra
	lw	$ra, -4($fp)	# store the value of the return address
	lw 	$s0, -8($fp) 	#houdt alle argumenten van het vorige programma bij
	lw 	$s1, -12($fp)	
	lw	$s2, -16($fp)
	lw 	$s3, -20($fp)	
	lw	$s4, -24($fp)
	move	$sp, $fp        # get old frame pointer from current fra
	lw	$fp, ($sp)	# restore old frame pointer
	jr	$ra
	

gamemainloop:	#Dit is de hoofdloop die constan gaat checken of er inout is en zoja dan update hij die respectievelijk
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 20	# allocate 20 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sw 	$s0, -8($fp) 	#houdt alle argumenten van het vorige programma bij
	sw 	$s1, -12($fp)	
	sw	$s2, -16($fp)
	
	la	$s0($a0)	#haalt de hudiige positei ut $a0 en $a1 en zet deze in $s registers
	la	$s1($a1)
	j testinput		#gaat naar een functie die test of er input is
	sleep:			#deze functie zorgt er gewoon voor dat het programma voor 60 milliseconde sleept
	la	$s0($a0)
	la	$s1($a1)
	li	$a0,60
	li 	$v0,32
	syscall
	la	$a0($s0)
		
	testinput:
		li $t0,0xffff0000 #checkt eerst of er input is door te zie of hetgeen in 0xffff0000 zit gelijk is aan 1
		lw $t1,($t0)
		bne $t1,1,sleep #als er geen input is dan wacht het 60 ms en start het de loop opnieuw
		j readinput	#is er wel input dan leest hetd eze
		
		readinput:
		
		li $t2,0xffff0004 #laad de keyboard input in $t2
		lw $t3,($t2) #zet deze input in $t3
		beq $t3,122,testgoup #als $t3 ascii waarde 122 is dan is dit een z en moet het testen of de positie naar boven kan
		beq $t3,115,testgodown #als $t3 ascii waarde 115 is dan is dit een s en moet het testen of de positie naar beneden kan
		beq $t3,113,testgoleft #als $t3 ascii waarde 113 is dan is dit een q en moet het testen of de positie naar links kan
		beq $t3,100,testgoright #als $t3 ascii waarde 100 is dan is dit een d en moet het testen of de positie naar rechts kan
		beq $t3,120,endgameloop #als $t3 ascii waarde 120 is dan is dit een x en moet het programma stoppen
		j sleep #als het geen van de vorige is dan start het de loop opnieuw   #anders start het de loop opnieuw
		testgoposition:#De functe die onder deze functei staan geven telkens de juiste coordinaten mee om dan de functie updateposition op te roepen
			testgoup:	
			la	$a0($s0)
			la	$a1($s1)
			la	$a2($s0)
			sub	$a3,$s1,1
			jal 	updateposition
			la	$a0($v0)
			la	$a1($v1)
			j sleep
				
			testgodown:
			la	$a0($s0)
			la	$a1($s1)
			la	$a2($s0)
			add	$a3,$s1,1
			jal 	updateposition
			la	$a0($v0)
			la	$a1($v1)
			j sleep
			
			testgoleft:
			la	$a0($s0)
			la	$a1($s1)
			sub	$a2,$s0,1
			la	$a3($s1)
			jal 	updateposition
			la	$a0($v0)
			la	$a1($v1)
			j sleep
		
			testgoright:	
			la	$a0($s0)
			la	$a1($s1)
			add	$a2,$s0,1
			la	$a3($s1)
			jal 	updateposition
			la	$a0($v0)
			la	$a1($v1)
			j sleep
		
		endgameloop:	#Deze functie eindigt de gameloop
		lw	$ra, -4($fp)	# store the value of the return address
		lw 	$s0, -8($fp) 	#houdt alle argumenten van het vorige programma bij
		lw 	$s1, -12($fp)	
		lw 	$s2, -16($fp)
		move	$sp, $fp        # get old frame pointer from current fra
		lw	$fp, ($sp)	# restore old frame pointer
		jr	$ra
		
		wingame:	#Deze functie toont aan dat je uit het doolhof bent geraakt
		jal 	update
		la	$a0,win
		li	$a1,1
		li 	$v0,4
		syscall
		j endprogramm
	
	
endprogramm:	#Deze functie eindigt het programma
	li $v0,10
	syscall
	
