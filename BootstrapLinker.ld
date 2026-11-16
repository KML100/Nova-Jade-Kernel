/* -------------------------------------------------------------------------------------------------------------------------- */
/**/
/* -------------------------------------------------------------------------------------------------------------------------- */

/* NAME: KernelLinker.ld  */

/* -------------------------------------------------------------------------------------------------------------------------- */
/**/
/* -------------------------------------------------------------------------------------------------------------------------- */

ENTRY(_start)

PHDRS
{
    text PT_LOAD FLAGS(5); /* Read + Execute */
    rodata PT_LOAD FLAGS(4); /* Read Only */
    data PT_LOAD FLAGS(6); /* Read + Write */
}

SECTIONS
{
    . = 0x80000;

    .Bootstrap : { 
        KEEP(*(.Bootstrap)) 
    } :text

    .text : { 
        *(.text*) 
    } :text

    .rodata : { 
        *(.rodata*) 
    } :rodata

    .data : { 
        *(.data*) 
    } :data

    . = ALIGN(8);
    StartOfBSS = .;
    
    .bss : { 
        *(.bss*) 
    } :data

    EndOfBSS = .;
    SizeOfBSS = EndOfBSS - StartOfBSS;
    ClearBlockCountBSS = SizeOfBSS / 8;
    
    HeapStart = .;
}