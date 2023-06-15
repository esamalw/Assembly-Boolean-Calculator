;// The following assembly program implements the following procedures :
;// 1-AND_op: Prompt the user for two hexadecimal integers.AND them
;//   together and display the result in hexadecimal.
;// 2- OR_op: Prompt the user for two hexadecimal integers.OR them
;//    together and display the result in hexadecimal.
;// 3- NOT_op: Prompt the user for a hexadecimal integer.NOT the
;//    integer and display the result in hexadecimal.
;// 4- XOR_op: Prompt the user for two hexadecimal integers.Exclusive - OR
;//    them together and display the result in hexadecimal.


include lib\Irvine32.inc

.data
msgMenu BYTE "---- Boolean Calculator ----------", 0dh, 0ah
BYTE 0dh, 0ah
BYTE "1. x AND y", 0dh, 0ah
BYTE "2. x OR y", 0dh, 0ah
BYTE "3. NOT x", 0dh, 0ah
BYTE "4. NOT y", 0dh, 0ah
BYTE "5. x XOR y", 0dh, 0ah
BYTE "6. x XOR y XOR x", 0dh, 0ah
BYTE "7. x XOR y XOR y", 0dh, 0ah
BYTE "8. x + y", 0dh, 0ah
BYTE "9. x - y", 0dh, 0ah

BYTE "10. Exit program", 0dh, 0ah, 0dh, 0ah
BYTE "Enter integer> ", 0

msgAND BYTE "Boolean AND:", 0
msgOR  BYTE "Boolean OR:", 0
msgNOT BYTE "Boolean NOT:", 0
msgXOR BYTE "Boolean XOR:", 0

msgOperand1 BYTE "Input the first 32-bit hexadecimal operand:  ", 0
msgOperand2 BYTE "Input the second 32-bit hexadecimal operand: ", 0
msgResult   BYTE "The 32-bit hexadecimal result is:            ", 0

caseTable BYTE '1';// lookup value
DWORD AND_op;// address of procedure
EntrySize = ($ - caseTable)
BYTE '2'
DWORD OR_op
BYTE '3'
DWORD NOT_op
BYTE '4'
DWORD XOR_op
BYTE '5'
DWORD ExitProgram
NumberOfEntries = ($ - caseTable) / EntrySize

.code
main PROC
call Clrscr

Menu :
mov	edx, OFFSET msgMenu;// menu choices
call WriteString

L1 : call ReadChar
cmp  al, '5';// is selection valid(1 - 5) ?
ja   L1;// if above 5, go back
cmp  al, '1'
jb   L1;// if below 1, go back

call Crlf
call ChooseProcedure
jc   quit;// if CF = 1 exit

call Crlf
jmp  Menu;// display menu again

quit:
exit
main ENDP

;// ------------------------------------------------
ChooseProcedure PROC
;//
;// Selects a procedure from the caseTable
;// Receives: AL = number of procedure
;// Returns: nothing
;// ------------------------------------------------
push ebx
push ecx

mov  ebx, OFFSET caseTable;// pointer to the table
mov  ecx, NumberOfEntries;// loop counter

L1: cmp  al, [ebx];// match found ?
jne  L2;// no: continue
call NEAR PTR[ebx + 1];// yes: call the procedure
jmp  L3

L2 : add  ebx, EntrySize;// point to the next entry
loop L1;// repeat until ECX = 0

L3:	pop  ecx
pop  ebx

ret
ChooseProcedure ENDP

;// ------------------------------------------------
AND_op PROC
;//
;// Performs a boolean AND operation
;// Receives: Nothing
;// Returns: Nothing
;// ------------------------------------------------
pushad;// save registers

mov	edx, OFFSET msgAND;// name of the operation
call WriteString;// display message
call Crlf
call Crlf

mov  edx, OFFSET msgOperand1;// ask for first operand
call WriteString
call ReadHex;// get hexadecimal integer
mov  ebx, eax;// move first operand to EBX

mov  edx, OFFSET msgOperand2;// ask for second operand
call WriteString
call ReadHex;// EAX = second operand

and eax, ebx;// operand1 AND operand2

mov  edx, OFFSET msgResult;// result of operation
call WriteString
call WriteHex;// EAX = result
call Crlf

popad;// restore registers
ret
AND_op ENDP


;// ------------------------------------------------
OR_op PROC
;//
;// Performs a boolean OR operation
;// Receives: Nothing
;// Returns: Nothing
;// ------------------------------------------------

;//-------------------------------------------------------- Code Below
pushad;// save registers

mov edx, OFFSET msgOR;// name of the operation
call WriteString;// display message
call Crlf
call Crlf

mov edx, OFFSET msgOperand1;// ask for first operand
call WriteString
call ReadHex;// get hexadecimal integer
mov ebx, eax;// move first operand to EBX

mov edx, OFFSET msgOperand2;// ask for second operand
call WriteString
call ReadHex;// EAX = second operand

or eax, ebx;// operand1 OR operand2

mov edx, OFFSET msgResult;// result of operation
call WriteString
call WriteHex;// EAX = result
call Crlf

popad;// restore registers

ret
OR_op ENDP

;// ------------------------------------------------
NOT_op PROC
;//
;// Performs a boolean NOT operation.
;// Receives: Nothing
;// Returns: Nothing
;// ------------------------------------------------

;//-------------------------------------------------------- Code Below
pushad;// save registers

mov edx, OFFSET msgNOT;// name of the operation
call WriteString;// display message
call Crlf
call Crlf

mov edx, OFFSET msgOperand1;// ask for the operand
call WriteString
call ReadHex;// get hexadecimal integer

not eax;// NOT the operand

mov edx, OFFSET msgResult;// result of operation
call WriteString
call WriteHex;// EAX = result
call Crlf

popad;// restore registers


ret
NOT_op ENDP



;// ------------------------------------------------
XOR_op PROC
;//
;// Performs an Exclusive - OR operation
;// Receives: Nothing
;// Returns: Nothing
;// ------------------------------------------------

;//-------------------------------------------------------- Code Below
pushad;// save registers

mov edx, OFFSET msgXOR;// name of the operation
call WriteString;// display message
call Crlf
call Crlf

mov edx, OFFSET msgOperand1;// ask for first operand
call WriteString
call ReadHex;// get hexadecimal integer
mov ebx, eax;// move first operand to EBX

mov edx, OFFSET msgOperand2;// ask for second operand
call WriteString
call ReadHex;// EAX = second operand

xor eax, ebx;// operand1 XOR operand2

mov edx, OFFSET msgResult;// result of operation
call WriteString
call WriteHex;// EAX = result
call Crlf

popad;// restore registers


ret
XOR_op ENDP

;// ------------------------------------------------
ExitProgram PROC
;//
;// Receives: Nothing
;// Returns: Sets CF = 1 to signal end of program
;// ------------------------------------------------
stc;// CF = 1
ret
ExitProgram ENDP

END main