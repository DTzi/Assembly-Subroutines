#make_bin#
include 'emu8086.inc' 
DEFINE_CLEAR_SCREEN ;Output screen
welcome:
CALL CLEAR_sCREEN
print " WELCOME"
gotoxy 0,1
print " SUBROUTINE PROGRAM VERSION EMU.0.2"
gotoxy 0,2
print " CHOOSE OPERATION"
gotoxy 0,3
print "1. FILE OPERATIONS"
gotoxy 0,4
print "2. INFO"
gotoxy 0,5 
print "3. CHECK FAT"
gotoxy 0,6 
print "4. CHECK ROOT"
gotoxy 0,7
print "5. EXIT PROGRAM"
gotoxy 0,8 
mov ah,00
int 16h
cmp al,30h 
je welcome 
cmp al,31h
je fileoperations
cmp al,32h
je INFO 
CMP AL,33H
je fat
cmp al,34h
je rot
cmp al,35h
je end
jnle welcome

INFO: ;display info
CALL CLEAR_SCREEN
PRINT " TEI SERRWN PLIROFORIKIS K EPIKOINWNIWN"
GOTOXY 0,1
PRINT " SPIROS KAZARLIS"
GOTOXY 0,2
PRINT " DIMITRIS TZIATZIOS 1615"
GOTOXY 0,3
PRINT " ALL RIGHTS RESERVED"
GOTOXY 0,4
PRINT " PRESS ANY KEY TO CONTINUE"
GOTOXY 0,5
MOV AH,00
INT 16H 
JMP WELCOME

FILEOPERATIONS: ;file operations
CALL CLEAR_SCREEN
start: 
CALL CLEAR_SCREEN
MOV SI,00           

;STRA:
;mov [si+0d000h],00                     ;clear buffer
;inc si
;cmp si,200h
;jne STRA
PRINT "1) CREATE FILE"
GOTOXY 0,1
PRINT "2) DELETE FILE"
GOTOXY 0,2
PRINT "3) RENAME FILE"
GOTOXY 0,3
PRINT "4) CHANGE PROPERTIES"
GOTOXY 0,4
PRINT "5) OPEN FILE"
GOTOXY 0,5
PRINT "6) CLOSE FILE"
GOTOXY 0,6 
PRINT "7) RETURN"
GOTOXY 0,7
                      
mov ah,00
int 16h
cmp al,30h
je start
cmp al,31h
je create  
cmp al,32h
je delete
cmp al,33h
je rename
cmp al,34h
je change 
cmp al,35h
je open 
CMP AL,36H
JE CLOSE
CMP AL,37H
JE WELCOME
jnle start

CLOSE: 
CALL CLEAR_SCREEN
MOV SI,00
RETRI:
mov [SI+0af00h],00
INC SI
CMP SI,200H
JNE RETRI
JMP FILEOPERATIONS
       
open: 
CALL CLEAR_SCREEN
mov [0b270h],00    
mov [0b272h],00                 
mov [0b273h],00
mov [0b274h],00
srat32:
loop3333:
xor ax,ax
xor dx,dx
xor bx,bx
xor cx,cx
mov [0b400h],00
mov [0b401h],00
mov [0b500h],00
mov [0b501h],00
mov [0b600h],00
mov [0f900h],00
mov [0b400h],00
mov [0b601h],00
call clear_Screen
print "SECTOR NUMBER"
mov ah,00
int 16h
mov [0b400h],al                                               
sub [0b400h],30h                                                    
mov bl,[0b400h]
mov ax,100
mul bl
mov [0b401h],ax          ;chs
mov dx,[0b401h]

mov ah,00
int 16h
mov [0b500h],al
sub [0b500h],30h
mov bl,[0b500h]
mov ax,10
mul bl
mov [0b501h],ax
mov cx,[0b501h]

mov ah,00
int 16h
mov [0b600h],al
sub [0b600h],30h
mov bx,[0b600h]                      

add dx,cx
add dx,bx
mov [0b400h],dx   ;fat entry root entry
mov ax,dx 
cmp dx,21h
jl srat32
cmp dx,2cfh

xor bx,bx
mov bl,31
sub ax,bx 
mov si,ax
mov dx,[0b400h]

xor ax,ax
mov ax,dx
mov bl,12h
div bl
mov [0b270h],al
mov bh,ah
xor ax,ax
mov al,bh
xor bx,bx
mov bl,09
div bl
mov [0b272h],al 
mov [0b273h],ah
mov di,[0b273h]
xor ax,ax
mov al,[0b273h]    
xor bx,bx
mov bl,09
div bl
mov [0b274h],ah

xor ax,ax
xor dx,dx
xor bx,bx
xor cx,cx

mov ax,0100h
mov es,ax
mov bx,0af00h      


mov ah,02h                 ; subroutine to read the file 
mov al,01
mov ch,[0b270h]
mov cl,[0b274h]
mov dh,[0b272h]
mov dl,00
int 13h          
mov [0b270h],00    
mov [0b272h],00                 
mov [0b273h],00
mov [0b274h],00           
jmp start       

create:  
CALL CLEAR_SCREEN
mov ax,0100h
mov es,ax
mov bx,0a000h

mov [0a000h+si],240
mov [0a001h+si],255 
mov [0a002h+si],255
mov ah,03h
mov al,09
mov ch,00
mov cl,02
mov dh,00
mov dl,00
int 13h
srat:
loop333:
;mov [0d000h],00          
;inc si                      ;clear sector
;cmp si,200h
;jne loop333 

xor ax,ax
xor dx,dx
xor bx,bx
xor cx,cx
 
mov [0b400h],00
mov [0b401h],00
mov [0b500h],00
mov [0b501h],00
mov [0b600h],00
mov [0f900h],00
mov [0b400h],00
mov [0f800h],00
mov [0f802h],00
CALL CLEAR_SCREEN
PRINT " SECTOR NUMBER"

mov ah,00
int 16h
mov [0b400h],al                                               
sub [0b400h],30h                                                    
mov bl,[0b400h]
mov ax,100
mul bl
mov [0b401h],ax          ;chs
mov dx,[0b401h]

mov ah,00
int 16h
mov [0b500h],al
sub [0b500h],30h
mov bl,[0b500h]
mov ax,10
mul bl
mov [0b501h],ax
mov cx,[0b501h]

mov ah,00
int 16h
mov [0b600h],al
sub [0b600h],30h
mov bx,[0b600h]                      

add dx,cx
add dx,bx
mov [0b400h],dx   ;fat entry root entry
mov ax,dx 
cmp dx,21h

cmp dx,2cfh

xor bx,bx
mov bl,31
sub ax,bx 
mov si,ax
mov [0f900h],si          ;me dx 
;mov [0b400h],si 
mov ax,0100h
mov es,ax
mov bx,0a000h

mov [0a001h+si],255
mov [0a002h+si],15
mov ah,03h
mov al,09
mov ch,00
mov cl,02
mov dh,00
mov dl,00
int 13h            
mov ax,0100h
mov es,ax
mov bx,0e000h

mov ah,02h
mov al,09
mov ch,00
mov cl,02
mov dh,00
mov dl,00
int 13h
mov dx,[0b400h]

xor ax,ax
mov ax,dx
mov bl,12h
div bl
mov [0b270h],al
mov bh,ah
xor ax,ax
mov al,bh
xor bx,bx
mov bl,09
div bl
mov [0b272h],al 
mov [0b273h],ah
mov di,[0b273h]
xor ax,ax
mov al,[0b273h]    
xor bx,bx
mov bl,09
div bl
mov [0b274h],ah
mov ah,00
int 10h
mov ah,2          
mov dh,1
mov dl,0
mov bh,0
int 10h
mov ah,0eh 
mov al,20h
int 10h  
mov al,53h
int 10h  
mov al,54h
int 10h  
mov al,41h
int 10h  
mov al,52h
int 10h  
mov al,54h
int 10h 
mov al,49h
int 10h  
mov al,4eh
int 10h  
mov al,47h
int 10h
mov al,20h
int 10h
mov al,42h
int 10h  
mov al,59h
int 10h  
mov al,54h
int 10h  
mov al,45h
int 10h  
mov al,20h
int 10h  
mov al,26h
int 10h 
mov al,20h
int 10h 
mov al,53h
int 10h  
mov al,49h
int 10h  
mov al,5ah
int 10h  
mov al,45h
int 10h      
mov ax,00
mov dx,00
mov bx,00       
loop:   
mov ah,00
int 16h
mov [0b500h],al                                               
sub [0b500h],30h                                                    
mov bl,[0b500h]
mov ax,100
mul bl
mov [0b501h],ax
mov dx,[0b501h]

mov ah,00
int 16h
mov [0b600h],al
sub [0b600h],30h
mov bl,[0b600h]
mov ax,10
mul bl
mov [0b601h],ax
mov cx,[0b601h]

mov ah,00
int 16h
mov [0b700h],al
sub [0b700h],30h
mov bx,[0b700h]

add dx,cx
add dx,bx
mov [0b500h],dx
cmp dx,1ffh
jnle loop
mov si,dx
xor ax,ax

loop2: 
mov ah,00
int 16h
mov [0b500h],al                                               
sub [0b500h],30h                                                    
mov bl,[0b500h]
mov ax,100
mul bl
mov [0b501h],ax
mov dx,[0b501h]

mov ah,00
int 16h
mov [0b600h],al
sub [0b600h],30h
mov bl,[0b600h]
mov ax,10
mul bl
mov [0b601h],ax
mov cx,[0b601h]

mov ah,00
int 16h
mov [0b700h],al
sub [0b700h],30h
mov bx,[0b700h]                      

add dx,cx
add dx,bx
cmp dx,00
je loop2
mov [0b500h],dx
mov [0f990h],dx
cmp dx,200h
jnle loop2
mov di,dx  
xor dx,dx
mov dx,00h                         
mov [0b000h],dx
cmp [0b000h],00h
jnle loop
mov [0b650h],di

call clear_screen
boc:
print " FOR BYTES PRESS 0 , FOR CHARS PRESS 1"
mov ah,00
int 16h
cmp al,30h
je bytes
cmp al,31h
je chars
jnle boc

BYTES:

mov ah,00
int 16h
cmp al,31h
je add31
cmp al,32h
je add32
cmp al,33h
je add33
cmp al,34h
je add34
cmp al,35h
je add35    
cmp al,36h
je add36
cmp al,37h
je add37
cmp al,38h
je add38
cmp al,39h
je add39

cmp al,41h  
je adc
cmp al,42h
je adc1
cmp al,43h
je adc2
cmp al,44h
je adc3
cmp al,45h
je adc4
cmp al,46h
je adc5
jne BYTES

add31:
mov [0b900h],16 
jmp add0

add32:
mov [0b900h],32 
jmp add0 

add33:
mov [0b900h],48 
jmp add0

add34:
mov [0b900h],64 
jmp add0

add35:
mov [0b900h],80 
jmp add0

add36:
mov [0b900h],96 
jmp add0

add37:
mov [0b900h],112 
jmp add0

add38:
mov [0b900h],128 
jmp add0

add39:
mov [0b900h],144 
jmp add0

adc:
mov [0b900h],160 
jmp add0

adc1:
mov [0b900h],176
jmp add0
adc2:
mov [0b900h],192
jmp add0
adc3:
mov [0b900h],208
jmp add0
adc4:
mov [0b900h],224
jmp add0
adc5:
mov [0b900h],240
jmp add0  

add0:
mov ah,00
int 16h 
cmp al,41h  
je adc0
cmp al,42h
je adc01
cmp al,43h
je adc02
cmp al,44h
je adc03
cmp al,45h
je adc04
cmp al,46h
je adc05
jne addp1

adc0:
mov [0b902h],10 
jmp add00

adc01:
mov [0b902h],11
jmp add00
adc02:
mov [0b902h],12
jmp add00
adc03:
mov [0b902h],13
jmp add00
adc04:
mov [0b902h],14
jmp add00
adc05:
mov [0b902h],15
jmp add00  

addp1:
sub al,30h
mov [0b902h],al

add00:
mov bh,[0b900h]
mov bl,[0b902h]
add bh,bl
mov [si+0d000h],bh                                                                 
inc si
dec di
cmp di,00      
je fin
jnle bytes                                                               
cmp [0b00h],00h
jnle bytes 

fin:
mov ax,0100h
mov es,ax
mov bx,0d000h      


mov ah,03h                 ; subroutine to write in the file
mov al,01
mov ch,[0b270h]
mov cl,[0b274h]
mov dh,[0b272h]
mov dl,00
int 13h 

mov si,00
sratbyt:
mov [si+0d000h],00
inc si
cmp si,200h
jne sratbyt 

JMP ROOT
    
chars:   
       
mov ah,00
int 16h 
mov [si+0d000h],al                                                                
inc si
dec di
cmp di,00      
jne chars                                                               



mov ax,0100h
mov es,ax
mov bx,0d000h      


mov ah,03h                 ; subourtine calls the file
mov al,01
mov ch,[0b270h]
mov cl,[0b274h]
mov dh,[0b272h]
mov dl,00
int 13h 

mov si,00
sratch:
mov [si+0d000h],00
inc si
cmp si,200h
jne sratch         
mov [0b270h],00    
mov [0b272h],00                 
mov [0b273h],00
mov [0b274h],00          
jmp ROOT



ROOT: 



mov ah,2    ; "ROOT"     
mov dh,4
mov dl,0
mov bh,0
int 10h 
call clear_screen
print " NAME 8 bytes AND EXTENSION 3 bytes"
 
mov ah,00
int 16h
mov [0a300h],al
mov ah,00
int 16h
mov [0a301h],al
mov ah,00
int 16h
mov [0a302h],al
mov ah,00
int 16h
mov [0a303h],al
mov ah,00
int 16h
mov [0a304h],al
mov ah,00
int 16h
mov [0a305h],al
mov ah,00
int 16h
mov [0a306h],al
mov ah,00
int 16h
mov [0a307h],al
mov ah,00
int 16h
mov [0a308h],al
mov ah,00
int 16h
mov [0a309h],al 
mov ah,00
int 16h
mov [0a30ah],al

mov [0a30bh],21h
mov [0a30eh],64h
mov [0a30fh],7dh
mov [0a310h],14h
mov [0a311h],2bh
mov [0a312h],46h
mov [0a313h],00h
mov [0a316h],24h
mov [0a317h],28h
mov [0a318h],46h
mov [0a319h],00h

mov [0a312h],46h
mov [0a316h],24h
mov [0a317h],28h



mov ah,2          
mov dh,6
mov dl,0
mov bh,0
int 10h  
ROOTENTRYcr:
call clear_screen
print " ROOT ENTRY 00 - 13"



 mov ah,00
int 16h
sub al,30h
mov bl,10
mul bl
mov [0a203h],al
mov ah,00
int 16h
sub al,30h
mov [0a205h],al
mov bh,[0a203h]
mov bl,[0a205h]
add bh,bl
cmp bh,00
je root1   
cmp bh,01 
je rooot
cmp bh,02 
je rooot1
cmp bh,03 
je rooot2
cmp bh,04 
je rooot3
cmp bh,05 
je rooot4
cmp bh,06 
je rooot5
cmp bh,07 
je rooot6
cmp bh,08 
je rooot7
cmp bh,09 
je rooot8
cmp bh,10 
je rooot9
cmp bh,11 
je rooot10
cmp bh,12 
je rooot11
cmp bh,13 
je rooot12
jnle ROOTENTRYcr

root1:   
mov [0f800h],02
mov [0f802h],00
jmp rootpos

rooot:
mov [0f800h],03
mov [0f802h],00
jmp rootpos   



rooot1:
mov [0f800h],04
mov [0f802h],00
jmp rootpos  


rooot2:
mov [0f800h],05
mov [0f802h],00
jmp rootpos  


rooot3:
mov [0f800h],06
mov [0f802h],00
jmp rootpos  


rooot4:
mov [0f800h],07
mov [0f802h],00
jmp rootpos  


rooot5:
mov [0f800h],08
mov [0f802h],00
jmp rootpos  


rooot6:
mov [0f800h],09
mov [0f802h],00
jmp rootpos  


rooot7:
mov [0f800h],01
mov [0f802h],01
jmp rootpos  


rooot8:
mov [0f800h],02
mov [0f802h],01
jmp rootpos  


rooot9:
mov [0f800h],03
mov [0f802h],01
jmp rootpos  


rooot10:
mov [0f800h],04
mov [0f802h],01
jmp rootpos  


rooot11:
mov [0f800h],05
mov [0f802h],01
jmp rootpos  


rooot12:
mov [0f800h],06
mov [0f802h],01
jmp rootpos


rootpos:  
mov ah,2          
mov dh,8
mov dl,0
mov bh,0
int 10h
call clear_screen
print " ROOT POSITION 00 - 15"

loop1111:  
mov ah,00
int 16h
mov [0a500h],al
sub [0a500h],30h
mov bl,[0a500h]
cmp bl,02h



jnl loop1111

mov ah,00
int 16h
mov [0a501h],al
sub [0a501h],30h
mov bl,[0a500h]
mov ax,10
mul bl
mov [0a502h],ax
mov bl,[0a502h]
mov cl,[0a501h]
add cl,bl
mov [0a503h],cl

cmp cl,16h
jnl loop1111  
mov ax,20h
mul cl
mov si,ax


mov al,[0a300h]
mov [si+0a600h],al
mov al,[0a301h]
mov [si+0a601h],al
mov al,[0a302h]
mov [si+0a602h],al
mov al,[0a303h]
mov [si+0a603h],al
mov al,[0a304h]
mov [si+0a604h],al
mov al,[0a305h]
mov [si+0a605h],al
mov al,[0a306h]
mov [si+0a606h],al
mov al,[0a307h]
mov [si+0a607h],al
mov al,[0a308h]
mov [si+0a608h],al
mov al,[0a309h]
mov [si+0a609h],al 
mov al,[0a30ah]
mov [si+0a60ah],al
mov al,[0a30bh]
mov [si+0a60bh],al
mov al,[0a30eh]
mov [si+0a60eh],al 
mov al,[0a30fh]
mov [si+0a60fh],al
mov al,[0a310h]
mov [si+0a610h],al 
mov al,[0a311h]
mov [si+0a611h],al
mov al,[0a312h]
mov [si+0a612h],al
mov al,[0a313h]
mov [si+0a613h],al
mov al,[0a316h]
mov [si+0a616h],al
mov al,[0a317h]
mov [si+0a617h],al
mov al,[0a318h]
mov [si+0a618h],al
mov al,[0a319h]
mov [si+0a619h],al

mov dx,[0f900h]
mov [si+0a61ah],dx




mov dx,[0f990h]
mov [si+0a61ch],dx


mov al,[si+0a6bh]
mov [0a400h],al


mov ax,0100h
mov es,ax
mov bx,0a600h  

mov ah,03h                  ;subroutine calls write 
mov al,01
mov ch,01
mov cl,[0f800h]
mov dh,[0f802h]
mov dl,00
int 13h




jmp start

delete:  
CALL CLEAR_SCREEN

srat2:
 
xor ax,ax
xor dx,dx
xor bx,bx
xor cx,cx
 
mov [0b400h],00
mov [0b401h],00
mov [0b500h],00
mov [0b501h],00
mov [0b600h],00
mov [0f900h],00
mov [0b400h],00
mov [0f800h],00
mov [0f802h],00
mov [0b270h],00    
mov [0b272h],00                 
mov [0b273h],00
mov [0b274h],00

mov [0b601h],00


CALL CLEAR_SCREEN
PRINT " SECTOR NUMBER"

mov ah,00
int 16h


mov [0b400h],al                                               
sub [0b400h],30h                                                    
mov bl,[0b400h]
mov ax,100
mul bl
mov [0b401h],ax          ;chs
mov dx,[0b401h]
                          

mov ah,00
int 16h
mov [0b500h],al
sub [0b500h],30h
mov bl,[0b500h]
mov ax,10
mul bl
mov [0b501h],ax
mov cx,[0b501h]


mov ah,00
int 16h
mov [0b600h],al
sub [0b600h],30h
mov bx,[0b600h]                      

add dx,cx
add dx,bx  

mov ax,dx 
cmp dx,21h
jl srat2

xor bx,bx
mov bl,31
sub ax,bx 
mov si,ax 
xor ax,ax
mov ax,dx
mov bl,12h
div bl
mov [0b270h],al
mov bh,ah
xor ax,ax
mov al,bh
xor bx,bx
mov bl,09
div bl
mov [0b272h],al 
mov [0b273h],ah
mov di,[0b273h]
xor ax,ax
mov al,[0b273h]    
xor bx,bx
mov bl,09
div bl
mov [0b274h],ah


cmp [0a002h+si],00
je error
jne con

error:
print " FILE DOESNT EXIST"
jmp srat2

mov [0b500h],00 
mov [0f990h],00

con:
mov [0f900h],si          ;me dx 
mov [0b400h],si   ;fat entry root entry
mov ax,0100h
mov es,ax
mov bx,0a000h

mov [0a001h+si],15
mov [0a002h+si],00
mov ah,03h
mov al,09
mov ch,00
mov cl,02
mov dh,00
mov dl,00
int 13h            
mov ax,0100h
mov es,ax
mov bx,0e000h


mov ah,02h
mov al,09
mov ch,00
mov cl,02
mov dh,00
mov dl,00
int 13h



                                                             
mov si,00
clear:

mov [si+0d000h],00                                                               
inc si
cmp si,200h      
jne clear 


mov ax,0100h
mov es,ax
mov bx,0d000h      
mov si,00



mov ah,03h                 ; i iporoutina poy kalw to grapsimo tou arxeioy sti disketa
mov al,01
mov ch,[0b270h]
mov cl,[0b274h]
mov dh,[0b272h]
mov dl,00
int 13h 

mov ax,0100h
mov es,ax
mov bx,0af00h      



mov ah,02h                 ; i iporoutina poy kalw to diavasma tou arxeioy sti disketa
mov al,01
mov ch,[0b270h]
mov cl,[0b274h]
mov dh,[0b272h]
mov dl,00
int 13h   

 

 

mov [0a300h],00

mov [0a301h],00

mov [0a302h],00

mov [0a303h],00

mov [0a304h],00

mov [0a305h],00

mov [0a306h],00

mov [0a307h],00

mov [0a308h],00

mov [0a309h],00 

mov [0a30ah],00

mov [0a30bh],00
mov [0a30eh],00
mov [0a30fh],00
mov [0a310h],00
mov [0a311h],00
mov [0a312h],00
mov [0a313h],00
mov [0a316h],00
mov [0a317h],00
mov [0a318h],00
mov [0a319h],00

mov [0a312h],00
mov [0a316h],00
mov [0a317h],00




  
mov ah,2          
mov dh,6
mov dl,0
mov bh,0
int 10h  
ROOTENTRY2:
call clear_screen
print " ROOT ENTRY 0 - 13"



mov ah,00
int 16h
sub al,30h
mov bl,10
mul bl
mov [0a203h],al
mov ah,00
int 16h
sub al,30h
mov [0a205h],al
mov bh,[0a203h]
mov bl,[0a205h]
add bh,bl
cmp bh,00
je roott1   
cmp bh,01 
je rooott
cmp bh,02 
je rooott1
cmp bh,03 
je rooott2
cmp bh,04 
je rooott3
cmp bh,05 
je rooott4
cmp bh,06 
je rooott5
cmp bh,07 
je rooott6
cmp bh,08 
je rooott7
cmp bh,09 
je rooott8
cmp bh,10 
je rooott9
cmp bh,11 
je rooott10
cmp bh,12 
je rooott11
cmp bh,13 
je rooott12
jnle ROOTENTRY2


roott1:   
mov [0f800h],02
mov [0f802h],00
jmp root001

rooott:
mov [0f800h],03
mov [0f802h],00
jmp root001   



rooott1:
mov [0f800h],04
mov [0f802h],00
jmp root001  


rooott2:
mov [0f800h],05
mov [0f802h],00
jmp root001  


rooott3:
mov [0f800h],06
mov [0f802h],00
jmp root001 


rooott4:
mov [0f800h],07
mov [0f802h],00
jmp root001  


rooott5:
mov [0f800h],08
mov [0f802h],00
jmp root001  


rooott6:
mov [0f800h],09
mov [0f802h],00
jmp root001 


rooott7:
mov [0f800h],01
mov [0f802h],01
jmp root001 


rooott8:
mov [0f800h],02
mov [0f802h],01
jmp root001  


rooott9:
mov [0f800h],03
mov [0f802h],01
jmp root001 


rooott10:
mov [0f800h],04
mov [0f802h],01
jmp root001  


rooott11:
mov [0f800h],05
mov [0f802h],01
jmp root001 


rooott12:
mov [0f800h],06
mov [0f802h],01
jmp root001

root001:
  
mov ah,2          
mov dh,8
mov dl,0
mov bh,0
int 10h
call clear_screen
print " ROOT POSITION 0 - 15"

ROOT0001:  
mov ah,00
int 16h
mov [0a500h],al
sub [0a500h],30h
mov bl,[0a500h]
cmp bl,02h



jnl ROOT0001

mov ah,00
int 16h
mov [0a501h],al
sub [0a501h],30h
mov bl,[0a500h]
mov ax,10
mul bl
mov [0a502h],ax
mov bl,[0a502h]
mov cl,[0a501h]
add cl,bl
mov [0a503h],cl

cmp cl,16h
jnl root001  
mov ax,20h
mul cl
mov si,ax


 
mov al,[0a300h]
mov [si+0a600h],00
mov al,[0a301h]
mov [si+0a601h],00
mov al,[0a302h]
mov [si+0a602h],00
mov al,[0a303h]
mov [si+0a603h],00
mov al,[0a304h]
mov [si+0a604h],00
mov al,[0a305h]
mov [si+0a605h],00
mov al,[0a306h]
mov [si+0a606h],00
mov al,[0a307h]
mov [si+0a607h],00
mov al,[0a308h]
mov [si+0a608h],00
mov al,[0a309h]
mov [si+0a609h],00 
mov al,[0a30ah]
mov [si+0a60ah],00
mov al,[0a30bh]
mov [si+0a60bh],00
mov al,[0a30eh]
mov [si+0a60eh],00
mov al,[0a30fh]
mov [si+0a60fh],00
mov al,[0a310h]
mov [si+0a610h],00
mov al,[0a311h]
mov [si+0a611h],00
mov al,[0a312h]
mov [si+0a612h],00
mov al,[0a313h]
mov [si+0a613h],00
mov al,[0a316h]
mov [si+0a616h],00
mov al,[0a317h]
mov [si+0a617h],00
mov al,[0a318h]
mov [si+0a618h],00
mov al,[0a319h]
mov [si+0a619h],00
mov [si+0a60ah],00
mov [si+0a609h],00
mov [si+0a61ah],00
mov [si+0a61bh],00
mov [si+0a608h],00
mov [si+0a60bh],00
mov [si+0a60eh],00
mov [si+0a60fh],00
mov [si+0a616h],00  
mov [si+0a612h],00



mov [si+0a61ch],00
mov [si+0a61dh],00




mov ax,0100h
mov es,ax
mov bx,0a600h  

mov ah,03h                  
mov al,01
mov ch,01
mov cl,[0f800h]
mov dh,[0f802h]
mov dl,00
int 13h


jmp start




rename:   
CALL CLEAR_SCREEN

srat3:


xor ax,ax
xor dx,dx
xor bx,bx
xor cx,cx
xor si,si 
mov [0b400h],00
mov [0b401h],00
mov [0b500h],00
mov [0b501h],00
mov [0b600h],00
mov [0f900h],00
mov [0b400h],00
mov [0f800h],00
mov [0f802h],00
mov [0b270h],00    
mov [0b272h],00                 
mov [0b273h],00
mov [0b274h],00
mov [0b601h],00


CALL CLEAR_SCREEN
PRINT " SECTOR NUMBER"


mov ah,00
int 16h


mov [0b400h],al                                               
sub [0b400h],30h                                                    
mov bl,[0b400h]
mov ax,100
mul bl
mov [0b401h],ax          ;chs
mov dx,[0b401h]









                                      

mov ah,00
int 16h
mov [0b500h],al
sub [0b500h],30h
mov bl,[0b500h]
mov ax,10
mul bl
mov [0b501h],ax
mov cx,[0b501h]






mov ah,00
int 16h
mov [0b600h],al
sub [0b600h],30h
mov bx,[0b600h]                      

add dx,cx
add dx,bx  

mov ax,dx 
cmp dx,21h
jl srat3

xor bx,bx
mov bl,31
sub ax,bx 
mov si,ax
mov [0f900h],si 

cmp [0a002h+si],00
je error0
jne conn

error0:
print " FILE DOESNT EXIST"
jmp srat3


conn:   

mov ah,2    ; "ROOT"     
mov dh,4
mov dl,0
mov bh,0
int 10h 
call clear_screen
print " NAME 8 bytes AND EXTENSION 3 bytes"
 
mov ah,00
int 16h
mov [0a300h],al
mov ah,00
int 16h
mov [0a301h],al
mov ah,00
int 16h
mov [0a302h],al
mov ah,00
int 16h
mov [0a303h],al
mov ah,00
int 16h
mov [0a304h],al
mov ah,00
int 16h
mov [0a305h],al
mov ah,00
int 16h
mov [0a306h],al
mov ah,00
int 16h
mov [0a307h],al
mov ah,00
int 16h
mov [0a308h],al
mov ah,00
int 16h
mov [0a309h],al 
mov ah,00
int 16h
mov [0a30ah],al
ROOTENTRY0:
call clear_screen
print " ROOT ENTRY 0 - 13"


 
 mov ah,00
int 16h
sub al,30h
mov bl,10
mul bl
mov [0a203h],al
mov ah,00
int 16h
sub al,30h
mov [0a205h],al
mov bh,[0a203h]
mov bl,[0a205h]
add bh,bl
cmp bh,00
je erooot1   
cmp bh,01 
je roooot
cmp bh,02 
je roooot1
cmp bh,03 
je roooot2
cmp bh,04 
je roooot3
cmp bh,05 
je roooot4
cmp bh,06 
je roooot5
cmp bh,07 
je roooot6
cmp bh,08 
je roooot7
cmp bh,09 
je roooot8
cmp bh,10 
je roooot9
cmp bh,11 
je roooot10
cmp bh,12 
je roooot11
cmp bh,13 
je roooot12
jnle ROOTENTRY0






erooot1:   
mov [0f800h],02
mov [0f802h],00
jmp root111

roooot:
mov [0f800h],03
mov [0f802h],00
jmp root111   



roooot1:
mov [0f800h],04
mov [0f802h],00
jmp root111 


roooot2:
mov [0f800h],05
mov [0f802h],00
jmp root111  


roooot3:
mov [0f800h],06
mov [0f802h],00
jmp root111  


roooot4:
mov [0f800h],07
mov [0f802h],00
jmp root111  


roooot5:
mov [0f800h],08
mov [0f802h],00
jmp root111  


roooot6:
mov [0f800h],09
mov [0f802h],00
jmp root111  


roooot7:
mov [0f800h],01
mov [0f802h],01
jmp root111

roooot8:
mov [0f800h],02
mov [0f802h],01
jmp root111  


roooot9:
mov [0f800h],03
mov [0f802h],01
jmp root111  


roooot10:
mov [0f800h],04
mov [0f802h],01
jmp root111  


roooot11:
mov [0f800h],05
mov [0f802h],01
jmp root111

roooot12:
mov [0f800h],06
mov [0f802h],01
jmp root111

root111:
  
mov ah,2          
mov dh,8
mov dl,0
mov bh,0
int 10h
call clear_screen
print " ROOT POSITION 0 - 15"

loop101:  
mov ah,00
int 16h
mov [0a500h],al
sub [0a500h],30h
mov bl,[0a500h]
cmp bl,02h



jnl loop101

mov ah,00
int 16h
mov [0a501h],al
sub [0a501h],30h
mov bl,[0a500h]
mov ax,10
mul bl
mov [0a502h],ax
mov bl,[0a502h]
mov cl,[0a501h]
add cl,bl
mov [0a503h],cl

cmp cl,16h
jnl loop101  
mov ax,20h
mul cl
mov si,ax


mov al,[0a300h]
mov [si+0a600h],al
mov al,[0a301h]
mov [si+0a601h],al
mov al,[0a302h]
mov [si+0a602h],al
mov al,[0a303h]
mov [si+0a603h],al
mov al,[0a304h]
mov [si+0a604h],al
mov al,[0a305h]
mov [si+0a605h],al
mov al,[0a306h]
mov [si+0a606h],al
mov al,[0a307h]
mov [si+0a607h],al
mov al,[0a308h]
mov [si+0a608h],al
mov al,[0a309h]
mov [si+0a609h],al 
mov al,[0a30ah]
mov [0a60ah],al

mov dx,[0f900h]
mov [si+0a61ah],dx

mov ax,0100h
mov es,ax
mov bx,0a600h  

mov ah,03h                  
mov al,01
mov ch,01
mov cl,[0f800h]
mov dh,[0f802h]
mov dl,00
int 13h




jmp start     




;-------------------------------------------





change:      
CALL CLEAR_SCREEN


srat4:


xor ax,ax
xor dx,dx
xor bx,bx
xor cx,cx
xor si,si 
mov [0b400h],00
mov [0b401h],00
mov [0b500h],00
mov [0b501h],00
mov [0b600h],00
mov [0f900h],00
mov [0b400h],00
mov [0f800h],00
mov [0f802h],00
mov [0b270h],00    
mov [0b272h],00                 
mov [0b273h],00
mov [0b274h],00

mov [0b601h],00

CALL CLEAR_SCREEN
PRINT " SECTOR NUMBER"
mov ah,00
int 16h


mov [0b400h],al                                               
sub [0b400h],30h                                                    
mov bl,[0b400h]
mov ax,100
mul bl
mov [0b401h],ax          ;chs
mov dx,[0b401h]









                                      

mov ah,00
int 16h
mov [0b500h],al
sub [0b500h],30h
mov bl,[0b500h]
mov ax,10
mul bl
mov [0b501h],ax
mov cx,[0b501h]






mov ah,00
int 16h
mov [0b600h],al
sub [0b600h],30h
mov bx,[0b600h]                      

add dx,cx
add dx,bx
mov [0b400h],dx   ;fat entry root entry
mov ax,dx 
cmp dx,21h

cmp dx,2cfh

xor bx,bx
mov bl,31
sub ax,bx 
mov si,ax
mov [0f900h],si


cmp [0a002h+si],00
je error001
jne conn0

error001:
print " FILE DOESNT EXIST"
jmp srat4



error01:
print " FILE DOESNT EXIST"
jmp srat4


conn0:

call clear_screen 
PRINT " CHOOSE PROPERTIES" 
mov ah,2          
mov dh,1
mov dl,0
mov bh,0
int 10h
print " 1) HIDDEN 0"
mov ah,2          
mov dh,2
mov dl,0
mov bh,0
int 10h 
PRINT " 2) SYSTEM 1"
mov ah,2          
mov dh,3
mov dl,0
mov bh,0
int 10h 
PRINT " 3) VOLUME LABEL 2"
mov ah,2          
mov dh,4
mov dl,0
mov bh,0
int 10h 
PRINT " 4) SUBDIRECTORY 3"
mov ah,2          
mov dh,5
mov dl,0
mov bh,0
int 10h 
PRINT " 5) ARCHIVE 4"
mov ah,2          
mov dh,6
mov dl,0
mov bh,0
int 10h 
PRINT " 6) HIDDEN SUBDIRECTORY 5"
mov ah,2          
mov dh,7
mov dl,0
mov bh,0
int 10h 
PRINT " 7) HIDDEN ARCHIVE 6"
MOV AH,00
INT 16H
cmp al,30h
je hidden
cmp al,31h
je system
cmp al,32h
je volume
cmp al,33h
je subd
cmp al,34h
je archive
cmp al,35h
je hsub
cmp al,36h
je harc
jnle conn

hidden:
mov [0a30bh],02h
jmp Rten


system:
mov [0a30bh],04h
jmp Rten

volume:
mov [0a30bh],08h
jmp Rten
 
subd:
mov [0a30bh],10h
jmp Rten

archive:
mov [0a30bh],20
jmp Rten

hsub:
mov [0a30bh],12h
jmp Rten

harc:
mov [0a30bh],22h
jmp Rten



Rten:
call clear_screen
print " ROOT ENTRY 0 - 13"




 mov ah,00
int 16h
sub al,30h
mov bl,10
mul bl
mov [0a203h],al
mov ah,00
int 16h
sub al,30h
mov [0a205h],al
mov bh,[0a203h]
mov bl,[0a205h]
add bh,bl
cmp bh,00
je root1   
cmp bh,01 
je rooot
cmp bh,02 
je rooot1
cmp bh,03 
je rooot2
cmp bh,04 
je rooot3
cmp bh,05 
je rooot4
cmp bh,06 
je rooot5
cmp bh,07 
je rooot6
cmp bh,08 
je rooot7
cmp bh,09 
je rooot8
cmp bh,10 
je rooot9
cmp bh,11 
je rooot10
cmp bh,12 
je rooot11
cmp bh,13 
je rooot12
jnle Rten






root01:   
mov [0f800h],02
mov [0f802h],00
jmp root711

rooot00:
mov [0f800h],03
mov [0f802h],00
jmp root711   



rooot01:
mov [0f800h],04
mov [0f802h],00
jmp root711  


rooot02:
mov [0f800h],05
mov [0f802h],00
jmp root711  


rooot03:
mov [0f800h],06
mov [0f802h],00
jmp root711  


rooot04:
mov [0f800h],07
mov [0f802h],00
jmp root711  


rooot05:
mov [0f800h],08
mov [0f802h],00
jmp root711  


rooot06:
mov [0f800h],09
mov [0f802h],00
jmp root711  


rooot07:
mov [0f800h],01
mov [0f802h],01
jmp root711 


rooot08:
mov [0f800h],02
mov [0f802h],01
jmp root711  


rooot09:
mov [0f800h],03
mov [0f802h],01
jmp root711 


rooot010:
mov [0f800h],04
mov [0f802h],01
jmp root711  


rooot011:
mov [0f800h],05
mov [0f802h],01
jmp root711  


rooot012:
mov [0f800h],06
mov [0f802h],01
jmp root711


root711:
  
mov ah,2          
mov dh,8
mov dl,0
mov bh,0
int 10h
call clear_screen
print " ROOT POSITION 0 - 15"

loop51:  
mov ah,00
int 16h
mov [0a500h],al
sub [0a500h],30h
mov bl,[0a500h]
cmp bl,02h



jnl loop51

mov ah,00
int 16h
mov [0a501h],al
sub [0a501h],30h
mov bl,[0a500h]
mov ax,10
mul bl
mov [0a502h],ax
mov bl,[0a502h]
mov cl,[0a501h]
add cl,bl
mov [0a503h],cl

cmp cl,16h
jnl root711  
mov ax,20h
mul cl
mov si,ax



mov al,[0a30bh]
mov [si+0a60bh],al

mov dx,[0f900h]
mov [si+0a61ah],dx


mov ax,0100h
mov es,ax
mov bx,0a600h  

mov ah,03h                  
mov al,01
mov ch,01
mov cl,[0f800h]
mov dh,[0f802h]
mov dl,00
int 13h



jmp start


fat:
mov ax,0100h
mov es,ax
mov bx,0a000h

mov [0a000h+si],240
mov [0a001h+si],255 
mov [0a002h+si],255
mov ah,03h
mov al,09
mov ch,00
mov cl,02
mov dh,00
mov dl,00
int 13h           
mov ax,0100h
mov es,ax                                                                                                                                                                                                     
mov bx,0e000h


mov ah,02h
mov al,09
mov ch,00
mov cl,02
mov dh,00
mov dl,00
int 13h         
jmp welcome


rot:     
MOV [0A205H],00
MOV [0A203H],00
CALL CLEAR_sCREEN
PRINT " ROOT ENTRY 00 - 13"

mov ah,00
int 16h
sub al,30h
mov bl,10
mul bl
mov [0a203h],al
mov ah,00
int 16h
sub al,30h
mov [0a205h],al
mov bh,[0a203h]
mov bl,[0a205h]
add bh,bl
cmp bh,00
JE ROT1

CMP bh,01
JE ROT2

CMP bh,02
JE ROT3

CMP bh,03
JE ROT4

CMP bh,04
JE ROT5

CMP bh,05
JE ROT6

CMP bh,06
JE ROT7

CMP bh,07
JE ROT8

CMP bh,08
JE ROT9

CMP bh,09
JE ROT10

CMP bh,10
JE ROT11

CMP bh,11
JE ROT12

CMP bh,12
JE ROT13

CMP bh,13
JE ROT14













ROT1:
mov ax,0100h
mov es,ax
mov bx,0f000h  

mov ah,02h                  
mov al,01
mov ch,01
mov cl,02
mov dh,00
mov dl,00
int 13h

jmp welcome

ROT2:
mov ax,0100h
mov es,ax
mov bx,0f000h  

mov ah,02h                  
mov al,01
mov ch,01
mov cl,03
mov dh,00
mov dl,00
int 13h

jmp welcome

ROT3:
mov ax,0100h
mov es,ax
mov bx,0f000h  

mov ah,02h                  
mov al,01
mov ch,01
mov cl,04
mov dh,00
mov dl,00
int 13h

jmp welcome

ROT4:
mov ax,0100h
mov es,ax
mov bx,0f000h  

mov ah,02h                  
mov al,01
mov ch,01
mov cl,05
mov dh,00
mov dl,00
int 13h

jmp welcome

ROT5:
mov ax,0100h
mov es,ax
mov bx,0f000h  

mov ah,02h                 
mov al,01
mov ch,01
mov cl,06
mov dh,00
mov dl,00
int 13h

jmp welcome

ROT6:
mov ax,0100h
mov es,ax
mov bx,0f000h  

mov ah,02h                  
mov al,01
mov ch,01
mov cl,07
mov dh,00
mov dl,00
int 13h

jmp welcome

ROT7:
mov ax,0100h
mov es,ax
mov bx,0f000h  

mov ah,02h                  
mov al,01
mov ch,01
mov cl,08
mov dh,00
mov dl,00
int 13h

jmp welcome


ROT8:
mov ax,0100h
mov es,ax
mov bx,0f000h  

mov ah,02h                  
mov al,01
mov ch,01
mov cl,09
mov dh,00
mov dl,00
int 13h

jmp welcome



ROT9:
mov ax,0100h
mov es,ax
mov bx,0f000h  

mov ah,02h                  
mov al,01
mov ch,01
mov cl,01
mov dh,01
mov dl,00
int 13h

jmp welcome

ROT10:
mov ax,0100h
mov es,ax
mov bx,0f000h  

mov ah,02h                  
mov al,01
mov ch,01
mov cl,02
mov dh,01
mov dl,00
int 13h

jmp welcome


ROT11:
mov ax,0100h
mov es,ax
mov bx,0f000h  

mov ah,02h                  
mov al,01
mov ch,01
mov cl,03
mov dh,01
mov dl,00
int 13h

jmp welcome


ROT12:
mov ax,0100h
mov es,ax
mov bx,0f000h  

mov ah,02h                  
mov al,01
mov ch,01
mov cl,04
mov dh,01
mov dl,00
int 13h

jmp welcome

ROT13:
mov ax,0100h
mov es,ax
mov bx,0f000h  

mov ah,02h                  
mov al,01
mov ch,01
mov cl,05
mov dh,01
mov dl,00
int 13h

jmp welcome

ROT14:
mov ax,0100h
mov es,ax
mov bx,0f000h  

mov ah,02h                 
mov al,01
mov ch,01
mov cl,06
mov dh,01
mov dl,00
int 13h

jmp welcome












end:
call clear_screen
print " THANK YOU FOR YOUR TIME"
HLT
