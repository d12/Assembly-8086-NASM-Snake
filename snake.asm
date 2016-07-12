; Snake!
[BITS 16]

section .bss
  x_coord   RESW 4 ; [x_coord] is the head, [x_coord+2] is the next cell, etc.
  y_coord   RESW 4 ; Same here

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

SetInitialCoords:
  MOV AX, 0x0F ; Initial x/y coord
  MOV [x_coord], AX
  MOV [y_coord], AX
  MOV AX, 0x00
  MOV [x_coord+2], AX
  MOV [y_coord+2], AX
  MOV [x_coord+4], AX
  MOV [y_coord+4], AX
  MOV [x_coord+6], AX
  MOV [y_coord+6], AX
  RET

ListenForInput:  ;Repeatedly check for keyboard input, print if available
  MOV AH, 0x00 ; Set AH to 0 to lock when listening for key
  MOV AL, 0x00 ; Set last key to 0
  INT 0x16   ; Listen for a keypress, save to register AL
  
  CALL InterpretKeypress

  CALL ListenForInput
  RET

InterpretKeypress:
  CMP AL, 0x77
  JE .w_pressed

  CMP AL, 0x61
  JE .a_pressed

  CMP AL, 0x73
  JE .s_pressed

  CMP AL, 0x64
  JE .d_pressed
  CALL Debug
  RET ; Invalid keypress, start listening again

  .w_pressed
  MOV AX, [x_coord]
  MOV BX, [y_coord]
  DEC BX
  JMP .after_control_handle

  .a_pressed
  MOV AX, [x_coord]
  MOV BX, [y_coord]
  DEC AX
  JMP .after_control_handle

  .s_pressed
  MOV AX, [x_coord]
  MOV BX, [y_coord]
  INC BX
  JMP .after_control_handle
  
  .d_pressed
  MOV AX, [x_coord]
  MOV BX, [y_coord]
  INC AX
 
  .after_control_handle
  CALL ShiftArray
  CALL DrawSnake
  RET

DrawSnake:
  MOV AL, 0x0A ; Color
 
  MOV DX, [x_coord]
  MOV CX, [y_coord]
  CMP CX, 0x00
  JE .skip
  CALL DrawPixel

  MOV AL, 0x0F
  MOV DX, [x_coord+2]
  MOV CX, [y_coord+2]
  CMP CX, 0x00
  JE .skip
  CALL DrawPixel

  MOV AL, 0x0C
  MOV DX, [x_coord+4]
  MOV CX, [y_coord+4]
  CMP CX, 0x00
  JE .skip
  CALL DrawPixel

  MOV AL, 0x0E
  MOV DX, [x_coord+6]
  MOV CX, [y_coord+6]
  CMP CX, 0x00
  JE .skip
  CALL DrawPixel

  .skip
  RET

ShiftArray:
  MOV DX, [x_coord+6]
  MOV CX, [y_coord+6]
  MOV AL, 0x00
  CALL DrawPixel ;Erase last pixel

  MOV DX, [x_coord+4]
  MOV [x_coord+6], DX
  MOV DX, [x_coord+2]
  MOV [x_coord+4], DX
  MOV DX, [x_coord]
  MOV [x_coord+2], DX
  MOV [x_coord], AX

  MOV DX, [y_coord+4]
  MOV [y_coord+6], DX
  MOV DX, [y_coord+2]
  MOV [y_coord+4], DX
  MOV DX, [y_coord]
  MOV [y_coord+2], DX
  MOV [y_coord], BX

DrawPixel:
  MOV AH, 0x0C     ; Draw mode
  MOV BH, 0x00     ; Pg 0
  INT 0x10         ; Draw
  RET

Debug:
  MOV AL, 0x0A
  MOV CX, 0x00
  MOV DX, 0x00
  CALL DrawPixel

TIMES 510 - ($ - $$) db 0  ;Fill the rest of sector with 0
DW 0xAA55      ;Add boot signature at the end of bootloader
