.globl main
.data
fmt_c: .ascii "%c\0"
fmt_d: .ascii "%d\0"
fmt_s: .ascii "%s\0"
.text
main:
  push %rbp
  mov %rsp, %rbp
  sub $8000, %rsp
  mov $0, %r15

loop_a:
  call getchar

  # accounts for '\n' & '\0'
  # use %eax because signed bit will become 0 with %rax
  cmp $11, %eax
  jl out_a
  movb %al, (%rsp, %r15)
  inc %r15
  jmp loop_a

out_a:
  mov %r15, %rcx
  mov $0, %r14
loop_b:
  add %r15, (%rsp, %r14)
  inc %r14
  loop loop_b

out_b:
  mov $fmt_s, %rdi
  mov %rsp, %rsi
  mov $0, %rax
  call printf
  mov %rbp, %rsp
  pop %rbp
