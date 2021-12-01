{\rtf1\ansi\ansicpg1252\cocoartf1504\cocoasubrtf840
\cocoascreenfonts1{\fonttbl\f0\fnil\fcharset0 Menlo-Regular;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue255;\red0\green128\blue0;\red163\green21\blue21;
}
{\*\expandedcolortbl;;\csgenericrgb\c0\c0\c100000;\csgenericrgb\c0\c50196\c0;\csgenericrgb\c63922\c8235\c8235;
}
\margl1440\margr1440\vieww25400\viewh14500\viewkind1
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural\partightenfactor0

\f0\fs20 \cf2 TITLE\cf0  Lab6	(Lab6.asm)\
\
;\cf3 // Clare Nguyen\cf0 \
;\cf3 // CIS21JA\cf0 \
;\cf3 // Samira C. Oliva\cf0 \
;\cf3 // Program adds two 64-bit hexadecimal values and prints the sum. \cf0 \
;\cf3 // It uses the stack, registers, implements procedures and macros.\cf0 \
\
\cf2 INCLUDE\cf0  Irvine32.\cf2 inc\cf0 \
\
;\cf3 //-------------------------------------\cf0 \
;\cf3 //prints a string \cf0 \
;\cf3 //receives: address of string to print\cf0 \
mWriteStr \cf2 MACRO\cf0  \
	\cf2 push\cf0  \cf2 edx\cf0 \
	\cf2 mov\cf0   \cf2 edx\cf0 ,\cf2 OFFSET\cf0  buffer\
	\cf2 call\cf0  WriteString\
	\cf2 pop\cf0   \cf2 edx\cf0 \
\cf2 ENDM\cf0 \
;\cf3 //-----------------------------------\cf0 \
;\cf3 //prints a signle space character\cf0 \
printSpace \cf2 MACRO\cf0  \
	\cf2 push\cf0   \cf2 eax\cf0 \
	\cf2 mov\cf0    \cf2 al\cf0 ,\cf4 ' '\cf0 \
	\cf2 call\cf0   WriteChar\
	\cf2 pop\cf0    \cf2 eax\cf0 \
\cf2 ENDM\cf0 \
;\cf3 //-----------------------------------\cf0 \
;\cf3 //prints a single character\cf0 \
printChar  \cf2 MACRO\cf0  \cf2 char\cf0 \
	\cf2 push\cf0   \cf2 eax\cf0 \
	\cf2 mov\cf0    \cf2 al\cf0 ,\cf2 char\cf0 \
	\cf2 call\cf0   WriteChar\
	\cf2 pop\cf0    \cf2 eax\cf0 \
\cf2 ENDM\cf0 \
\
.\cf2 stack\cf0 \
.\cf2 data\cf0 \
promptUpperHalf \cf2 BYTE\cf0  \cf4 "Please enter upper half of the 64-bit-> "\cf0 ,0\
promptLowerHalf \cf2 BYTE\cf0  \cf4 "Please enter upper lower of the 64-bit-> "\cf0 ,0\
errorMessage	 \cf2 BYTE\cf0  \cf4 "ERROR: sum exceeds 64-bits		       "\cf0 ,0\
num1 \cf2 QWORD\cf0  ?\
num2 \cf2 QWORD\cf0  ?\
sum  \cf2 QWORD\cf0  ?\
.\cf2 code\cf0 \
main \cf2 PROC\cf0 \
	;\cf3 //;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;getUserInput add PART.I\cf0 \
	\cf2 mov\cf0   \cf2 edx\cf0 ,\cf2 OFFSET\cf0  promptUpperHalf\
	\cf2 call\cf0  WriteString\
	\cf2 call\cf0  ReadHex\
	\cf2 mov\cf0   \cf2 DWORD\cf0  \cf2 PTR\cf0  num1+4, \cf2 eax\cf0 \
	\cf2 mov\cf0  \cf2 edx\cf0 ,\cf2 OFFSET\cf0  promptLowerHalf\
	\cf2 call\cf0  WriteString\
	\cf2 call\cf0  ReadHex\
	\cf2 mov\cf0  \cf2 DWORD\cf0  \cf2 PTR\cf0  num1,\cf2 eax\cf0 \
	\cf2 mov\cf0   \cf2 edx\cf0 ,\cf2 OFFSET\cf0  promptUpperHalf\
	\cf2 call\cf0  WriteString\
	\cf2 call\cf0  ReadHex\
	\cf2 mov\cf0   \cf2 DWORD\cf0  \cf2 PTR\cf0  num2+4, \cf2 eax\cf0 \
	\cf2 mov\cf0  \cf2 edx\cf0 ,\cf2 OFFSET\cf0  promptLowerHalf\
	\cf2 call\cf0  WriteString\
	\cf2 call\cf0  ReadHex\
	\cf2 mov\cf0  \cf2 DWORD\cf0  \cf2 PTR\cf0  num2,\cf2 eax\cf0 \
\
	;\cf3 //pass lowerHalf of num1, lowerHald of num2, carryVal = 0 \cf0 \
	\cf2 mov\cf0  \cf2 ecx\cf0 ,0\
	\cf2 sub\cf0  \cf2 esp\cf0 ,4			 ;\cf3 //save room for the return value					 \cf0 \
	\cf2 push\cf0  \cf2 DWORD\cf0  \cf2 PTR\cf0  num1 ;\cf3 //pass lowerHalf of num1\cf0 \
	\cf2 push\cf0  \cf2 DWORD\cf0  \cf2 PTR\cf0  num2 ;\cf3 //pass lowerHald of num2\cf0 \
	\cf2 push\cf0  \cf2 DWORD\cf0  \cf2 PTR\cf0  \cf2 ecx\cf0 	 ;\cf3 //pass carryValue set to 0\cf0 \
	\cf2 push\cf0  \cf2 OFFSET\cf0  sum	 ;\cf3 //(&sum) pass by address \cf0 \
\
	\cf2 call\cf0  add64BitInts    ;\cf3 //carry = add64BitInts (num1, num2, carry, &sum)\cf0 \
	\cf2 pop\cf0  \cf2 ecx\cf0 ;	\
	\
	;\cf3 // add PART. II\cf0 \
	\cf2 sub\cf0  \cf2 esp\cf0 ,4\
	\cf2 push\cf0  \cf2 DWORD\cf0  \cf2 PTR\cf0  num1+4\
	\cf2 push\cf0  \cf2 DWORD\cf0  \cf2 PTR\cf0  num2+4\
	\cf2 push\cf0  \cf2 DWORD\cf0  \cf2 PTR\cf0  \cf2 ecx\cf0 \
	\cf2 push\cf0  \cf2 OFFSET\cf0  sum+4\
	\cf2 call\cf0  add64BitInts\
	\cf2 pop\cf0   \cf2 ecx\cf0 ;\
\
	;\cf3 // PART.III if sum is withing 64 bits call printer else errMsg\cf0 \
	;\cf3 // use the carry bit to determine this\cf0 \
	\cf2 cmp\cf0   \cf2 ecx\cf0 ,1\
     \cf2 jne\cf0   successPrint\
	\cf2 mov\cf0   \cf2 edx\cf0 ,\cf2 OFFSET\cf0  errorMessage\
	\cf2 call\cf0  WriteString\
	\cf2 jmp\cf0   theEnd\
\
successPrint:\
	\cf2 mov\cf0    \cf2 ebx\cf0 ,\cf2 OFFSET\cf0  num1 	   ;\cf3 // printer(&num1, &num2, &sum)\cf0 \
	\cf2 mov\cf0    \cf2 ecx\cf0 ,\cf2 OFFSET\cf0  num2\
	\cf2 mov\cf0    \cf2 edx\cf0 ,\cf2 OFFSET\cf0  sum\
	\cf2 call\cf0   printer\
	\cf2 jmp\cf0    theEnd\
main \cf2 ENDP\cf0 \
\
;\cf3 //--------------------------------------------------------------------------;\cf0 \
;\cf3 //												                          \cf0 \
;\cf3 //--------------------------------------------------------------------------;\cf0 \
;\cf3 // Perfoms   addition of 32-bit integers.			\cf0 \
;\cf3 // Receives: EDI, ESI (two unsigned integers)	, EAX (carryValue = 0)\cf0 \
;\cf3 // Returns:  EAX (the new carry), &sum 				\cf0 \
;\cf3 // Requires: Nothing								\cf0 \
;\cf3 //--------------------------------------------------------------------------;\cf0 \
add64BitInts \cf2 PROC\cf0 \
\cf2 push\cf0  \cf2 ebp\cf0 		;; \cf3 //save ebp value\cf0 \
\cf2 mov\cf0   \cf2 ebp\cf0 ,\cf2 esp\cf0 	;; \cf3 //set ebp to esp value\cf0 \
			;; \cf3 //pushad;; save all the registers\cf0 \
\cf2 push\cf0  \cf2 eax\cf0 		;; \cf3 //save registers\cf0 \
\cf2 push\cf0  \cf2 ebx\cf0 \
\cf2 push\cf0  \cf2 ecx\cf0 \
\cf2 push\cf0  \cf2 edx\cf0 \
\cf2 push\cf0  \cf2 esi\cf0 \
\cf2 push\cf0  \cf2 edi\cf0 \
			   ;\cf3 //now use the registers inside the procedure\cf0 \
\cf2 mov\cf0  \cf2 esi\cf0 ,[\cf2 ebp\cf0 +20] ;\cf3 // esi=num1 \cf0 \
\cf2 mov\cf0  \cf2 edi\cf0 ,[\cf2 ebp\cf0 +16] ;\cf3 // edi=num2   \cf0 \
\cf2 mov\cf0  \cf2 ebx\cf0 ,[\cf2 ebp\cf0 +12] ;\cf3 // ebx =0 (carrybit)\cf0 \
\cf2 mov\cf0  \cf2 eax\cf0 ,[\cf2 ebp\cf0 +8]  ;\cf3 // eax is ptr---> sum\cf0 \
\cf2 mov\cf0  \cf2 ecx\cf0 ,32	   ;\cf3 // set counter\cf0 \
\
addIntsBitByBit:\
	\cf2 push\cf0  \cf2 esi\cf0 		;\cf3 //save esi	; mov eax,esi\cf0 \
	\cf2 and\cf0   \cf2 esi\cf0 ,1	;\cf3 //use esi	; and eax,1     ;;;// eax=num1 AND 1 = (ith bit of num1)		\cf0 \
	\cf2 push\cf0  \cf2 edi\cf0 		;\cf3 //save edi	; mov ebx,edi \cf0 \
	\cf2 and\cf0   \cf2 edi\cf0 ,1    ;\cf3 //use edi	; and ebx,1     ;;;// ebx=num2 AND 1 = (ith bit of num2)\cf0 \
\
				;\cf3 // bit i of sum = a xor b xor c\cf0 \
	\cf2 mov\cf0  \cf2 edx\cf0 ,\cf2 esi\cf0 	;\cf3 // edx = esi = num1 ith bit\cf0 \
	\cf2 xor\cf0  \cf2 edx\cf0 ,\cf2 edi\cf0 	;\cf3 // xor edx,ebx  (a xor b)\cf0 \
	\cf2 xor\cf0  \cf2 edx\cf0 ,\cf2 ebx\cf0 	; \cf3 // edx(ith bit num1) xor ebx(carryValue) //edx = a xor b xor c\cf0 \
	\
	\cf2 push\cf0  \cf2 ecx\cf0        ;\cf3 //save counter value and use ecx temporarily\cf0 \
	\cf2 mov\cf0   \cf2 ecx\cf0 ,[\cf2 eax\cf0 ] ;\cf3 //mov  ecx,[ebx]// DEREFERENCE THE SUM\cf0 \
	\cf2 or\cf0    \cf2 ecx\cf0 ,\cf2 edx\cf0 \
     \cf2 ror\cf0   \cf2 ecx\cf0 ,1\
	\cf2 mov\cf0   [\cf2 eax\cf0 ],\cf2 ecx\cf0 \
	\cf2 pop\cf0   \cf2 ecx\cf0      ;\cf3 //restore ecx (may change later optimize to only one push and pop with adding\cf0 \
	\cf2 push\cf0  \cf2 ecx\cf0 	    ;\cf3 //:::push ecx to stack so can use it temporarily\cf0 \
	\cf2 push\cf0  \cf2 edx\cf0      ;\cf3 //:::push edx to stack and use it temporarily\cf0 \
\
	\cf2 mov\cf0  \cf2 ecx\cf0 ,\cf2 esi\cf0  ;\cf3 // ecx = num1 ith bit\cf0 \
     \cf2 and\cf0  \cf2 ecx\cf0 ,\cf2 edi\cf0  ;\cf3 // ecx AND num2 ith bit (a and b)\cf0 \
	\cf2 mov\cf0  \cf2 edx\cf0 ,\cf2 esi\cf0  ;\cf3 // edx = num1 ith bit\cf0 \
	\cf2 and\cf0  \cf2 edx\cf0 ,\cf2 ebx\cf0  ;\cf3 // (a and c)\cf0 \
	\cf2 or\cf0   \cf2 ecx\cf0 ,\cf2 edx\cf0  ;\cf3 // (a and b) or (a and c)\cf0 \
	\cf2 mov\cf0  \cf2 edx\cf0 ,\cf2 edi\cf0  ;\cf3 // edx = num2 ith bit\cf0 \
	\cf2 and\cf0  \cf2 edx\cf0 ,\cf2 ebx\cf0  ;\cf3 // num2 ith bit AND c\cf0 \
	\cf2 or\cf0   \cf2 ecx\cf0 ,\cf2 edx\cf0  ;\cf3 // [(a and b) or (a and c)] OR (b and c) \cf0 \
	\
	\cf2 mov\cf0  \cf2 ebx\cf0 ,\cf2 ecx\cf0  ;\cf3 // UPDATE C VALUE\cf0 \
\
	\cf2 pop\cf0  \cf2 edx\cf0 	  ;\cf3 // restore temp edx\cf0 \
	\cf2 pop\cf0  \cf2 ecx\cf0     ;\cf3 // restore the count\cf0 \
	\cf2 pop\cf0  \cf2 edi\cf0     ;\cf3 // restore edi = num2 ith bit\cf0 \
	\cf2 pop\cf0  \cf2 esi\cf0 	  ;\cf3 // restore esi = num1 ith bit\cf0 \
\
	\cf2 shr\cf0  \cf2 esi\cf0 ,1\
	\cf2 shr\cf0  \cf2 edi\cf0 ,1\
\
	\cf2 loop\cf0  addIntsBitByBit\
\
	\cf2 mov\cf0  [\cf2 ebp\cf0 +24],\cf2 ebx\cf0  ;\cf3 //THE RETURN VALUE!!!\cf0 \
			        ;\cf3 //restore registers\cf0 \
	\cf2 pop\cf0  \cf2 edi\cf0 \
	\cf2 pop\cf0  \cf2 esi\cf0 \
	\cf2 pop\cf0  \cf2 edx\cf0 \
	\cf2 pop\cf0  \cf2 ecx\cf0 \
	\cf2 pop\cf0  \cf2 ebx\cf0 \
	\cf2 pop\cf0  \cf2 eax\cf0 \
	\cf2 pop\cf0  \cf2 ebp\cf0 \
	\cf2 ret\cf0  16\
\
add64BitInts \cf2 ENDP\cf0 \
\
;\cf3 //--------------------------------------------------------------------------;\cf0 \
;\cf3 // Perfoms:  prints three values to screen (num1, num2 and sum)              \
\cf0 ;\cf3 // Receives: EBX (num1), ECX(num2), EDX (sum)			\cf0 \
;\cf3 // Returns:  Nothing 								\cf0 \
;\cf3 // Requires: Nothing								\cf0 \
;\cf3 // -----------------------------------------------------------------------------;\cf0 \
printer \cf2 PROC\cf0 \
	\cf2 mov\cf0   \cf2 eax\cf0 ,[\cf2 ebx\cf0 +4]\
	\cf2 call\cf0  WriteHex\
	\cf2 mov\cf0   \cf2 eax\cf0 ,[\cf2 ebx\cf0 ]\
	\cf2 call\cf0  WriteHex\
	printSpace \
	printChar \cf4 '+'\cf0 \
	printSpace\
	\cf2 mov\cf0   \cf2 eax\cf0 ,[\cf2 ecx\cf0 +4]\
	\cf2 call\cf0  WriteHex\
	\cf2 mov\cf0   \cf2 eax\cf0 ,[\cf2 ecx\cf0 ]\
	\cf2 call\cf0  WriteHex\
	printSpace\
	printChar \cf4 '='\cf0 \
	printSpace\
	\cf2 mov\cf0   \cf2 eax\cf0 ,[\cf2 edx\cf0 +4]\
	\cf2 call\cf0  WriteHex\
	\cf2 mov\cf0   \cf2 eax\cf0 ,[\cf2 edx\cf0 ]\
	\cf2 call\cf0  WriteHex\
	\cf2 call\cf0  crlf\
printer \cf2 ENDP\cf0 \
\
theEnd:\
exit\
\cf2 END\cf0  main\
\
\
\
\cf2 COMMENT\cf0  &\
AFTER SET \cf2 mov\cf0  \cf2 ecx\cf0 ,0\
Please \cf2 enter\cf0  upper half of the 64-bit-> efffffff\
Please \cf2 enter\cf0  upper half of the 64-bit-> ffffffff\
Please \cf2 enter\cf0  upper half of the 64-bit-> 0\
Please \cf2 enter\cf0  upper half of the 64-bit-> 1\
EFFFFFFFFFFFFFFF + 0000000000000001 = F000000000000000\
Press any key to \cf2 continue\cf0  . . .\
&\
\
}