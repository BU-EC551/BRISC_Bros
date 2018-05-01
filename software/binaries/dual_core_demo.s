	.file	"dual_core_demo.c"
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
.L10:
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
	lw	a4,-24(s0)
	li	a5,65
	bne	a4,a5,.L4
	call	calculator
	j	.L5
.L4:
	lw	a4,-24(s0)
	li	a5,73
	bne	a4,a5,.L6
	li	a0,1
	call	interrupt
	j	.L5
.L6:
	lw	a4,-24(s0)
	li	a5,66
	bne	a4,a5,.L7
	call	fibonacci
	j	.L5
.L7:
	lw	a4,-24(s0)
	li	a5,77
	bne	a4,a5,.L8
	call	start_mandelbrot
	j	.L5
.L8:
	lw	a4,-24(s0)
	li	a5,67
	bne	a4,a5,.L9
	call	clear_screen
	j	.L5
.L9:
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
.L5:
	j	.L10
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
	li	a0,44
	call	tx_byte
	li	a0,67
	call	tx_byte
	li	a0,44
	call	tx_byte
	li	a0,77
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
	li	a0,44
	call	tx_byte
	li	a0,42
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
	li	a4,38
	beq	a5,a4,.L24
	li	a4,42
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
.L24:
	lw	a4,-32(s0)
	lw	a5,-40(s0)
	and	a5,a4,a5
	sw	a5,-20(s0)
	j	.L28
.L25:
	lw	a1,-40(s0)
	lw	a0,-32(s0)
	call	multu
	sw	a0,-20(s0)
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
	bnez	a5,.L30
	lw	a0,-20(s0)
	call	tx_uint
.L30:
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	calculator, .-calculator
	.align	2
	.globl	program_interrupt
	.type	program_interrupt, @function
program_interrupt:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	li	a5,-1879048192
	addi	a5,a5,48
	sw	a5,-20(s0)
	li	a5,-1879048192
	addi	a5,a5,52
	sw	a5,-24(s0)
	lw	a5,-20(s0)
	lw	a4,-36(s0)
	sw	a4,0(a5)
	lw	a5,-24(s0)
	lw	a4,-40(s0)
	sw	a4,0(a5)
	nop
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	program_interrupt, .-program_interrupt
	.align	2
	.globl	interrupt
	.type	interrupt, @function
interrupt:
	addi	sp,sp,-64
	sw	ra,60(sp)
	sw	s0,56(sp)
	addi	s0,sp,64
	sw	a0,-52(s0)
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
	j	.L33
.L37:
	call	rx_byte
	sw	a0,-40(s0)
	lw	a5,-40(s0)
	li	a4,48
	bltu	a5,a4,.L41
	li	a4,57
	bleu	a5,a4,.L35
	addi	a4,a5,-65
	li	a5,5
	bgtu	a4,a5,.L41
	j	.L40
.L35:
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
	j	.L33
.L40:
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
	j	.L33
.L41:
	nop
.L33:
	lw	a5,-28(s0)
	bgtz	a5,.L37
	sw	zero,-24(s0)
	j	.L38
.L39:
	call	rx_byte
	sw	a0,-24(s0)
.L38:
	lw	a4,-24(s0)
	li	a5,13
	bne	a4,a5,.L39
	lw	a5,-32(s0)
	lw	a4,-20(s0)
	sw	a4,0(a5)
	lw	a5,-36(s0)
	lw	a4,-52(s0)
	sw	a4,0(a5)
	nop
	lw	ra,60(sp)
	lw	s0,56(sp)
	addi	sp,sp,64
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
.L43:
	lw	a5,-24(s0)
	lw	a5,0(a5)
	beqz	a5,.L43
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
.L46:
	lw	a5,-24(s0)
	lw	a5,0(a5)
	beqz	a5,.L46
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
	j	.L48
.L51:
	lw	a5,-36(s0)
	sw	a5,-20(s0)
	j	.L49
.L50:
	lw	a0,-20(s0)
	call	div10
	sw	a0,-20(s0)
.L49:
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	bgtu	a4,a5,.L50
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
.L48:
	lw	a4,-36(s0)
	lw	a5,-24(s0)
	bgtu	a4,a5,.L51
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
	j	.L53
.L54:
	lw	a5,-20(s0)
	addi	a5,a5,-10
	sw	a5,-20(s0)
.L53:
	lw	a4,-20(s0)
	li	a5,9
	bgtu	a4,a5,.L54
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
	j	.L57
.L58:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
	lw	a5,-20(s0)
	addi	a5,a5,10
	sw	a5,-20(s0)
.L57:
	lw	a4,-20(s0)
	lw	a5,-36(s0)
	bltu	a4,a5,.L58
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
	j	.L61
.L63:
	lw	a4,-36(s0)
	lw	a5,-24(s0)
	srl	a5,a4,a5
	andi	a5,a5,1
	beqz	a5,.L62
	lw	a4,-40(s0)
	lw	a5,-24(s0)
	sll	a5,a4,a5
	lw	a4,-20(s0)
	add	a5,a4,a5
	sw	a5,-20(s0)
.L62:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L61:
	lw	a4,-24(s0)
	li	a5,31
	ble	a4,a5,.L63
	lw	a5,-20(s0)
	mv	a0,a5
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	multu, .-multu
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
.L69:
	nop
.L66:
	lw	a5,-32(s0)
	lw	a5,0(a5)
	beqz	a5,.L66
	lw	a5,-24(s0)
	lw	a5,0(a5)
	sw	a5,-44(s0)
	lw	a4,-44(s0)
	li	a5,27
	bne	a4,a5,.L70
	li	a0,10
	call	tx_byte
	li	a0,13
	call	tx_byte
	lw	a5,-36(s0)
	li	a4,4
	sw	a4,0(a5)
	lw	a5,-40(s0)
	li	a4,1
	sw	a4,0(a5)
.L70:
	nop
.L68:
	lw	a5,-28(s0)
	lw	a5,0(a5)
	beqz	a5,.L68
	lw	a5,-20(s0)
	lw	a4,-44(s0)
	sw	a4,0(a5)
	j	.L69
	.size	loopback, .-loopback
	.align	2
	.globl	start_mandelbrot
	.type	start_mandelbrot, @function
start_mandelbrot:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	addi	s0,sp,16
	li	a0,83
	call	tx_byte
	li	a0,116
	call	tx_byte
	li	a0,97
	call	tx_byte
	li	a0,114
	call	tx_byte
	li	a0,116
	call	tx_byte
	li	a0,105
	call	tx_byte
	li	a0,110
	call	tx_byte
	li	a0,103
	call	tx_byte
	li	a0,32
	call	tx_byte
	li	a0,77
	call	tx_byte
	li	a0,97
	call	tx_byte
	li	a0,110
	call	tx_byte
	li	a0,100
	call	tx_byte
	li	a0,101
	call	tx_byte
	li	a0,108
	call	tx_byte
	li	a0,98
	call	tx_byte
	li	a0,114
	call	tx_byte
	li	a0,111
	call	tx_byte
	li	a0,116
	call	tx_byte
	li	a0,46
	call	tx_byte
	li	a0,46
	call	tx_byte
	li	a0,46
	call	tx_byte
	li	a0,10
	call	tx_byte
	li	a0,13
	call	tx_byte
	li	a1,2
	li	a0,332
	call	program_interrupt
	nop
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	start_mandelbrot, .-start_mandelbrot
	.align	2
	.globl	clear_screen
	.type	clear_screen, @function
clear_screen:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	addi	s0,sp,16
	li	a0,67
	call	tx_byte
	li	a0,108
	call	tx_byte
	li	a0,101
	call	tx_byte
	li	a0,97
	call	tx_byte
	li	a0,114
	call	tx_byte
	li	a0,32
	call	tx_byte
	li	a0,83
	call	tx_byte
	li	a0,114
	call	tx_byte
	li	a0,99
	call	tx_byte
	li	a0,101
	call	tx_byte
	li	a0,101
	call	tx_byte
	li	a0,110
	call	tx_byte
	li	a0,32
	call	tx_byte
	li	a0,46
	call	tx_byte
	li	a0,46
	call	tx_byte
	li	a0,46
	call	tx_byte
	li	a0,10
	call	tx_byte
	li	a0,13
	call	tx_byte
	li	a1,2
	li	a0,4
	call	program_interrupt
	nop
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	clear_screen, .-clear_screen
	.ident	"GCC: (GNU) 7.2.0"
