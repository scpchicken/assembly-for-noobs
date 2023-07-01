cat > bruh.s <<- 'BRUH'
.globl main
.data
fmt_c: .ascii "%c\0"
fmt_d: .ascii "%ld\0"
fmt_s: .ascii "%s\0"

.text
main:
  push %rbp
  mov %rsp, %rbp
  sub $8000, %rsp

  mov $fmt_d, %rdi
  lea -6969(%rsp), %rsi
  mov $0, %rax
  call scanf

  mov $0, %r15
  mov $0, %r12

loop_a:
  cmp -6969(%rsp), %r15
  jge out_a

  mov $fmt_d, %rdi
  lea -8008(%rsp), %rsi
  mov $0, %rax
  call scanf

  add -8008(%rsp), %r12

  inc %r15
  jmp loop_a

out_a:
  mov $fmt_d, %rdi
  mov %r12, %rsi
  mov $0, %rax
  call printf
  mov %rbp, %rsp
  pop %rbp
BRUH

gcc -no-pie -g bruh.s -o bruh
./bruh
