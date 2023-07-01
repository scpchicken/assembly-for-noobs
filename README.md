# Assembly for Noobs

# So you want to learn assembly?

The luck possessed by thee is unparalleled, for thou art did grant the blessing bestoweth upon this enchiridion's grandeur. This definite guide will answer all your questions about this ancient and mysterious programming language. The dialect used will be x86-64 GAS syntax/AT&T for the GCC compiler, but you can apply these concepts to most Assembly dialects. Prerequisites include basic knowledge of the [C programming language](https://www.youtube.com/watch?v=tas0O586t80) and/or full completion of the hit game [Human Resource Machine](https://www.youtube.com/watch?v=dQw4w9WgXcQ) will help grasp concepts quicker.


# File Compilation
- before learning the fundamentals, it is important to understand the different ways to execute assembly code

### Command Line
#### GCC
- similar to inline assembly
- able to define .data segment
- need to make your own main function
```bash
cat > bruh.s <<- 'BRUH'
.globl main

.data
bruh: .ascii "bruh moment"

.text
main:
  push %rbp
  mov %rsp, %rbp

  mov $bruh, %rdi
  mov $0, %rax
  call puts
  mov %rbp, %rsp
  pop %rbp
BRUH

gcc -no-pie -g bruh.s -o bruh
./bruh
```

#### AS (only for the epic gamers)
```bash
cat > bruh.s <<- 'BRUH'
.global _start

.data
bruh: .ascii  "bruh moment"
bruh_len = . - bruh

.text
_start:
  mov $1, %rax
  mov $1, %rdi
  mov $bruh, %rsi
  mov $bruh_len, %rdx
  syscall

  mov $60, %rax
  xor %rdi, %rdi
  syscall
BRUH

as -g ./bruh.s -o bruh.o
ld bruh.o -o bruh
./bruh
```

### Inline Assembly
#### Standard Mode
```c
int main() {
  asm volatile(R"(
movb $'b', (%rsp)
movb $'r', 1(%rsp)
movb $'u', 2(%rsp)
movb $'h', 3(%rsp)
movb $0, 4(%rsp)

mov %rsp, %rdi
call puts
  )");
}
```

#### Extended Mode
- Useful if you want to just test a few instructions but it's a bit complicated to get started
- [Read More](https://ibiblio.org/gferg/ldp/GCC-Inline-Assembly-HOWTO)
```c
int main() {
  char * bruh_moment = "bruh\0";
  asm volatile(R"(
call puts
  )"
  :
  : "D" (bruh_moment)
  );
}
```












# Syntax

- Section [.data || .text]
- Literal [$5 || $'\n' || $bruh || $3+5 || $0b1010 || $0xdeadbeef || $0777]
- Register [%rax || %esi || %bh || %cl]
- Memory [(%rsp) || 8(%rsp,%rcx) || -16(%rsp, %rcx, 8)]
- Label [lab: || yourmom: || bruh:]
- Instruction [mov $5, %rax]





# Sections
.globl main
- allows for the file to call your code
```gas
# gcc
.globl main
.text
main:

# as
.globl _start:
.text
_start:
```

.data
- define constants

.text
- rest of your code














# Literals
- literals are prefixed with a $ symbol
```gas
# number 32 
$32

# single quote char
$'\''

# expression (6 / 9) + 5 (int division)
$(6/9)+5
$ ( 6 / 9 ) + 5

# value of the constant "bruh" address
.data
bruh: .ascii "bruh\0
.text
$bruh

# binary
$0b1010101

# octal
$0777

# hexadecimal
$0xabc
```













# Registers
- registers are prefixed with a % symbol
- all non-xmm registers have a 64, 32, 16, 8 bit sections (same register, different chunks)
- only rax, rbx, rcx, rdx have a 16-8 bit higher (h) byte section
[![register and subregister image](https://i.postimg.cc/PxNWm9Wg/image-1.jpg)](https://postimg.cc/vgFxyPSh)

## Temporary Registers (may get overwritten by call functions)

#### %rax (%eax, %ax, %ah & %al)
- most common register
- specify syscall instrution number
- dividend and quotient in integer division (the "a" in [a = a / b])
- return value of function call

#### %rdi (%edi, %di, %dil)
- 1st argument in function call / syscall

#### %rsi (%esi, %si, %sil)
- 2nd argument in function call / syscall

#### %rdx (same as %rax)
- 3nd argument in function call / syscall
- remainder in integer division (the "d" in [d = a % b])

#### %rcx (same as %rax)
- 4th argument in function call / syscall
- looping variable

#### %r8 (%r8d, %r8w, %r8b)
- 5th argument in function call / syscall

#### %r9 (same as %r8)
- 6th argument in function call / syscall

#### %xmm0
- SIMD float register
- 1st argument when calling function (if float)
- return value from function (if float)

#### %xmm1, %xmm2 .. %xmm15
- more SIMD float registers

## Preserved Registers (bad things may happen if you don't save original value for reassign)

#### %rbx (same as %rax)

#### %rbp (%ebp, %bp, %bpl)
- store an old value of %rsp for functions
- can store arrays (base stack pointer)

#### %rsp (same as %rbp)
- points to the top of the stack
- can be used to create local variables for recursion
- push and pop will modify (need to utilise %rbp)
- can store arrays (stack pointer)

#### %r10, %r11 .. %r15 (same as %r8)

## Misc Registers

#### %rip
- don't need to use this as most instructions abstract it away
- allows you to move the instruction pointer

#### %rflags
- don't need to use this as there are instructions referencing individual flags











# Memory
#### To understand memory, imagine this scenario:<br>
There exists a prison containing an infinite amount of prison cells. There are registered bad guys convicted with the most heinous crimes. It so happens that they have names including but not limited to %rax, %rbx, %rcx. They are given a prison numbers $1, $2, $3 respectively. When they get to their prison cell via their prison number, they find a random amount of chicken inside. In this hypothetical thought experiment, the prison cells reference the individual memory cells that can be indexed via the numbers of the prisoners. The amount of chicken refers to the values that you find when indexing the prison cells. This value will change depending on the size of the prison cell you choose to use. For example, if you use the q suffix as seen in "movq", it assume that the prison cell is 8 bytes wide. The instruction will refer to the index plus 7 bytes afterwards as a single value. By this logic, it is safe to assume the size of one's prison cell is directly proportional to the amount of chicken that is available.

[![image of prisoner named rax with an orange shirt holding a sign with the number 1 on it and then 4 prison cells with the numbers 1 to 4. there is a random amount of chicken in each cell. there are a lot of red arrows pointing to the 1st cell, which is the number the prisoner is holding](https://i.postimg.cc/kgv5vdmB/memory.png)](https://postimg.cc/ZW0ZJ20S)

- store local variables for recursion 
- store variables that are instantly recognizable for improved coding speed
- multiplication via lea instruction
- storing and indexing arrays
- usually you want an offset of %rbp or %rsp

```gas
# *rbp (assumes 8 bytes since %rbp is 8 byte register)
(%rbp)

# *(8 + rbp)
8(%rbp)

# *(-8 + rsp)
-8(%rsp)

# *(rbp + rax)
(%rbp,%rax)

# *(-6969 + rbp + rax * 8) (useful for looping through an array at an offset)
# only 1, 2, 4, 8 allowed
-6969(%rbp,%rax,8)

# rsp = "ab\0"
movb $'a', 0(%rsp)
movb $'b', 1(%rsp)
movb $0, 2(%rsp)
```




# Important Instructions
## Disclaimer: GAS syntax instructions are backwards when compared to conventional programming languages, very epic gamer moment.

- most instructions are split into 3 components
- the "name" will use the "source" to modify the "destination"
1. instruction name (mnemonic)
2. source
3. destination

### mov
- the most fundamental instruction is assignment
- move A into B
- when working with memory specify the suffix
```gas
# 1 -> rax (rax = 1)
mov $1, %rax
```
```gas
# rbp -> rdi
mov %rbp, %rdi
```
 
### lea
- register reference assignment
- useful for scanf int / char
```gas
# &var_6969 -> rcx (rcx = &var_6969)
lea -6969(%rbp), %rcx
```
 
### add
- add A to B
```gas
# rax + 1 -> rax (rax += 1)
add $1, %rax
```
```gas
# rax + rcx -> rax (rax += rcx)
add %rcx, %rax
```
 
### sub

### neg
- regular negation
- flips all bits and adds 1

### xor
- bitwise xor (^)

### and
- bitwise and (&)

### not
- bitwise negation (~)
- flips all bits

### shl / sal
- bitwise left shift (<<)

### sar
- bitwise right shift (>>)
- maintain signed bit

### shr
- bitwise right shift
- also shift the signed bit

 
### idiv
- unsigned division of rax
- ensure %rdx = 0
```gas
mov $0, %rdx
# rax / rcx -> rax (rax /= rcx)
# rax % rcx -> rdx (rdx = rax % rcx)
idiv %rcx
```
 
### imul
- unsigned multiplication of rax
```gas
# rax * rcx -> rax (rax *= rcx)
imul %rcx
```

### xchg
- exchange the source and destination (a, b) = (b, a)
### cmp
### jmp / j + suffix
### cmov + suffix

### loop

















# Labels & Conditionals (Compare & Jump)

- jmp: jump if 6<9 (unconditional jump)
- jz / je: jump if zero
- jnz / jne: jump if not zero
- jg: jump if greater
- jge: jump if greater or equal
- jl: jump if less than
- jle: jump if less than or equal
- jcxz: jump if %rcx is zero (no cmp)
 
#### C code
```c
if (rax < 10) {
  rax = 1;
} else {
  rax = 0;
}
```
 
#### ASM translation
```gas
cmp $10, %rax
 
# jump to true label if 10 > rax (rax < 10)
# fall-through if no jump
jl true
# jump to false label
jmp false
 
# true goto label
true:
  mov $1, %rax
  # jump to end label to avoid fallthrough
  jmp end
 
false:
  mov $0, %rax
 
end:
```















# Looping
 
#### C code
```c
int rax = 1;
int rbx = 7;
int rcx = 5;
do {
  rax *= rbx;
} while (--rcx);
```
 
#### ASM translation
```gas
mov $1, %rax
mov $7, %rbx
mov $5, %rcx
 
# goto label name
for_loop:
  # rax * rbx -> rax
  imul %rbx
  # loop only works with rcx
  loop for_loop
```
















# SIMD (Floating Point Math)

#### C code
```c
int rax = 123;
rax = sqrt(rax);
```
 
#### ASM translation
```gas
mov $123, %rax
# convert single integer to single double
cvtsi2sd %rax, %xmm0
# sqrt(xmm0) -> xmm1
sqrtsd %xmm0, %xmm1
# convert single double to single integer
cvtsd2si %xmm1, %rax
```
 
## 
 
#### C code
```c
int rax = 123;
double rax = sqrt(rax);
```
#### ASM translation
```gas
mov $123, %rax
cvtsi2sd %rax, %xmm0
sqrtsd %xmm0, %xmm1
 
# move quadword (idk why you need quadword)
movq %xmm1, %rax
```
 
## 
 
#### C code
```c
int rax = 123;
double rax_f = sqrt(rax);
printf("%f", rax_f);
```
#### ASM translation
```gas
mov $123, %rax
cvtsi2sd %rax, %xmm0
sqrtsd %xmm0, %xmm1
movq %xmm1, %rax
 
mov $'%', (%rbp)
mov $'f', 1(%rbp)
mov $0, 2(%rbp)
mov %rbp, %rdi
mov %rax, %rsi
 
# rax = 1 is float print
mov $1, %rax
 
call printf
```

















# GCC Function Calling

```gas
# getchar() -> rax
call getchar
```
 
##

#### C code
```c
char * rbp = "%d\0";
int var_6969;
scanf(rbp, &var_6969);
 
rbp = "%d\0";
printf(rbp, var_6969);
```
 
#### ASM translation
```gas
# rbp = "%d\0"
# *(rbp + 0) = '%'
mov $'%', (%rbp)
# *(rbp + 1) = 'd'
mov $'d', 1(%rbp)
# *(rbp + 2) = 0
mov $0, 2(%rbp)
 
# &var_6969 -> rcx (rcx = &var_6969)
lea -6969(%rbp), %rcx
 
# rbp -> rdi (1st arg is format str)
mov %rbp, %rdi
# rcx -> rsi (2nd arg is var ref)
mov %rcx, %rsi
# if rax = 1 it will read float
mov $0, %rax
 
# scanf(rbp, &var_6969)
call scanf
 
mov $'%', (%rbp)
mov $'d', 1(%rbp)
mov $0, 2(%rbp)
 
mov %rbp, %rdi
mov -6969(%rbp), %rsi
 
# if rax = 1 it will print float
mov $0, %rax
 
# printf(rbp, var_6969)
call printf
```














# Syscall
 
#### C code (not an exact untranslation because im too noob)
```c
int rax, rcx, rdi;

rax = 500;
int * rsp = 69;
char * rsi = &rsp;
*rsi = '\n';
 
rcx = 10;
int len = 1;
do {
  *--rsi = (rax % rcx) + '0';
  rax /= rcx;
  len++;
} while(rax);

rax = 1;
rdi = 1;
syscall(rax, rdi, rsi, len);
```
 
#### ASM translation
```gas
mov $500, %rax
 
print_num:
  lea -1(%rsp), %rsi
  movb $10, (%rsi)
  # base 10
  mov $10, %rcx
 
print_digit:
  xor %rdx, %rdx
  div %rcx
 
  add $'0', %rdx
  dec %rsi
  movb %dl, (%rsi)
 
  test %rax, %rax
  jne print_digit
  mov $1, %rax
  mov $1, %rdi
  mov %rsp, %rdx
  sub %rsi, %rdx
  syscall
```

# User Created Functions & Recursion
#### C code
```gas
int f(int n) {
  if (n < 5) {return f(n + 1);}
  return n;
}

int main() {
  printf("%d", f(1));
}
```

#### ASM translation
```gas
.globl main
.data
bruh: .string "%d"
.text
main:
  push %rbp
  mov %rsp, %rbp
  mov $1, %rcx
  mov %rcx, %rdi
  call f

  mov $bruh, %rdi
  mov %rax, %rsi
  mov $0, %rax
  call printf

  mov %rbp, %rsp
  pop %rbp

f:
  push %rbp
  mov %rsp, %rbp

  # will "push" the recursed n value each time by moving the stack pointer up
  sub $8, %rsp
  mov %rdi, -8(%rbp)
  cmpq $4, -8(%rbp)
  jg else_ret
  mov -8(%rbp), %eax
  inc %rax
  mov %rax, %rdi
  call f
  jmp if_ret
else_ret:
  mov -8(%rbp), %rax
if_ret:
  # allows for the function to backtrack (no idea how it work)
  leave
  ret
```
