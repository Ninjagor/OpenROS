bits 16
org 0x7c00

mov si, 0

mov ah, 0x06
mov al, 0
mov bh, 0x07
mov cx, 0
mov dx, 0x184f
int 0x10

print:
  mov ah, 0x0e
  mov al, [hello + si]
  int 0x10
  add si, 1
  cmp byte [hello + si], 0
  jne print

hello:
  db " Booting into openROS...", 0

times 510 - ($ - $$) db 0
dw 0xAA55
