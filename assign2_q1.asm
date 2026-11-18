// CPSC 355 Assignment 2 - Question 1: GCD and LCM
// Uses 64-bit arithmetic throughout.

.data
fmt_in:  .string "%ld %ld"
fmt_gcd: .string "GCD(%ld, %ld) = %ld\n"
fmt_lcm: .string "LCM(%ld, %ld) = %ld\n"

.bss
.balign 8
val_a: .skip 8
val_b: .skip 8

.text
.balign 4
.global main
// Input: stdin. Output: two result lines; w0 = exit status.
// Uses x19-x22, saved on stack.
main:
    stp x29, x30, [sp, -48]!
    mov x29, sp
    stp x19, x20, [sp, 16]
    stp x21, x22, [sp, 32]

    ldr x0, =fmt_in
    ldr x1, =val_a
    ldr x2, =val_b
    bl scanf

    ldr x9, =val_a
    ldr x19, [x9]
    ldr x9, =val_b
    ldr x20, [x9]

    mov x0, x19
    mov x1, x20
    bl gcd
    mov x21, x0

    mov x0, x19
    mov x1, x20
    bl lcm
    mov x22, x0

    ldr x0, =fmt_gcd
    mov x1, x19
    mov x2, x20
    mov x3, x21
    bl printf

    ldr x0, =fmt_lcm
    mov x1, x19
    mov x2, x20
    mov x3, x22
    bl printf

    mov w0, 0
    ldp x21, x22, [sp, 32]
    ldp x19, x20, [sp, 16]
    ldp x29, x30, [sp], 48
    ret

.balign 4
.global gcd
// Input: x0=A, x1=B. Output: x0=GCD(A,B).
// Uses x0-x3 (caller-saved); no callee-saved general registers.
gcd:
    stp x29, x30, [sp, -16]!
    mov x29, sp

gcd_loop:
    cbz x1, gcd_done
    udiv x2, x0, x1
    msub x3, x2, x1, x0
    mov x0, x1
    mov x1, x3
    b gcd_loop

gcd_done:
    ldp x29, x30, [sp], 16
    ret

.balign 4
.global lcm
// Input: x0=A, x1=B. Output: x0=LCM(A,B).
// Uses x19-x20 (saved) and x0-x2; calls gcd.
lcm:
    stp x29, x30, [sp, -32]!
    mov x29, sp
    stp x19, x20, [sp, 16]

    mov x19, x0
    mov x20, x1
    bl gcd

    udiv x2, x19, x0
    mul x0, x2, x20

    ldp x19, x20, [sp, 16]
    ldp x29, x30, [sp], 32
    ret
