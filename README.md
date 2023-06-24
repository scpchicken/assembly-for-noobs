# Assembly for Noobs

## So you want to learn assembly?
The luck possessed by thee is unparalleled, for thou art did grant the blessing bestoweth upon this enchiridion's grandeur. This definite guide will answer all your questions about this ancient and mysterious programming language. The dialect used will be x86-64 GAS syntax/AT&T for the GCC compiler, but you can apply these concepts to most Assembly dialects. Basic knowledge of the C programming language will help grasp concepts quicker.

## Registers
### Special Registers (some instructions will mutate)
#### %rax
- most common register
- specify syscall instrution number
- dividend and quotient in integer division (the "a" in [a = a / b])
- return value of function call

#### %rbx
#### %rcx
#### %rdx
- 3rd argument in function call / syscall
- remainder in integer division (the "d" in [d = a % b])
#### %rdi
- 1st argument in function call / syscall
#### %rsi
- 2nd argument in function call / syscall
#### %r8
- 4th argument in function call / syscall
#### %r9
- 5th argument in function call / syscall
#### %r10
- 6th argument in function call / syscall
#### %rip
- something about instruction pointer idk

### Normal Registers (won't be modified)
#### %rbp
- something about frame pointing and scoping idk
- can store arrays
#### %rsp
- something about stack pointing idk
- if you push and pop stuff it will change
- can store arrays
#### %r11
#### %r12
#### %r13
#### %r14
#### %r15
#### %xmm0
#### %xmm1
#### %xmm2
#### %xmm3
#### %xmm4
#### %xmm5
#### %xmm6
#### %xmm7

## Important Instructions

### mov
- the most fundamental instruction is assignment
- move A into B
```python
# 1 -> rax (rax = 1)
mov $1, %rax
```
```python
# rbp -> rdi
mov %rbp, %rdi
```

### lea
- register reference assignment
- useful for scanf int / char
```python
# &var_6969 -> rcx (rcx = &var_6969)
lea -6969(%rbp), %rcx
```

### add
- add A to B
```python
# rax + 1 -> rax (rax += 1)
add $1, %rax
```
```python
# rax + rcx -> rax (rax += rcx)
add %rcx, %rax
```

### sub

### idiv
- unsigned division of rax
- ensure %rdx = 0
```python
mov $0, %rdx
# rax / rcx -> rax (rax /= rcx)
# rax % rcx -> rdx (rdx = rax % rcx)
idiv %rcx
```

### imul
- unsigned multiplication of rax
```python
# rax * rcx -> rax (rax *= rcx)
imul %rcx
```

### shl
### shr
### cmp
### loop

## Labels & Conditionals (Compare & Jump)
- jmp: jump if 6<9 (unconditional jump)
- je: jump if equal
- jne: jump if not equal
- jg: jump if greater
- jge: jump if greater or equal
- jl: jump if less than
- jle: jump if less than or equal

#### C code
```c
if (10 < rax) {
  rax = 1;
} else {
  rax = 0;
}
```

#### ASM translation
```python
cmp $10, %rax

# jump to true label if 10 < rax
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

## Looping

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
```python
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

## GCC Function Calling
```python
# getchar() -> rax
call getchar
```

## 

#### C code
```c
char * rbp = "%d\0";
int var_6969;
scanf(rbp, &var_6969);

char * rbp = "%d\0";
printf(rbp, var_6969);
```

#### ASM translation
```python
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

## Floating Point Math (SIMD)
#### C code
```c
int rax = 123;
rax = sqrt(rax);
```

#### ASM translation
```python
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
```python
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
```python
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

## Syscall

#### C code (not an exact untranslation because im too noob)
```c
int rax = 500;
int * rsp = 69;
char * rsi = &rsp;
*rsi = '\n';

int rcx = 10;
int len = 1;
do {
  *--rsi = (rax % rcx) + '0';
  rax /= rcx;
  len++;
} while(rax);

int rdi = 1;
write(rdi, rsi, len);
```

#### ASM translation
```python
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
