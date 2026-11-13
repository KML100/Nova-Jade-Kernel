extern void PushStringUART(char* s);

// Simple helper to print a 64-bit hex value
void PrintHex(unsigned long long Value) {
    char HexCharacter[] = "0123456789ABCDEF";
    char Buffer[17];
    Buffer[16] = '\0'; // Null terminator

    for (int i = 15; i >= 0; i--) {
        Buffer[i] = HexCharacter[Value & 0xF];  // Get the lowest 4 bits
        Value >>= 4;                            // Shift right by 4 to get the next nibble
    }
    
    PushStringUART("0x");
    PushStringUART(Buffer);
    PushStringUART("\n");
}

// The actual handler called from Assembly
void ExceptionHandlerC(unsigned long long esr, unsigned long long elr) {
    PushStringUART("// NOVA JADE ENCOUNTERED AN UNEXPECTED FATAL PROBLEM! \n");
    
    PushStringUART("Exception Syndrome (ESR): ");
    PrintHex(esr);
    
    PushStringUART("Instruction Address (ELR): ");
    PrintHex(elr);
    
    PushStringUART("System Halted.\n");

    while (1){}
}