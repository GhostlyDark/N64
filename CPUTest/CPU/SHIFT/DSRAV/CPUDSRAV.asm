// N64 'Bare Metal' CPU Doubleword Shift Right Arithmetic Variable (0..63) Test Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CPUDSRAV.N64", create
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


  PrintString($A0100000,88,8,FontRed,RTHEX,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,232,8,FontRed,RSDEC,11) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,384,8,FontRed,RDHEX,7) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,528,8,FontRed,TEST,10) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,0,16,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


  PrintString($A0100000,8,24,FontRed,DSRAV,4) // Print Text String To VRAM Using Font At X,Y Position
  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,1     // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,24,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,24,FontBlack,TEXTLONG0,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,24,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,24,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSRAVCHECK0 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSRAVPASS0 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,24,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND0
  nop // Delay Slot
  DSRAVPASS0:
  PrintString($A0100000,528,24,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND0:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,3     // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,32,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,32,FontBlack,TEXTLONG1,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,32,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,32,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSRAVCHECK1 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSRAVPASS1 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,32,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND1
  nop // Delay Slot
  DSRAVPASS1:
  PrintString($A0100000,528,32,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND1:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,5     // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,40,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,40,FontBlack,TEXTLONG2,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,40,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,40,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSRAVCHECK2 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSRAVPASS2 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,40,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND2
  nop // Delay Slot
  DSRAVPASS2:
  PrintString($A0100000,528,40,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND2:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,7     // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,48,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,48,FontBlack,TEXTLONG3,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,48,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,48,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSRAVCHECK3 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSRAVPASS3 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,48,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND3
  nop // Delay Slot
  DSRAVPASS3:
  PrintString($A0100000,528,48,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND3:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,9     // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,56,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,360,56,FontBlack,TEXTLONG4,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,56,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,56,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSRAVCHECK4 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSRAVPASS4 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,56,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND4
  nop // Delay Slot
  DSRAVPASS4:
  PrintString($A0100000,528,56,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND4:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,11    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,64,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,64,FontBlack,TEXTLONG5,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,64,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,64,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSRAVCHECK5 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSRAVPASS5 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,64,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND5
  nop // Delay Slot
  DSRAVPASS5:
  PrintString($A0100000,528,64,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND5:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,13    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,72,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,72,FontBlack,TEXTLONG6,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,72,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,72,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSRAVCHECK6 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSRAVPASS6 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,72,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND6
  nop // Delay Slot
  DSRAVPASS6:
  PrintString($A0100000,528,72,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND6:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,15    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,80,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,80,FontBlack,TEXTLONG7,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,80,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,80,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSRAVCHECK7 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSRAVPASS7 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,80,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND7
  nop // Delay Slot
  DSRAVPASS7:
  PrintString($A0100000,528,80,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND7:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,17    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,88,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,88,FontBlack,TEXTLONG8,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,88,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,88,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSRAVCHECK8 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSRAVPASS8 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,88,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND8
  nop // Delay Slot
  DSRAVPASS8:
  PrintString($A0100000,528,88,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND8:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,19    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,96,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,96,FontBlack,TEXTLONG9,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,96,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,96,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG      // A0 = Long Data Offset
  ld t0,0(a0)       // T0 = Long Data
  la a0,DSRAVCHECK9 // A0 = Long Check Data Offset
  ld t1,0(a0)       // T1 = Long Check Data
  beq t0,t1,DSRAVPASS9 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,96,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND9
  nop // Delay Slot
  DSRAVPASS9:
  PrintString($A0100000,528,96,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND9:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,21    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,104,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,104,FontBlack,TEXTLONG10,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,104,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,104,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRAVCHECK10 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRAVPASS10 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,104,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND10
  nop // Delay Slot
  DSRAVPASS10:
  PrintString($A0100000,528,104,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND10:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,23    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,112,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,112,FontBlack,TEXTLONG11,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,112,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,112,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRAVCHECK11 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRAVPASS11 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,112,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND11
  nop // Delay Slot
  DSRAVPASS11:
  PrintString($A0100000,528,112,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND11:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,25    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,120,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,120,FontBlack,TEXTLONG12,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,120,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,120,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRAVCHECK12 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRAVPASS12 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,120,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND12
  nop // Delay Slot
  DSRAVPASS12:
  PrintString($A0100000,528,120,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND12:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,27    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,128,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,128,FontBlack,TEXTLONG13,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,128,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,128,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRAVCHECK13 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRAVPASS13 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,128,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND13
  nop // Delay Slot
  DSRAVPASS13:
  PrintString($A0100000,528,128,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND13:

  la a0,VALUELONG // T0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,29    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // T1 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,136,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,136,FontBlack,TEXTLONG14,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,136,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,136,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRAVCHECK14 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRAVPASS14 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,136,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND14
  nop // Delay Slot
  DSRAVPASS14:
  PrintString($A0100000,528,136,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND14:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,31    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,144,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,144,FontBlack,TEXTLONG15,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,144,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,144,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRAVCHECK15 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRAVPASS15 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,144,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND15
  nop // Delay Slot
  DSRAVPASS15:
  PrintString($A0100000,528,144,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND15:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,33    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,152,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,152,FontBlack,TEXTLONG16,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,152,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,152,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG       // T0 = Long Data Offset
  ld t1,0(t0)        // T1 = Long Data
  la t0,DSRAVCHECK16 // T0 = Long Check Data Offset
  ld t2,0(t0)        // T2 = Long Check Data
  beq t1,t2,DSRAVPASS16 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,152,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND16
  nop // Delay Slot
  DSRAVPASS16:
  PrintString($A0100000,528,152,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND16:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,35    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,160,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,160,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,160,FontBlack,TEXTLONG17,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,160,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,160,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la t0,RDLONG       // T0 = Long Data Offset
  ld t1,0(t0)        // T1 = Long Data
  la t0,DSRAVCHECK17 // T0 = Long Check Data Offset
  ld t2,0(t0)        // T2 = Long Check Data
  beq t1,t2,DSRAVPASS17 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,160,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND17
  nop // Delay Slot
  DSRAVPASS17:
  PrintString($A0100000,528,160,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND17:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,37    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,168,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,168,FontBlack,TEXTLONG18,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,168,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,168,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRAVCHECK18 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRAVPASS18 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,168,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND18
  nop // Delay Slot
  DSRAVPASS18:
  PrintString($A0100000,528,168,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND18:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,39    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,176,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,176,FontBlack,TEXTLONG19,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,176,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,176,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRAVCHECK19 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRAVPASS19 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,176,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND19
  nop // Delay Slot
  DSRAVPASS19:
  PrintString($A0100000,528,176,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND19:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,41    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,184,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,184,FontBlack,TEXTLONG20,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,184,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,184,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRAVCHECK20 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRAVPASS20 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,184,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND20
  nop // Delay Slot
  DSRAVPASS20:
  PrintString($A0100000,528,184,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND20:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,43    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,192,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,192,FontBlack,TEXTLONG21,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,192,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,192,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRAVCHECK21 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRAVPASS21 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,192,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND21
  nop // Delay Slot
  DSRAVPASS21:
  PrintString($A0100000,528,192,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND21:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,45    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,200,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,200,FontBlack,TEXTLONG22,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,200,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,200,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRAVCHECK22 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRAVPASS22 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,200,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND22
  nop // Delay Slot
  DSRAVPASS22:
  PrintString($A0100000,528,200,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND22:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,47    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,208,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,208,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,208,FontBlack,TEXTLONG23,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,208,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,208,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRAVCHECK23 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRAVPASS23 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,208,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND23
  nop // Delay Slot
  DSRAVPASS23:
  PrintString($A0100000,528,208,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND23:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,49    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,216,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,216,FontBlack,TEXTLONG24,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,216,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,216,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRAVCHECK24 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRAVPASS24 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,216,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND24
  nop // Delay Slot
  DSRAVPASS24:
  PrintString($A0100000,528,216,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND24:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,51    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,224,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,224,FontBlack,TEXTLONG25,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,224,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,224,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRAVCHECK25 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRAVPASS25 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,224,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND25
  nop // Delay Slot
  DSRAVPASS25:
  PrintString($A0100000,528,224,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND25:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,53    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,232,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,232,FontBlack,TEXTLONG26,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,232,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,232,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRAVCHECK26 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRAVPASS26 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,232,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND26
  nop // Delay Slot
  DSRAVPASS26:
  PrintString($A0100000,528,232,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND26:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,55    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,240,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,240,FontBlack,TEXTLONG27,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,240,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,240,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRAVCHECK27 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRAVPASS27 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,240,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND27
  nop // Delay Slot
  DSRAVPASS27:
  PrintString($A0100000,528,240,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND27:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,57    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,248,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,248,FontBlack,TEXTLONG28,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,248,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,248,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRAVCHECK28 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRAVPASS28 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,248,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND28
  nop // Delay Slot
  DSRAVPASS28:
  PrintString($A0100000,528,248,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND28:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,59    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,256,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,256,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,256,FontBlack,TEXTLONG29,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,256,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,256,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRAVCHECK29 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRAVPASS29 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,256,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND29
  nop // Delay Slot
  DSRAVPASS29:
  PrintString($A0100000,528,256,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND29:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,61    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,264,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,264,FontBlack,TEXTLONG30,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,264,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,264,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRAVCHECK30 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRAVPASS30 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,264,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND30
  nop // Delay Slot
  DSRAVPASS30:
  PrintString($A0100000,528,264,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND30:

  la a0,VALUELONG // A0 = Long Data Offset
  ld t0,0(a0)     // T0 = Long Data
  li t1,63    // T1 = Shift Amount
  dsrav t0,t1 // T0 = Test Long Data
  la a0,RDLONG // A0 = RDLONG Offset
  sd t0,0(a0)  // RDLONG = Long Data
  PrintString($A0100000,80,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,88,272,FontBlack,VALUELONG,7) // Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString($A0100000,352,272,FontBlack,TEXTLONG31,1) // Print Text String To VRAM Using Font At X,Y Position
  PrintString($A0100000,376,272,FontBlack,DOLLAR,0) // Print Text String To VRAM Using Font At X,Y Position
  PrintValue($A0100000,384,272,FontBlack,RDLONG,7) // Print Text String To VRAM Using Font At X,Y Position
  la a0,RDLONG       // A0 = Long Data Offset
  ld t0,0(a0)        // T0 = Long Data
  la a0,DSRAVCHECK31 // A0 = Long Check Data Offset
  ld t1,0(a0)        // T1 = Long Check Data
  beq t0,t1,DSRAVPASS31 // Compare Result Equality With Check Data
  nop // Delay Slot
  PrintString($A0100000,528,272,FontRed,FAIL,3) // Print Text String To VRAM Using Font At X,Y Position
  j DSRAVEND31
  nop // Delay Slot
  DSRAVPASS31:
  PrintString($A0100000,528,272,FontGreen,PASS,3) // Print Text String To VRAM Using Font At X,Y Position
  DSRAVEND31:


  PrintString($A0100000,0,280,FontBlack,PAGEBREAK,79) // Print Text String To VRAM Using Font At X,Y Position


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

DSRAV:
  db "DSRAV"

RDHEX:
  db "RD (Hex)"
RTHEX:
  db "RT (Hex)"
RSDEC:
  db "RS (Decimal)"
TEST:
  db "Test Result"
FAIL:
  db "FAIL"
PASS:
  db "PASS"

DOLLAR:
  db "$"

TEXTLONG0:
  db "1"
TEXTLONG1:
  db "3"
TEXTLONG2:
  db "5"
TEXTLONG3:
  db "7"
TEXTLONG4:
  db "9"
TEXTLONG5:
  db "11"
TEXTLONG6:
  db "13"
TEXTLONG7:
  db "15"
TEXTLONG8:
  db "17"
TEXTLONG9:
  db "19"
TEXTLONG10:
  db "21"
TEXTLONG11:
  db "23"
TEXTLONG12:
  db "25"
TEXTLONG13:
  db "27"
TEXTLONG14:
  db "29"
TEXTLONG15:
  db "31"
TEXTLONG16:
  db "33"
TEXTLONG17:
  db "35"
TEXTLONG18:
  db "37"
TEXTLONG19:
  db "39"
TEXTLONG20:
  db "41"
TEXTLONG21:
  db "43"
TEXTLONG22:
  db "45"
TEXTLONG23:
  db "47"
TEXTLONG24:
  db "49"
TEXTLONG25:
  db "51"
TEXTLONG26:
  db "53"
TEXTLONG27:
  db "55"
TEXTLONG28:
  db "57"
TEXTLONG29:
  db "59"
TEXTLONG30:
  db "61"
TEXTLONG31:
  db "63"

PAGEBREAK:
  db "--------------------------------------------------------------------------------"

align(8) // Align 64-Bit
VALUELONG:
  dd -123456789123456789

DSRAVCHECK0:
  dd $FF24B25A2997D075
DSRAVCHECK1:
  dd $FFC92C968A65F41D
DSRAVCHECK2:
  dd $FFF24B25A2997D07
DSRAVCHECK3:
  dd $FFFC92C968A65F41
DSRAVCHECK4:
  dd $FFFF24B25A2997D0
DSRAVCHECK5:
  dd $FFFFC92C968A65F4
DSRAVCHECK6:
  dd $FFFFF24B25A2997D
DSRAVCHECK7:
  dd $FFFFFC92C968A65F
DSRAVCHECK8:
  dd $FFFFFF24B25A2997
DSRAVCHECK9:
  dd $FFFFFFC92C968A65
DSRAVCHECK10:
  dd $FFFFFFF24B25A299
DSRAVCHECK11:
  dd $FFFFFFFC92C968A6
DSRAVCHECK12:
  dd $FFFFFFFF24B25A29
DSRAVCHECK13:
  dd $FFFFFFFFC92C968A
DSRAVCHECK14:
  dd $FFFFFFFFF24B25A2
DSRAVCHECK15:
  dd $FFFFFFFFFC92C968
DSRAVCHECK16:
  dd $FFFFFFFFFF24B25A
DSRAVCHECK17:
  dd $FFFFFFFFFFC92C96
DSRAVCHECK18:
  dd $FFFFFFFFFFF24B25
DSRAVCHECK19:
  dd $FFFFFFFFFFFC92C9
DSRAVCHECK20:
  dd $FFFFFFFFFFFF24B2
DSRAVCHECK21:
  dd $FFFFFFFFFFFFC92C
DSRAVCHECK22:
  dd $FFFFFFFFFFFFF24B
DSRAVCHECK23:
  dd $FFFFFFFFFFFFFC92
DSRAVCHECK24:
  dd $FFFFFFFFFFFFFF24
DSRAVCHECK25:
  dd $FFFFFFFFFFFFFFC9
DSRAVCHECK26:
  dd $FFFFFFFFFFFFFFF2
DSRAVCHECK27:
  dd $FFFFFFFFFFFFFFFC
DSRAVCHECK28:
  dd $FFFFFFFFFFFFFFFF
DSRAVCHECK29:
  dd $FFFFFFFFFFFFFFFF
DSRAVCHECK30:
  dd $FFFFFFFFFFFFFFFF
DSRAVCHECK31:
  dd $FFFFFFFFFFFFFFFF

RDLONG:
  dd 0

insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"