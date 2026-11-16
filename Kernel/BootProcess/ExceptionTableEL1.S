//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

// Name: ExceptionTableEL1.S

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#define ExceptionSyndromeEL1 esr_el1
#define ExceptionLinkEL1 elr_el1

.section ".text"
.align 11 // Align to 2KB (2^11 = 2048)

.global ExceptionVectorTableEL1
ExceptionVectorTableEL1:

    // Synchronous Exceptions
    .balign 128
    b UnhandledException
    .balign 128
    b UnhandledException
    .balign 128
    b UnhandledException
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
    mrs x0, ExceptionSyndromeEL1  // Exception Syndrome
    mrs x1, ExceptionLinkEL1  // Exception Link

    bl ExceptionHandlerC // Jump to the C exception handler function

    b ExceptionHalt

ExceptionHalt:
    wfe
    b ExceptionHalt