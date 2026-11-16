//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

// Name: BootSequenceKernel.S

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#define StackPointerStartEL2 0x400000
#define ClearBlockSizeBSS 8

.global BootKernel
BootKernel:

    // Set Up EL2 Stack Pointer
    ldr x0, =StackPointerStartEL2
    mov sp, x0

    bl StartClearingBSS

    b InvokeKernelMain

StartClearingBSS:
    ldr x0, =ClearBlockCountBSS 
    ldr x1, =StartOfBSS 

    cbz x0, StopClearingBSS
    b ClearBSS

ClearBSS:
    cbz x0, StopClearingBSS
    str xzr, [x1], #ClearBlockSizeBSS
    sub x0, x0, #1 
    b ClearBSS 

StopClearingBSS:
    ret

InvokeKernelMain:
    b KernelMain
    b ExceptionKernelMain

ExceptionKernelMain:
    wfe
    b ExceptionKernelMain