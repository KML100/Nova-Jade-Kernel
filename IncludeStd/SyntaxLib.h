//------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//--// DESCRIPTION //--
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------

// NAME: SyntaxLib (Header)

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//--// CODE //--
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#ifndef SYNTAXLIB_H
#define SYNTAXLIB_H

#define Function(ReturnType) ReturnType
#define Open (

#define While while (
#define Repeat do {
#define Until } while (!(

#define For for (

#define If if (
#define Elif } else if (
#define Else } else {

#define Not !
#define And &&
#define Or ||

#define BNot ~
#define BAnd &
#define BOr |

#define Then ){
#define End };
#define Stop ));
#define Close );
#define To ;
#define Is }

#define Return return
#define Const const
#define Static static
#define Inline inline
#define Restrict restrict

#define Struct struct{
#define Union union{
#define Enums enum{
#define Define typedef

#define size_t unsigned long long

#endif
