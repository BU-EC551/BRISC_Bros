	.file	"frame_buffer.c"
	.option nopic
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	li	a5,-2147483648
	sw	a5,-32(s0)
	sw	zero,-20(s0)
	sw	zero,-24(s0)
	j	.L2
.L5:
	sw	zero,-28(s0)
	j	.L3
.L4:
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
	lw	a4,-20(s0)
	li	a5,536870912
	add	a5,a4,a5
	slli	a5,a5,2
	sw	a5,-32(s0)
	lw	a5,-24(s0)
	srai	a5,a5,2
	andi	a4,a5,1
	lw	a5,-32(s0)
	sw	a4,0(a5)
	lw	a5,-28(s0)
	addi	a5,a5,1
	sw	a5,-28(s0)
.L3:
	lw	a4,-28(s0)
	li	a5,639
	ble	a4,a5,.L4
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L2:
	lw	a4,-24(s0)
	li	a5,479
	ble	a4,a5,.L5
	li	a5,-1879048192
	sw	a5,-36(s0)
	lw	a5,-36(s0)
	li	a4,1
	sw	a4,0(a5)
.L6:
	j	.L6
	.size	main, .-main
	.ident	"GCC: (GNU) 7.2.0"
