//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

// Name: ExceptionTable.S

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

// The ARM64 Exception Vector Table for Nova Jade

#define ExceptionLinkRegisterEL1 elr_el1
#define ExceptionSyndRegisterEL1 esr_el1

.section ".text"
.align 11 // Align to 2KB (2^11 = 2048)

.global ExceptionVectorTable
ExceptionVectorTable:
    // Synchronous Exceptions
    .balign 128
    b UnhandledException //SyncCurrentEL_SP0
    .balign 128
    b UnhandledException //SyncCurrentEL_SPx
    .balign 128
    b UnhandledException //SyncLowerEL_AArch64
    .balign 128
    b UnhandledException

    // IRQ (Interrupts)
    .balign 128
    b UnhandledException
    .balign 128
    b UnhandledException
    .balign 128
    b UnhandledException
    .balign 128
    b UnhandledException

    // FIQ (Fast Interrupts)
    .balign 128
    b UnhandledException
    .balign 128
    b UnhandledException
    .balign 128
    b UnhandledException
    .balign 128
    b UnhandledException

    // SError (System Errors)
    .balign 128
    b UnhandledException
    .balign 128
    b UnhandledException
    .balign 128
    b UnhandledException
    .balign 128
    b UnhandledException

UnhandledException:

    // If we get here, something went horribly wrong.

    mrs x0, ExceptionSyndRegisterEL1  // Exception Syndrome
    mrs x1, ExceptionLinkRegisterEL1  // Exception Link

    // Jump to the C function
    b ExceptionHandlerC

    b UnhandledException