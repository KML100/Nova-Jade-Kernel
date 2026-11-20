//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

// Name: MemoryLib.S

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.global AsmMemoryCopy
.type AsmMemoryCopy, %function

.set SIMD_BIT_MULT, 5
.set SIMD_COPY_SIZE, (1 << SIMD_BIT_MULT) // In Bytes, 32
.set SIMD_REMAINDER_MASK, SIMD_COPY_SIZE - 1
.set BYTE_COPY_SIZE, 1

// x0 = Source Ptr (Const), x1 = Destination Ptr (Const), x2 = Count In Bytes (Modified)
AsmMemoryCopy:
    
    and x3, x2, #SIMD_REMAINDER_MASK    // Get Remainder Of Count
    sub x2, x2, x3                      // Subtract Remainder From Count For Clean Even Loop Counts
    lsr x2, x2, #SIMD_BIT_MULT          // Get Loop Count By Division

    b CopyLoopSIMD

CopyLoopSIMD:

    ldp q0, q1, [x0], #SIMD_COPY_SIZE
    stp q0, q1, [x1], #SIMD_COPY_SIZE

    sub x2, #1
    cbnz x2, CopyLoopSIMD

    cbz x3, Return
    b CopyLoopByte

CopyLoopByte:

    ldrb x2, [x0], #1
    strb x2, [x1], #1

    sub x3, #1
    cbnz x3, CopyLoopByte

    b Return
    
Return:
    ret