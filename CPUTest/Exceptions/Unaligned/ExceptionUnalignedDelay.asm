// Tests unaligned memory exception
// Author: Lemmy with original sources from Peter Lemon's test sources
output "ExceptionUnalignedDelay.n64", create
arch n64.cpu
endian msb
fill 1052672 // Set ROM Size

constant SCREEN_X(400)
constant SCREEN_Y(240)
constant BYTES_PER_PIXEL(4)
// Setup Characters
constant CHAR_X(8)
constant CHAR_Y(8)

define header_title_27("Exception: Unaligned(delay)")

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

macro clear(start, end) {
    li a0, {start}
    li a1, {end}
loop:
    sw r0, 0(a0)
    addiu a0, a0, 4
    blt a0, a1, loop
    nop
}

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

macro PrintPassIf2ValuesMatch(left, top, source1, expected1, source2, expected2) {
    lui r1, 0   // this becomes 1 if any value differs

    la r2, {source1}
    lw r2, 0(r2)
    la r3, {expected1}
    beq r2, r3, {#}Equal1
    nop
    ori r1, r1, 1
{#}Equal1:

    la r2, {source2}
    lw r2, 0(r2)
    la r3, {expected2}
    beq r2, r3, {#}Equal2
    nop
    ori r1, r1, 1
{#}Equal2:

    beqz r1, {#}Equal

    nop
    PrintString($A0100000, ({left}), ({top}), FontRed, FAIL, 3)
    b {#}Done
    nop
{#}Equal:
    PrintString($A0100000, ({left}), ({top}), FontGreen, PASS, 3)

{#}Done:
}

macro PrintPassIf3ValuesMatch(left, top, source1, expected1, source2, expected2, source3, expected3) {
    lui r1, 0   // this becomes 1 if any value differs

    la r2, {source1}
    lw r2, 0(r2)
    la r3, {expected1}
    beq r2, r3, {#}Equal1
    nop
    ori r1, r1, 1
{#}Equal1:

    la r2, {source2}
    lw r2, 0(r2)
    la r3, {expected2}
    beq r2, r3, {#}Equal2
    nop
    ori r1, r1, 1
{#}Equal2:

    la r2, {source3}
    lw r2, 0(r2)
    la r3, {expected3}
    beq r2, r3, {#}Equal3
    nop
    ori r1, r1, 1
{#}Equal3:

    beqz r1, {#}Equal

    nop
    PrintString($A0100000, ({left}), ({top}), FontRed, FAIL, 3)
    b {#}Done
    nop
{#}Equal:
    PrintString($A0100000, ({left}), ({top}), FontGreen, PASS, 3)

{#}Done:
}

constant RANDOM(1)
constant CONTEXT(4)
constant COUNT(9)
constant COMPARE(11)
constant STATUS(12)
constant CAUSE(13)
constant EXCEPTPC(14)
constant BADVADDR(8)
constant ERRORPC(30)

macro memcpy(to, from, length) {
    la r1, {to}
    la r2, {from}
    la r3, {length}
{#}loop:
    lw r4, 0(r2)
    sw r4, 0(r1)
    addi r1, r1, 4
    addi r2, r2, 4
    addi r3, r3, -4
    bgtz r3, {#}loop
    nop
}

macro InvalidateCache(start, length, type) {
    la r1, {start}
    la r3, {length}
{#}loop:
    cache {type}, 0(r1)
    addi r1, r1, 16
    addi r3, r3, -16
    bgtz r3, {#}loop
    nop
}

macro InstallExceptionHandlers() {
    memcpy(0x80000000, handler_0, 0x80)
    memcpy(0x80000080, handler_80, 0x100)
    memcpy(0x80000180, handler_180, 0x100)
    InvalidateCache(0x80000000, 0x300, 25) // index load data
    InvalidateCache(0x80000000, 0x300, 16) // hit invalidate - instruction
}

macro SaveRegisters(offset) {
  mfc0 r1, EXCEPTPC
  la r2, ExceptPC
  sw r1, {offset}(r2)

  mfc0 r1, ERRORPC
  la r2, ErrorPC
  sw r1, {offset}(r2)

  mfc0 r1, CAUSE
  la r2, Cause
  sw r1, {offset}(r2)

  mfc0 r1, STATUS
  la r2, Status
  sw r1, {offset}(r2)

  mfc0 r1, BADVADDR
  la r2, BadVAddr
  sw r1, {offset}(r2)

  mfc0 r1, CONTEXT
  la r2, Context
  sw r1, {offset}(r2)
}

macro ShowRow(top, label, labelLength, data, expectedBefore, expectedDuring, expectedAfter) {
  PrintString($A0100000, (16), ({top}), FontBlack, {label}, {labelLength})
  PrintValue($A0100000, (112), ({top}), FontBlack, {data}, 3)
  PrintValue($A0100000, (188), ({top}), FontBlack, ({data}+4), 3)
  PrintValue($A0100000, (264), ({top}), FontBlack, ({data}+8), 3)
  PrintPassIf3ValuesMatch(340, top, {data}, {expectedBefore}, ({data}+4), {expectedDuring}, ({data}+8), {expectedAfter})
}

// Doesn't test the previous value. It still shows it though
macro ShowRowNoBefore(top, label, labelLength, data, expectedDuring, expectedAfter) {
  PrintString($A0100000, (16), ({top}), FontBlack, {label}, {labelLength})
  PrintValue($A0100000, (112), ({top}), FontBlack, {data}, 3)
  PrintValue($A0100000, (188), ({top}), FontBlack, ({data}+4), 3)
  PrintValue($A0100000, (264), ({top}), FontBlack, ({data}+8), 3)
  PrintPassIf2ValuesMatch(340, top, ({data}+4), {expectedDuring}, ({data}+8), {expectedAfter})
}

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(SCREEN_X, SCREEN_Y, BPP32|AA_MODE_2, $A0100000)

  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  clear($A0100000, $A0100000 + SCREEN_X*BYTES_PER_PIXEL*SCREEN_Y)

  InstallExceptionHandlers()

  SaveRegisters(0)

  li r1, 0x80000000
  beq r0, r0, target
  lw r1, 1(r1)
  nop
  nop
  target:
  nop

  SaveRegisters(8)

  variable top(16)
  PrintString($A0100000, (112), (top), FontBlack, Before_6, 5)
  PrintString($A0100000, (188), (top), FontBlack, During_6, 5)
  PrintString($A0100000, (264), (top), FontBlack, After_5, 4)

  variable top(top + 16)
  PrintString($A0100000, (16), (top), FontBlack, HandlerPC_11, 10)
  PrintValue($A0100000, (188), (top), FontBlack, HandlerPC, 3)

  variable top(top + 16)
  ShowRow(top, ErrorPC_8, 7, ErrorPC, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF)

  variable top(top + 16)
  ShowRow(top, ExceptPC_9, 8, ExceptPC, 0xFFFFFFFF, 0x80001220, 0x80001228)

  variable top(top + 16)
  ShowRowNoBefore(top, Cause_6, 5, Cause, 0x80000010, 0x80000010)

  variable top(top + 16)
  ShowRow(top, Status_7, 6, Status, 0x241000E0, 0x241000E2, 0x241000E0)

  variable top(top + 16)
  ShowRow(top, BadVAddr_9, 8, BadVAddr, 0xFFFFFFFF, 0x80000001, 0x80000001)

  variable top(top + 16)
  ShowRow(top, Context_8, 7, Context, 0x007FFFF0, 0x00400000, 0x00400000)
Loop:
  j Loop
  nop // Delay Slot



align(8)
PASS:
  db "PASS"

align(8)
FAIL:
  db "FAIL"

Before_6:
  db "before"
During_6:
  db "during"
After_5:
  db "after"
HandlerPC_11:
  db "Handler PC:"
ErrorPC_8:
  db "ErrorPC:"
ExceptPC_9:
  db "ExceptPC:"
Cause_6:
  db "Cause:"
Status_7:
  db "Status:"
BadVAddr_9:
  db "BadVAddr:"
Context_8:
  db "Context:"

align(0x100)
align(4)
handler_0:
  la r1, 0x80000000
  la r2, HandlerPC
  sw r1, 0(r2)
  SaveRegisters(4)
  mfc0 r1, EXCEPTPC
  addiu r1, r1, 8
  mtc0 r1, EXCEPTPC
  nop
  nop
  eret

align(0x100)
handler_80:
  la r1, 0x80000080
  la r2, HandlerPC
  sw r1, 0(r2)
  SaveRegisters(4)
  mfc0 r1, EXCEPTPC
  addiu r1, r1, 8
  mtc0 r1, EXCEPTPC
  nop
  nop
  eret

align(0x100)
handler_180:
  la r1, 0x80000180
  la r2, HandlerPC
  sw r1, 0(r2)
  SaveRegisters(4)

  // Increase EXCEPTPC by 8. Otherwise ERET and LW will infinite-loop
  mfc0 r1, EXCEPTPC
  addiu r1, r1, 8
  mtc0 r1, EXCEPTPC

  // Need a minimum of 2 nops after changing LW before eret will work
  nop
  nop
  eret
  nop
  nop
  nop
  nop

align(0x1000)
HandlerPC:
  dw 0
ErrorPC:
  dw 0
  dw 0
  dw 0
ExceptPC:
  dw 0
  dw 0
  dw 0
Cause:
  dw 0
  dw 0
  dw 0
Status:
  dw 0
  dw 0
  dw 0
BadVAddr:
  dw 0
  dw 0
  dw 0
Context:
  dw 0
  dw 0
  dw 0


insert FontBlack, "FontBlack8x8.bin"
insert FontGreen, "FontGreen8x8.bin"
insert FontRed, "FontRed8x8.bin"
