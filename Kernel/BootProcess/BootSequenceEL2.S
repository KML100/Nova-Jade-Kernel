//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

// Name: BootSequenceEL2.S

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#define ExceptionTableEL2 vbar_el2
#define ConfigRegisterEL2 hcr_el2
#define StackPointerEL2 sp_el2
#define ExceptionReturnEL2 elr_el2
#define StackPointerMode SPSel
#define StatusRegisterEL2 spsr_el2

#define AArach64Mode (1 << 31) // Runs In AArach64Mode
#define ConfigMaskEL2 (AArach64Mode)

#define DAIF_MASK (0xF << 6)
#define AARCH64_STATE (0 << 4)
#define EL1H_MODE 0b0101
#define KernelMask (DAIF_MASK | AARCH64_STATE | EL1H_MODE)

#define StackPointerModeMask 1

#define StackPointerStartEL2 0x200000

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

    // Set Up EL2 Stack Pointer
    ldr x1, =0x200000
    msr sp_el2, x1 // This is somehow an Undefined Instruction

    b Loop

    // Load And Set EL2 Exception Table
    ldr x0, =ExceptionVectorTableEL2 // Other File
    msr ExceptionTableEL2, x0
    isb // Refresh    

    // Set Return Address
    ldr x0, =HalfBoot
    msr ExceptionReturnEL2, x0

    b Loop

    eret

Loop:
    b Loop