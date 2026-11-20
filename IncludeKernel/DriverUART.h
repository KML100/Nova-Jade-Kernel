
#ifndef DRIVER_UART
#define DRIVER_UART

void PushCharacterUART(char Character);
void PushStringUART(char* StringC);
void PrintHex(unsigned long long HexStringC);
void InitializeUART(void);

#endif