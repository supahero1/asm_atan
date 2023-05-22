section .data
align 16
c1:		dd	0x3F5A0F91	; 0.8518
align 16
c2:		dd	0x40700000	; 3.75
align 16
c3:		dd	0x3E7CD6EA	; 1 / 4.05
align 16
c4_pi:		dd	0x3FC90FDB	; pi / 2
align 16
mask_sgn:	dd	0x80000000
align 16
mask_abs:	dd	0x7FFFFFFF

section .text
global empty_function
empty_function:
	ret

align 4096
global asm_atan
asm_atan:
	movss	xmm1, xmm0
	andps	xmm1, [rel mask_abs]	; fabs(x)
	movss	xmm2, dword[rel c1]
	comiss	xmm1, xmm2		; fabs(x) < c1
	jb	less			; less likely

	movss	xmm2, [rel c2]
	mulss	xmm2, xmm0		; x * c2
	rcpss	xmm2, xmm2		; 1 / (x * c2)
	addss	xmm2, xmm0		; x + 1 / (x * c2)
	rcpss	xmm2, xmm2		; 1 / (x + 1 / (x * c2))

	movss	xmm1, dword[rel c4_pi]
	andps	xmm0, [rel mask_sgn]	; upper bit either 0 or 1
	orps	xmm0, xmm1		; PI/2 or -PI/2

	subss	xmm0, xmm2
	ret
less:
	mulss	xmm1, xmm1
	mulss	xmm1, xmm0		; fabs(x) * fabs(x) * x == x * x * x
	movss	xmm2, dword[rel c3]
	mulss	xmm1, xmm2		; (x * x * x) * c3
	subss	xmm0, xmm1		; x - (x * x * x)  * c3
	ret
