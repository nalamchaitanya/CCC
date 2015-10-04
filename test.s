	.section	.rodata
.LC0:
	.string	"%d\t%d\t%d\t%d\t%d\t%d\t%d\n"
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	movl	$1, -36(%rbp)
	movl	$2, -32(%rbp)
	movl	$3, -28(%rbp)
	movl	$4, -24(%rbp)
	movl	$5, -20(%rbp)
	movl	$6, -16(%rbp)
	movl	$7, -12(%rbp)
	movl	$8, -8(%rbp)
	movl	$9, -4(%rbp)
	movl	-36(%rbp), %esi
	movl	-32(%rbp), %edx
	movl	-28(%rbp), %ecx
	movl	-24(%rbp), %r8d
	movl	-20(%rbp), %r9d
	movl	-16(%rbp), %eax
	movl	%eax, (%rsp)
	movl	-12(%rbp), %eax
	movl	%eax, 8(%rsp)
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	leave
	ret
