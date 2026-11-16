//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

// Name: ExceptionTableEL2.S

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#define ExceptionSyndromeEL2 esr_el2
#define ExceptionLinkEL2 elr_el2

.section ".text"
.align 11 // Align to 2KB (2^11 = 2048)

.global ExceptionVectorTableEL2
ExceptionVectorTableEL2:

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
    mrs x0, ExceptionSyndromeEL2  // Exception Syndrome
    mrs x1, ExceptionLinkEL2  // Exception Link

    bl ExceptionHandlerC // Jump to the C exception handler function

    b ExceptionHalt

ExceptionHalt:
    wfe
    b ExceptionHalt