	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
kernel: 
	addi	zero,zero,0
	addi	ra,zero,0
	addi	sp,zero,450
	addi	gp,zero,0
	addi	tp,zero,0
	addi	t0,zero,0
	addi	t1,zero,0
	addi	t2,zero,0
	addi	s0,zero,0
	addi	a0,zero,0
	addi	a1,zero,0
	addi	a2,zero,0
	addi	s3,zero,0
	addi	a4,zero,0
	addi	a5,zero,0
	addi	a6,zero,0
	addi	a7,zero,0
	addi	s2,zero,0
	addi	s3,zero,0
	addi	s4,zero,0
	addi	s5,zero,0
	addi	s6,zero,0
	addi	s7,zero,0
	addi	s8,zero,0
	addi	s9,zero,0
	addi	s10,zero,0
	addi	s11,zero,0
	addi	t3,zero,0
	addi	t4,zero,0
	addi	t5,zero,0
	addi	t6,zero,0
	call	main
	addi	zero,zero,0
	mv	    s1,a0
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
	auipc	ra,0x0
	jalr	ra,0(ra)
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
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
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
	auipc	ra,0x0
	jalr	ra,0(ra)
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
