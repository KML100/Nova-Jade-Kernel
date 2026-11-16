//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

// Name: Bootstrap.S

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#define CoreInformationEL1 mpidr_el1
#define UniCoreSystemMask (1 << 30)

.section .data
.align 3
.global BootLock
BootLock:
    .quad 0

.section ".Bootstrap", "ax" // Force The Section To Be Placed At The Correct Position

.global _start
_start:
    b StartBootstrap

StartBootstrap:

    // Check For UniCore System
    mrs x0, CoreInformationEL1
    and x0, x0, #UniCoreSystemMask

    //cbnz x0, MainCoreBoot // Boot As UniCore
    b BootAtomically // Boot As MultiCore

BootAtomically:

    // Get Lock
    ldr x0, =BootLock
    ldaxr w1, [x0]

    // If Didnt Get Lock Then Boot As Extra
    cmp w1, #1
    beq HaltExtraCore

    bl StoreExclusiveSafe
    dmb ish

    b MainCoreBoot

StoreExclusiveSafe:

    // Ensure The Lock Is Updated Properly
    mov w3, #1
    stxr w2, w3, [x0]
    cmp w2, #1
    beq StoreExclusiveSafe

    ret

BeginCoreHalt:
    clrex
    b HaltExtraCore

HaltExtraCore:
    wfe
    b HaltExtraCore
    
MainCoreBoot:

    // Check Current Boot EL
    mrs x0, CurrentEL
    lsr x0, x0, #2

    cmp x0, #2 
    bne HalfBoot // If Somehow Starts At EL1 Do HalfBoot
    b FullBoot // Else FullBoot

FullBoot:
    b BootEL2 // Other File

.global HalfBoot
HalfBoot:
    //bl BootEL1 // Other File
    //b BootKernel // Other File
    b Loop

Loop:
    b Loop
