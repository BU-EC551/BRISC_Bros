	.file	"calculator.c"
	.option nopic
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	li	a0,79
	call	tx_byte
	li	a0,112
	call	tx_byte
	li	a0,115
	call	tx_byte
	li	a0,58
	call	tx_byte
	li	a0,32
	call	tx_byte
	li	a0,91
	call	tx_byte
	li	a0,43
	call	tx_byte
	li	a0,44
	call	tx_byte
	li	a0,45
	call	tx_byte
	li	a0,44
	call	tx_byte
	li	a0,94
	call	tx_byte
	li	a0,44
	call	tx_byte
	li	a0,38
	call	tx_byte
	li	a0,93
	call	tx_byte
	li	a0,10
	call	tx_byte
	li	a0,13
	call	tx_byte
.L13:
	sw	zero,-28(s0)
	sw	zero,-24(s0)
	call	rx_byte
	sw	a0,-32(s0)
	lw	a5,-32(s0)
	mv	a0,a5
	call	tx_byte
	call	rx_byte
	sw	a0,-36(s0)
	lw	a5,-36(s0)
	mv	a0,a5
	call	tx_byte
	call	rx_byte
	sw	a0,-40(s0)
	lw	a5,-40(s0)
	mv	a0,a5
	call	tx_byte
	j	.L2
.L3:
	call	rx_byte
	sw	a0,-24(s0)
.L2:
	lw	a4,-24(s0)
	li	a5,13
	bne	a4,a5,.L3
	li	a0,10
	call	tx_byte
	li	a0,13
	call	tx_byte
	lw	a5,-32(s0)
	addi	a5,a5,-48
	sw	a5,-32(s0)
	lw	a5,-40(s0)
	addi	a5,a5,-48
	sw	a5,-40(s0)
	lw	a5,-36(s0)
	li	a4,43
	beq	a5,a4,.L5
	li	a4,43
	bgtu	a5,a4,.L6
	li	a4,38
	beq	a5,a4,.L7
	li	a4,42
	beq	a5,a4,.L8
	j	.L4
.L6:
	li	a4,45
	beq	a5,a4,.L9
	li	a4,94
	beq	a5,a4,.L10
	j	.L4
.L5:
	lw	a4,-32(s0)
	lw	a5,-40(s0)
	add	a5,a4,a5
	sw	a5,-20(s0)
	j	.L11
.L9:
	lw	a4,-32(s0)
	lw	a5,-40(s0)
	sub	a5,a4,a5
	sw	a5,-20(s0)
	j	.L11
.L10:
	lw	a4,-32(s0)
	lw	a5,-40(s0)
	xor	a5,a4,a5
	sw	a5,-20(s0)
	j	.L11
.L7:
	lw	a4,-32(s0)
	lw	a5,-40(s0)
	and	a5,a4,a5
	sw	a5,-20(s0)
	j	.L11
.L8:
	lw	a1,-40(s0)
	lw	a0,-32(s0)
	call	multu
	sw	a0,-20(s0)
	j	.L11
.L4:
	li	a0,69
	call	tx_byte
	li	a0,114
	call	tx_byte
	li	a0,114
	call	tx_byte
	li	a0,111
	call	tx_byte
	li	a0,114
	call	tx_byte
	li	a5,1
	sw	a5,-28(s0)
.L11:
	lw	a5,-28(s0)
	bnez	a5,.L12
	lw	a0,-20(s0)
	call	tx_uint
.L12:
	li	a0,10
	call	tx_byte
	li	a0,13
	call	tx_byte
	j	.L13
	.size	main, .-main
	.align	2
	.globl	rx_byte
	.type	rx_byte, @function
rx_byte:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	li	a5,-1879048192
	addi	a5,a5,16
	sw	a5,-20(s0)
	li	a5,-1879048192
	addi	a5,a5,20
	sw	a5,-24(s0)
	nop
.L15:
	lw	a5,-24(s0)
	lw	a5,0(a5)
	beqz	a5,.L15
	lw	a5,-20(s0)
	lw	a5,0(a5)
	mv	a0,a5
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	rx_byte, .-rx_byte
	.align	2
	.globl	tx_byte
	.type	tx_byte, @function
tx_byte:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	li	a5,-1879048192
	addi	a5,a5,32
	sw	a5,-20(s0)
	li	a5,-1879048192
	addi	a5,a5,36
	sw	a5,-24(s0)
	nop
.L18:
	lw	a5,-24(s0)
	lw	a5,0(a5)
	beqz	a5,.L18
	lw	a4,-36(s0)
	lw	a5,-20(s0)
	sw	a4,0(a5)
	nop
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	tx_byte, .-tx_byte
	.align	2
	.globl	tx_uint
	.type	tx_uint, @function
tx_uint:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	li	a5,9
	sw	a5,-24(s0)
	j	.L20
.L23:
	lw	a5,-36(s0)
	sw	a5,-20(s0)
	j	.L21
.L22:
	lw	a0,-20(s0)
	call	div10
	sw	a0,-20(s0)
.L21:
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	bgtu	a4,a5,.L22
	lw	a0,-20(s0)
	call	mod10
	sw	a0,-28(s0)
	lw	a5,-28(s0)
	addi	a5,a5,48
	mv	a0,a5
	call	tx_byte
	lw	a4,-24(s0)
	mv	a5,a4
	slli	a5,a5,1
	add	a5,a5,a4
	slli	a5,a5,2
	sub	a5,a5,a4
	sw	a5,-24(s0)
.L20:
	lw	a4,-36(s0)
	lw	a5,-24(s0)
	bgtu	a4,a5,.L23
	lw	a0,-36(s0)
	call	mod10
	sw	a0,-28(s0)
	lw	a5,-28(s0)
	addi	a5,a5,48
	mv	a0,a5
	call	tx_byte
	li	a0,32
	call	tx_byte
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	tx_uint, .-tx_uint
	.align	2
	.globl	mod10
	.type	mod10, @function
mod10:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	j	.L25
.L26:
	lw	a5,-20(s0)
	addi	a5,a5,-10
	sw	a5,-20(s0)
.L25:
	lw	a4,-20(s0)
	li	a5,9
	bgtu	a4,a5,.L26
	lw	a5,-20(s0)
	mv	a0,a5
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	mod10, .-mod10
	.align	2
	.globl	div10
	.type	div10, @function
div10:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	lw	a0,-36(s0)
	call	mod10
	mv	a4,a0
	lw	a5,-36(s0)
	sub	a5,a5,a4
	sw	a5,-36(s0)
	sw	zero,-24(s0)
	sw	zero,-20(s0)
	j	.L29
.L30:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
	lw	a5,-20(s0)
	addi	a5,a5,10
	sw	a5,-20(s0)
.L29:
	lw	a4,-20(s0)
	lw	a5,-36(s0)
	bltu	a4,a5,.L30
	lw	a5,-24(s0)
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	div10, .-div10
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
	j	.L33
.L35:
	lw	a4,-36(s0)
	lw	a5,-24(s0)
	srl	a5,a4,a5
	andi	a5,a5,1
	beqz	a5,.L34
	lw	a4,-40(s0)
	lw	a5,-24(s0)
	sll	a5,a4,a5
	lw	a4,-20(s0)
	add	a5,a4,a5
	sw	a5,-20(s0)
.L34:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L33:
	lw	a4,-24(s0)
	li	a5,31
	ble	a4,a5,.L35
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
	beqz	a5,.L38
	lw	a5,-36(s0)
	sub	a5,zero,a5
	sw	a5,-36(s0)
.L38:
	lw	a5,-28(s0)
	beqz	a5,.L39
	lw	a5,-40(s0)
	sub	a5,zero,a5
	sw	a5,-40(s0)
.L39:
	lw	a5,-36(s0)
	lw	a4,-40(s0)
	mv	a1,a4
	mv	a0,a5
	call	multu
	mv	a5,a0
	sw	a5,-20(s0)
	lw	a4,-24(s0)
	lw	a5,-28(s0)
	beq	a4,a5,.L40
	lw	a5,-20(s0)
	sub	a5,zero,a5
	sw	a5,-20(s0)
.L40:
	lw	a5,-20(s0)
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	mult, .-mult
	.ident	"GCC: (GNU) 7.2.0"
