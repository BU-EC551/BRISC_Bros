	.file	"loopback_serial.c"
	.option nopic
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sw	s0,44(sp)
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
.L4:
	nop
.L2:
	lw	a5,-32(s0)
	lw	a5,0(a5)
	beqz	a5,.L2
	lw	a5,-24(s0)
	lw	a5,0(a5)
	sw	a5,-36(s0)
	nop
.L3:
	lw	a5,-28(s0)
	lw	a5,0(a5)
	beqz	a5,.L3
	lw	a5,-20(s0)
	lw	a4,-36(s0)
	sw	a4,0(a5)
	j	.L4
	.size	main, .-main
	.ident	"GCC: (GNU) 7.2.0"
