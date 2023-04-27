


; COAL LAB PROJECT
; SUPER MARIO
; Compatible with masm615, Dosbox

;i190656 Mahnoor Fazal
;i190721 Sumen jamil
;i190745 Ibrahim Razzaque Bhatti
;section CS-D




.model small
.stack
.data
left dw 0
right dw 0
height dw 0
up dw 0 
down dw 0
color db 0
mariox word 0
marioy word 0
marioState word 0
marioJump word 0
collision word 0
win word 0
monster1x word 0
monster1y word 0
monster1state word 0
monster2x word 0
monster2y word 0
monster2state word 0
monster3x word 0
monster3y word 0
monster3state word 0
fireballx word 0
firebally word 0
fireballstate word 0
flagy word 0
screen word 0
msg1 db "LEVEL COMPLETED",'$'
msg2 db "LEVEL ONE",'$'
msg3 db "LEVEL TWO",'$'
msg4 db "LEVEL THREE",'$'
mmsg2 db "LEVEL 1",'$'
mmsg3 db "LEVEL 2",'$'
mmsg4 db "LEVEL 3",'$'
msg8 db "ENTER NAME",'$'
msg5 db "GAME OVER",'$'
msg6 db "CONGRATULATIONS. YOU WON!!!",'$'
msg7 db "ENTER YOUR NAME",'$'
startMsg1 db "PRESS ENTER TO PLAY",'$'
startMsg2 db "PRESS H FOR HELP",'$'
startMsg3 db "PRESS C FOR CREDITS",'$'
SuperMario db "SUPER MARIO - COAL PROJECT",'$'
instructions db "- HOW TO PLAY -",'$'
buffer db 360 dup ("$")
buffer2 db 230 dup ("$")
username db 30 dup("$")
level db 0
readFileIns db 'marioInstructions.txt',0
readFileCredits db 'cred.txt',0

.code

main proc
    mov ax,@data
    mov ds,ax

    mov ah,0
	mov al,13h
	int 10h

	call InstRead
	call readCreds

	mainLoop:

		cmp screen,0
		je screen0
		cmp screen,1
		je screen1
		cmp screen,2
		je screen2
		cmp screen,3
		je screen3
	
	jmp mainLoop
	
	screen0:
		call mainMenu
		jmp mainLoop
	
	screen1:
		call takeInput
		mov level,1
		call drawLevel1
		call level1
		mov level,2
		call drawLevel2
		call level2
		mov level,3
		call drawLevel3
		call level3
		call drawWin
		mov ah,4ch
		int 21h

	screen2:
		call howToplay
		jmp mainLoop
	
	screen3:
		call creditScreen
		jmp mainLoop

    mov ah,4ch
    int 21h
main endp


mainMenu proc 
	
	call drawStartScreen
	lMain:
		mov ah,11h
		int 16h
		jz lMain
		mov ah,10h
		int 16h

		cmp ah,1Ch  ;ENTER PRESSED
		je enterPressed
		cmp ah,23h 	;H key pressed
		je hpressed
		cmp ah,2Eh	;C key Pressed
		je cPressed
		cmp ah,1Bh
		je escPressed
		jmp lMain

	enterPressed:
		mov screen,1
		ret
	
	hpressed:
		mov screen,2
		ret

	cPressed:
		mov screen,3
		ret
	
	escPressed:
		mov ah,4ch
		int 21h
ret
mainMenu endp

howToplay proc
	
	call drawInstructionScreen
	lHtp:
		mov ah,11h
		int 16h
		jz lHtp
		mov ah,10h
		int 16h

		cmp ah,1Ch  ;ENTER PRESSED
		je enterPressed2
		cmp ah,30h 	;B key pressed
		je bpressed
		cmp ah,1Bh
		je escPressed2
		jmp lHtp

	enterPressed2:
		mov screen,1
		ret
	
	bpressed:
		mov screen,0
		ret

	escPressed2:
		mov ah,4ch
		int 21h


ret
howToplay endp

creditScreen proc
	call drawCredistsScreen

	Lcs:
		mov ah,11h
		int 16h
		jz lcs
		mov ah,10h
		int 16h
		
		cmp ah,30h 	;B Key Pressed
		je bpressed2
		cmp ah,1Bh
		je escPressed3
		jmp lcs

	bpressed2:
		mov screen,0
		ret
	
	escPressed3:
		mov ah,4ch
		int 21h


ret
creditScreen endp

level1 proc uses cx

	call drawScreen1
	mov mariox,10
	mov marioy,182
	mov flagy,0
	mov al,0ch
	int 21h

	
	mov cx,1000

	loopS1:	
		call drawmario
		call delay
		mov ah,11h
		int 16h
		jz noKeyS1
		;call delay
		mov ah,10h
		int 16h
		call delay
		call keyPressed
		call clearmario
		call moveMarioLevel1
		call checkWinCriteria
		cmp win,1
		je level1Completed
		noKeyS1:
			mov marioState,0
		call clearmario
		cmp marioJump,0
		je	loopS1
		cmp marioy,182
		jne gravitys1
		mov marioJump,0
		jmp loopS1
		gravitys1:
			;HURDLE 1
			cmp mariox,90
			jbe checkHurdle1
			jmp endHurle1

			checkHurdle1:
				cmp mariox,36
				jbe endHurle1 

				cmp marioy,146
				jbe endHurle1

				jmp loopS1

			endHurle1:
			cmp mariox,180
			jbe checkHurdle2
			jmp endHurle2

			checkHurdle2:
				cmp mariox,128
				jbe endHurle2

				cmp marioy,126
				jbe endHurle2

				jmp loopS1		
			endHurle2:
			cmp mariox,280
			jbe checkHurdle3
			jmp endHurle3

			checkHurdle3:
				cmp mariox,225
				jbe endHurle3

				cmp marioy,146
				jbe endHurle3
				
				jmp loopS1
			endHurle3:
			add marioy,1
		jmp loopS1
	;loop loopS1

	level1Completed:
		drop:
			call drawFlag
			cmp flagy,154
			ja endDrop
			call dropFlag
			call delay	
			call clearFlag
			jmp drop
		endDrop:
		call completeLevel
	
ret
level1 endp

level2 proc
	
	mov monster1x,90
	mov monster1y,183
	
	mov monster2x,225
	mov monster2y,183
	mov flagy,0
	call drawScreen2
		mov monster1state,0
	mov mariox,10
	mov marioy,182
	mov collision,0
	mov marioState,0
	mov marioJump,0
	mov win,0
	
	mov al,0ch
	int 21h

	loopS2:
		call drawmario
		call delay
		mov ah,11h
		int 16h
		jz noKeyS2
		call delay 
		mov ah,10h
		int 16h
		call keyPressed
		call clearmario
		call moveMarioLevel2

		call delay
		call checkWinCriteria
		cmp win,1
		je level2Completed
		noKeyS2:
			mov marioState,0
		call monsterStates
			call monsterstates2


		cmp monster1state,2
		je nokill1
		;call drawmonster1
		call moveM1
		call clearM1
		call drawmonster1
		
		nokill1:
		cmp monster2state,2
		je nokill2
		call moveM2	
		call clearM2
		call drawmonster2
		
		nokill2:
		call checkCollision
		call collision2
		



		cmp collision,0
		je	endCollision
			collisionTrue:
				call drawGameOver
				mov ah,04ch
				int 21h

			endCollision:
		call clearmario
		cmp marioJump,0
		je loopS2
		cmp marioy,182
		jne gravitys2
		mov marioJump,0
		jmp loopS2
		gravitys2:
			;HURDLE 1
			cmp mariox,90
			jbe checkHurdle11
			jmp endHurle11

			checkHurdle11:
				cmp mariox,36
				jbe endHurle11

				cmp marioy,146
				jbe endHurle11

				jmp loopS2
			
			endHurle11:
			cmp mariox,220
			jbe checkHurdle21
			jmp endHurle21

			checkHurdle21:
				cmp mariox, 167
				jbe endHurle21

				cmp marioy,146
				jbe endHurle21

				jmp loopS2
			
			endHurle21:

			;cmp marioy,182
			;je loopS2

			add marioy,1
		jmp loopS2

	level2Completed:
		drop2:
			call drawFlag
			cmp flagy,154
			ja endDrop2
			call dropFlag
			call delay
			call clearFlag
			jmp drop2
		endDrop2:
		call completeLevel
ret
level2 endp

level3 proc uses cx
	mov monster1x,90
	mov monster1y,183

	mov monster3x,60
	mov monster3y,50
	mov monster3state,1
	mov fireballx,240		
	mov firebally,170		

	call drawScreen3
	mov monster1state,1
	mov mariox,10
	mov marioy,182
		mov collision,0
	mov marioState,0
	mov marioJump,0
	mov win,0
	mov flagy,0
	mov al,0ch
	int 21h


	loopS3:
		call drawmario
		call delay
		mov ah,11h
		int 16h
		jz noKeyS3
		call delay 
		mov ah,10h
		int 16h
		call keyPressed
		call clearmario
		call moveMarioLevel3
		call delay
		call checkWinCriteria2
		cmp win,1
		je level3Completed
		noKeyS3:
			mov marioState,0
		
		call clearM3
		call moveM3
		call drawmonster3
		call clearmario

		cmp fireballstate,0
		je endfireballl
		
		fireballl:
			call clearFireball
			call drawFireball

		endfireballl:
			call movefireball
				call monsterStates
		cmp monster1state,2
		je nokill2

	
		call moveM12
		call clearM1
		call drawmonster1
		call clearmario
		
		
		nokill2:
		call checkCollision
		call firecollision

		cmp collision,0
		je	endCollision
			collisionTrue:
			call  drawgameover
			mov ah,4ch
			int 21h

			endCollision:
		call clearmario
		cmp marioJump,0
		je loopS3
		cmp marioy,182
		jne gravitys3
		mov marioJump,0
		jmp loopS3
	

		gravitys3:
			;HURDLE 1
			cmp mariox,90
			jbe checkHurdle12
			jmp endHurle12

			checkHurdle12:
				cmp mariox,36
				jbe endHurle12

				cmp marioy,146
				jbe endHurle12

				jmp loopS3
			
			endHurle12:
			add marioy,1

	jmp loopS3

	level3Completed:
		;drop3:
		;	call drawFlag
		;	cmp flagy,154
		;	ja endDrop3
		;	call dropFlag
		;	call delay
		;	call clearFlag
		;	jmp drop2
		;endDrop3:
	call completeLevel

ret
level3 endp

checkWinCriteria proc
	cmp mariox,288
	ja levelDone
	ret

	levelDone:
		mov win,1
ret
checkWinCriteria endp

checkWinCriteria2 proc
	cmp mariox,260
	ja levelDone
	ret

	levelDone:
		mov win,1
ret
checkWinCriteria2 endp

monsterStates2 proc uses ax bx

	mov ax,mariox
	mov bx,monster2x
	cmp monster2x,ax
	jbe killMonster2L
	jmp notkill2

	killMonster2L:
		mov ax,mariox

		cmp monster2x,ax
		jb killMonster2L2

		mov ax,marioy
		mov bx,monster2y
		add ax,10
		
		cmp monster2y,ax
		jb monster2killT



			killMonster2L2:
		mov ax,mariox

		cmp monster2x,ax
		jb notkill2

		mov ax,marioy
		mov bx,monster2y
		add ax,25
		sub bx,15
		cmp bx,ax
		jb monster2killT




	notkill2:
	ret

	monster2killT:
	call clearm2
		mov monster2x,0
		mov monster2y,0
		
		mov monster2state,2
		   call clearmario
        sub marioy,50

ret
monsterstates2 endp

monsterStates proc uses ax bx

	mov ax,mariox
	mov bx,monster1x
	cmp monster1x,ax
	jbe killMonsterL
	jmp notkill1

	killMonsterL:
		mov ax,mariox

		cmp monster1x,ax
		jb killMonsterL1

		mov ax,marioy
		mov bx,monster1y
		add ax,10
		sub bx,10
		cmp bx,ax
		jb monster1killT



			killMonsterL1:
		mov ax,mariox

		cmp monster1x,ax
		jb notkill1

		mov ax,marioy
		mov bx,monster1y
		add ax,25
		sub bx,15
		
		
		
		cmp bx,ax
		jb monster1killT




	notkill1:
	ret

	monster1killT:
	call clearm1
		mov monster1x,0
		mov monster1y,0
		
		mov monster1state,2
		call clearmario
        sub marioy,50


ret
monsterstates endp

checkCollision proc uses ax bx
	mov ax,mariox
	mov bx,monster1x
	add ax,20
	cmp monster1x,ax
	jbe checkMonsterL
	jmp notMonsterL

	checkMonsterL:
		mov ax,mariox
		add ax,20
		sub bx,20
		cmp monster1x,ax
		jb checkMonsterL2
		
		mov ax,marioy
		add ax,10
		cmp monster1y,ax
		jb collisionT
		

			checkMonsterL2:
		mov ax,mariox
		sub ax,25
		add bx,25
		cmp bx,ax
		jb notMonsterL
		
		mov ax,marioy
		add ax,10
		cmp monster1y,ax
		jb collisionT
		
	notMonsterL:
	ret

	collisionT:
		mov collision,1

ret
checkCollision endp

Collision2 proc uses ax bx
	mov ax,mariox

	mov bx,monster2x
	add ax,20
	cmp monster2x,ax
	jbe checkMonsterL2
	jmp notMonsterL2

	checkMonsterL2:
		mov ax,mariox
		add ax,20
		sub bx,20
		cmp monster1x,ax
		jb checkMonsterL2a
		
		mov ax,marioy
		add ax,10
		cmp monster1y,ax
		jb collisionT2
		

			checkMonsterL2a:
		mov ax,mariox
		sub ax,25
		add bx,25
		cmp bx,ax
		jb notMonsterL2
		
		mov ax,marioy
		add ax,10
		cmp monster2y,ax
		jb collisionT2
		
	notMonsterL2:
	ret

	collisionT2:
		mov collision,1

ret
Collision2 endp

firecollision proc uses ax bx

	mov ax,mariox

	mov bx,fireballx
	;add ax,20
	cmp fireballx,ax
	jbe checkfireball
	jmp notfireballL2

	checkfireball:
		mov ax,mariox
		;sub ax,40
		;sub bx,10
		cmp monster1x,ax
		je notfireballL2
		
		mov ax,marioy
		sub ax,35
		cmp firebally,ax
		je firecollisionT2
		
		
	notfireballL2:
	ret

	firecollisionT2:
		mov collision,1

ret
firecollision endp

completeLevel proc
	;BACKGROUND BLUE
        mov left,0
        mov right,320   
        mov down, 201
        mov up,0
        mov color,10h
        call drawRectangle

		mov dl, 12 ;col
		mov dh, 12;row
		mov bh,0
		mov ah,02h
		int 10h

		mov si,offset msg1 
		mov cx,15
		msg1L:
			mov al, [si]
			mov bl,04h
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
			call delay
			call delay
			call delay
		loop msg1L

		call delay
		call delay
		call delay
ret
completeLevel endp

takeInput proc
	mov left,0
	mov right,320   
	mov down, 201
	mov up,0
	mov color,10h
	call drawRectangle

	mov dl, 14;col
	mov dh, 5;row
	mov bh,0
	mov ah,02h
	int 10h

	mov si,offset msg8
	mov cx,10
	msg2L:
		mov al, [si]
		mov bl,1fh
		mov bh, 0
		mov ah, 0eh
		int 10h

		inc si
		call delay
		call delay
		call delay
	loop msg2L

	mov dl, 14;col
	mov dh, 9;row
	mov bh,0
	mov ah,02h
	int 10h

	
	
	mov dx,offset username
	mov ah,0ah
	int 21h

	call delay
	call delay


ret
takeInput endp

drawLevel1 proc
		mov left,0
        mov right,320   
        mov down, 201
        mov up,0
        mov color,10h
        call drawRectangle

		mov dl, 16;col
		mov dh, 12;row
		mov bh,0
		mov ah,02h
		int 10h

		mov si,offset msg2 
		mov cx,9
		msg2L:
			mov al, [si]
			mov bl,04h
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
			call delay
			call delay
			call delay
		loop msg2L

		call delay
		call delay
		call delay

ret
drawLevel1 endp

drawLevel2 proc
		mov left,0
        mov right,320   
        mov down, 201
        mov up,0
        mov color,10h
        call drawRectangle

		mov dl, 16;col
		mov dh, 12;row
		mov bh,0
		mov ah,02h
		int 10h

		mov si,offset msg3 
		mov cx,9
		msg3L:
			mov al, [si]
			mov bl,04h
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
			call delay
			call delay
			call delay
		loop msg3L

		call delay
		call delay
		call delay

ret
drawLevel2 endp

drawLevel3 proc
		mov left,0
        mov right,320   
        mov down, 201
        mov up,0
        mov color,10h
        call drawRectangle

		mov dl, 14;col
		mov dh, 12;row
		mov bh,0
		mov ah,02h
		int 10h

		mov si,offset msg4 
		mov cx,11
		msg4L:
			mov al, [si]
			mov bl,04h
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
			call delay
			call delay
			call delay
		loop msg4L

		call delay
		call delay
		call delay

ret
drawLevel3 endp

drawGameOver proc 

		mov left,0
        mov right,320   
        mov down, 201
        mov up,0
        mov color,10h
        call drawRectangle

		mov dl, 15;col
		mov dh, 7;row
		mov bh,0
		mov ah,02h
		int 10h

		mov si,offset msg5 
		mov cx,9
		msg5L:
			mov al, [si]
			mov bl,04h
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
			call delay
			call delay
			call delay
		loop msg5L
			call delay
			call delay
		
		mov cx,3
		
		blinking:
			push cx
			mov left,0
			mov right,320   
			mov down, 201
			mov up,0
			mov color,10h
			call drawRectangle

			call delay
			call delay
			call delay
			call delay
			call delay
			call delay
			call delay
			call delay
			call delay
			call delay

			mov dl, 15;col
			mov dh, 7;row
			mov bh,0
			mov ah,02h
			int 10h

			mov si,offset msg5 
			mov cx,9
			msg5L2:
				mov al, [si]
				mov bl,04h
				mov bh, 0
				mov ah, 0eh
				int 10h

				inc si
			loop msg5L2
			call delay
			call delay
			call delay
			call delay
			call delay
			call delay
			call delay
			call delay
			call delay
			call delay
			pop cx
		loop blinking
		call delay
		call delay

	mov dl, 15;col
	mov dh, 11;row
	mov bh,0
	mov ah,02h
	int 10h

	cmp level,2
	je level2c
	cmp level,3
	jmp level3c

	level1c:
		mov si,offset mmsg2	
		jmp endc
	
	level2c:
		mov si,offset mmsg3
		jmp endc
	
	level3c:
		mov si,offset mmsg4

	
	endc:
	mov cx,7
	msg6L:
		mov al, [si]
		mov bl,1fh
		mov bh, 0
		mov ah, 0eh
		int 10h

		inc si
	loop msg6L

	mov dl, 16;col
	mov dh, 14;row
	mov bh,0
	mov ah,02h
	int 10h

	mov si,offset username
	add si,2
	mov cx,15
	msg6L1:
		mov al, [si]
		cmp al,'$'
		je skip
		mov bl,1fh
		mov bh, 0
		mov ah, 0eh
		int 10h
		skip:
		inc si
	loop msg6L1
	emsg6l:

		


ret 
drawGameOver endp

drawWin proc
	mov left,0
	mov right,320   
	mov down, 201
	mov up,0
	mov color,10h
	call drawRectangle

	mov dl, 7;col
		mov dh, 5;row
		mov bh,0
		mov ah,02h
		int 10h

		mov si,offset msg6
		mov cx,27
		msg6L:
			mov al, [si]
			mov bl,04h
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
			call delay
			call delay
			call delay
		loop msg6L
			call delay
			call delay

		mov dl, 15;col
	mov dh, 11;row
	mov bh,0
	mov ah,02h
	int 10h

	cmp level,2
	je level2c
	cmp level,3
	jmp level3c

	level1c:
		mov si,offset mmsg2	
		jmp endc
	
	level2c:
		mov si,offset mmsg3
		jmp endc
	
	level3c:
		mov si,offset mmsg4

	
		endc:
		mov cx,7
		msg6Ls:
			mov al, [si]
			mov bl,1fh
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
		loop msg6Ls

		mov dl, 16;col
		mov dh, 14;row
		mov bh,0
		mov ah,02h
		int 10h

		mov si,offset username
		add si,2
		mov cx,10
		msg6L1:
			mov al, [si]
			cmp al,'$'
			je skip
			mov bl,1fh
			mov bh, 0
			mov ah, 0eh
			int 10h
			skip:
			inc si
		loop msg6L1
		emsg6l:


ret
drawWin endp

drawScreen1 proc uses cx dx
	

	call drawingBg
	call drawPole
	call drawFlag 
    call drawingHurdles1
	;call drawMoonAndStars

	mov dl, 1;col
	mov dh, 1;row
	mov bh,0
	mov ah,02h
	int 10h

	mov si,offset msg2
	mov cx,9
	msg6L:
		mov al, [si]
		mov bl,1fh
		mov bh, 0
		mov ah, 0eh
		int 10h

		inc si
	loop msg6L

	mov dl, 11;col
	mov dh, 1;row
	mov bh,0
	mov ah,02h
	int 10h

	mov si,offset username
	add si,2
	mov cx,15
	msg6L1:
		mov al, [si]
		cmp al,'$'
		je emsg6l
		mov bl,1fh
		mov bh, 0
		mov ah, 0eh
		int 10h

		inc si
	loop msg6L1
	emsg6l:

ret
drawScreen1 endp

drawScreen2 proc uses cx dx
    call drawingBg
	call drawPole
	call drawFlag 
    call drawingHurdles2
	;call drawMoonAndStars
	mov dl, 1;col
	mov dh, 1;row
	mov bh,0
	mov ah,02h
	int 10h

	mov si,offset msg3
	mov cx,9
	msg6L:
		mov al, [si]
		mov bl,1fh
		mov bh, 0
		mov ah, 0eh
		int 10h

		inc si
	loop msg6L

	mov dl, 11;col
	mov dh, 1;row
	mov bh,0
	mov ah,02h
	int 10h

	mov si,offset username
	add si,2
	mov cx,15
	msg6L1:
		mov al, [si]
		cmp al,'$'
		je emsg6l
		mov bl,1fh
		mov bh, 0
		mov ah, 0eh
		int 10h

		inc si
	loop msg6L1
	emsg6l:
ret
drawScreen2 endp

drawScreen3 proc
	call drawingBg
	;call drawFlag 
	call drawingHurdles3
	call drawKingdom
ret
drawScreen3 endp

moveM1 proc
	
		cmp monster1state,0
		je m1Right
		jmp m1Left

		m1Right:
			cmp monster1x,165
			ja m1Change

			add monster1x,1
			ret
		
		m1Change:
				cmp monster1state,0
				jne m1Change2
				
				mov monster1state,1
				ret
		m1Change2:
				mov monster1state,0
				ret
			
		m1Left:
			cmp monster1x,90
			jbe m1Change

			sub monster1x,1
			ret

moveM1 endp

moveM12 proc
	
		cmp monster1state,0
		je m12Right
		jmp m12Left

		m12Right:
			cmp monster1x,240
			ja m12Change

			add monster1x,1
			ret
		
		m12Change:
				cmp monster1state,0
				jne m12Change2
				
				mov monster1state,1
				ret
		m12Change2:
				mov monster1state,0
				ret
			
		m12Left:
			cmp monster1x,90
			jbe m12Change

			sub monster1x,1
			ret

moveM12 endp

moveM2 proc
	
		cmp monster2state,0
		je m2Right
		jmp m2Left

		m2Right:
			cmp monster2x,290
			ja m2Change

			add monster2x,1
			ret
		
		m2Change:
				cmp monster2state,0
				jne m2Change2
				
				mov monster2state,1
				ret
		m2Change2:
				mov monster2state,0
				ret
			
		m2Left:
			cmp monster2x,225
			jbe m2Change

			sub monster2x,1
			ret

moveM2 endp

moveM3 proc
	cmp monster3state,0
		je m3Right
		jmp m3Left

		m3Right:
			cmp monster3x,290
			ja m3Change

			add monster3x,1
			ret
		
		m3Change:
				cmp monster3state,0
				jne m3Change2
				
				mov monster3state,1
				ret
		m3Change2:
				mov monster3state,0
				ret
			
		m3Left:
			cmp monster3x,25
			jbe m3Change

			sub monster3x,1
			ret
ret
moveM3 endp

movefireball proc
	cmp fireballstate,1
	je isActive

	isntActive:
		mov ax,monster3x
		mov fireballx,ax
		mov ax,monster3y
		mov firebally,ax
		mov fireballstate,1
		ret

	isActive:
		;HURDLE 1	;38,85	;136	;KINGDOM 	;248 ,300	,106	
		cmp fireballx,85
		jbe saveHurdle1
		cmp fireballx,299
		jbe savekingdom

		saveHurdle1:
			cmp fireballx,38
			jbe endsave
			cmp firebally,135
			ja endMove
			jmp endsave

		savekingdom:
			cmp fireballx,248
			jbe endsave
			cmp firebally,106
			ja endMove
			jmp endsave

		endsave:
			cmp firebally,170
			ja endMove
			add firebally,1
		ret

	endMove:
		mov fireballstate,0
		call clearFireball

ret 
movefireball endp

keyPressed proc uses ax

	cmp ah,4dh
	je rightArrow
	cmp ah,4bh
	je leftArrow
	cmp ah,48h
	je upArrow
	cmp al,1Bh
	je escKey
	mov marioState,0
	ret

	rightArrow:
		mov marioState,1
		ret
	leftArrow:
		mov marioState,2
		ret
	upArrow:
		mov marioState,3
		mov marioJump,1
		ret
	escKey:
		mov ah,4ch 
		int 21h

ret
keyPressed endp

moveMarioLevel1 proc uses ax bx cx
	
		mov ax, mariox
		mov bx, marioy
		cmp	marioState, 0
		je level1State0
		cmp marioState,1
		je level1State1
		cmp marioState,2
		je level1State2
		cmp marioState,3
		je level1State3

	level1State0:			;MARIO IS STATIONARY
		ret

	level1State1:			;MARIOS MOVES RIGHT
		
		cmp mariox,26		;HURDLE 1
		jbe moveright1

		check1H1:
			cmp mariox,88
			jbe hurdle1
			jmp next1
		hurdle1:
			cmp marioy,147
			ja noright1


		next1:
		cmp mariox,120
		jbe moveright1

			cmp mariox,180
			jbe hurdle2
			jmp next2

		hurdle2:
			cmp marioy,127
			ja noright1

		next2:
		cmp mariox,215
		jbe moveright1
			cmp mariox,280
			jbe hurdle3
			jmp moveright1

		hurdle3:
			cmp marioy,147
			ja noright1

		moveright1:
		add mariox,7
		noright1:
		ret

	level1State2:			;MARIO MOVES LEFT
		cmp mariox,10
		jbe	noleft1
		cmp mariox,40
		jbe moveleft1
		cmp mariox,96
		jbe check1H1L
		cmp mariox,186
		jbe check1H2L
		cmp mariox,285
		jbe check1H3L
		jmp moveleft1

		check1H1L:
			cmp marioy,147
			ja noleft1
			jmp moveleft1
		
		check1H2L:
			cmp mariox,144
			jbe moveleft1
			cmp marioy,127
			ja noleft1
			jmp moveleft1

		check1H3L:
			cmp mariox,220
			jbe moveleft1
			cmp marioy,147
			ja noleft1


		moveleft1:
		sub mariox,7
		noleft1:
		ret

	level1State3: 			;MARIO JUMPS
		cmp marioy,182
		jb inair1
		jmp jump1

		inair1:
			cmp mariox,26	;Hurdle 1 LEFT
			jb skipJump1
			cmp mariox,88		;HURDLE 1 RIGHT
			ja inair2
			cmp marioy,145		;HURDLE HEIGHT
			ja jump1

		inair2:
			cmp mariox,128
			jb skipJump1
			cmp mariox,180
			ja inair3
			cmp marioy,125
			ja jump1
		
		inair3:
			cmp mariox,229
			jb skipJump1
			cmp mariox,280
			ja skipJump1
			cmp marioy,145
			ja jump1
			jmp skipJump1
			

		jump1:
		sub marioy,65
		skipJump1:
		ret

ret
moveMarioLevel1 endp

moveMarioLevel2 proc uses ax bx cx
	
	mov ax, mariox
	mov bx, marioy
	cmp marioState,0
	je level2State0
	cmp marioState,1
	je level2State1
	cmp marioState,2
	je level2State2
	cmp marioState,3
	je level2State3

	level2State0:
		ret
	
	level2State1:		;MARIO MOVES RIGHT
		cmp mariox,26
		jbe moveright2
		cmp mariox,88
		jbe hurdle11
		cmp mariox,162
		jbe moveright2
		cmp mariox,220
		jbe hurdle21
		jmp moveright2

		hurdle11:
			cmp marioy,147
			ja noright2
			jmp moveright2

		hurdle21:
			cmp marioy,147
			ja noright2
			jmp	moveright2

		next21:

			;cmp mariox 


		moveright2:
		add mariox,7
		noright2:
		ret
	level2State2:
		cmp mariox,10
		jbe noleft2
		cmp mariox,40
		jbe moveleft2
		cmp mariox,96
		jbe check2H1L
		cmp mariox,170
		jbe moveleft2
		cmp mariox,230
		jbe check2h2l

		check2H1L:
			cmp marioy,147
			ja noleft2
			jmp moveleft2
		
		check2h2l:
			cmp marioy,147
			ja noleft2
			jmp moveleft2

		moveleft2:
		sub mariox,7
		noleft2:
		ret

	level2State3:
		cmp marioy,182
		jb inair11
		jmp jump2

		inair11:
			cmp mariox,26
			jb skipJump2
			cmp mariox,88
			ja inair21
			cmp marioy,145
			ja jump2

		inair21:
			cmp mariox,162
			jb skipJump2
			cmp mariox,220
			ja jump2
			cmp marioy,145
			ja jump2

		


		jump2:
			sub marioy,65
		skipJump2:

		ret

ret  
moveMarioLevel2 endp 

moveMarioLevel3 proc uses ax bx cx
	cmp marioState,0
	je level3State0
	cmp marioState,1
	je level3State1
	cmp marioState,2
	je level3State2
	cmp marioState,3
	je level3State3

	level3State0:
		ret

	level3State1:
		cmp mariox,26
		jbe moveright3
		cmp mariox,88
		jbe hurdle12
		jmp moveright3

		hurdle12:
			cmp marioy,147
			ja noright3
			jmp moveright3


		moveright3:
			add mariox,7
		noright3:
		ret
	
	level3State2:
		cmp mariox,10
		jbe noleft3
		cmp mariox,40
		jbe moveleft3
		cmp mariox,96
		jbe check3h1l
		jmp moveleft3

		check3h1l:
			cmp marioy,147
			ja noleft3
			jmp moveleft3

		moveleft3:
			sub mariox,7		

		noleft3:
		ret

	level3State3:
		cmp marioy,182
		jb inair12
		jmp jump3

		inair12:
			cmp mariox,26
			jb skipJump3
			cmp mariox,88
			ja skipJump3
			cmp marioy,145
			ja jump3
			jmp skipJump3
		
		jump3:
			sub marioy,65
		skipJump3:
		ret

ret 
moveMarioLevel3 endp

drawingHurdles1 proc
    ;;;HURDLE 1
        ;DRAWING BASE
            ;OUTLINE
                mov left,59
                mov right,81   
                mov down, 183
                mov up,149
                mov color,10h
                call drawRectangle
            
            ;HURDLE
                mov left,60
                mov right,80   
                mov down, 183
                mov up,160
                mov color,32h
                call drawRectangle
            ;Color
                mov left,70
                mov right,75   
                mov down, 183
                mov up,160
                mov color,48h
                call drawRectangle
                

        ;DRAWING TOP
            ;OUTLINE
                mov left,54
                mov right,86
                mov down, 161
                mov up,149
                mov color,10h
                call drawRectangle

            ;HURDLE
                mov left,55
                mov right,85
                mov down, 160
                mov up,150
                mov color,32h
                call drawRectangle

    ;;;HURDLE 2
        ;DRAWING BASE
            ;OUTLINE
                mov left,149
                mov right,171
                mov down, 183
                mov up,141
                mov color,10h
                call drawRectangle
            
            ;HURDLE
                mov left,150
                mov right,170   
                mov down, 183
                mov up,140
                mov color,32h
                call drawRectangle
            ;Color
                mov left,160
                mov right,165   
                mov down, 183
                mov up,140
                mov color,48h
                call drawRectangle
            

        ;DRAWING TOP
            ;OUTLINE
                mov left,144
                mov right,176
                mov down, 141
                mov up,129
                mov color,10h
                call drawRectangle

            ;HURDLE
                mov left,145
                mov right,175
                mov down, 140
                mov up,130
                mov color,32h
                call drawRectangle
   
     ;;;HURDLE 3
        ;DRAWING BASE
            ;OUTLINE
                mov left,249
                mov right,271   
                mov down, 183
                mov up,149
                mov color,10h
                call drawRectangle
            
            ;HURDLE
                mov left,250
                mov right,270   
                mov down, 183
                mov up,160
                mov color,32h
                call drawRectangle
            ;Color
                mov left,260
                mov right,265   
                mov down, 183
                mov up,160
                mov color,48h
                call drawRectangle
                

        ;DRAWING TOP
            ;OUTLINE
                mov left,244
                mov right,276
                mov down, 161
                mov up,149
                mov color,10h
                call drawRectangle

            ;HURDLE
                mov left,245
                mov right,275
                mov down, 160
                mov up,150
                mov color,32h
                call drawRectangle


ret
drawingHurdles1 endp

drawingHurdles2 proc
    ;;;HURDLE 1
        ;DRAWING BASE
            ;OUTLINE
                mov left,59
                mov right,81   
                mov down, 183
                mov up,149
                mov color,10h
                call drawRectangle
            
            ;HURDLE
                mov left,60
                mov right,80   
                mov down, 183
                mov up,160
                mov color,32h
                call drawRectangle
            ;Color
                mov left,70
                mov right,75   
                mov down, 183
                mov up,160
                mov color,48h
                call drawRectangle
                

        ;DRAWING TOP
            ;OUTLINE
                mov left,54
                mov right,86
                mov down, 161
                mov up,149
                mov color,10h
                call drawRectangle

            ;HURDLE
                mov left,55
                mov right,85
                mov down, 160
                mov up,150
                mov color,32h
                call drawRectangle

    ;;;HURDLE 3
        ;DRAWING BASE
            ;OUTLINE
                mov left,189
                mov right,211   
                mov down, 183
                mov up,149
                mov color,10h
                call drawRectangle
            
            ;HURDLE
                mov left,190
                mov right,210   
                mov down, 183
                mov up,160
                mov color,32h
                call drawRectangle
            ;Color
                mov left,200
                mov right,205   
                mov down, 183
                mov up,160
                mov color,48h
                call drawRectangle
                

        ;DRAWING TOP
            ;OUTLINE
                mov left,184
                mov right,216
                mov down, 161
                mov up,149
                mov color,10h
                call drawRectangle

            ;HURDLE
                mov left,185
                mov right,215
                mov down, 160
                mov up,150
                mov color,32h
                call drawRectangle


ret
drawingHurdles2 endp

drawingHurdles3 proc
    ;;;HURDLE 1
        ;DRAWING BASE
            ;OUTLINE
                mov left,59
                mov right,81   
                mov down, 183
                mov up,149
                mov color,10h
                call drawRectangle
            
            ;HURDLE
                mov left,60
                mov right,80   
                mov down, 183
                mov up,160
                mov color,32h
                call drawRectangle
            ;Color
                mov left,70
                mov right,75   
                mov down, 183
                mov up,160
                mov color,48h
                call drawRectangle
                

        ;DRAWING TOP
            ;OUTLINE
                mov left,54
                mov right,86
                mov down, 161
                mov up,149
                mov color,10h
                call drawRectangle

            ;HURDLE
                mov left,55
                mov right,85
                mov down, 160
                mov up,150
                mov color,32h
                call drawRectangle

    ;;HURDLE 3
    ;;DRAWING BASE
    ;    ;OUTLINE
    ;        mov left,189
    ;        mov right,211   
    ;        mov down, 183
    ;        mov up,149
    ;        mov color,10h
    ;        call drawRectangle
    ;    
    ;    ;HURDLE
    ;        mov left,190
    ;        mov right,210   
    ;        mov down, 183
    ;        mov up,160
    ;        mov color,32h
    ;        call drawRectangle
    ;    ;Color
    ;        mov left,200
    ;        mov right,205   
    ;        mov down, 183
    ;        mov up,160
    ;        mov color,48h
    ;        call drawRectangle
    ;        

    ;;DRAWING TOP
    ;    ;OUTLINE
    ;        mov left,184
    ;        mov right,216
    ;        mov down, 161
    ;        mov up,149
    ;        mov color,10h
    ;        call drawRectangle

    ;    ;HURDLE
    ;        mov left,185
    ;        mov right,215
    ;        mov down, 160
    ;        mov up,150
    ;        mov color,32h
    ;        call drawRectangle


ret
drawingHurdles3 endp

drawingBg proc
	
    ;BACKGROUND BLUE
        mov left,0
        mov right,320   
        mov down, 201
        mov up,0
        mov color,67h
        call drawRectangle

    ;GROUND OUTLINE
        mov left,0
        mov right,321   
        mov down, 199
        mov up,184
        mov color,10h
        call drawRectangle

    ;GROUND
        mov left,1
        mov right,318   
        mov down, 198
        mov up,185
        mov color,06h
        call drawRectangle

    


    
    mov left,0
    mov right,320
    mov down, 191
    mov up,191
    mov color,10h
    call drawRectangle

    mov left,10
    mov right,10
    mov down, 191
    mov up,184
    mov color,10h
    call drawRectangle

    mov cx,15

    bricks:
        add left,10
        add right,10
        mov down, 198
        mov up,191
        call drawRectangle

        add left,10
        add right,10
        mov down,191
        mov up,184
        call drawRectangle

    loop bricks

ret
drawingBg endp

drawMoonAndStars proc
	    mov left,80
    mov right,95   
    mov down, 45
    mov up,30
    mov color,1Fh
    call drawRectangle

    mov left,150
    mov right,152   
    mov down, 50
    mov up,49
    mov color,1Fh
    call drawRectangle

    mov left,200
    mov right,201   
    mov down, 40
    mov up,39
    mov color,1Fh
    call drawRectangle

ret
drawMoonAndStars endp

drawKingdom proc 

    mov left,265
    mov right,318
    mov down, 182
    mov up,174
    mov color,19
    call drawRectangle


    mov left,265
    mov right,318
    mov down, 176
    mov up,169
    mov color,20
    call drawRectangle



    mov left,265
    mov right,318
    mov down, 168
    mov up,162
    mov color,22
    call drawRectangle






	;tower1
		mov left,267
		mov right,276
		mov down, 161
		mov up,148
		mov color,22
		call drawRectangle

		mov left,267
		mov right,276
		mov down, 161
		mov up,150
		mov color,21
		call drawRectangle


		mov left,267
		mov right,276
		mov down, 161
		mov up,153
		mov color,20
		call drawRectangle




		mov left,271
		mov right,273
		mov down, 155
		mov up,151
		mov color,43
		call drawRectangle


	;tower top
		mov left,265
		mov right,278
		mov down, 147
		mov up,146
		mov color,28h
		call drawRectangle

		mov left,266
		mov right,277
		mov down, 145
		mov up,144
		mov color,28h
		call drawRectangle


		mov left,267
		mov right,276
		mov down, 143
		mov up,142
		mov color,28h
		call drawRectangle

	mov left,268
		mov right,275
		mov down, 141
		mov up,140
		mov color,28h
		call drawRectangle

	mov left,269
		mov right,274
		mov down, 139
		mov up,138
		mov color,28h
		call drawRectangle

	mov left,270
		mov right,273
		mov down, 137
		mov up,136
		mov color,28h
		call drawRectangle

	mov left,271
		mov right,271
		mov down, 140
		mov up,130
		mov color,28h
		call drawRectangle












	;tower2
		mov left,287
		mov right,296
		mov down, 161
		mov up,145
		mov color,23
		call drawRectangle



		mov left,287
		mov right,296
		mov down, 161
		mov up,149
		mov color,22
		call drawRectangle

		mov left,287
		mov right,296
		mov down, 161
		mov up,152
		mov color,21
		call drawRectangle


		mov left,290
		mov right,293
		mov down, 154
		mov up,149
		mov color,43
		call drawRectangle


	;towertop2
		mov left,284
		mov right,299
		mov down, 145
		mov up,144
		mov color,28h
		call drawRectangle

		mov left,285
		mov right,298
		mov down, 143
		mov up,142
		mov color,28h
		call drawRectangle



		mov left,286
		mov right,297
		mov down, 141
		mov up,140
		mov color,28h
		call drawRectangle

		mov left,287
		mov right,296
		mov down, 139
		mov up,138
		mov color,28h
		call drawRectangle

		mov left,288
		mov right,295
		mov down, 137
		mov up,136
		mov color,28h
		call drawRectangle


		mov left,289
		mov right,294
		mov down, 135
		mov up,134
		mov color,28h
		call drawRectangle

		mov left,290
		mov right,293
		mov down, 133
		mov up,132
		mov color,28h
		call drawRectangle

		mov left,291
		mov right,292
		mov down, 131
		mov up,130
		mov color,28h
		call drawRectangle

		mov left,291
		mov right,291
		mov down, 130
		mov up,120
		mov color,28h
		call drawRectangle

	;3rd tower

		mov left,307
		mov right,315
		mov down, 161
		mov up,149
		mov color,22
		call drawRectangle

		mov left,307
		mov right,315
		mov down, 161
		mov up,150
		mov color,21
		call drawRectangle


		mov left,307
		mov right,315
		mov down, 161
		mov up,153
		mov color,20
		call drawRectangle


		mov left,310
		mov right,312
		mov down, 155
		mov up,151
		mov color,43
		call drawRectangle


	;tower top3
		mov left,305
		mov right,317
		mov down, 148
		mov up,147
		mov color,28h
		call drawRectangle


		mov left,306
		mov right,316
		mov down, 146
		mov up,145
		mov color,28h
		call drawRectangle



		mov left,307
		mov right,315
		mov down, 144
		mov up,143
		mov color,28h
		call drawRectangle


		mov left,308
		mov right,314
		mov down, 142
		mov up,141
		mov color,28h
		call drawRectangle

		mov left,309
		mov right,313
		mov down, 140
		mov up,139
		mov color,28h
		call drawRectangle

		mov left,310
		mov right,312
		mov down, 138
		mov up,137
		mov color,28h
		call drawRectangle

		mov left,311
		mov right,311
		mov down, 136
		mov up,132
		mov color,28h
		call drawRectangle








		mov left,265
		mov right,269 
		mov down, 162
		mov up,158
		mov color,24
		call drawRectangle






		mov left,275
		mov right,279 
		mov down, 162
		mov up,158
		mov color,24
		call drawRectangle



		mov left,285
		mov right,289
		mov down, 162
		mov up,158
		mov color,24
		call drawRectangle

		mov left,295
		mov right,299
		mov down, 162
		mov up,158
		mov color,24
		call drawRectangle


		mov left,305
		mov right,309
		mov down, 162
		mov up,158
		mov color,24
		call drawRectangle




		mov left,314
		mov right,318
		mov down, 161
		mov up,158
		mov color,24
		call drawRectangle


	;door

    mov left,288
    mov right,296
    mov down, 182
    mov up,173
    mov color,72h
    call drawRectangle

    mov left,289
    mov right,289
    mov down, 182
    mov up,173
    mov color,00h
    call drawRectangle

    mov left,291
    mov right,291
    mov down, 182
    mov up,173
    mov color,00h
    call drawRectangle


    mov left,293
    mov right,293
    mov down, 182
    mov up,173
    mov color,00h
    call drawRectangle

    mov left,295
    mov right,295
    mov down, 182
    mov up,173
    mov color,00h
    call drawRectangle

    mov left,264
    mov right,264
    mov down, 183
    mov up,158
    mov color,00h
    call drawRectangle

    mov left,266
    mov right,266
    mov down, 157
    mov up,148
    mov color,00h
    call drawRectangle

    mov left,264
    mov right,266
    mov down, 157
    mov up,157
    mov color,00h
    call drawRectangle

    mov left,319
    mov right,319
    mov down, 183
    mov up,158
    mov color,00h
    call drawRectangle

    mov left,316
    mov right,319
    mov down, 157
    mov up,157
    mov color,00h
    call drawRectangle

    mov left,316
    mov right,316
    mov down, 157
    mov up,149
    mov color,00h
    call drawRectangle







ret 
drawKingdom endp

drawPole proc 
	;;DRAW OUTLINE
    mov left,314
    mov right,318   
    mov down, 184
    mov up,3
    mov color,10h
    call drawRectangle

   ;;DRAW POLE
    mov left,315
    mov right,317   
    mov down, 183
    mov up,3
    mov color,1Fh
    call drawRectangle

drawPole endp

drawFlag proc uses ax
	mov ax,flagy

    ;;DRAW OUTLINE
    mov left,293
    mov right,319
    mov height,28
	add ax,4
    mov down,ax
	mov ax,flagy
	add ax,2
    mov up,ax
    gap=1
    mov color,10h
    call drawTriangle

	
    ;;DRAW FLAG
    mov left,295
    mov right,318
    mov height,25
	mov ax,flagy
	add ax,4
    mov down,ax
	mov ax,flagy
	add ax,3
    mov up,ax
    gap=1
    mov color,28h
    call drawTriangle

	call drawFlagM

ret
drawFlag endp

dropFlag proc

	add flagy,5
ret
dropFlag endp

drawStartScreen proc uses ax bx cx
	;BACKGROUND BLUE
        mov left,0
        mov right,320   
        mov down, 200
        mov up,0
        mov color,10h;37h
        call drawRectangle
	
	call drawMarioLogo


	;;PRESS ENTER TO GO
			mov dl, 10;col
			mov dh, 17;row
			mov bh,0
			mov ah,02h
			int 10h

		mov si,offset startMsg1
		mov cx,19
		strt1:
			mov al, [si]
			mov bl,1fh
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
		loop strt1

		mov dl, 12;col
			mov dh, 20;row
			mov bh,0
			mov ah,02h
			int 10h

		mov si,offset startMsg2
		mov cx,16
		strt2:
			mov al, [si]
			mov bl,1fh
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
		loop strt2

			
			mov dl, 10;col
			mov dh, 23;row
			mov bh,0
			mov ah,02h
			int 10h

		mov si,offset startMsg3
		mov cx,19
		strt3:
			mov al, [si]
			mov bl,1fh
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
		loop strt3



ret
drawStartScreen endp

drawInstructionScreen proc uses ax bx cx

		mov left,0
        mov right,320   
        mov down, 201
        mov up,0
        mov color,10h
        call drawRectangle

		mov dl, 6;col
		mov dh, 1;row
		mov bh,0
		mov ah,02h
		int 10h

		mov si,offset SuperMario
		mov cx,26
		loopSuper:
			mov al, [si]
			mov bl,1fh
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
		loop loopSuper

		
		mov dl, 11;col
		mov dh, 4;row
		mov bh,0
		mov ah,02h
		int 10h

		mov si,offset instructions
		mov cx,15
		loopIns:
			mov al, [si]
			mov bl,1fh
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
		loop loopIns



		mov dl, 1;col
		mov dh, 9;row
		mov bh,0
		mov ah,02h
		int 10h

		mov si,offset buffer
		mov cx,360
		loopBuffer:
			mov al, [si]
			cmp al,'$'
			je endLoopB
			mov bl,1fh
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
		loop loopBuffer
		endLoopB:
		mov dl, 0;col
		mov dh, 23;row
		mov bh,0
		mov ah,02h
		int 10h

ret
drawInstructionScreen endp

drawCredistsScreen proc uses ax bx cx
		

		mov left,0
        mov right,320   
        mov down, 201
        mov up,0
        mov color,10h
        call drawRectangle


		mov dl, 7;col
		mov dh, 1;row
		mov bh,0
		mov ah,02h
		int 10h

		mov si,offset SuperMario
		mov cx,26
		loopSuper2:
			mov al, [si]
			mov bl,1fh
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
		loop loopSuper2


		mov dl, 12;col
		mov dh, 7;row
		mov bh,0
		mov ah,02h
		int 10h

		mov si,offset buffer2
		mov cx,230
		loopCre:
			mov al, [si]
			cmp al,'$'
			je endloopc
			mov bl,1fh
			mov bh, 0
			mov ah, 0eh
			int 10h

			inc si
		loop loopCre
	endLoopc:

ret
drawCredistsScreen endp

InstRead proc uses ax bx cx dx
	mov dx, offset readFileIns
	mov al, 0
	mov ah, 3dh
	int 21h

	mov bx, ax

	mov dx, offset buffer
	mov ah, 3fh
	mov cx, 360
	int 21h

	;mov dx, offset buffer
	;mov ah, 09h
	;int 21h

	mov ah, 3eh
	int 21h

ret
InstRead endp

readCreds proc uses	ax bx cx dx

	mov dx, offset readFileCredits
	mov al, 0
	mov ah, 3dh
	int 21h

	mov bx, ax

	mov dx, offset buffer2
	mov ah, 3fh
	mov cx, 230
	int 21h

	mov ah, 3eh
	int 21h

ret
readCreds endp

clearM1 proc uses cx
	mov cx,monster1x
	mov left,cx
	sub left,5
	mov right,cx
	add right, 21
	mov cx,monster1y  
	mov down, cx
	sub down,0
	mov up,cx
	sub up,19
	mov color,67h
	call drawRectangle

	mov cx,monster1x
	mov left,cx
	sub left,2
	mov right,cx
	add right, 17
	mov cx,monster1y  
	mov down, cx
	sub down,19
	mov up,cx
	sub up,24
	mov color,67h
	call drawRectangle

ret
clearM1 endp

clearM2 proc uses cx
	mov cx,monster2x
	mov left,cx
	sub left,5
	mov right,cx
	add right, 21
	mov cx,monster2y  
	mov down, cx
	sub down,0
	mov up,cx
	sub up,19
	mov color,67h
	call drawRectangle

	mov cx,monster2x
	mov left,cx
	sub left,2
	mov right,cx
	add right, 17
	mov cx,monster2y  
	mov down, cx
	sub down,19
	mov up,cx
	sub up,24
	mov color,67h
	call drawRectangle

ret
clearM2 endp

clearM3 proc uses cx
	mov cx,monster3x
	mov left,cx
	sub left,8
	mov right,cx
	add right, 15
	mov cx,monster3y  
	mov down, cx
	add down,2
	mov up,cx
	sub up,10
	mov color,67h
	call drawRectangle

	mov cx,monster3x
	mov left,cx
	sub left,17
	mov right,cx
	add right, 14
	mov cx,monster3y  
	mov down, cx
	sub down,8
	mov up,cx
	sub up,20
	mov color,67h
	call drawRectangle

	mov cx,monster3x
	mov left,cx
	sub left,23
	mov right,cx
	add right, 	14
	mov cx,monster3y  
	mov down, cx
	sub down,20
	mov up,cx	
	sub up,42	
	mov color,67h
	call drawRectangle

ret
clearM3 endp

clearmario proc uses cx
	mov cx,mariox
	mov left,cx
	sub left,6
	mov right,cx
	add right, 18
	mov cx,marioy
	mov down, cx
	add down,1
	mov up,cx
	sub up,29
	mov color,67h
	call drawRectangle

ret
clearmario endp

clearFlag proc uses cx
	
	mov left,292
	mov right, 319
	mov cx,flagy
	mov down, cx
	add down,33
	mov up,cx
	sub up,3
	mov color,67h
	call drawRectangle

	;;DRAW OUTLINE
    mov left,314
    mov right,318
	mov cx,flagy
	mov down,cx   
    add down, 33
    mov up,cx
	sub up,3
    mov color,10h
    call drawRectangle

   ;;DRAW POLE
    mov left,315
    mov right,317   
	mov cx,flagy
    mov down, cx
	add down,33
    mov up,cx
	sub up,3
    mov color,1Fh
    call drawRectangle

ret
clearFlag endp

clearFireball proc uses cx
	mov cx,fireballx
	mov left,cx
	add left,2
	mov right,cx          
	add right,14  
	mov cx,firebally  
	mov down, cx
	add down,11
	mov up,cx
	add up,1
	mov color,67h
	call drawRectangle
ret 
clearFireball endp

drawTriangle proc uses cx

    mov cx,height

    triangle:
        mov dx,left
        cmp dx,right
        ja exitTriangle
        call drawRectangle
        add down,gap
        add up,gap
        add left,gap
    loop triangle
    exitTriangle:
    
ret
drawTriangle endp

drawTriangle2 proc uses cx

    mov cx,height
	mov ax,left
	mov bx,right
	mov left,bx
    triangle2:
		cmp left,ax
		je exitTriangle2
		push ax
		push bx
        call drawRectangle
		sub left,gap
        add down,gap
        add up,gap
		pop ax
		pop bx
    loop triangle2
    exitTriangle2:
ret
drawTriangle2 endp

drawRectangle proc uses cx dx  
	mov cx,down
	l1:
		mov dx,cx
		push cx
		mov cx,right
		loop2:
			mov ah,0ch
			mov AL, color
			int 10h
			cmp cx,left
			je exit
		loop loop2
		exit:
		pop cx
		cmp cx,up
		je exit2
		sub dx,1
	loop l1
	exit2:
ret 
drawRectangle endp

drawmonster1 proc

	;MID BODY	
		mov cx,monster1x
		mov left,cx
		;add left
		mov right,cx
		add right, 15
		mov cx,monster1y  
		mov down, cx
		sub down,2
		mov up,cx
		sub up,8
		mov color,42h
		call drawRectangle

	;LEFT FOOT
		;BOTTOM
			mov cx,monster1x
			mov left,cx
			sub left,2
			mov right,cx
			add right,6 
			mov cx,monster1y  
			mov down, cx
			mov up,cx
			sub up,1
			mov color,00h
			call drawRectangle

			mov cx,monster1x
			mov left,cx
			sub left,3
			mov right,cx
			add right,6 
			mov cx,monster1y  
			mov down, cx
			sub down,1
			mov up,cx
			sub up,2
			mov color,00h
			call drawRectangle

			mov cx,monster1x
			mov left,cx
			sub left,3
			mov right,cx
			add right,5 
			mov cx,monster1y  
			mov down, cx
			sub down,2
			mov up,cx
			sub up,3
			mov color,00h
			call drawRectangle

		;TOP	
			mov cx,monster1x
			mov left,cx
			sub left,2
			mov right,cx
			add right,3 
			mov cx,monster1y  
			mov down, cx
			sub down,3
			mov up,cx
			sub up,4
			mov color,00h
			call drawRectangle
		
	;RIGHT FOOT
		;BOTTOM
			mov cx,monster1x
			mov left,cx
			add left,10
			mov right,cx
			add right,15 
			mov cx,monster1y  
			mov down, cx
			mov up,cx
			sub up,1
			mov color,00h
			call drawRectangle

			mov cx,monster1x
			mov left,cx
			add left,11
			mov right,cx
			add right,15 
			mov cx,monster1y  
			mov down, cx
			sub down,1
			mov up,cx
			sub up,2
			mov color,00h
			call drawRectangle

			mov cx,monster1x
			mov left,cx
			add left,12
			mov right,cx
			add right,16
			mov cx,monster1y  
			mov down, cx
			sub down,2
			mov up,cx
			sub up,3
			mov color,00h
			call drawRectangle

	;HEAD
		;BOTTOM
			mov cx,monster1x
			mov left,cx
			sub left,3
			mov right,cx
			add right, 4
			mov cx,monster1y  
			mov down, cx
			sub down,8
			mov up,cx
			sub up,16
			mov color,06h
			call drawRectangle

			mov cx,monster1x
			mov left,cx
			add left,12
			mov right,cx
			add right, 19
			mov cx,monster1y  
			mov down, cx
			sub down,8
			mov up,cx
			sub up,16
			mov color,06h
			call drawRectangle

			mov cx,monster1x
			mov left,cx
			sub left,4
			mov right,cx
			add right, 20
			mov cx,monster1y  
			mov down, cx
			sub down,9
			mov up,cx
			sub up,14
			mov color,06h
			call drawRectangle

			mov cx,monster1x
			mov left,cx
			sub left,2
			mov right,cx
			add right, 18
			mov cx,monster1y  
			mov down, cx
			sub down,15
			mov up,cx
			sub up,17
			mov color,06h
			call drawRectangle

			mov cx,monster1x
			mov left,cx
			sub left,1
			mov right,cx
			add right, 17
			mov cx,monster1y  
			mov down, cx
			sub down,17
			mov up,cx
			sub up,18
			mov color,06h
			call drawRectangle

			mov cx,monster1x
			mov left,cx
			;sub left,1
			mov right,cx
			add right, 16
			mov cx,monster1y  
			mov down, cx
			sub down,18
			mov up,cx
			sub up,19
			mov color,06h
			call drawRectangle

			mov cx,monster1x
			mov left,cx
			ADD left,1
			mov right,cx
			add right, 15
			mov cx,monster1y  
			mov down, cx
			sub down,19
			mov up,cx
			sub up,20
			mov color,06h
			call drawRectangle

			mov cx,monster1x
			mov left,cx
			ADD left,2
			mov right,cx
			add right, 14
			mov cx,monster1y  
			mov down, cx
			sub down,20
			mov up,cx
			sub up,21
			mov color,06h
			call drawRectangle

			mov cx,monster1x
			mov left,cx
			ADD left,3
			mov right,cx
			add right, 13
			mov cx,monster1y  
			mov down, cx
			sub down,21
			mov up,cx
			sub up,22
			mov color,06h
			call drawRectangle
		;TOP
			mov cx,monster1x
			mov left,cx
			ADD left,5
			mov right,cx
			add right, 11
			mov cx,monster1y  
			mov down, cx
			sub down,22
			mov up,cx
			sub up,23
			mov color,06h
			call drawRectangle
		
	;EYES
		;LEFT
			;WHITE BOTTOM
				mov cx,monster1x
				mov left,cx
				ADD left,3
				mov right,cx
				add right, 6
				mov cx,monster1y  
				mov down, cx
				sub down,10
				mov up,cx
				sub up,14
				mov color,1Fh
				call drawRectangle

			;WHITE TOP
				mov cx,monster1x
				mov left,cx
				ADD left,3
				mov right,cx
				add right, 5
				mov cx,monster1y  
				mov down, cx
				sub down,14
				mov up,cx
				sub up,16
				mov color,1Fh
				call drawRectangle

			;BLACK CENTER
				mov cx,monster1x
				mov left,cx
				ADD left,4
				mov right,cx
				add right, 5
				mov cx,monster1y  
				mov down, cx
				sub down,12
				mov up,cx
				sub up,16
				mov color,10h
				call drawRectangle

			;EYEBROW
				mov cx,monster1x
				mov left,cx
				;ADD left,1
				mov right,cx
				add right, 3
				mov cx,monster1y  
				mov down, cx
				sub down,16
				mov up,cx
				sub up,17
				mov color,10h
				call drawRectangle
			
		;PARTITION
			mov cx,monster1x
			mov left,cx
			ADD left,5
			mov right,cx
			add right, 11
			mov cx,monster1y  
			mov down, cx
			sub down,14
			mov up,cx
			sub up,15
			mov color,10h
			call drawRectangle

		;RIGHT
			;WHITE BOTTOM
				mov cx,monster1x
				mov left,cx
				ADD left,10
				mov right,cx
				add right, 13
				mov cx,monster1y  
				mov down, cx
				sub down,10
				mov up,cx
				sub up,13
				mov color,1Fh
				call drawRectangle

			;WHITE TOP
				mov cx,monster1x
				mov left,cx
				ADD left,12
				mov right,cx
				add right, 13
				mov cx,monster1y  
				mov down, cx
				sub down,13
				mov up,cx
				sub up,16
				mov color,1Fh
				call drawRectangle

			;BLACK CENTER
				mov cx,monster1x
				mov left,cx
				ADD left,11
				mov right,cx
				add right, 12
				mov cx,monster1y  
				mov down, cx
				sub down,12
				mov up,cx
				sub up,16
				mov color,10h
				call drawRectangle

			;EYEBROW
				mov cx,monster1x
				mov left,cx
				ADD left,13
				mov right,cx
				add right, 16
				mov cx,monster1y  
				mov down, cx
				sub down,16
				mov up,cx
				sub up,17
				mov color,10h
				call drawRectangle



ret
drawmonster1 endp
	
drawmonster2 proc

	;MID BODY	
		mov cx,monster2x
		mov left,cx
		;add left
		mov right,cx
		add right, 15
		mov cx,monster2y  
		mov down, cx
		sub down,2
		mov up,cx
		sub up,8
		mov color,42h
		call drawRectangle

	;LEFT FOOT
		;BOTTOM
			mov cx,monster2x
			mov left,cx
			sub left,2
			mov right,cx
			add right,6 
			mov cx,monster2y  
			mov down, cx
			mov up,cx
			sub up,1
			mov color,00h
			call drawRectangle

			mov cx,monster2x
			mov left,cx
			sub left,3
			mov right,cx
			add right,6 
			mov cx,monster2y  
			mov down, cx
			sub down,1
			mov up,cx
			sub up,2
			mov color,00h
			call drawRectangle

			mov cx,monster2x
			mov left,cx
			sub left,3
			mov right,cx
			add right,5 
			mov cx,monster2y  
			mov down, cx
			sub down,2
			mov up,cx
			sub up,3
			mov color,00h
			call drawRectangle

		;TOP	
			mov cx,monster2x
			mov left,cx
			sub left,2
			mov right,cx
			add right,3 
			mov cx,monster2y  
			mov down, cx
			sub down,3
			mov up,cx
			sub up,4
			mov color,00h
			call drawRectangle
		
	;RIGHT FOOT
		;BOTTOM
			mov cx,monster2x
			mov left,cx
			add left,10
			mov right,cx
			add right,15 
			mov cx,monster2y  
			mov down, cx
			mov up,cx
			sub up,1
			mov color,00h
			call drawRectangle

			mov cx,monster2x
			mov left,cx
			add left,11
			mov right,cx
			add right,15 
			mov cx,monster2y  
			mov down, cx
			sub down,1
			mov up,cx
			sub up,2
			mov color,00h
			call drawRectangle

			mov cx,monster2x
			mov left,cx
			add left,12
			mov right,cx
			add right,16
			mov cx,monster2y  
			mov down, cx
			sub down,2
			mov up,cx
			sub up,3
			mov color,00h
			call drawRectangle

	;HEAD
		;BOTTOM
			mov cx,monster2x
			mov left,cx
			sub left,3
			mov right,cx
			add right, 4
			mov cx,monster2y  
			mov down, cx
			sub down,8
			mov up,cx
			sub up,16
			mov color,06h
			call drawRectangle

			mov cx,monster2x
			mov left,cx
			add left,12
			mov right,cx
			add right, 19
			mov cx,monster2y  
			mov down, cx
			sub down,8
			mov up,cx
			sub up,16
			mov color,06h
			call drawRectangle

			mov cx,monster2x
			mov left,cx
			sub left,4
			mov right,cx
			add right, 20
			mov cx,monster2y  
			mov down, cx
			sub down,9
			mov up,cx
			sub up,14
			mov color,06h
			call drawRectangle

			mov cx,monster2x
			mov left,cx
			sub left,2
			mov right,cx
			add right, 18
			mov cx,monster2y  
			mov down, cx
			sub down,15
			mov up,cx
			sub up,17
			mov color,06h
			call drawRectangle

			mov cx,monster2x
			mov left,cx
			sub left,1
			mov right,cx
			add right, 17
			mov cx,monster2y  
			mov down, cx
			sub down,17
			mov up,cx
			sub up,18
			mov color,06h
			call drawRectangle

			mov cx,monster2x
			mov left,cx
			;sub left,1
			mov right,cx
			add right, 16
			mov cx,monster2y  
			mov down, cx
			sub down,18
			mov up,cx
			sub up,19
			mov color,06h
			call drawRectangle

			mov cx,monster2x
			mov left,cx
			ADD left,1
			mov right,cx
			add right, 15
			mov cx,monster2y  
			mov down, cx
			sub down,19
			mov up,cx
			sub up,20
			mov color,06h
			call drawRectangle

			mov cx,monster2x
			mov left,cx
			ADD left,2
			mov right,cx
			add right, 14
			mov cx,monster2y  
			mov down, cx
			sub down,20
			mov up,cx
			sub up,21
			mov color,06h
			call drawRectangle

			mov cx,monster2x
			mov left,cx
			ADD left,3
			mov right,cx
			add right, 13
			mov cx,monster2y  
			mov down, cx
			sub down,21
			mov up,cx
			sub up,22
			mov color,06h
			call drawRectangle
		;TOP
			mov cx,monster2x
			mov left,cx
			ADD left,5
			mov right,cx
			add right, 11
			mov cx,monster2y  
			mov down, cx
			sub down,22
			mov up,cx
			sub up,23
			mov color,06h
			call drawRectangle
		
	;EYES
		;LEFT
			;WHITE BOTTOM
				mov cx,monster2x
				mov left,cx
				ADD left,3
				mov right,cx
				add right, 6
				mov cx,monster2y  
				mov down, cx
				sub down,10
				mov up,cx
				sub up,14
				mov color,1Fh
				call drawRectangle

			;WHITE TOP
				mov cx,monster2x
				mov left,cx
				ADD left,3
				mov right,cx
				add right, 5
				mov cx,monster2y  
				mov down, cx
				sub down,14
				mov up,cx
				sub up,16
				mov color,1Fh
				call drawRectangle

			;BLACK CENTER
				mov cx,monster2x
				mov left,cx
				ADD left,4
				mov right,cx
				add right, 5
				mov cx,monster2y  
				mov down, cx
				sub down,12
				mov up,cx
				sub up,16
				mov color,10h
				call drawRectangle

			;EYEBROW
				mov cx,monster2x
				mov left,cx
				;ADD left,1
				mov right,cx
				add right, 3
				mov cx,monster2y  
				mov down, cx
				sub down,16
				mov up,cx
				sub up,17
				mov color,10h
				call drawRectangle
			
		;PARTITION
			mov cx,monster2x
			mov left,cx
			ADD left,5
			mov right,cx
			add right, 11
			mov cx,monster2y  
			mov down, cx
			sub down,14
			mov up,cx
			sub up,15
			mov color,10h
			call drawRectangle

		;RIGHT
			;WHITE BOTTOM
				mov cx,monster2x
				mov left,cx
				ADD left,10
				mov right,cx
				add right, 13
				mov cx,monster2y  
				mov down, cx
				sub down,10
				mov up,cx
				sub up,13
				mov color,1Fh
				call drawRectangle

			;WHITE TOP
				mov cx,monster2x
				mov left,cx
				ADD left,12
				mov right,cx
				add right, 13
				mov cx,monster2y  
				mov down, cx
				sub down,13
				mov up,cx
				sub up,16
				mov color,1Fh
				call drawRectangle

			;BLACK CENTER
				mov cx,monster2x
				mov left,cx
				ADD left,11
				mov right,cx
				add right, 12
				mov cx,monster2y  
				mov down, cx
				sub down,12
				mov up,cx
				sub up,16
				mov color,10h
				call drawRectangle

			;EYEBROW
				mov cx,monster2x
				mov left,cx
				ADD left,13
				mov right,cx
				add right, 16
				mov cx,monster2y  
				mov down, cx
				sub down,16
				mov up,cx
				sub up,17
				mov color,10h
				call drawRectangle



ret
drawmonster2 endp

drawmonster3 proc
	
	;BOWSER FEET BASE
		mov cx,monster3x
		mov left,cx
		;add left
		mov right,cx
		add right, 11
		mov cx,monster3y  
		mov down, cx
		sub down,0
		mov up,cx
		sub up,3
		mov color,42h
		call drawRectangle
	
		mov cx,monster3x
		mov left,cx
		sub left,3
		mov right,cx
		add right, 11
		mov cx,monster3y  
		mov down, cx
		sub down,3
		mov up,cx
		sub up,6
		mov color,42h
		call drawRectangle

		
	
	;BOWSER FEET BASE EXTENDED
		mov cx,monster3x
		mov left,cx
		;add left
		mov right,cx
		add right, 13
		mov cx,monster3y  
		mov down, cx
		sub down,0
		mov up,cx
		sub up,1
		mov color,42h
		call drawRectangle

	;RIGHT NAIL
		mov cx,monster3x
		mov left,cx
		add left,3
		mov right,cx
		add right, 6
		mov cx,monster3y  
		mov down, cx
		sub down,0
		mov up,cx
		sub up,1
		mov color,1Fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		add left,4
		mov right,cx
		add right, 6
		mov cx,monster3y  
		mov down, cx
		sub down,1
		mov up,cx
		sub up,2
		mov color,1Fh
		call drawRectangle
	
	;LEFT NAIL
		mov cx,monster3x
		mov left,cx
		sub left,2
		mov right,cx
		add right, 1
		mov cx,monster3y  
		mov down, cx
		sub down,0
		mov up,cx
		sub up,1
		mov color,1Fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,1
		mov right,cx
		add right, 1
		mov cx,monster3y  
		mov down, cx
		sub down,1
		mov up,cx
		sub up,2
		mov color,1Fh
		call drawRectangle
	
	;LEFT NAIL
		mov cx,monster3x
		mov left,cx
		sub left,6
		mov right,cx
		sub right, 3
		mov cx,monster3y  
		mov down, cx
		sub down,2
		mov up,cx
		sub up,3
		mov color,1Fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,5
		mov right,cx
		sub right, 3
		mov cx,monster3y  
		mov down, cx
		sub down,2
		mov up,cx
		sub up,4
		mov color,1Fh
		call drawRectangle
	
	
	
	;GREEEN BASE
		mov cx,monster3x
		mov left,cx
		sub left,2
		mov right,cx
		add right, 13
		mov cx,monster3y  
		mov down, cx
		sub down,5
		mov up,cx
		sub up,13
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,3
		mov right,cx
		add right, 12
		mov cx,monster3y  
		mov down, cx
		sub down,6
		mov up,cx
		sub up,19
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,4
		mov right,cx
		sub right, 3
		mov cx,monster3y  
		mov down, cx
		sub down,6
		mov up,cx
		sub up,7
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,5
		mov right,cx
		add right, 12
		mov cx,monster3y  
		mov down, cx
		sub down,7
		mov up,cx
		sub up,12
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,5
		mov right,cx
		add right, 12
		mov cx,monster3y  
		mov down, cx
		sub down,7
		mov up,cx
		sub up,12
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,6
		mov right,cx
		add right, 11
		mov cx,monster3y  
		mov down, cx
		sub down,20
		mov up,cx
		sub up,22
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,9
		mov right,cx
		add right, 10
		mov cx,monster3y  
		mov down, cx
		sub down,22
		mov up,cx
		sub up,26
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,12
		mov right,cx
		add right, 8
		mov cx,monster3y  
		mov down, cx
		sub down,26
		mov up,cx
		sub up,28
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,13
		mov right,cx
		add right, 4
		mov cx,monster3y  
		mov down, cx
		sub down,28
		mov up,cx
		sub up,30
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,16
		mov right,cx
		sub right,5
		mov cx,monster3y  
		mov down, cx
		sub down,30
		mov up,cx
		sub up,32
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,10
		mov right,cx
		sub right,6
		mov cx,monster3y  
		mov down, cx
		sub down,32
		mov up,cx
		sub up,37
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,11
		mov right,cx
		sub right,6
		mov cx,monster3y  
		mov down, cx
		sub down,35
		mov up,cx
		sub up,36
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,13
		mov right,cx
		sub right,6
		mov cx,monster3y  
		mov down, cx
		sub down,28
		mov up,cx
		sub up,35
		mov color,02h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,7
		mov right,cx
		sub right,4
		mov cx,monster3y  
		mov down, cx
		sub down,22
		mov up,cx
		sub up,23
		mov color,42h
		call drawRectangle




	;TURTLE SHELL
		mov cx,monster3x
		mov left,cx
		add left,9
		mov right,cx
		add right, 14
		mov cx,monster3y  
		mov down, cx
		sub down,3
		mov up,cx
		sub up,5
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		add left,7
		mov right,cx
		add right, 9
		mov cx,monster3y  
		mov down, cx
		sub down,5
		mov up,cx
		sub up,7
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		add left,5
		mov right,cx
		add right, 7
		mov cx,monster3y  
		mov down, cx
		sub down,7
		mov up,cx
		sub up,9
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		add left,4
		mov right,cx
		add right, 5
		mov cx,monster3y  
		mov down, cx
		sub down,9
		mov up,cx
		sub up,11
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		add left,3
		mov right,cx
		add right, 4
		mov cx,monster3y  
		mov down, cx
		sub down,9
		mov up,cx
		sub up,11
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		add left,3
		mov right,cx
		add right, 4
		mov cx,monster3y  
		mov down, cx
		sub down,11
		mov up,cx
		sub up,16
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		add left,2
		mov right,cx
		add right, 3
		mov cx,monster3y  
		mov down, cx
		sub down,13
		mov up,cx
		sub up,19
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		add left,1
		mov right,cx
		add right, 2
		mov cx,monster3y  
		mov down, cx
		sub down,19
		mov up,cx
		sub up,21
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		;add left,1
		mov right,cx
		add right, 1
		mov cx,monster3y  
		mov down, cx
		sub down,21
		mov up,cx
		sub up,23
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,5
		mov right,cx
		; right, 2
		mov cx,monster3y  
		mov down, cx
		sub down,22
		mov up,cx
		sub up,23
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,8
		mov right,cx
		sub right, 5
		mov cx,monster3y  
		mov down, cx
		sub down,23
		mov up,cx
		sub up,25
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,7
		mov right,cx
		sub right, 4
		mov cx,monster3y  
		mov down, cx
		sub down,25
		mov up,cx
		sub up,26
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,6
		mov right,cx
		sub right, 3
		mov cx,monster3y  
		mov down, cx
		sub down,26
		mov up,cx
		sub up,27
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,5
		mov right,cx
		sub right, 3
		mov cx,monster3y  
		mov down, cx
		sub down,27
		mov up,cx
		sub up,30
		mov color,1fh
		call drawRectangle

	;HANDS
		mov cx,monster3x
		mov left,cx
		sub left,10
		mov right,cx
		sub right,5
		mov cx,monster3y  
		mov down, cx
		sub down,11
		mov up,cx
		sub up,14
		mov color,42h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,5
		mov right,cx
		sub right,4
		mov cx,monster3y  
		mov down, cx
		sub down,13
		mov up,cx
		sub up,14
		mov color,1Fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,9
		mov right,cx
		sub right,7
		mov cx,monster3y  
		mov down, cx
		sub down,10
		mov up,cx
		sub up,16
		mov color,42h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,14
		mov right,cx
		sub right,11
		mov cx,monster3y  
		mov down, cx
		sub down,16
		mov up,cx
		sub up,17
		mov color,42h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,15
		mov right,cx
		sub right,13
		mov cx,monster3y  
		mov down, cx
		sub down,14
		mov up,cx
		sub up,16
		mov color,42h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,15
		mov right,cx
		sub right,13
		mov cx,monster3y  
		mov down, cx
		sub down,12
		mov up,cx
		sub up,14
		mov color,42h
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,14
		mov right,cx
		sub right,13
		mov cx,monster3y  
		mov down, cx
		sub down,10
		mov up,cx
		sub up,11
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,14
		mov right,cx
		sub right,13
		mov cx,monster3y  
		mov down, cx
		sub down,13
		mov up,cx
		sub up,14
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,12
		mov right,cx
		sub right,11
		mov cx,monster3y  
		mov down, cx
		sub down,15
		mov up,cx
		sub up,16
		mov color,1fh
		call drawRectangle

		mov cx,monster3x
		mov left,cx
		sub left,10
		mov right,cx
		sub right,9
		mov cx,monster3y  
		mov down, cx
		sub down,10
		mov up,cx
		sub up,11
		mov color,1Fh
		call drawRectangle
	
	;face
		;green
			mov cx,monster3x
			mov left,cx
			sub left,18
			mov right,cx
			sub right,12
			mov cx,monster3y  
			mov down, cx
			sub down,30
			mov up,cx
			sub up,33
			mov color,02h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,16
			mov right,cx
			sub right,12
			mov cx,monster3y  
			mov down, cx
			sub down,33
			mov up,cx
			sub up,35
			mov color,02h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,15
			mov right,cx
			sub right,10
			mov cx,monster3y  
			mov down, cx
			sub down,35
			mov up,cx
			sub up,36
			mov color,02h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,14
			mov right,cx
			sub right,7
			mov cx,monster3y  
			mov down, cx
			sub down,36
			mov up,cx
			sub up,37
			mov color,02h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,12
			mov right,cx
			sub right,7
			mov cx,monster3y  
			mov down, cx
			sub down,37
			mov up,cx
			sub up,38
			mov color,02h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,11
			mov right,cx
			sub right,7
			mov cx,monster3y  
			mov down, cx
			sub down,38
			mov up,cx
			sub up,39
			mov color,02h
			call drawRectangle			
		;SKIN
			mov cx,monster3x
			mov left,cx
			sub left,14
			mov right,cx
			sub right,12
			mov cx,monster3y  
			mov down, cx
			sub down,23
			mov up,cx
			sub up,25
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,13
			mov right,cx
			sub right,12
			mov cx,monster3y  
			mov down, cx
			sub down,24
			mov up,cx
			sub up,27
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,11
			mov right,cx
			sub right,11
			mov cx,monster3y  
			mov down, cx
			sub down,24
			mov up,cx
			sub up,29
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,10
			mov right,cx
			sub right,10
			mov cx,monster3y  
			mov down, cx
			sub down,28
			mov up,cx
			sub up,32
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,13
			mov right,cx
			sub right,10
			mov cx,monster3y  
			mov down, cx
			sub down,32
			mov up,cx
			sub up,32
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,15
			mov right,cx
			sub right,13
			mov cx,monster3y  
			mov down, cx
			sub down,31
			mov up,cx
			sub up,31
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,15
			mov right,cx
			sub right,13
			mov cx,monster3y  
			mov down, cx
			sub down,31
			mov up,cx
			sub up,31
			mov color,42h
			call drawRectangle		

			mov cx,monster3x
			mov left,cx
			sub left,18
			mov right,cx
			sub right,15
			mov cx,monster3y  
			mov down, cx
			sub down,30
			mov up,cx
			sub up,30
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,21
			mov right,cx
			sub right,18
			mov cx,monster3y  
			mov down, cx
			sub down,31
			mov up,cx
			sub up,32
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,21
			mov right,cx
			sub right,19
			mov cx,monster3y  
			mov down, cx
			sub down,32
			mov up,cx
			sub up,33
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,21
			mov right,cx
			sub right,21
			mov cx,monster3y  
			mov down, cx
			sub down,33
			mov up,cx
			sub up,34
			mov color,42h
			call drawRectangle	

			mov cx,monster3x
			mov left,cx
			sub left,19
			mov right,cx
			sub right,19
			mov cx,monster3y  
			mov down, cx
			sub down,33
			mov up,cx
			sub up,34
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,20
			mov right,cx
			sub right,20
			mov cx,monster3y  
			mov down, cx
			sub down,35
			mov up,cx
			sub up,35
			mov color,42h
			call drawRectangle	

			mov cx,monster3x
			mov left,cx
			sub left,12
			mov right,cx
			sub right,11
			mov cx,monster3y  
			mov down, cx
			sub down,33
			mov up,cx
			sub up,33
			mov color,42h
			call drawRectangle	

			mov cx,monster3x
			mov left,cx
			sub left,9
			mov right,cx
			sub right,8
			mov cx,monster3y  
			mov down, cx
			sub down,37
			mov up,cx
			sub up,39
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,8
			mov right,cx
			sub right,8
			mov cx,monster3y  
			mov down, cx
			sub down,38
			mov up,cx
			sub up,40
			mov color,42h
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,7
			mov right,cx
			sub right,7
			mov cx,monster3y  
			mov down, cx
			sub down,39
			mov up,cx
			sub up,41
			mov color,42h
			call drawRectangle

			

		;WHITE
			mov cx,monster3x
			mov left,cx
			sub left,15
			mov right,cx
			sub right,15
			mov cx,monster3y  
			mov down, cx
			sub down,24
			mov up,cx
			sub up,25
			mov color,1Fh
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,13
			mov right,cx
			sub right,13
			mov cx,monster3y  
			mov down, cx
			sub down,26
			mov up,cx
			sub up,27
			mov color,1Fh
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,11
			mov right,cx
			sub right,11
			mov cx,monster3y  
			mov down, cx
			sub down,28
			mov up,cx
			sub up,29
			mov color,1fh
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,17
			mov right,cx
			sub right,15
			mov cx,monster3y  
			mov down, cx
			sub down,33
			mov up,cx
			sub up,33
			mov color,1fh
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,15
			mov right,cx
			sub right,14
			mov cx,monster3y  
			mov down, cx
			sub down,34
			mov up,cx
			sub up,36
			mov color,1fh
			call drawRectangle	

			mov cx,monster3x
			mov left,cx
			sub left,10
			mov right,cx
			sub right,9
			mov cx,monster3y  
			mov down, cx
			sub down,37
			mov up,cx
			sub up,39
			mov color,1fh
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,9
			mov right,cx
			sub right,9
			mov cx,monster3y  
			mov down, cx
			sub down,38
			mov up,cx
			sub up,40
			mov color,1fh
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			sub left,8
			mov right,cx
			sub right,8
			mov cx,monster3y  
			mov down, cx
			sub down,39
			mov up,cx
			sub up,41
			mov color,1fh
			call drawRectangle	

			mov cx,monster3x
			mov left,cx
			sub left,7
			mov right,cx
			sub right,6
			mov cx,monster3y  
			mov down, cx
			sub down,41
			mov up,cx
			sub up,41
			mov color,1fh
			call drawRectangle	

			mov cx,monster3x
			mov left,cx
			add left,2
			mov right,cx
			add right,4
			mov cx,monster3y  
			mov down, cx
			sub down,25
			mov up,cx
			sub up,27
			mov color,1fh
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			add left,4
			mov right,cx
			add right,5
			mov cx,monster3y  
			mov down, cx
			sub down,26
			mov up,cx
			sub up,29
			mov color,1fh
			call drawRectangle	

			mov cx,monster3x
			mov left,cx
			add left,8
			mov right,cx
			add right,10
			mov cx,monster3y  
			mov down, cx
			sub down,20
			mov up,cx
			sub up,22
			mov color,1fh
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			add left,7
			mov right,cx
			add right,9
			mov cx,monster3y  
			mov down, cx
			sub down,18
			mov up,cx
			sub up,20
			mov color,1fh
			call drawRectangle	

			mov cx,monster3x
			mov left,cx
			add left,10
			mov right,cx
			add right,12
			mov cx,monster3y  
			mov down, cx
			sub down,13
			mov up,cx
			sub up,15
			mov color,1fh
			call drawRectangle

			mov cx,monster3x
			mov left,cx
			add left,9
			mov right,cx
			add right,10
			mov cx,monster3y  
			mov down, cx
			sub down,11
			mov up,cx
			sub up,14
			mov color,1fh
			call drawRectangle	



ret
drawmonster3 endp

drawFireball proc uses cx

	fire=2Bh
	mov cx,fireballx
	mov left,cx
	add left,3
	mov right,cx          
	add right,13  
	mov cx,firebally  
	mov down, cx
	add down,6
	mov up,cx
	add up,6
	mov color,fire
	call drawRectangle

	mov cx,fireballx
	mov left,cx
	add left,4
	mov right,cx          
	add right,12
	mov cx,firebally  
	mov down, cx
	add down,5
	mov up,cx
	add up,5
	mov color,fire
	call drawRectangle

	mov cx,fireballx
	mov left,cx
	add left,4
	mov right,cx          
	add right,12
	mov cx,firebally  
	mov down, cx
	add down,7
	mov up,cx
	add up,7
	mov color,fire
	call drawRectangle

	mov cx,fireballx
	mov left,cx
	add left,5
	mov right,cx          
	add right,11
	mov cx,firebally  
	mov down, cx
	add down,8
	mov up,cx
	add up,8
	mov color,fire
	call drawRectangle

	mov cx,fireballx
	mov left,cx
	add left,5
	mov right,cx          
	add right,11
	mov cx,firebally  
	mov down, cx
	add down,4
	mov up,cx
	add up,4
	mov color,fire
	call drawRectangle

	mov cx,fireballx
	mov left,cx
	add left,6
	mov right,cx          
	add right,10
	mov cx,firebally  
	mov down, cx
	add down,3
	mov up,cx
	add up,3
	mov color,fire
	call drawRectangle

	mov cx,fireballx
	mov left,cx
	add left,6
	mov right,cx          
	add right,10
	mov cx,firebally  
	mov down, cx
	add down,9
	mov up,cx
	add up,9
	mov color,fire
	call drawRectangle
	

	mov cx,fireballx
	mov left,cx
	add left,7
	mov right,cx          
	add right,9
	mov cx,firebally  
	mov down, cx
	add down,10
	mov up,cx
	add up,10
	mov color,fire
	call drawRectangle

	mov cx,fireballx
	mov left,cx
	add left,7
	mov right,cx          
	add right,9
	mov cx,firebally  
	mov down, cx
	add down,2
	mov up,cx
	add up,2
	mov color,fire
	call drawRectangle
	
	
ret
drawFireball endp

drawmario proc uses cx

		mov cx,mariox
		mov left,cx
		sub left,4   ;10-4=6
		mov right,cx           ;2
		add right,2   ;10-2=8
		mov cx,marioy  
		mov down, cx
		add down,1
		mov up,cx
		;sub up,1
		mov color,06h
		call drawRectangle


			mov cx,mariox
		mov left,cx
		sub left,3   
		mov right,cx          
		add right,2   
		mov cx,marioy  
		mov down, cx
		add down,1
		mov up,cx
		sub up,1
		mov color,06h
		call drawRectangle

	;left leg
		mov cx,mariox
		mov left,cx
		add left,10   	                         
		mov right,cx
		add right,16    
		mov cx,marioy  
		mov down, cx
		add down,1
		mov up,cx
		;sub up,1
		mov color,06h
		call drawRectangle



			mov cx,mariox
		mov left,cx
		add left,10 
		mov right,cx          
		add right,15   
		mov cx,marioy  
		mov down, cx
		add down,1
		mov up,cx
		sub up,1
		mov color,06h
		call drawRectangle


	;hands
		mov cx,mariox
		mov left,cx
		sub left,4	                         
		mov right,cx
		add right,16 
		mov cx,marioy  
		mov down, cx
		sub down,4
		mov up,cx
		sub up,10
		mov color,68
		call drawRectangle




	;face

		mov cx,mariox
		mov left,cx
		add left,2	                         
		mov right,cx
		add right,10
		mov cx,marioy  
		mov down, cx
		sub down,17
		mov up,cx
		sub up,23
		mov color,68
		call drawRectangle






		mov cx,mariox
		mov left,cx
		add left,11	                         
		mov right,cx
		add right,12
		mov cx,marioy  
		mov down, cx
		sub down,21
		mov up,cx
		sub up,21
		mov color,68
		call drawRectangle



		mov cx,mariox
		mov left,cx
		add left,11	                         
		mov right,cx
		add right,13
		mov cx,marioy  
		mov down, cx
		sub down,20
		mov up,cx
		sub up,20
		mov color,68
		call drawRectangle

		mov cx,mariox
		mov left,cx
		sub left,1	                         
		mov right,cx
		ADD right,1
		mov cx,marioy  
		mov down, cx
		sub down,20
		mov up,cx
		sub up,23
		mov color,68
		call drawRectangle



		mov cx,mariox
		mov left,cx
		add left,7	                         
		mov right,cx
		add right,12
		mov cx,marioy  
		mov down, cx
		sub down,19
		mov up,cx
		sub up,19
		mov color,06h
		call drawRectangle


		mov cx,mariox
		mov left,cx
		add left,8	                         
		mov right,cx
		add right,8
		mov cx,marioy  
		mov down, cx
		sub down,20
		mov up,cx
		sub up,20
		mov color,06h
		call drawRectangle



		mov cx,mariox
		mov left,cx
		add left,7	                         
		mov right,cx
		add right,7
		mov cx,marioy  
		mov down, cx
		sub down,21
		mov up,cx
		sub up,23
		mov color,06h
		call drawRectangle



		mov cx,mariox
		mov left,cx
		;add left,1	                         
		mov right,cx
		add right,1
		mov cx,marioy  
		mov down, cx
		sub down,19
		mov up,cx
		sub up,19
		mov color,06h
		call drawRectangle



		mov cx,mariox
		mov left,cx
		sub left,1	                         
		mov right,cx
		sub right,1
		mov cx,marioy  
		mov down, cx
		sub down,20
		mov up,cx
		sub up,23
		mov color,06h
		call drawRectangle


		mov cx,mariox
		mov left,cx
		;add left,1	                         
		mov right,cx
		add right,4
		mov cx,marioy  
		mov down, cx
		sub down,23
		mov up,cx
		sub up,23
		mov color,06h
		call drawRectangle


		mov cx,mariox
		mov left,cx
		add left,2	                         
		mov right,cx
		add right,2
		mov cx,marioy  
		mov down, cx
		sub down,20
		mov up,cx
		sub up,23
		mov color,06h
		call drawRectangle

		mov cx,mariox
		mov left,cx
		add left,2	                         
		mov right,cx
		add right,3
		mov cx,marioy  
		mov down, cx
		sub down,19
		mov up,cx
		sub up,20
		mov color,06h
		call drawRectangle



	;shirt
		mov cx,mariox
		mov left,cx
		add left,12	                         
		mov right,cx
		add right,13
		mov cx,marioy  
		mov down, cx
		sub down,9
		mov up,cx
		sub up,10
		mov color,4
		call drawRectangle

		mov cx,mariox
		mov left,cx
		sub left,1	                         
		mov right,cx
		;sub right,1
		mov cx,marioy  
		mov down, cx
		sub down,9
		mov up,cx
		sub up,10
		mov color,4
		call drawRectangle



		mov cx,mariox
		mov left,cx
		sub left,4	                         
		mov right,cx
		add right,16
		mov cx,marioy  
		mov down, cx
		sub down,11
		mov up,cx
		sub up,12
		mov color,4
		call drawRectangle


		mov cx,mariox
		mov left,cx
		sub left,2	                         
		mov right,cx
		add right,14
		mov cx,marioy  
		mov down, cx
		sub down,13
		mov up,cx
		sub up,14
		mov color,4
		call drawRectangle


		mov cx,mariox
		mov left,cx
		;sub left,2	                         
		mov right,cx
		add right,12
		mov cx,marioy  
		mov down, cx
		sub down,15
		mov up,cx
		sub up,16
		mov color,4
		call drawRectangle


	;cap
		mov cx,mariox
		mov left,cx
		;sub left,2	                         
		mov right,cx
		add right,12
		mov cx,marioy  
		mov down, cx
		sub down,25
		mov up,cx
		sub up,26
		mov color,4
		call drawRectangle

		mov cx,mariox
		mov left,cx
		add left,1
		mov right,cx
		add right,10
		mov cx,marioy  
		mov down, cx
		sub down,26
		mov up,cx
		sub up,28
		mov color,4
		call drawRectangle



	;clothing

		mov cx,mariox
		mov left,cx
		add left,8	                         
		mov right,cx
		add right,13   
		mov cx,marioy  
		mov down, cx
		sub down,2
		mov up,cx
		sub up,5
		mov color,1
		call drawRectangle



		mov cx,mariox
		mov left,cx
		sub left,1	                         
		mov right,cx
		add right,4 
		mov cx,marioy  
		mov down, cx
		sub down,2
		mov up,cx
		sub up,5
		mov color,1
		call drawRectangle



	;straps
		mov cx,mariox
		mov left,cx
		add left,3	                         
		mov right,cx
		add right,4
		mov cx,marioy  
		mov down, cx
		sub down,11
		mov up,cx
		sub up,16
		mov color,1
		call drawRectangle


		mov cx,mariox
		mov left,cx
		add left,8	                         
		mov right,cx
		add right,9
		mov cx,marioy  
		mov down, cx
		sub down,11
		mov up,cx
		sub up,16
		mov color,1
		call drawRectangle


		mov cx,mariox
		mov left,cx
		add left,3	                         
		mov right,cx
		add right,8
		mov cx,marioy  
		mov down, cx
		sub down,6
		mov up,cx
		sub up,12
		mov color,1
		call drawRectangle









	;overall
		mov cx,mariox
		mov left,cx
		add left,1	                         
		mov right,cx
		add right,11 
		mov cx,marioy  
		mov down, cx
		sub down,4
		mov up,cx
		sub up,10
		mov color,1
		call drawRectangle



	;buttons
		mov cx,mariox
		mov left,cx
		add left,3	                         
		mov right,cx
		add right,4
		mov cx,marioy  
		mov down, cx
		sub down,9
		mov up,cx
		sub up,10
		mov color,43
		call drawRectangle


		mov cx,mariox
		mov left,cx
		add left,8	                         
		mov right,cx
		add right,9
		mov cx,marioy  
		mov down, cx
		sub down,9
		mov up,cx
		sub up,10
		mov color,43
		call drawRectangle






ret
drawmario endp

drawMarioLogo proc 
	
	;DRAW OUTLINE
		mov left,91
        mov right,95
        mov down, 20
        mov up,15
        mov color,10h
        call drawRectangle

		mov left,96
        mov right,115
        mov down, 25
        mov up,10
        mov color,10h
        call drawRectangle

		mov left,116
        mov right,140
        mov down, 20
        mov up,15
        mov color,10h
        call drawRectangle

		mov left,151
        mov right,156
        mov down, 20
        mov up,15
        mov color,10h
        call drawRectangle

		mov left,155
        mov right,175
        mov down, 15
        mov up,10
        mov color,10h
        call drawRectangle

		mov left,176
        mov right,185
        mov down, 20
        mov up,15
        mov color,10h
        call drawRectangle

		mov left,196
        mov right,210
        mov down, 20
        mov up,15
        mov color,10h
        call drawRectangle
	   
		mov left,186
        mov right,195
        mov down, 15
        mov up,10
        mov color,10h
        call drawRectangle

		mov left,211
        mov right,230
        mov down, 15
        mov up,10
        mov color,10h
        call drawRectangle

		mov left,230
        mov right,235
        mov down, 20
        mov up,15
        mov color,10h
        call drawRectangle

		mov left,240
		mov right,245
		mov down,50
		mov up,45
		mov color,10h
        call drawRectangle
		

		mov left,235
        mov right,240
        mov down, 60
        mov up,20
        mov color,10h
        call drawRectangle

	    mov left,84
        mov right,236
        mov down, 45
        mov up,21
        mov color,10h
        call drawRectangle
		
		
		mov left,89
        mov right,241
        mov down, 50
        mov up,46
        mov color,10h
        call drawRectangle

		mov left,74
        mov right,236
        mov down, 55
        mov up,51
        mov color,10h
        call drawRectangle

		mov left,74
        mov right,251
        mov down, 60
        mov up,56
        mov color,10h
        call drawRectangle

		mov left,74
        mov right,256
        mov down, 65
        mov up,61
        mov color,10h
        call drawRectangle

		mov left,69
        mov right,261
        mov down, 75
        mov up,66
        mov color,10h
        call drawRectangle

		mov left,64
        mov right,261
        mov down, 85
        mov up,76
        mov color,10h
        call drawRectangle

		mov left,59
        mov right,261
        mov down, 90
        mov up,86
        mov color,10h
        call drawRectangle

		mov left,59
        mov right,85
        mov down, 100
        mov up,91
        mov color,10h
        call drawRectangle

		mov left,65
        mov right,85
        mov down, 105
        mov up,101
        mov color,10h
        call drawRectangle

		mov left,75
        mov right,85
        mov down, 110
        mov up,106
        mov color,10h
        call drawRectangle

		mov left,90
        mov right,256
        mov down, 95
        mov up,91
        mov color,10h
        call drawRectangle

		mov left,100
        mov right,256
        mov down, 100
        mov up,96
        mov color,10h
        call drawRectangle

		mov left,100
        mov right,136
        mov down, 105
        mov up,101
        mov color,10h
        call drawRectangle

		mov left,100
        mov right,136
        mov down, 110
        mov up,106
        mov color,10h
        call drawRectangle

		mov left,140
        mov right,251
        mov down, 105
        mov up,101
        mov color,10h
        call drawRectangle

		mov left,140
        mov right,156
        mov down, 110
        mov up,106
        mov color,10h
        call drawRectangle

		mov left,160
        mov right,175
        mov down, 110
        mov up,106
        mov color,10h
        call drawRectangle

		mov left,180
        mov right,191
        mov down, 110
        mov up,106
        mov color,10h
        call drawRectangle

		mov left,195
        mov right,210
        mov down, 110
        mov up,106
        mov color,10h
        call drawRectangle

		mov left,220
        mov right,245
        mov down, 110
        mov up,106
        mov color,10h
        call drawRectangle

	;DRAW S
		mov left,95
        mov right,115
        mov down, 20
        mov up,15
        mov color,35h
        call drawRectangle

		mov left,90
        mov right,105
        mov down, 30
        mov up,21
        mov color,35h
        call drawRectangle

		mov left,110
        mov right,120
        mov down, 25
        mov up,21
        mov color,35h
        call drawRectangle

		mov left,100
        mov right,115
        mov down, 35
        mov up,31
        mov color,35h
        call drawRectangle

		mov left,90
        mov right,100
        mov down, 40
        mov up,36
        mov color,35h
        call drawRectangle

		mov left,105
        mov right,120
        mov down, 40
        mov up,36
        mov color,35h
        call drawRectangle

		mov left,90
        mov right,120
        mov down, 45
        mov up,41
        mov color,35h
        call drawRectangle

		mov left,95
        mov right,115
        mov down, 50
        mov up,46
        mov color,35h
        call drawRectangle

	;DRAW U
		mov left,125
        mov right,135
        mov down, 30
        mov up,21
        mov color,2bh
        call drawRectangle

		mov left,125
        mov right,130
        mov down, 45
        mov up,30
        mov color,2bh
        call drawRectangle

		mov left,130
        mov right,145
        mov down, 50
        mov up,40
        mov color,2bh
        call drawRectangle

		mov left,140
        mov right,150
        mov down, 45
        mov up,25
        mov color,2bh
        call drawRectangle

		mov left,145
        mov right,155
        mov down, 35
        mov up,25
        mov color,2bh
        call drawRectangle

	;DRAW P
		mov left,155
        mov right,175
        mov down, 20
        mov up,15
        mov color,28h
        call drawRectangle

		mov left,160
        mov right,185
        mov down, 25
        mov up,20
        mov color,28h
        call drawRectangle

		mov left,180
        mov right,185
        mov down, 35
        mov up,20
        mov color,28h
        call drawRectangle

		mov left,170
        mov right,180
        mov down, 40
        mov up,35
        mov color,28h
        call drawRectangle

		mov left,160
        mov right,170
        mov down, 50
        mov up,20
        mov color,28h
        call drawRectangle

	;DRAW E
		mov left,186
        mov right,195
        mov down, 20
        mov up,15
        mov color,32h
        call drawRectangle

		mov left,190
        mov right,205
        mov down, 25
        mov up,20
        mov color,32h
        call drawRectangle

		mov left,190
        mov right,195
        mov down, 40
        mov up,25
        mov color,32h
        call drawRectangle

		mov left,190
        mov right,205
        mov down, 40
        mov up,30
        mov color,32h
        call drawRectangle

		mov left,186
        mov right,190
        mov down, 40
        mov up,35
        mov color,32h
        call drawRectangle

		mov left,181
        mov right,195
        mov down, 45
        mov up,41
        mov color,32h
        call drawRectangle
		
		mov left,181
        mov right,205
        mov down, 50
        mov up,45
        mov color,32h
        call drawRectangle

	;MAKE R

		mov left,211
		mov right,220
		mov down,50
		mov up,15
		mov color,2bh
		call drawRectangle

		mov left,220
		mov right,230
		mov down,25
		mov up,15
		mov color,2bh
		call drawRectangle

		mov left,230
		mov right,235
		mov down,35
		mov up,20
		mov color,2bh
		call drawRectangle

		mov left,220
		mov right,229
		mov down,40
		mov up,35
		mov color,2bh
		call drawRectangle

		mov left,225
		mov right,229
		mov down,45
		mov up,40
		mov color,2bh
		call drawRectangle

		mov left,230
		mov right,235
		mov down,50
		mov up,40
		mov color,2bh
		call drawRectangle

	;MAKE M

		mov left,80
        mov right,90
        mov down, 75
        mov up,56
        mov color,28h
        call drawRectangle

		mov left,75
        mov right,85
        mov down, 90
        mov up,66
        mov color,28h
        call drawRectangle

		mov left,75
        mov right,80
        mov down, 100
        mov up,76
        mov color,28h
        call drawRectangle

		mov left,70
        mov right,75
        mov down, 95
        mov up,76
        mov color,28h
        call drawRectangle

		mov left,65
        mov right,70
        mov down, 95
        mov up,86
        mov color,28h
        call drawRectangle

		mov left,90
        mov right,95
        mov down, 85
        mov up,61
        mov color,28h
        call drawRectangle

		mov left,95
        mov right,100
        mov down, 80
        mov up,71
        mov color,28h
        call drawRectangle

		mov left,100
        mov right,105
        mov down, 75
        mov up,56
        mov color,28h
        call drawRectangle

		mov left,105
        mov right,115
        mov down, 100
        mov up,56
        mov color,28h
        call drawRectangle

		mov left,115
        mov right,120
        mov down, 100
        mov up,81
        mov color,28h
        call drawRectangle

	;MAKE A

		mov left,121
        mov right,135
        mov down, 80
        mov up,70
        mov color,32h
        call drawRectangle

		mov left,125
        mov right,135
        mov down, 90
        mov up,60
        mov color,32h
        call drawRectangle

		mov left,130
        mov right,145
        mov down, 60
        mov up,55
        mov color,32h
        call drawRectangle

		mov left,125
        mov right,150
        mov down, 70
        mov up,60
        mov color,32h
        call drawRectangle

		mov left,140
        mov right,150
        mov down, 90
        mov up,60
        mov color,32h
        call drawRectangle

		mov left,125
        mov right,155
        mov down, 90
        mov up,80
        mov color,32h
        call drawRectangle

		mov left,125
        mov right,130
        mov down, 100
        mov up,90
        mov color,32h
        call drawRectangle

		mov left,145
        mov right,160
        mov down, 100
        mov up,90
        mov color,32h
        call drawRectangle

		mov left,150
        mov right,155
        mov down, 80
        mov up,75
        mov color,32h
        call drawRectangle

	;MAKE R
		
		mov left,161
        mov right,170
        mov down, 90
        mov up,55
        mov color,2bh
        call drawRectangle

		mov left,165
        mov right,170
        mov down, 100
        mov up,85
        mov color,2bh
        call drawRectangle

		mov left,170
        mov right,185
        mov down, 60
        mov up,55
        mov color,2bh
        call drawRectangle

		mov left,170
        mov right,195
        mov down, 65
        mov up,60
        mov color,2bh
        call drawRectangle

		mov left,180
        mov right,195
        mov down, 75
        mov up,65
        mov color,2bh
        call drawRectangle

		mov left,170
        mov right,190
        mov down, 80
        mov up,75
        mov color,2bh
        call drawRectangle

		mov left,165
        mov right,185
        mov down, 85
        mov up,80
        mov color,2bh
        call drawRectangle

		mov left,175
        mov right,185
        mov down, 90
        mov up,85
        mov color,2bh
        call drawRectangle

		mov left,180
        mov right,190
        mov down, 95
        mov up,85
        mov color,2bh
        call drawRectangle

		mov left,190
        mov right,195
        mov down, 95
        mov up,90
        mov color,2bh
        call drawRectangle

		mov left,180
        mov right,185
        mov down, 100
        mov up,95
        mov color,2bh
        call drawRectangle

	;Make I
		
		mov left,200
        mov right,210
        mov down, 100
        mov up,55
        mov color,35h
        call drawRectangle

		mov left,210
        mov right,215
        mov down, 80
        mov up,60
        mov color,35h
        call drawRectangle

	;Make O
		mov left,220
        mov right,230
        mov down, 95
        mov up,65
        mov color,32h
        call drawRectangle

		mov left,225
        mov right,240
        mov down, 60
        mov up,55
        mov color,32h
        call drawRectangle

		mov left,225
        mov right,245
        mov down, 65
        mov up,60
        mov color,32h
        call drawRectangle

		mov left,230
        mov right,250
        mov down, 70
        mov up,65
        mov color,32h
        call drawRectangle

		mov left,240
        mov right,255
        mov down, 85
        mov up,70
        mov color,32h
        call drawRectangle

		mov left,230
        mov right,250
        mov down, 95
        mov up,85
        mov color,32h
        call drawRectangle

		mov left,230
        mov right,245
        mov down, 100
        mov up,95
        mov color,32h
        call drawRectangle



ret
drawMarioLogo endp

drawFlagM proc uses ax

	mov ax,flagy
	mov left,303
	mov right,318
	mov down, ax
	add down,18
	mov up,ax
	add up, 3
	mov color,22h
	;call drawRectangle

	mov ax,flagy
	sub ax,2
	mov left,304
	mov right,305
	mov down, ax
	add down,15
	mov up,ax
	add up,14
	mov color,1fh
	call drawRectangle

	mov ax,flagy
	sub ax,2
	mov left,316
	mov right,317
	mov down, ax
	add down,15
	mov up,ax
	add up,14
	mov color,1fh
	call drawRectangle

	mov ax,flagy
	sub ax,2
	mov left,305
	mov right,306
	mov down, ax
	add down,16
	mov up,ax
	add up,12
	mov color,1fh
	call drawRectangle

	mov ax,flagy
	sub ax,2
	mov left,315
	mov right,316
	mov down, ax
	add down,16
	mov up,ax
	add up,12
	mov color,1fh
	call drawRectangle

	mov ax,flagy
	sub ax,2
	mov left,306
	mov right,307
	mov down, ax
	add down,17
	mov up,ax
	add up,10
	mov color,1fh
	call drawRectangle

	mov ax,flagy
	sub ax,2
	mov left,314
	mov right,315
	mov down, ax
	add down,17
	mov up,ax
	add up,10
	mov color,1fh
	call drawRectangle

	mov ax,flagy
	sub ax,2
	mov left,307
	mov right,308
	mov down, ax
	add down,14
	mov up,ax
	add up,8
	mov color,1fh
	call drawRectangle

	mov ax,flagy
	sub ax,2
	mov left,313
	mov right,314
	mov down, ax
	add down,14
	mov up,ax
	add up,8
	mov color,1fh
	call drawRectangle

	mov ax,flagy
	sub ax,2
	mov left,308
	mov right,309
	mov down, ax
	add down,11
	mov up,ax
	add up,7
	mov color,1fh
	call drawRectangle

	mov ax,flagy
	sub ax,2
	mov left,312
	mov right,313
	mov down, ax
	add down,11
	mov up,ax
	add up,7
	mov color,1fh
	call drawRectangle

	mov ax,flagy
	sub ax,2
	mov left,309
	mov right,310
	mov down, ax
	add down,12
	mov up,ax
	add up,8
	mov color,1fh
	call drawRectangle

	mov ax,flagy
	sub ax,2
	mov left,311
	mov right,312
	mov down, ax
	add down,12
	mov up,ax
	add up,8
	mov color,1fh
	call drawRectangle

	mov ax,flagy
	sub ax,2
	mov left,310
	mov right,311
	mov down, ax
	add down,13
	mov up,ax
	add up,10
	mov color,1fh
	call drawRectangle

	
ret
drawFlagM endp

delay proc

	push ax
	push bx
	push cx
	push dx

	mov cx,100
	mydelay:
	mov bx,400      ;; increase this number if you want to add more delay, and decrease this number if you want to reduce delay.
	mydelay1:
	dec bx
	jnz mydelay1
	loop mydelay


	pop dx
	pop cx
	pop bx
	pop ax
ret

delay endp

end main