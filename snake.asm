; Snake!
[BITS 16]

section .bss
  x_coord   RESB 8 ; [x_coord] is the head, [x_coord+2] is the next cell, etc.
  y_coord   RESB 8 ; Same here

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
  JE .s_pressed

  RET ; Invalid keypress, start listening again

  MOV AX, [x_coord]
  MOV BX, [y_coord]

  .w_pressed
  DEC BX
  JMP .after_control_handle

  .a_pressed
  DEC AX
  JMP .after_control_handle

  .s_pressed
  INC BX
  JMP .after_control_handle
  
  .d_pressed
  INC AX
 
  .after_control_handle
  CALL ShiftArray
  CALL ClearScreen
  CALL DrawSnake
  RET

DrawSnake:
  MOV DX, [x_coord]
  MOV CX, [y_coord]
  CALL DrawPixel

  MOV DX, [x_coord+2]
  MOV CX, [y_coord+2]
  CALL DrawPixel

  MOV DX, [x_coord+4]
  MOV CX, [y_coord+4]
  CALL DrawPixel

  MOV DX, [x_coord+6]
  MOV CX, [y_coord+6]
  CALL DrawPixel
  RET

ShiftArray:
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
  MOV [y_coord], AX

ClearScreen:
  MOV AH, 0x06  ; Scroll mode
  MOV AL, 0x00  ; Clear screen
  INT 0x10      ; Interupt
  RET

DrawPixel:
  MOV AH, 0x0C     ; Draw mode
  MOV BH, 0x00     ; Pg 0
  MOV AL, 0x0A     ; Color
  INT 0x10         ; Draw
  RET

TIMES 510 - ($ - $$) db 0  ;Fill the rest of sector with 0
DW 0xAA55      ;Add boot signature at the end of bootloader
