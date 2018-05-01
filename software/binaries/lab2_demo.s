	.file	"lab2_demo.c"
	.option nopic
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	call	print_hello
.L9:
	call	print_mode
	call	rx_byte
	sw	a0,-24(s0)
	lw	a5,-24(s0)
	mv	a0,a5
	call	tx_byte
	sw	zero,-20(s0)
	j	.L2
.L3:
	call	rx_byte
	sw	a0,-20(s0)
.L2:
	lw	a4,-20(s0)
	li	a5,13
	bne	a4,a5,.L3
	li	a0,10
	call	tx_byte
	li	a0,13
	call	tx_byte
	lw	a5,-24(s0)
	li	a4,66
	beq	a5,a4,.L5
	li	a4,73
	beq	a5,a4,.L6
	li	a4,65
	bne	a5,a4,.L10
	call	calculator
	j	.L8
.L6:
	call	interrupt
	j	.L8
.L5:
	call	fibonacci
	j	.L8
.L10:
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
	li	a0,10
	call	tx_byte
	li	a0,13
	call	tx_byte
.L8:
	j	.L9
	.size	main, .-main
	.align	2
	.globl	print_hello
	.type	print_hello, @function
print_hello:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	addi	s0,sp,16
	li	a0,10
	call	tx_byte
	li	a0,13
	call	tx_byte
	li	a0,72
	call	tx_byte
	li	a0,101
	call	tx_byte
	li	a0,108
	call	tx_byte
	li	a0,108
	call	tx_byte
	li	a0,111
	call	tx_byte
	li	a0,44
	call	tx_byte
	li	a0,32
	call	tx_byte
	li	a0,109
	call	tx_byte
	li	a0,121
	call	tx_byte
	li	a0,32
	call	tx_byte
	li	a0,110
	call	tx_byte
	li	a0,97
	call	tx_byte
	li	a0,109
	call	tx_byte
	li	a0,101
	call	tx_byte
	li	a0,32
	call	tx_byte
	li	a0,105
	call	tx_byte
	li	a0,115
	call	tx_byte
	li	a0,32
	call	tx_byte
	li	a0,66
	call	tx_byte
	li	a0,82
	call	tx_byte
	li	a0,73
	call	tx_byte
	li	a0,83
	call	tx_byte
	li	a0,67
	call	tx_byte
	li	a0,45
	call	tx_byte
	li	a0,86
	call	tx_byte
	nop
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	print_hello, .-print_hello
	.align	2
	.globl	print_mode
	.type	print_mode, @function
print_mode:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	addi	s0,sp,16
	li	a0,10
	call	tx_byte
	li	a0,13
	call	tx_byte
	li	a0,69
	call	tx_byte
	li	a0,110
	call	tx_byte
	li	a0,116
	call	tx_byte
	li	a0,101
	call	tx_byte
	li	a0,114
	call	tx_byte
	li	a0,32
	call	tx_byte
	li	a0,109
	call	tx_byte
	li	a0,111
	call	tx_byte
	li	a0,100
	call	tx_byte
	li	a0,101
	call	tx_byte
	li	a0,32
	call	tx_byte
	li	a0,91
	call	tx_byte
	li	a0,65
	call	tx_byte
	li	a0,44
	call	tx_byte
	li	a0,73
	call	tx_byte
	li	a0,44
	call	tx_byte
	li	a0,66
	call	tx_byte
	li	a0,93
	call	tx_byte
	li	a0,58
	call	tx_byte
	li	a0,32
	call	tx_byte
	nop
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	print_mode, .-print_mode
	.align	2
	.globl	fibonacci
	.type	fibonacci, @function
fibonacci:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	li	a0,83
	call	tx_byte
	li	a0,101
	call	tx_byte
	li	a0,113
	call	tx_byte
	li	a0,117
	call	tx_byte
	li	a0,101
	call	tx_byte
	li	a0,110
	call	tx_byte
	li	a0,99
	call	tx_byte
	li	a0,101
	call	tx_byte
	li	a0,32
	call	tx_byte
	li	a0,76
	call	tx_byte
	li	a0,101
	call	tx_byte
	li	a0,110
	call	tx_byte
	li	a0,58
	call	tx_byte
	li	a0,32
	call	tx_byte
	call	rx_byte
	sw	a0,-36(s0)
	lw	a5,-36(s0)
	mv	a0,a5
	call	tx_byte
	lw	a5,-36(s0)
	addi	a5,a5,-48
	sw	a5,-36(s0)
	sw	zero,-20(s0)
	j	.L14
.L15:
	call	rx_byte
	sw	a0,-20(s0)
.L14:
	lw	a4,-20(s0)
	li	a5,13
	bne	a4,a5,.L15
	li	a0,10
	call	tx_byte
	li	a0,13
	call	tx_byte
	li	a5,1
	sw	a5,-28(s0)
	sw	zero,-24(s0)
	sw	zero,-32(s0)
	j	.L16
.L17:
	lw	a4,-28(s0)
	lw	a5,-24(s0)
	add	a5,a4,a5
	sw	a5,-40(s0)
	lw	a5,-28(s0)
	sw	a5,-24(s0)
	lw	a5,-40(s0)
	sw	a5,-28(s0)
	lw	a0,-40(s0)
	call	tx_uint
	lw	a5,-32(s0)
	addi	a5,a5,1
	sw	a5,-32(s0)
.L16:
	lw	a5,-32(s0)
	lw	a4,-36(s0)
	bgtu	a4,a5,.L17
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	fibonacci, .-fibonacci
	.align	2
	.globl	calculator
	.type	calculator, @function
calculator:
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
	j	.L19
.L20:
	call	rx_byte
	sw	a0,-24(s0)
.L19:
	lw	a4,-24(s0)
	li	a5,13
	bne	a4,a5,.L20
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
	beq	a5,a4,.L22
	li	a4,43
	bgtu	a5,a4,.L23
	li	a4,35
	beq	a5,a4,.L24
	li	a4,38
	beq	a5,a4,.L25
	j	.L21
.L23:
	li	a4,45
	beq	a5,a4,.L26
	li	a4,94
	beq	a5,a4,.L27
	j	.L21
.L22:
	lw	a4,-32(s0)
	lw	a5,-40(s0)
	add	a5,a4,a5
	sw	a5,-20(s0)
	j	.L28
.L26:
	lw	a4,-32(s0)
	lw	a5,-40(s0)
	sub	a5,a4,a5
	sw	a5,-20(s0)
	j	.L28
.L27:
	lw	a4,-32(s0)
	lw	a5,-40(s0)
	xor	a5,a4,a5
	sw	a5,-20(s0)
	j	.L28
.L25:
	lw	a4,-32(s0)
	lw	a5,-40(s0)
	and	a5,a4,a5
	sw	a5,-20(s0)
	j	.L28
.L24:
	lw	a4,-32(s0)
	lw	a5,-40(s0)
	and	a5,a4,a5
	sw	a5,-20(s0)
	j	.L28
.L21:
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
.L28:
	lw	a5,-28(s0)
	bnez	a5,.L29
	lw	a0,-20(s0)
	call	tx_uint
.L29:
	li	a0,10
	call	tx_byte
	li	a0,13
	call	tx_byte
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	calculator, .-calculator
	.align	2
	.globl	interrupt
	.type	interrupt, @function
interrupt:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	li	a5,-1879048192
	addi	a5,a5,48
	sw	a5,-32(s0)
	li	a5,-1879048192
	addi	a5,a5,52
	sw	a5,-36(s0)
	li	a0,78
	call	tx_byte
	li	a0,101
	call	tx_byte
	li	a0,119
	call	tx_byte
	li	a0,32
	call	tx_byte
	li	a0,80
	call	tx_byte
	li	a0,67
	call	tx_byte
	li	a0,58
	call	tx_byte
	li	a0,32
	call	tx_byte
	sw	zero,-20(s0)
	li	a5,32
	sw	a5,-28(s0)
	j	.L31
.L35:
	call	rx_byte
	sw	a0,-40(s0)
	lw	a5,-40(s0)
	li	a4,48
	bltu	a5,a4,.L39
	li	a4,57
	bleu	a5,a4,.L33
	addi	a4,a5,-65
	li	a5,5
	bgtu	a4,a5,.L39
	j	.L38
.L33:
	lw	a5,-28(s0)
	addi	a5,a5,-4
	sw	a5,-28(s0)
	lw	a5,-40(s0)
	mv	a0,a5
	call	tx_byte
	lw	a5,-40(s0)
	addi	a5,a5,-48
	sw	a5,-40(s0)
	lw	a4,-40(s0)
	lw	a5,-28(s0)
	sll	a5,a4,a5
	lw	a4,-20(s0)
	or	a5,a4,a5
	sw	a5,-20(s0)
	j	.L31
.L38:
	lw	a5,-28(s0)
	addi	a5,a5,-4
	sw	a5,-28(s0)
	lw	a5,-40(s0)
	mv	a0,a5
	call	tx_byte
	lw	a5,-40(s0)
	addi	a5,a5,-55
	sw	a5,-40(s0)
	lw	a4,-40(s0)
	lw	a5,-28(s0)
	sll	a5,a4,a5
	lw	a4,-20(s0)
	or	a5,a4,a5
	sw	a5,-20(s0)
	j	.L31
.L39:
	nop
.L31:
	lw	a5,-28(s0)
	bgtz	a5,.L35
	sw	zero,-24(s0)
	j	.L36
.L37:
	call	rx_byte
	sw	a0,-24(s0)
.L36:
	lw	a4,-24(s0)
	li	a5,13
	bne	a4,a5,.L37
	lw	a5,-32(s0)
	lw	a4,-20(s0)
	sw	a4,0(a5)
	lw	a5,-36(s0)
	li	a4,1
	sw	a4,0(a5)
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	interrupt, .-interrupt
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
.L41:
	lw	a5,-24(s0)
	lw	a5,0(a5)
	beqz	a5,.L41
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
.L44:
	lw	a5,-24(s0)
	lw	a5,0(a5)
	beqz	a5,.L44
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
	j	.L46
.L49:
	lw	a5,-36(s0)
	sw	a5,-20(s0)
	j	.L47
.L48:
	lw	a0,-20(s0)
	call	div10
	sw	a0,-20(s0)
.L47:
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	bgtu	a4,a5,.L48
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
.L46:
	lw	a4,-36(s0)
	lw	a5,-24(s0)
	bgtu	a4,a5,.L49
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
	j	.L51
.L52:
	lw	a5,-20(s0)
	addi	a5,a5,-10
	sw	a5,-20(s0)
.L51:
	lw	a4,-20(s0)
	li	a5,9
	bgtu	a4,a5,.L52
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
	j	.L55
.L56:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
	lw	a5,-20(s0)
	addi	a5,a5,10
	sw	a5,-20(s0)
.L55:
	lw	a4,-20(s0)
	lw	a5,-36(s0)
	bltu	a4,a5,.L56
	lw	a5,-24(s0)
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	div10, .-div10
	.align	2
	.globl	loopback
	.type	loopback, @function
loopback:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	li	a5,-1879048192
	addi	a5,a5,32
	sw	a5,-20(s0)
	li	a5,-1879048192
	addi	a5,a5,16
	sw	a5,-24(s0)
	li	a5,-1879048192
	addi	a5,a5,36
	sw	a5,-28(s0)
	li	a5,-1879048192
	addi	a5,a5,20
	sw	a5,-32(s0)
	li	a5,-1879048192
	addi	a5,a5,48
	sw	a5,-36(s0)
	li	a5,-1879048192
	addi	a5,a5,52
	sw	a5,-40(s0)
	li	a0,10
	call	tx_byte
	li	a0,13
	call	tx_byte
.L62:
	nop
.L59:
	lw	a5,-32(s0)
	lw	a5,0(a5)
	beqz	a5,.L59
	lw	a5,-24(s0)
	lw	a5,0(a5)
	sw	a5,-44(s0)
	lw	a4,-44(s0)
	li	a5,27
	bne	a4,a5,.L63
	li	a0,10
	call	tx_byte
	li	a0,13
	call	tx_byte
	li	a5,4096
	addi	a0,a5,-744
	call	tx_uint
	lw	a5,-36(s0)
	sw	zero,0(a5)
	lw	a5,-40(s0)
	li	a4,1
	sw	a4,0(a5)
.L63:
	nop
.L61:
	lw	a5,-28(s0)
	lw	a5,0(a5)
	beqz	a5,.L61
	lw	a5,-20(s0)
	lw	a4,-44(s0)
	sw	a4,0(a5)
	j	.L62
	.size	loopback, .-loopback
	.ident	"GCC: (GNU) 7.2.0"
