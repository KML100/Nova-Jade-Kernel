//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

// Name: Bootstrap.S

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#define CoreAffinityEL1 mpidr_el1
#define ExceptionTableEL1 vbar_el1
#define StackPointerEL1 sp_el1

#define StatusRegisterEL2 spsr_el2
#define ReturnRegisterEL2 elr_el2

#define ModeRegister hcr_el2

#define AArach64Mode #(1 << 31)
#define ClearBlockSizeBSS #8
#define CoreZeroMask #0xFF

#define KernelMask #0x3C5 // 0x3C5 = EL1h (Kernel mode), DAIF masked

#define RingOneStackStart 0x300000
#define RingZeroStackStart 0x200000 

// 0x080000 - Kernel Code (.text, .data, .bss)
// 0x200000 - Ring 0 (Kernel) Stack (grows down) (1 MB mark)
// 0x300000 - Ring 1 (Exception/Interrupt) Stack (grows down) (2 MB mark)

.section ".Bootstrap", "ax"

.global _start
.global StartBootstrap

_start:
    b StartBootstrap

StartBootstrap:
    mrs x0, CoreAffinityEL1 
    and x0, x0, CoreZeroMask

    cbz x0, InitializeCoreZero 
    b SpinOnAccidentalWake

SpinOnAccidentalWake:
    wfe 
    b SpinOnAccidentalWake

InitializeCoreZero:

    // Check EL Level, If Ring -1 Then Drop To Ring 0
    mrs x0, CurrentEL
    lsr x0, x0, #2
    cmp x0, #2
    beq DropAuthorityToEL1

    b SetUpCore

DropAuthorityToEL1:

    // Set AArach64Mode
    mov x0, AArach64Mode
    msr ModeRegister, x0

    // Set Up Ring 0 Stack Pointer
    ldr x1, =RingZeroStackStart
    msr StackPointerEL1, x1

    // Return Adress As SetUpCore
    ldr x0, =SetUpCore
    msr ReturnRegisterEL2, x0

    // Change Status
    mov x0, KernelMask 
    msr StatusRegisterEL2, x0

    eret // Exception Return

SetUpCore:

    // Set Up Ring 1 Stack Pointer
    ldr x0, =RingOneStackStart
    mov sp, x0

    // Load And Set CPU Exception Table
    ldr x0, =ExceptionVectorTable
    msr ExceptionTableEL1, x0
    isb // Refresh

    // Set Up For BSS Clear
    ldr x0, =ClearBlockCountBSS 
    ldr x1, =StartOfBSS 

    b ClearBSS

ClearBSS:
    cbz x0, CallKernelMainC 
    str xzr, [x1], ClearBlockSizeBSS
    sub x0, x0, #1 
    b ClearBSS 

CallKernelMainC:
    b KernelMain
    b ExceptionKernelMain

ExceptionKernelMain:
    b ExceptionKernelMain
