	.file	"tx_serial.c"
	.option nopic
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	li	a5,-1879048192
	sw	a5,-24(s0)
	li	a5,-1879048192
	addi	a5,a5,32
	sw	a5,-28(s0)
	li	a5,-1879048192
	addi	a5,a5,36
	sw	a5,-32(s0)
	sw	zero,-20(s0)
	j	.L2
.L4:
	lw	a5,-32(s0)
	lw	a5,0(a5)
	beqz	a5,.L3
	lw	a5,-20(s0)
	addi	a5,a5,48
	mv	a4,a5
	lw	a5,-28(s0)
	sw	a4,0(a5)
.L3:
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L2:
	lw	a4,-20(s0)
	li	a5,9
	ble	a4,a5,.L4
	lw	a5,-24(s0)
	li	a4,1
	sw	a4,0(a5)
.L5:
	j	.L5
	.size	main, .-main
	.ident	"GCC: (GNU) 7.2.0"
