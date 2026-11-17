//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

// Name: BootSequenceEL2.S

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#define ExceptionTableEL2 vbar_el2
#define ConfigRegisterEL2 hcr_el2
#define ExceptionReturnEL2 elr_el2
#define StackPointerMode SPSel
#define StatusRegisterEL2 spsr_el2

#define StackPointerEL1 sp_el1
#define StackPointerEL0 sp_el0

#define AArach64Mode (1 << 31) // Runs In AArach64Mode
#define ConfigMaskEL2 (AArach64Mode)

#define DAIF_MASK (0xF << 6)
#define AARCH64_STATE (0 << 4)
#define EL1H_MODE 0b0101
#define KernelMask (DAIF_MASK | AARCH64_STATE | EL1H_MODE)

#define StackPointerModeMask 1

#define StackPointerStartEL2 0x200000
#define StackPointerStartEL1 0x300000
#define StackPointerStartEL0 0x400000

.global BootEL2
BootEL2:

    // Set EL2 Status 
    mov x0, #KernelMask //KernelMask
    msr StatusRegisterEL2, x0
    isb // Refresh

    // Set EL2 Configs
    mov x0, #ConfigMaskEL2 
    msr ConfigRegisterEL2, x0
    isb // Refresh

    // Set Up ELx Stack Pointer Mode
    mov x1, #StackPointerModeMask
    msr StackPointerMode, x1
    isb // Refresh

    // Set EL2 Stack Pointer
    mov sp, #StackPointerStartEL2

    ldr x1, =StackPointerStartEL1
    msr StackPointerEL1, x1

    ldr x1, =StackPointerStartEL0
    msr StackPointerEL0, x1

    // Load And Set EL2 Exception Table
    ldr x0, =ExceptionVectorTableEL2 // Other File
    msr ExceptionTableEL2, x0
    isb // Refresh    

    // Set Return Address
    ldr x0, =HalfBoot
    msr ExceptionReturnEL2, x0

    eret