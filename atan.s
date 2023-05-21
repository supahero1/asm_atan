section .data
align 16
c1:	dq	0x3F5A0F91, 0, 0, 0	; 0.8518
align 16
c2:	dq	0x40700000, 0, 0, 0	; 3.75
align 16
c3:	dq	0x3E7CD6EA, 0, 0, 0	; 1 / 4.05
align 16
c4_pi:	dq	0x3FC90FDB, 0, 0, 0	; pi / 2
align 16
mask:	dq	0x00000000000000000000000080000000

section .text
global empty_function
empty_function:
	ret

align 4096
global asm_atan
asm_atan:
	movaps	xmm1, xmm0
	psllq	xmm1, 1
	psrlq	xmm1, 1		; fabs(x)
	movaps	xmm2, [rel c1]
	comiss	xmm1, xmm2	; fabs(x) < c1
	jb	less		; less likely

	movaps	xmm1, xmm0
	andps	xmm1, [rel mask]; upper bit either 0 or 1

	movaps	xmm2, [rel c2]
	mulss	xmm2, xmm0	; x * c2
	rcpss	xmm2, xmm2	; 1 / (x * c2)
	addss	xmm2, xmm0	; x + 1 / (x * c2)
	rcpss	xmm2, xmm2	; 1 / (x + 1 / (x * c2))

	movaps	xmm0, [rel c4_pi]
	orps	xmm0, xmm1	; PI/2 or -PI/2

	subss	xmm0, xmm2
	ret
less:
	mulss	xmm1, xmm1
	mulss	xmm1, xmm0	; fabs(x) * fabs(x) * x == x * x * x
	movaps	xmm2, [rel c3]
	mulss	xmm1, xmm2	; (x * x * x) * c3
	subss	xmm0, xmm1	; x - (x * x * x)  * c3
	ret
