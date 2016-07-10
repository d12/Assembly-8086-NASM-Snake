; Snake!
[BITS 16]

section .bss
  xcoord RESB 2
  ycoord RESB 2

section  .text
  global_start 

_start:
  CALL SetVideoMode
  CALL SetInitialCoords
  CALL ListenForInput

SetVideoMode:
  MOV AH, 0x00
  MOV AL, 0x13
  INT 0x10
  RET

SetInitialCoords
  MOV AX, 0x0F ; Initial x/y coord
  MOV [xcoord], AX
  MOV [ycoord], AX
  RET

ListenForInput:  ;Repeatedly check for keyboard input, print if available
  MOV AH, 0x00 ; Set AH to 0 to lock when listening for key
  MOV AL, 0x00 ; Set last key to 0
  INT 0x16   ; Listen for a keypress, save to register AL
  
  CALL DrawPixel

  CALL ListenForInput
  RET

DrawPixel:
  MOV AH, 0x0C     ; Draw mode
  MOV BH, 0x00     ; Pg 0
  MOV DX, [xcoord]
  MOV CX, [ycoord]
  MOV AL, 0x0A     ; Color
  INT 0x10         ; Draw

  ADD DX, 0x01    
  ADD CX, 0x01
  MOV [xcoord], DX
  MOV [ycoord], CX
  RET

TIMES 510 - ($ - $$) db 0  ;Fill the rest of sector with 0
DW 0xAA55      ;Add boot signature at the end of bootloader
