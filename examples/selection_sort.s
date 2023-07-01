.globl main
.data
fmt: .ascii "%d "
.text
main:
  # save copy of rsp and rbp
  push %rbp
  mov %rsp, %rbp
  sub $8000, %rsp

  # rsp = [431, 3, 223, 223432, 25, 224]
  movq $431, (%rsp)
  movq $3, 8(%rsp)
  movq $223, 16(%rsp)
  movq $232432, 24(%rsp)
  movq $25, 32(%rsp)
  movq $224, 40(%rsp)

  mov $6, %r15
  mov $0, %rcx

loop_i:
  mov %rcx, %r8
  mov %rcx, %rbx
loop_j:
  inc %rbx
  cmp %r15, %rbx
  jge out_j
  mov (%rsp, %rbx, 8), %r9
  cmp %r9, (%rsp, %r8, 8)

  jl loop_j
  mov %rbx, %r8
  jmp loop_j
out_j:
  mov (%rsp, %rcx, 8), %r9
  mov (%rsp, %r8, 8), %r10
  mov %r10, (%rsp, %rcx, 8)
  mov %r9, (%rsp, %r8, 8)

  inc %rcx
  cmp %r15, %rcx
  jge out_i
  jmp loop_i

out_i:
  mov %r15, %rcx
  mov $0, %rbx

# rsp = [3, 25, 223, 224, 431, 232432]
loop_a:
  mov %rcx, %r12
  mov $fmt, %rdi
  mov (%rsp, %rbx, 8), %rsi
  mov $0, %rax
  call printf
  mov %r12, %rcx
  inc %rbx
  loop loop_a

out_a:
  # restore rsp and rbp with copies
  mov %rbp, %rsp
  pop %rbp
