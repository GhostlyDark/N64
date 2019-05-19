// N64 'Bare Metal' CPU Unsigned Doubleword Division Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CPUDDIVU.N64", create
fill 1052672 // Set ROM Size

// Setup Frame Buffer
constant SCREEN_X(640)
constant SCREEN_Y(480)
constant BYTES_PER_PIXEL(4)

// Setup Characters
constant CHAR_X(8)
constant CHAR_Y(8)

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

macro PrintString(vram, xpos, ypos, fontfile, string, length) { // Print Text String To VRAM Using Font At X,Y Position
  li a0,{vram}+({xpos}*BYTES_PER_PIXEL)+(SCREEN_X*BYTES_PER_PIXEL*{ypos}) // A0 = Frame Buffer Pointer (Place text at XY Position)
  la a1,{fontfile} // A1 = Characters
  la a2,{string} // A2 = Text Offset
  ori t0,r0,{length} // T0 = Number of Text Characters to Print
  {#}DrawChars:
    ori t1,r0,CHAR_X-1 // T1 = Character X Pixel Counter
    ori t2,r0,CHAR_Y-1 // T2 = Character Y Pixel Counter

    lb t3,0(a2) // T3 = Next Text Character
    addi a2,1

    sll t3,8 // Add Shift to Correct Position in Font (*256: CHAR_X*CHAR_Y*BYTES_PER_PIXEL)
    add t3,a1

    {#}DrawCharX:
      lw t4,0(t3) // Load Font Text Character Pixel
      addi t3,BYTES_PER_PIXEL
      sw t4,0(a0) // Store Font Text Character Pixel into Frame Buffer
      addi a0,BYTES_PER_PIXEL

      bnez t1,{#}DrawCharX // IF (Character X Pixel Counter != 0) DrawCharX
      subi t1,1 // Decrement Character X Pixel Counter

      addi a0,(SCREEN_X*BYTES_PER_PIXEL)-CHAR_X*BYTES_PER_PIXEL // Jump Down 1 Scanline, Jump Back 1 Char
      ori t1,r0,CHAR_X-1 // Reset Character X Pixel Counter
      bnez t2,{#}DrawCharX // IF (Character Y Pixel Counter != 0) DrawCharX
      subi t2,1 // Decrement Character Y Pixel Counter

    subi a0,((SCREEN_X*BYTES_PER_PIXEL)*CHAR_Y)-CHAR_X*BYTES_PER_PIXEL // Jump To Start Of Next Char
    bnez t0,{#}DrawChars // Continue to Print Characters
    subi t0,1 // Subtract Number of Text Characters to Print
}

macro PrintValue(vram, xpos, ypos, fontfile, value, length) { // Print HEX Chars To VRAM Using Font At X,Y Position
  li a0,{vram}+({xpos}*BYTES_PER_PIXEL)+(SCREEN_X*BYTES_PER_PIXEL*{ypos}) // A0 = Frame Buffer Pointer (Place text at XY Position)
  la a1,{fontfile} // A1 = Characters
  la a2,{value} // A2 = Value Offset
  li t0,{length} // T0 = Number of HEX Chars to Print
  {#}DrawHEXChars:
    ori t1,r0,CHAR_X-1 // T1 = Character X Pixel Counter
    ori t2,r0,CHAR_Y-1 // T2 = Character Y Pixel Counter

    lb t3,0(a2) // T3 = Next 2 HEX Chars
    addi a2,1

    srl t4,t3,4 // T4 = 2nd Nibble
    andi t4,$F
    subi t5,t4,9
    bgtz t5,{#}HEXLetters
    addi t4,$30 // Delay Slot
    j {#}HEXEnd
    nop // Delay Slot

    {#}HEXLetters:
    addi t4,7
    {#}HEXEnd:

    sll t4,8 // Add Shift to Correct Position in Font (*256: CHAR_X*CHAR_Y*BYTES_PER_PIXEL)
    add t4,a1

    {#}DrawHEXCharX:
      lw t5,0(t4) // Load Font Text Character Pixel
      addi t4,4
      sw t5,0(a0) // Store Font Text Character Pixel into Frame Buffer
      addi a0,4

      bnez t1,{#}DrawHEXCharX // IF (Character X Pixel Counter != 0) DrawCharX
      subi t1,1 // Decrement Character X Pixel Counter

      addi a0,(SCREEN_X*BYTES_PER_PIXEL)-CHAR_X*BYTES_PER_PIXEL // Jump down 1 Scanline, Jump back 1 Char
      ori t1,r0,CHAR_X-1 // Reset Character X Pixel Counter
      bnez t2,{#}DrawHEXCharX // IF (Character Y Pixel Counter != 0) DrawCharX
      subi t2,1 // Decrement Character Y Pixel Counter

    subi a0,((SCREEN_X*BYTES_PER_PIXEL)*CHAR_Y)-CHAR_X*BYTES_PER_PIXEL // Jump To Start Of Next Char

    ori t2,r0,CHAR_Y-1 // Reset Character Y Pixel Counter

    andi t4,t3,$F // T4 = 1st Nibble
    subi t5,t4,9
    bgtz t5,{#}HEXLettersB
    addi t4,$30 // Delay Slot
    j {#}HEXEndB
    nop // Delay Slot

    {#}HEXLettersB:
    addi t4,7
    {#}HEXEndB:

    sll t4,8 // Add Shift to Correct Position in Font (*256: CHAR_X*CHAR_Y*BYTES_PER_PIXEL)
    add t4,a1

    {#}DrawHEXCharXB:
      lw t5,0(t4) // Load Font Text Character Pixel
      addi t4,4
      sw t5,0(a0) // Store Font Text Character Pixel into Frame Buffer
      addi a0,4

      bnez t1,{#}DrawHEXCharXB // IF (Character X Pixel Counter != 0) DrawCharX
      subi t1,1 // Decrement Character X Pixel Counter

      addi a0,(SCREEN_X*BYTES_PER_PIXEL)-CHAR_X*BYTES_PER_PIXEL // Jump down 1 Scanline, Jump back 1 Char
      ori t1,r0,CHAR_X-1 // Reset Character X Pixel Counter
      bnez t2,{#}DrawHEXCharXB // IF (Character Y Pixel Counter != 0) DrawCharX
      subi t2,1 // Decrement Character Y Pixel Counter

    subi a0,((SCREEN_X*BYTES_PER_PIXEL)*CHAR_Y)-CHAR_X*BYTES_PER_PIXEL // Jump To Start Of Next Char

    bnez t0,{#}DrawHEXChars // Continue to Print Characters
    subi t0,1 // Subtract Number of Text Characters to Print
}

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(640, 480, BPP32|INTERLACE|AA_MODE_2, $A0100000) // Screen NTSC: 640x480, 32BPP, Interlace, Resample Only, DRAM Origin = $A0100000

  lui a0,$A010 // A0 = VRAM Start Offset
  la a1,$A0100000+((SCREEN_X*SCREEN_Y*BYTES_PER_PIXEL)-BYTES_PER_PIXEL) // A1 = VRAM End Offset
  ori t0,r0,$000000FF // T0 = Black
ClearScreen:
  sw t0,0(a0)
  bne a0,a1,ClearScreen
  addi a0,4 // Delay Slot


  PrintString($A0100000,80,8,FontRed,RSRTHEX,10) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,8,FontRed,RSRTDEC,14) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,8,FontRed,LOHIHEX,10) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,24,FontRed,DDIVU,4) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUELONGA // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,VALUELONGB // A0 = Long Data Offset
  ld t1,0(a0)      // T1 = Long Data
  ddivu t0,t1 // HI/LO = Test Long Data
  mflo t0 // T0 = LO
  la a0,LOLONG // A0 = LOLONG Offset
  sd t0,0(a0)  // LOLONG = Long Data
  mfhi t0 // T0 = HI
  la a0,HILONG // A0 = HILONG Offset
  sd t0,0(a0)  // HILONG = Long Data
  PrintString($A0100000,72,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,24,FontBlack,VALUELONGA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,24,FontBlack,TEXTLONGA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,24,FontBlack,LOLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,72,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,32,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,32,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,32,FontBlack,HILONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,LOLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DDIVULOCHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DDIVULOPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DDIVUENDA
  nop // Delay Slot
  DDIVULOPASSA:
  PrintString($A0100000,528,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HILONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DDIVUHICHECKA // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DDIVUHIPASSA // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DDIVUENDA
  nop // Delay Slot
  DDIVUHIPASSA:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DDIVUENDA:

  la a0,VALUELONGB // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,VALUELONGC // A0 = Long Data Offset
  ld t1,0(a0)      // T1 = Long Data
  ddivu t0,t1 // HI/LO = Test Long Data
  mflo t0 // T0 = LO
  la a0,LOLONG // A0 = LOLONG Offset
  sd t0,0(a0)  // LOLONG = Long Data
  mfhi t0 // T0 = HI
  la a0,HILONG // A0 = HILONG Offset
  sd t0,0(a0)  // HILONG = Long Data
  PrintString($A0100000,72,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,48,FontBlack,VALUELONGB,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,48,FontBlack,TEXTLONGB,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,48,FontBlack,LOLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,72,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,56,FontBlack,VALUELONGC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,56,FontBlack,TEXTLONGC,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,56,FontBlack,HILONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,LOLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DDIVULOCHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DDIVULOPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,48,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DDIVUENDB
  nop // Delay Slot
  DDIVULOPASSB:
  PrintString($A0100000,528,48,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HILONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DDIVUHICHECKB // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DDIVUHIPASSB // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DDIVUENDB
  nop // Delay Slot
  DDIVUHIPASSB:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DDIVUENDB:

  la a0,VALUELONGC // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,VALUELONGD // A0 = Long Data Offset
  ld t1,0(a0)      // T1 = Long Data
  ddivu t0,t1 // HI/LO = Test Long Data
  mflo t0 // T0 = LO
  la a0,LOLONG // A0 = LOLONG Offset
  sd t0,0(a0)  // LOLONG = Long Data
  mfhi t0 // T0 = HI
  la a0,HILONG // A0 = HILONG Offset
  sd t0,0(a0)  // HILONG = Long Data
  PrintString($A0100000,72,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,72,FontBlack,VALUELONGC,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,288,72,FontBlack,TEXTLONGC,9) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,72,FontBlack,LOLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,72,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,80,FontBlack,VALUELONGD,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,80,FontBlack,TEXTLONGD,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,80,FontBlack,HILONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,LOLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DDIVULOCHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DDIVULOPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DDIVUENDC
  nop // Delay Slot
  DDIVULOPASSC:
  PrintString($A0100000,528,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HILONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DDIVUHICHECKC // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DDIVUHIPASSC // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,80,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DDIVUENDC
  nop // Delay Slot
  DDIVUHIPASSC:
  PrintString($A0100000,528,80,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DDIVUENDC:

  la a0,VALUELONGD // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,VALUELONGE // A0 = Long Data Offset
  ld t1,0(a0)      // T1 = Long Data
  ddivu t0,t1 // HI/LO = Test Long Data
  mflo t0 // T0 = LO
  la a0,LOLONG // A0 = LOLONG Offset
  sd t0,0(a0)  // LOLONG = Long Data
  mfhi t0 // T0 = HI
  la a0,HILONG // A0 = HILONG Offset
  sd t0,0(a0)  // HILONG = Long Data
  PrintString($A0100000,72,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,96,FontBlack,VALUELONGD,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,96,FontBlack,TEXTLONGD,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,96,FontBlack,LOLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,72,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,104,FontBlack,VALUELONGE,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,104,FontBlack,TEXTLONGE,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,104,FontBlack,HILONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,LOLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DDIVULOCHECKD // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DDIVULOPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,96,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DDIVUENDD
  nop // Delay Slot
  DDIVULOPASSD:
  PrintString($A0100000,528,96,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HILONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DDIVUHICHECKD // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DDIVUHIPASSD // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DDIVUENDD
  nop // Delay Slot
  DDIVUHIPASSD:
  PrintString($A0100000,528,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DDIVUENDD:

  la a0,VALUELONGE // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,VALUELONGF // A0 = Long Data Offset
  ld t1,0(a0)      // T1 = Long Data
  ddivu t0,t1 // HI/LO = Test Long Data
  mflo t0 // T0 = LO
  la a0,LOLONG // A0 = LOLONG Offset
  sd t0,0(a0)  // LOLONG = Long Data
  mfhi t0 // T0 = HI
  la a0,HILONG // A0 = HILONG Offset
  sd t0,0(a0)  // HILONG = Long Data
  PrintString($A0100000,72,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,120,FontBlack,VALUELONGE,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,120,FontBlack,TEXTLONGE,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,120,FontBlack,LOLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,72,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,128,FontBlack,VALUELONGF,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,280,128,FontBlack,TEXTLONGF,10) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,128,FontBlack,HILONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,LOLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DDIVULOCHECKE // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DDIVULOPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,120,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DDIVUENDE
  nop // Delay Slot
  DDIVULOPASSE:
  PrintString($A0100000,528,120,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HILONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DDIVUHICHECKE // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DDIVUHIPASSE // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DDIVUENDE
  nop // Delay Slot
  DDIVUHIPASSE:
  PrintString($A0100000,528,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DDIVUENDE:

  la a0,VALUELONGF // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,VALUELONGG // A0 = Long Data Offset
  ld t1,0(a0)      // T1 = Long Data
  ddivu t0,t1 // HI/LO = Test Long Data
  mflo t0 // T0 = LO
  la a0,LOLONG // A0 = LOLONG Offset
  sd t0,0(a0)  // LOLONG = Long Data
  mfhi t0 // T0 = HI
  la a0,HILONG // A0 = HILONG Offset
  sd t0,0(a0)  // HILONG = Long Data
  PrintString($A0100000,72,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,144,FontBlack,VALUELONGF,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,280,144,FontBlack,TEXTLONGF,10) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,144,FontBlack,LOLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,72,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,152,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,152,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,152,FontBlack,HILONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,LOLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DDIVULOCHECKF // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DDIVULOPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,144,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DDIVUENDF
  nop // Delay Slot
  DDIVULOPASSF:
  PrintString($A0100000,528,144,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HILONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DDIVUHICHECKF // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DDIVUHIPASSF // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DDIVUENDF
  nop // Delay Slot
  DDIVUHIPASSF:
  PrintString($A0100000,528,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DDIVUENDF:

  la a0,VALUELONGA // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,VALUELONGG // A0 = Long Data Offset
  ld t1,0(a0)      // T1 = Long Data
  ddivu t0,t1 // HI/LO = Test Long Data
  mflo t0 // T0 = LO
  la a0,LOLONG // A0 = LOLONG Offset
  sd t0,0(a0)  // LOLONG = Long Data
  mfhi t0 // T0 = HI
  la a0,HILONG // A0 = HILONG Offset
  sd t0,0(a0)  // HILONG = Long Data
  PrintString($A0100000,72,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,168,FontBlack,VALUELONGA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,168,FontBlack,TEXTLONGA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,168,FontBlack,LOLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,72,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,176,FontBlack,VALUELONGG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,224,176,FontBlack,TEXTLONGG,17) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,176,FontBlack,HILONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,LOLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DDIVULOCHECKG // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DDIVULOPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,168,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DDIVUENDG
  nop // Delay Slot
  DDIVULOPASSG:
  PrintString($A0100000,528,168,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HILONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DDIVUHICHECKG // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DDIVUHIPASSG // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,176,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DDIVUENDG
  nop // Delay Slot
  DDIVUHIPASSG:
  PrintString($A0100000,528,176,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DDIVUENDG:

  la a0,VALUELONGD // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,VALUELONGA // A0 = Long Data Offset
  ld t1,0(a0)      // T1 = Long Data
  ddivu t0,t1 // HI/LO = Test Long Data
  mflo t0 // T0 = LO
  la a0,LOLONG // A0 = LOLONG Offset
  sd t0,0(a0)  // LOLONG = Long Data
  mfhi t0 // T0 = HI
  la a0,HILONG // A0 = HILONG Offset
  sd t0,0(a0)  // HILONG = Long Data
  PrintString($A0100000,72,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,192,FontBlack,VALUELONGD,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,192,FontBlack,TEXTLONGD,16) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,192,FontBlack,LOLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,72,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,200,FontBlack,VALUELONGA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,200,FontBlack,TEXTLONGA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,200,FontBlack,HILONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,LOLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DDIVULOCHECKH // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DDIVULOPASSH // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,192,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DDIVUENDH
  nop // Delay Slot
  DDIVULOPASSH:
  PrintString($A0100000,528,192,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HILONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DDIVUHICHECKH // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DDIVUHIPASSH // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,200,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DDIVUENDH
  nop // Delay Slot
  DDIVUHIPASSH:
  PrintString($A0100000,528,200,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DDIVUENDH:

  la a0,VALUELONGH // A0 = Long Data Offset
  ld t0,0(a0)      // T0 = Long Data
  la a0,VALUELONGA // A0 = Long Data Offset
  ld t1,0(a0)      // T1 = Long Data
  ddivu t0,t1 // HI/LO = Test Long Data
  mflo t0 // T0 = LO
  la a0,LOLONG // A0 = LOLONG Offset
  sd t0,0(a0)  // LOLONG = Long Data
  mfhi t0 // T0 = HI
  la a0,HILONG // A0 = HILONG Offset
  sd t0,0(a0)  // HILONG = Long Data
  PrintString($A0100000,72,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,216,FontBlack,VALUELONGH,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,216,216,FontBlack,TEXTLONGH,18) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,216,FontBlack,LOLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,72,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,80,224,FontBlack,VALUELONGA,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,224,FontBlack,TEXTLONGA,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,224,FontBlack,HILONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,LOLONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DDIVULOCHECKI // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DDIVULOPASSI // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,216,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DDIVUENDI
  nop // Delay Slot
  DDIVULOPASSI:
  PrintString($A0100000,528,216,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  la a0,HILONG        // A0 = Long Data Offset
  ld t0,0(a0)         // T0 = Long Data
  la a0,DDIVUHICHECKI // A0 = Long Check Data Offset
  ld t1,0(a0)         // T1 = Long Check Data
  beq t0,t1,DDIVUHIPASSI // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,224,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DDIVUENDI
  nop // Delay Slot
  DDIVUHIPASSI:
  PrintString($A0100000,528,224,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DDIVUENDI:

  PrintString($A0100000,0,232,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


Loop:
  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank
  WaitScanline($1E2)

  ori t0,r0,$00000800 // Even Field
  sw t0,VI_Y_SCALE(a0)

  WaitScanline($1E0) // Wait For Scanline To Reach Vertical Blank
  WaitScanline($1E2)

  li t0,$02000800 // Odd Field
  sw t0,VI_Y_SCALE(a0)

  j Loop
  nop // Delay Slot

DDIVU:
  db "DDIVU"

LOHIHEX:
  db "LO/HI (Hex)"
RSRTHEX:
  db "RS/RT (Hex)"
RSRTDEC:
  db "RS/RT (Decimal)"
TEST:
  db "Test Result"
FAIL:
  db "FAIL"
PASS:
  db "PASS"

DOLLAR:
  db "$"

TEXTLONGA:
  db "0"
TEXTLONGB:
  db "12345678967891234"
TEXTLONGC:
  db "1234567895"
TEXTLONGD:
  db "12345678912345678"
TEXTLONGE:
  db "123456789123456789"
TEXTLONGF:
  db "12345678956"
TEXTLONGG:
  db "123456789678912345"
TEXTLONGH:
  db "9876543219876543210"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

align(8) // Align 64-Bit
VALUELONGA:
  dd 0
VALUELONGB:
  dd 12345678967891234
VALUELONGC:
  dd 1234567895
VALUELONGD:
  dd 12345678912345678
VALUELONGE:
  dd 123456789123456789
VALUELONGF:
  dd 12345678956
VALUELONGG:
  dd 123456789678912345
VALUELONGH:
  dd 9876543219876543210

DDIVULOCHECKA:
  dd $0000000000000000
DDIVUHICHECKA:
  dd $0000000000000000
DDIVULOCHECKB:
  dd $0000000000989680
DDIVUHICHECKB:
  dd $000000000110FFA2
DDIVULOCHECKC:
  dd $0000000000000000
DDIVUHICHECKC:
  dd $00000000499602D7
DDIVULOCHECKD:
  dd $0000000000000000
DDIVUHICHECKD:
  dd $002BDC545E14D64E
DDIVULOCHECKE:
  dd $000000000098967F
DDIVUHICHECKE:
  dd $00000002C5D6FD81
DDIVULOCHECKF:
  dd $0000000000000000
DDIVUHICHECKF:
  dd $00000002DFDC1C6C
DDIVULOCHECKG:
  dd $0000000000000000
DDIVUHICHECKG:
  dd $0000000000000000
DDIVULOCHECKH:
  dd $FFFFFFFFFFFFFFFF
DDIVUHICHECKH:
  dd $002BDC545E14D64E
DDIVULOCHECKI:
  dd $FFFFFFFFFFFFFFFF
DDIVUHICHECKI:
  dd $891087BAF588BAEA

LOLONG:
  dd 0
HILONG:
  dd 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"
