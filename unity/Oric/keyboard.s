;
; Copyright (c) 2019 Anthony Beaucamp.
;
; This software is provided 'as-is', without any express or implied warranty.
; In no event will the authors be held liable for any damages arising from
; the use of this software.
;
; Permission is granted to anyone to use this software for any purpose,
; including commercial applications, and to alter it and redistribute it
; freely, subject to the following restrictions:
;
;   1. The origin of this software must not be misrepresented; you must not
;   claim that you wrote the original software. If you use this software in a
;   product, an acknowledgment in the product documentation would be
;   appreciated but is not required.
;
;   2. Altered source versions must be plainly marked as such, and must not
;   be misrepresented as being the original software.
;
;   3. This notice may not be removed or altered from any distribution.
;
;   4. The names of this software and/or it's copyright holders may not be
;   used to endorse or promote products derived from this software without
;   specific prior written permission.
;
 
	.export		_GetKey

; ---------------------------------------------------------------
; unsigned char __near__ GetKey (unsigned char)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_GetKey: near	
	php
	sei
	tax
	and #$38
	lsr A
	lsr A
	lsr A
	pha
	txa
	and #$07
	tax
	clc
	lda #$FF
loop:
	rol A
	dex
	bpl loop
	tax
	lda #$0E
check:
	ldy $C800	; 0: ROM 1.0
	cpy #$00
	bne rom11
rom10:
	jsr $F535
	jmp process
rom11:
	jsr $F590
process:
	pla
	ora #$10
	sta $0300
	lda #$08
	plp
	bit $0300
	beq false
	lda #$01
	rts
false:	
	lda #$00
	rts
.endproc
