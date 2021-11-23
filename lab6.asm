TITLE Lab6    (Lab6.asm)
;// Professor Clare Nguyen
;// CIS21JA
;// Samira C. Oliva Madrigal
;// Program adds two 64-bit hexadecimal values and prints the sum. ;// It uses the stack, registers, implements procedures and macros.
INCLUDE Irvine32.inc
;//------------------------------------- ;//prints a string
;//receives: address of string to print mWriteStr MACRO
     push edx
     mov  edx,OFFSET buffer
     call WriteString
     pop  edx
ENDM
;//-----------------------------------
;//prints a signle space character
printSpace MACRO
     push  eax
     mov   al,' '
     call  WriteChar
     pop   eax
ENDM
;//-----------------------------------
;//prints a single character
printChar  MACRO char
     push  eax
     mov   al,char
     call  WriteChar
     pop   eax
ENDM
.stack
.data
promptUpperHalf BYTE "Please enter upper half of the 64-bit-> ",0 promptLowerHalf BYTE "Please enter upper half of the 64-bit-> ",0
errorMessage
num1 QWORD ?
num2 QWORD ?
sum  QWORD ?
.code
BYTE "ERROR: sum exceeds 64-bits                ",0
main PROC
;//;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;getUserInput add PART.I mov edx,OFFSET promptUpperHalf
call WriteString
call ReadHex
mov DWORD PTR num1+4, eax
mov edx,OFFSET promptLowerHalf
call WriteString
call ReadHex
mov DWORD PTR num1,eax
mov edx,OFFSET promptUpperHalf
call WriteString
call ReadHex
mov  DWORD PTR num2+4, eax
mov edx,OFFSET promptLowerHalf
call WriteString
call ReadHex
mov DWORD PTR num2,eax
;//pass lowerHalf of num1, lowerHald of num2, carryVal = 0 mov ecx,0
sub esp,4 ;//save room for the return value
push DWORD PTR num1 ;//pass lowerHalf of num1 push DWORD PTR num2 ;//pass lowerHald of num2 push DWORD PTR ecx ;//pass carryValue set to 0 push OFFSET sum ;//(&sum) pass by address
call add64BitInts ;//carry = add64BitInts (num1, num2, carry, &sum) pop ecx;
;// add PART. II
sub esp,4
push DWORD PTR num1+4
push DWORD PTR num2+4
push DWORD PTR ecx
push OFFSET sum+4
call add64BitInts
pop  ecx;
;// PART.III if sum is withing 64 bits call printer else errMsg ;// use the carry bit to determine this
cmp ecx,1
jne  successPrint
mov  edx,OFFSET errorMessage
call WriteString
jmp  theEnd
successPrint:
     mov   ebx,OFFSET num1
     mov   ecx,OFFSET num2
     mov   edx,OFFSET sum
     call  printer
     jmp   theEnd
main ENDP
;// printer(&num1, &num2, &sum)
;//--------------------------------------------------------------------------; ;// ;//--------------------------------------------------------------------------; ;// Perfoms addition of 32-bit integers.
;// Receives: EDI, ESI (two unsigned integers) , EAX (carryValue = 0)
;// Returns: EAX (the new carry), &sum
;// Requires: Nothing ;//--------------------------------------------------------------------------; add64BitInts PROC
push ebp      ;; //save ebp value
mov  ebp,esp  ;; //set ebp to esp value
              ;; //pushad;; save all the registers
push eax      ;; //save registers
push ebx
push ecx
push edx
push esi
push edi
                 ;//now use the registers inside the procedure
mov esi,[ebp+20] ;// esi=num1
mov edi,[ebp+16] ;// edi=num2
mov ebx,[ebp+12] ;// ebx =0 (carrybit)
mov eax,[ebp+8]  ;// eax is ptr---> sum
mov ecx,32
addIntsBitByBit:
push esi
     and  esi,1
bit of num1)
push edi
     and  edi,1
bit of num2)
     mov edx,esi
     xor edx,edi
     xor edx,ebx
xor c
;// set counter
  ;//save esi
  ;//use esi
  ;//save edi
;//use edi
; mov eax,esi
; and eax,1
; mov ebx,edi
; and ebx,1
;;;// eax=num1 AND
;;;// ebx=num2 AND
1 = (ith
1 = (ith
= a xor b
one push
;// bit i of sum = a xor b xor c
;// edx = esi = num1 ith bit
;// xor edx,ebx  (a xor b)
; // edx(ith bit num1) xor ebx(carryValue) //edx
;//save counter value and use ecx temporarily
push ecx
mov ecx,[eax] ;//mov ecx,[ebx]// DEREFERENCE THE SUM or ecx,edx
ror ecx,1
mov [eax],ecx
pop ecx ;//restore ecx (may change later optimize to only
and pop with adding
push ecx ;//:::push ecx to stack so can use it temporarily push edx ;//:::push edx to stack and use it temporarily
     mov ecx,esi ;// ecx = num1 ith bit
     and ecx,edi ;// ecx AND num2 ith bit (a and b)
mov edx,esi ;// edx = num1 ith bit
and edx,ebx ;// (a and c)
or ecx,edx ;// (a and b) or (a and c)
mov edx,edi ;// edx = num2 ith bit
and edx,ebx ;// num2 ith bit AND c
or ecx,edx;//[(aandb)or(aandc)]OR(bandc)
     mov ebx,ecx ;// UPDATE C VALUE
pop edx
pop ecx
pop edi
pop esi
shr esi,1
shr edi,1
;// restore temp edx
;// restore the count
;// restore edi = num2 ith bit
;// restore esi = num1 ith bit
loop addIntsBitByBit
mov [ebp+24],ebx ;//THE RETURN VALUE!!!
pop edi
;//restore registers
     pop esi
     pop edx
     pop ecx
     pop ebx
     pop eax
     pop ebp
     ret 16
add64BitInts ENDP
;//--------------------------------------------------------------------------; ;// Perfoms: prints three values to screen (num1, num2 and sum)
;// Receives: EBX (num1), ECX(num2), EDX (sum)
;// Returns: Nothing
;// Requires: Nothing
;// -----------------------------------------------------------------------------; printer PROC
     mov  eax,[ebx+4]
     call WriteHex
     mov  eax,[ebx]
     call WriteHex
     printSpace
     printChar '+'
     printSpace
     mov  eax,[ecx+4]
     call WriteHex
     mov  eax,[ecx]
     call WriteHex
     printSpace
     printChar '='
     printSpace
     mov  eax,[edx+4]
     call WriteHex
     mov  eax,[edx]
     call WriteHex
     call crlf
printer ENDP
theEnd:
exit
END main
COMMENT &
AFTER SET mov ecx,0
Please enter upper half of the 64-bit-> efffffff Please enter upper half of the 64-bit-> ffffffff Please enter upper half of the 64-bit-> 0
Please enter upper half of the 64-bit-> 1 EFFFFFFFFFFFFFFF + 0000000000000001 = F000000000000000 Press any key to continue . . .
&
