// N64 'Bare Metal' 16BPP 320x240 Copy Texture Rectangle TLUT RGBA4B RDP Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "CopyTextureRectangle16BPPTLUTRGBA4B320X240.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  include "LIB/N64_GFX.INC" // Include Graphics Macros
  N64_INIT() // Run N64 Initialisation Routine

  ScreenNTSC(320, 240, BPP16|AA_MODE_2, $A0100000) // Screen NTSC: 320x240, 16BPP, Resample Only, DRAM Origin $A0100000

  WaitScanline($200) // Wait For Scanline To Reach Vertical Blank

  DPC(RDPBuffer, RDPBufferEnd) // Run DPC Command Buffer: Start, End

Loop:
  j Loop
  nop // Delay Slot

align(8) // Align 64-Bit
RDPBuffer:
arch n64.rdp
  Set_Scissor 0<<2,0<<2, 0,0, 320<<2,240<<2 // Set Scissor: XH 0.0,YH 0.0, Scissor Field Enable Off,Field Off, XL 320.0,YL 240.0
  Set_Other_Modes CYCLE_TYPE_FILL // Set Other Modes
  Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,320-1, $00100000 // Set Color Image: FORMAT RGBA,SIZE 16B,WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $FF01FF01 // Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 // Fill Rectangle: XL 319.0,YL 239.0, XH 0.0,YH 0.0

  Set_Other_Modes CYCLE_TYPE_COPY|EN_TLUT|ALPHA_COMPARE_EN // Set Other Modes

  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1-1, Tlut // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 1, Tlut DRAM ADDRESS
  Set_Tile 0,0,0, $100, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: TMEM Address $100, Tile 0
  Load_Tlut 0<<2,0<<2, 0, 47<<2,0<<2 // Load Tlut: SL 0.0,TL 0.0, Tile 0, SH 47.0,TH 0.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4-1, Texture16x16 // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 4, Texture16x16 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,1, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 15<<2,15<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 15.0,TH 15.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,1, $000, 0,PALETTE_0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0,Palette 0
  Texture_Rectangle 83<<2,129<<2, 0, 68<<2,114<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 83.0,YL 129.0, Tile 0, XH 68.0,YH 114.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,8-1, Texture32x32 // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 8, Texture32x32 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,2, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 2 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 31<<2,31<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 31.0,TH 31.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,2, $000, 0,PALETTE_1, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 2 (64bit Words), TMEM Address $000, Tile 0,Palette 1
  Texture_Rectangle 175<<2,129<<2, 0, 144<<2,98<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 175.0,YL 129.0, Tile 0, XH 144.0,YH 98.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Tile // Sync Tile
  Set_Texture_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,16-1, Texture64x64 // Set Texture Image: FORMAT RGBA,SIZE 16B,WIDTH 16, Texture64x64 DRAM ADDRESS
  Set_Tile IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_16B,4, $000, 0,0, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT RGBA,SIZE 16B,Tile Line Size 4 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 63<<2,63<<2 // Load Tile: SL 0.0,TL 0.0, Tile 0, SH 63.0,TH 63.0
  Sync_Tile // Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_COLOR_INDX,SIZE_OF_PIXEL_4B,4, $000, 0,PALETTE_2, 0,0,0,0, 0,0,0,0 // Set Tile: FORMAT COLOR INDEX,SIZE 4B,Tile Line Size 4 (64bit Words), TMEM Address $000, Tile 0,Palette 2
  Texture_Rectangle 291<<2,129<<2, 0, 228<<2,66<<2, 0<<5,0<<5, 4<<10,1<<10 // Texture Rectangle: XL 291.0,YL 129.0, Tile 0, XH 228.0,YH 66.0, S 0.0,T 0.0, DSDX 4.0,DTDY 1.0

  Sync_Full // Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

Texture16x16:
  db $33,$00,$00,$02,$20,$00,$00,$00 // 16x16x4B = 128 Bytes
  db $33,$00,$00,$21,$12,$00,$00,$00
  db $00,$00,$02,$11,$11,$20,$00,$00
  db $00,$00,$21,$11,$11,$12,$00,$00
  db $00,$02,$11,$11,$11,$11,$20,$00
  db $00,$21,$11,$11,$11,$11,$12,$00
  db $02,$11,$11,$11,$11,$11,$11,$20
  db $21,$11,$11,$11,$11,$11,$11,$12
  db $21,$11,$11,$11,$11,$11,$11,$12
  db $22,$22,$22,$11,$11,$22,$22,$22
  db $00,$00,$02,$11,$11,$20,$00,$00
  db $00,$00,$02,$11,$11,$20,$00,$00
  db $00,$00,$02,$11,$11,$20,$00,$00
  db $00,$00,$02,$11,$11,$20,$00,$00
  db $00,$00,$02,$11,$11,$20,$00,$00
  db $00,$00,$02,$22,$22,$20,$00,$00

Texture32x32:
  db $33,$33,$00,$00,$00,$00,$00,$02,$20,$00,$00,$00,$00,$00,$00,$00 // 32x32x4B = 512 Bytes
  db $33,$33,$00,$00,$00,$00,$00,$21,$12,$00,$00,$00,$00,$00,$00,$00
  db $33,$33,$00,$00,$00,$00,$02,$11,$11,$20,$00,$00,$00,$00,$00,$00
  db $33,$33,$00,$00,$00,$00,$21,$11,$11,$12,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$21,$11,$11,$11,$11,$12,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00
  db $00,$00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00,$00
  db $00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00
  db $00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00
  db $00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00
  db $00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00
  db $00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00
  db $00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00
  db $02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20
  db $21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12
  db $21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12
  db $22,$22,$22,$22,$22,$22,$11,$11,$11,$11,$22,$22,$22,$22,$22,$22
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$22,$22,$22,$22,$20,$00,$00,$00,$00,$00

Texture64x64:
  db $33,$33,$33,$33,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // 64x64x4B = 2048 Bytes
  db $33,$33,$33,$33,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$21,$12,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
  db $33,$33,$33,$33,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
  db $33,$33,$33,$33,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$21,$11,$11,$12,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
  db $33,$33,$33,$33,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $33,$33,$33,$33,$00,$00,$00,$00,$00,$00,$00,$00,$00,$21,$11,$11,$11,$11,$12,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $33,$33,$33,$33,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $33,$33,$33,$33,$00,$00,$00,$00,$00,$00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00
  db $00,$00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00,$00
  db $00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00
  db $00,$00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00,$00
  db $00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00
  db $00,$00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00,$00
  db $00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00
  db $00,$21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12,$00
  db $02,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$20
  db $21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12
  db $21,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$12
  db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$11,$11,$11,$11,$11,$11,$11,$11,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$11,$11,$11,$11,$11,$11,$11,$11,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$22,$22,$22,$22,$22,$22,$22,$22,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

Tlut:
  dh $0000,$FFFF,$0001,$F001,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // 4B Palette 0 (4x16B = 8 Bytes)
  dh $0000,$F0FF,$0001,$F001,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // 4B Palette 1
  dh $0000,$0FFF,$0001,$F001,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // 4B Palette 2