#Dit programma neem een file met text dat een doolhof voorstelt als input en zoekt automatisch een pad dat een oplossing is
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
	
	jal depthfirstsearch
	
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
	subu	$sp, $sp, 40	# allocate 20 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sw 	$s0, -8($fp) 	#houdt alle argumenten van het vorige programma bij
	sw 	$s1, -12($fp)	
	sw	$s2, -16($fp)
	sw	$s3, -20($fp)
	sw	$s4, -24($fp)
	sw	$s5, -28($fp)
	sw	$s6, -32($fp)
	sw	$s7, -36($fp)
	
	la	$t8($v0)	
	la	$t9($a0)
	li	$v0,32		#sleep voor 100 milliseconde
	la	$a0,100
	syscall
	la	$v0($t8)
	la	$a0($t9)
	
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
	jal update
	li	$t5,0x0000ff00	#het test of de kleur groen is want dan is het spel gedaan en moet het programma stoppen
	beq	$s5,$t5,endprogramm
	j goback
	
	update:	#Deze functie update de kleur op de bitmap als deze verandert moet worden
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 8	# allocate 16 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	
	li	$t4,0x00ffff00	#zet de kleur geel in $t4
	sw	$t4($s6)	#zet geel op op de neiuwe locatie
	la	$v0($t2)	#haalt de nieuwe locatie en zet deze in de twee $v registers want dat moet deze functie teruggeven
	la	$v1($t3)
	la	$a0($t0)
	la	$a1($t1)
	la	$t7($v0)	#slaagt tijdelijk het $v0 register op want deze gaat aangepast worden in getbitmaplocaton
	jal 	getbitmaplocation
	beq	$s7,1,placered
	placelightblue: 	#Deze functie plaats een lichtblauwvakje op de vorige positie
	li	$t4,0x00fffff
	sw	$t4($v0)	
	la	$v0($t7)	#zet $v0 terug naar hetgeen het was voor het oproepen van de functie getbitmaploction
	j returnbackafterplacement
	placered:		#Deze functie plaats een rood op de vorige positie
	li	$t4,0xff0000
	sw	$t4($v0)	
	la	$v0($t7)
	returnbackafterplacement: #Deze functie gaat terug naar de vorige programmcounter
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old frame pointer from current fra
	lw	$fp, ($sp)	# restore old frame pointer
	jr 	$ra
	goback: #Deze functie zet alle register terug op hetgeen het was voor het oproepen van de functie updatepositie en jumpt dan naar $ra
	lw	$ra, -4($fp)	# store the value of the return address
	lw 	$s0, -8($fp) 	#houdt alle argumenten van het vorige programma bij
	lw 	$s1, -12($fp)	
	lw	$s2, -16($fp)
	lw 	$s3, -20($fp)	
	lw	$s4, -24($fp)
	lw	$s5, -28($fp)
	lw 	$s6, -32($fp)	
	lw	$s7, -36($fp)
	move	$sp, $fp        # get old frame pointer from current fra
	lw	$fp, ($sp)	# restore old frame pointer
	jr	$ra
	

depthfirstsearch:	#Dit is de hoofdloop die constan gaat checken of er inout is en zoja dan update hij die respectievelijk
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 40	# allocate 20 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sw 	$s0, -8($fp) 	#houdt alle argumenten van het vorige programma bij  
	sw	$s1, -12($fp)  
	sw	$s2, -16($fp)  
	sw	$s3, -20($fp)
	sw	$s4, -24($fp)
	sw	$s5, -28($fp)  
	sw	$s6, -32($fp)  
	sw	$s7, -36($fp)
	
	li 	$s7,0
	la	$s0,($a0)	#zet de hudiige positie in $s0 en s$1 
	la	$s1,($a1)
	checkup:	#Test ofdat het nog naar boven kan
		addi	 $s2,$s1,1	#voegt 1 toe bij s1 en zet dit in s2 dit wordt de y coordinaat van de positiie die we willen testen
		la	$a0($s0)	
		la	$a1($s2)
		jal getbitmaplocation	#haalt de locatie van deze nieuwe positie
		lw 	$t0($v0)
		li	$t1,0x00000000	#test of dat het zwart of groen is 
		li	$t5,0x0000ff00
		beq	$t0,$t5,moveup
		bne	$t0,$t1,checkdown	#als ze dit niet zijn dan test het de volgende positie
		moveup:
		la $a0($s0)
		la $a1($s1)
		la $a2($s0)
		la $a3($s2)
		jal updateposition	#update de positie en laat een lightblauw vakje achter op de vorige positie
		la $a0($s0)
		la $a1($s2)

		jal depthfirstsearch	#roept recursief het depth first search algoritme op voor de nieuwe positie
		la $a0($s0)
		la $a1($s2)
		la $a2($s0)
		la $a3($s1)
		li $s7,1
		jal updateposition	#als deze lijnen coden worden uitgevoerd dan heeft het moeten backtrakcken en moet de positie teruggezet worden, Er wordt ook een rood vakje achtergelaten
		li $s7,0		
	checkdown:	#Deze functie doet identiek hetzelfde maar dan met de positie onder het huidige vakje
		subi	 $s2,$s1,1
		la $a0($s0)
		la $a1($s2)
		jal getbitmaplocation
		lw 	$t0($v0)
		li	$t1,0x00000000
		li	$t5,0x0000ff00
		beq	$t0,$t5,movedown
		bne	$t0,$t1,checkleft
		movedown:
		la $a0($s0)
		la $a1($s1)
		la $a2($s0)
		la $a3($s2)
		jal updateposition
		la $a0($s0)
		la $a1($s2)
		jal depthfirstsearch
		la $a0($s0)
		la $a1($s2)
		la $a2($s0)
		la $a3($s1)
		li $s7,1
		jal updateposition
		li $s7,0
	checkleft:	#Deze functie doet identiek hetzelfde maar dan met de positie links van het huidige vakje
		subi	 $s2,$s0,1
		la $a0($s2)
		la $a1($s1)
		jal getbitmaplocation
		lw 	$t0($v0)
		li	$t1,0x00000000
		li	$t5,0x0000ff00
		beq	$t0,$t5,moveleft
		bne	$t0,$t1,checkright
		moveleft:
		la $a0($s0)
		la $a1($s1)
		la $a2($s2)
		la $a3($s1)
		jal updateposition
		la $a0($s2)
		la $a1($s1)
		jal depthfirstsearch
		la $a0($s2)
		la $a1($s1)
		la $a2($s0)
		la $a3($s1)
		li $s7,1
		jal updateposition
		li $s7,0
	checkright: 	#Deze functie doet identiek hetzelfde maar dan met de positie rechts van het huidige vakje
		addi	 $s2,$s0,1
		la $a0($s2)
		la $a1($s1)
		jal getbitmaplocation
		lw 	$t0($v0)
		li	$t1,0x00000000
		li	$t5,0x0000ff00
		beq	$t0,$t5,moveright
		bne	$t0,$t1,popdepthfirststack
		moveright:
		la $a0($s0)
		la $a1($s1)
		la $a2($s2)
		la $a3($s1)
		jal updateposition
		la $a0($s2)
		la $a1($s1)
		jal depthfirstsearch
		la $a0($s2)
		la $a1($s1)
		la $a2($s0)
		la $a3($s1)
		li $s7,1
		jal updateposition
		li $s7,0
	popdepthfirststack:	#Deze functie gaat eigenlijk 1 recursieniveau terug
		lw	$ra, -4($fp)	# store the value of the return address
		lw 	$s0, -8($fp) 	#houdt alle argumenten van het vorige programma bij
		lw 	$s1, -12($fp)	
		lw	$s2, -16($fp)
		lw 	$s3, -20($fp)	
		lw	$s4, -24($fp)
		lw	$s5, -28($fp)
		lw 	$s6, -32($fp)	
		lw	$s7, -36($fp)
		move	$sp, $fp        # get old frame pointer from current fra
		lw	$fp, ($sp)	# restore old frame pointer
		jr	$ra
		
endprogramm:	#Deze functie eindigt het programma
	li $v0,10
	syscall
