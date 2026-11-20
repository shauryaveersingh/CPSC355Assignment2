define(fp, x29)
define(lr, x30)

.data
fmt_in:      .string "%ld"
fmt_yes:     .string "Palindrome: yes\n"
fmt_no:      .string "Palindrome: no\n"
fmt_weight:  .string "Hamming weight: %d\n"

.bss
.balign 8
input_n:     .skip 8

.text
.balign 4
.global main

main:
    stp fp, lr, [sp, -32]!
    mov fp, sp

    str x19, [sp, 16]

    // Read N
    ldr x0, =fmt_in
    ldr x1, =input_n
    bl scanf

    // Check binary palindrome
    ldr x0, =input_n
    ldr x0, [x0]
    bl is_bin_palindrome

    mov x19, x0

    // Print palindrome result
    cmp x19, 1
    b.ne print_no

    ldr x0, =fmt_yes
    bl printf
    b print_weight

print_no:
    ldr x0, =fmt_no
    bl printf

print_weight:
    // Calculate Hamming weight
    ldr x0, =input_n
    ldr x0, [x0]
    bl popcount

    mov x1, x0
    ldr x0, =fmt_weight
    bl printf

    mov w0, 0

    ldr x19, [sp, 16]
    ldp fp, lr, [sp], 32
    ret
    // popcount
// Input: x0 = N
// Output: x0 = number of 1 bits
// Registers used: x0, x1, x2, x29, x30

.balign 4
.global popcount

popcount:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    mov x1, x0          // Working copy of N
    mov x0, 0           // Start count at 0

count_loop:
    cbz x1, count_done

    and x2, x1, 1       // Get lowest bit
    add x0, x0, x2      // Add bit to count
    lsr x1, x1, 1       // Shift right
    b count_loop

count_done:
    ldp x29, x30, [sp], 16
    ret
    // is_bin_palindrome
// Input: x0 = N
// Output: x0 = 1 if binary palindrome, otherwise 0
// Registers used: x0-x5, x29, x30

.balign 4
.global is_bin_palindrome

is_bin_palindrome:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Zero is a palindrome
    cbz x0, palindrome_yes

    mov x1, x0          // Original number
    mov x2, 0           // Highest bit position
    mov x3, x0          // Working copy

find_highest:
    cmp x3, 1
    b.ls check_bits

    lsr x3, x3, 1
    add x2, x2, 1
    b find_highest

check_bits:
    mov x3, 0           // Lowest bit position

compare_loop:
    cmp x3, x2
    b.ge palindrome_yes

    // Extract lowest bit
    lsr x4, x1, x3
    and x4, x4, 1

    // Extract highest bit
    lsr x5, x1, x2
    and x5, x5, 1

    cmp x4, x5
    b.ne palindrome_no

    add x3, x3, 1       // Move inward from low end
    sub x2, x2, 1       // Move inward from high end
    b compare_loop

palindrome_yes:
    mov x0, 1
    b palindrome_done

palindrome_no:
    mov x0, 0

palindrome_done:
    ldp x29, x30, [sp], 16
    ret