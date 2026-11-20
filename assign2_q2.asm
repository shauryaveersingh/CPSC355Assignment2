define(fp, x29)
define(lr, x30)

.data
fmt_in:     .string "%ld"
fmt_sum:    .string "Sum: %ld\n"
fmt_strong: .string "Strong: %ld\n"

.bss
.balign 8
input_n:    .skip 8

.text
.balign 4
.global main

main:
    stp fp, lr, [sp, -48]!
    mov fp, sp

    str x19, [sp, 16]
    str x20, [sp, 24]

    // Read input using scanf
    ldr x0, =fmt_in
    ldr x1, =input_n
    bl scanf

    // Call strong_check
    ldr x0, =input_n
    ldr x0, [x0]
    bl strong_check

    // Save both return values
    mov x19, x0
    mov x20, x1

    // Print factorial sum
    ldr x0, =fmt_sum
    mov x1, x19
    bl printf

    // Print strong number result
    ldr x0, =fmt_strong
    mov x1, x20
    bl printf

    mov w0, 0

    ldr x19, [sp, 16]
    ldr x20, [sp, 24]
    ldp fp, lr, [sp], 48
    ret

    // strong_check
// Input: x0 = N
// Output: x0 = sum of digit factorials
//         x1 = 1 if N is strong, otherwise 0
// Registers used: x0-x3, x19-x21, x29, x30

.balign 4
.global strong_check

strong_check:
    stp x29, x30, [sp, -48]!
    mov x29, sp

    stp x19, x20, [sp, 16]
    str x21, [sp, 32]

    mov x19, x0             // Save original N
    mov x20, x0             // Working copy of N
    mov x21, 0              // Running factorial sum

digit_loop:
    mov x2, 10
    udiv x3, x20, x2       // quotient = N / 10
    msub x0, x3, x2, x20   // digit = N % 10

    // x3 is caller-saved, so save the quotient
    // before calling factorial
    str x3, [sp, 40]

    bl factorial

    add x21, x21, x0       // Add factorial to sum
    ldr x20, [sp, 40]      // Restore quotient

    cbnz x20, digit_loop

    mov x0, x21             // Return factorial sum
    cmp x21, x19
    cset x1, eq             // Return 1 if sum == N

    ldr x21, [sp, 32]
    ldp x19, x20, [sp, 16]
    ldp x29, x30, [sp], 48
    ret
    // factorial
// Input: w0 = digit (0 to 9)
// Output: x0 = digit factorial
// Registers used: x0, x1, x29, x30

.balign 4
.global factorial

factorial:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    mov x1, x0
    mov x0, 1

factorial_loop:
    cmp x1, 1
    b.le factorial_done

    mul x0, x0, x1
    sub x1, x1, 1
    b factorial_loop

factorial_done:
    ldp x29, x30, [sp], 16
    ret