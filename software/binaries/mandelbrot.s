	.file	"mandelbrot.c"
	.option nopic
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-64
	sw	ra,60(sp)
	sw	s0,56(sp)
	addi	s0,sp,64
	li	a5,-2147483648
	sw	a5,-40(s0)
	li	a5,255
	sw	a5,-44(s0)
	sw	zero,-20(s0)
	li	a5,4096
	addi	a5,a5,464
	sw	a5,-60(s0)
	sw	zero,-28(s0)
	j	.L2
.L9:
	li	a5,-8192
	addi	a5,a5,79
	sw	a5,-64(s0)
	sw	zero,-32(s0)
	j	.L3
.L8:
	lw	a4,-20(s0)
	li	a5,536870912
	add	a5,a4,a5
	slli	a5,a5,2
	sw	a5,-40(s0)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
	sw	zero,-24(s0)
	sw	zero,-56(s0)
	sw	zero,-52(s0)
	sw	zero,-36(s0)
	j	.L4
.L7:
	addi	a4,s0,-64
	addi	a5,s0,-56
	mv	a1,a4
	mv	a0,a5
	call	mandelbrot_iter
	addi	a5,s0,-56
	mv	a0,a5
	call	complex_magnitude
	mv	a4,a0
	li	a5,16384
	ble	a4,a5,.L5
	li	a5,7
	sw	a5,-24(s0)
	j	.L6
.L5:
	lw	a5,-36(s0)
	addi	a5,a5,1
	sw	a5,-36(s0)
.L4:
	lw	a4,-36(s0)
	lw	a5,-44(s0)
	blt	a4,a5,.L7
.L6:
	lw	a5,-64(s0)
	addi	a5,a5,19
	sw	a5,-64(s0)
	lw	a5,-40(s0)
	lw	a4,-24(s0)
	sw	a4,0(a5)
	lw	a5,-32(s0)
	addi	a5,a5,1
	sw	a5,-32(s0)
.L3:
	lw	a4,-32(s0)
	li	a5,639
	ble	a4,a5,.L8
	lw	a5,-60(s0)
	addi	a5,a5,-19
	sw	a5,-60(s0)
	lw	a5,-28(s0)
	addi	a5,a5,1
	sw	a5,-28(s0)
.L2:
	lw	a4,-28(s0)
	li	a5,479
	ble	a4,a5,.L9
	li	a5,-1879048192
	sw	a5,-48(s0)
	lw	a5,-48(s0)
	li	a4,1
	sw	a4,0(a5)
	li	a5,0
	mv	a0,a5
	lw	ra,60(sp)
	lw	s0,56(sp)
	addi	sp,sp,64
	jr	ra
	.size	main, .-main
	.align	2
	.globl	complex_add
	.type	complex_add, @function
complex_add:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	sw	a2,-28(s0)
	lw	a5,-20(s0)
	lw	a4,0(a5)
	lw	a5,-24(s0)
	lw	a5,0(a5)
	add	a4,a4,a5
	lw	a5,-28(s0)
	sw	a4,0(a5)
	lw	a5,-20(s0)
	lw	a4,4(a5)
	lw	a5,-24(s0)
	lw	a5,4(a5)
	add	a4,a4,a5
	lw	a5,-28(s0)
	sw	a4,4(a5)
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	complex_add, .-complex_add
	.align	2
	.globl	complex_mult
	.type	complex_mult, @function
complex_mult:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	sw	s1,36(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	lw	a5,-36(s0)
	lw	a4,0(a5)
	lw	a5,-40(s0)
	lw	a5,0(a5)
	mv	a1,a5
	mv	a0,a4
	call	mult
	mv	s1,a0
	lw	a5,-36(s0)
	lw	a4,4(a5)
	lw	a5,-40(s0)
	lw	a5,4(a5)
	mv	a1,a5
	mv	a0,a4
	call	mult
	mv	a5,a0
	sub	a5,s1,a5
	sw	a5,-20(s0)
	lw	a5,-36(s0)
	lw	a4,0(a5)
	lw	a5,-40(s0)
	lw	a5,4(a5)
	mv	a1,a5
	mv	a0,a4
	call	mult
	mv	s1,a0
	lw	a5,-36(s0)
	lw	a4,4(a5)
	lw	a5,-36(s0)
	lw	a5,0(a5)
	mv	a1,a5
	mv	a0,a4
	call	mult
	mv	a5,a0
	add	a5,s1,a5
	sw	a5,-24(s0)
	lw	a5,-20(s0)
	srai	a4,a5,12
	lw	a5,-44(s0)
	sw	a4,0(a5)
	lw	a5,-24(s0)
	srai	a4,a5,12
	lw	a5,-44(s0)
	sw	a4,4(a5)
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s1,36(sp)
	addi	sp,sp,48
	jr	ra
	.size	complex_mult, .-complex_mult
	.align	2
	.globl	complex_square
	.type	complex_square, @function
complex_square:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	lw	a2,-24(s0)
	lw	a1,-20(s0)
	lw	a0,-20(s0)
	call	complex_mult
	nop
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	complex_square, .-complex_square
	.align	2
	.globl	mandelbrot_iter
	.type	mandelbrot_iter, @function
mandelbrot_iter:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	lw	a1,-20(s0)
	lw	a0,-20(s0)
	call	complex_square
	lw	a2,-20(s0)
	lw	a1,-24(s0)
	lw	a0,-20(s0)
	call	complex_add
	nop
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	mandelbrot_iter, .-mandelbrot_iter
	.align	2
	.globl	complex_magnitude
	.type	complex_magnitude, @function
complex_magnitude:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	sw	s1,36(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	lw	a5,-36(s0)
	lw	a4,0(a5)
	lw	a5,-36(s0)
	lw	a5,0(a5)
	mv	a1,a5
	mv	a0,a4
	call	mult
	mv	s1,a0
	lw	a5,-36(s0)
	lw	a4,4(a5)
	lw	a5,-36(s0)
	lw	a5,4(a5)
	mv	a1,a5
	mv	a0,a4
	call	mult
	mv	a5,a0
	add	a5,s1,a5
	sw	a5,-20(s0)
	lw	a5,-20(s0)
	srai	a5,a5,12
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s1,36(sp)
	addi	sp,sp,48
	jr	ra
	.size	complex_magnitude, .-complex_magnitude
	.align	2
	.globl	multu
	.type	multu, @function
multu:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	zero,-20(s0)
	sw	zero,-24(s0)
	j	.L18
.L20:
	lw	a4,-36(s0)
	lw	a5,-24(s0)
	srl	a5,a4,a5
	andi	a5,a5,1
	beqz	a5,.L19
	lw	a4,-40(s0)
	lw	a5,-24(s0)
	sll	a5,a4,a5
	lw	a4,-20(s0)
	add	a5,a4,a5
	sw	a5,-20(s0)
.L19:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L18:
	lw	a4,-24(s0)
	li	a5,31
	ble	a4,a5,.L20
	lw	a5,-20(s0)
	mv	a0,a5
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	multu, .-multu
	.align	2
	.globl	mult
	.type	mult, @function
mult:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	lw	a5,-36(s0)
	srai	a5,a5,31
	sw	a5,-24(s0)
	lw	a5,-40(s0)
	srai	a5,a5,31
	sw	a5,-28(s0)
	lw	a5,-24(s0)
	beqz	a5,.L23
	lw	a5,-36(s0)
	sub	a5,zero,a5
	sw	a5,-36(s0)
.L23:
	lw	a5,-28(s0)
	beqz	a5,.L24
	lw	a5,-40(s0)
	sub	a5,zero,a5
	sw	a5,-40(s0)
.L24:
	lw	a5,-36(s0)
	lw	a4,-40(s0)
	mv	a1,a4
	mv	a0,a5
	call	multu
	mv	a5,a0
	sw	a5,-20(s0)
	lw	a4,-24(s0)
	lw	a5,-28(s0)
	beq	a4,a5,.L25
	lw	a5,-20(s0)
	sub	a5,zero,a5
	sw	a5,-20(s0)
.L25:
	lw	a5,-20(s0)
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	mult, .-mult
	.ident	"GCC: (GNU) 7.2.0"
