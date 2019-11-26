
TITLE FindGDC.asm
; ------------------------------------------------------------------------
; CS10 - Assignment 07 - 110219 - Jesse Cecil
; Author Daniela Goggel, Edited by LA Breene
; FindGCD finds the Greatest Common Devisor
; GCD. Ensures user enters valid, non-zero input.
; Integer assinged to x must be larger than or equal to that
; assigned to y.
; ------------------------------------------------------------------------

INCLUDE Irvine32.inc


BUFMAX = 128     	   ; maximum buffer size
COUNTL = 3

.data
sBanner    BYTE      "Find GCD of 2 integer decimals.", 0
getFirst   BYTE      "Enter the first signed decimal: ", 0
getSecond  BYTE      "Enter the second signed decimal: ", 0
putResult  BYTE      "The GCD is: ", 0
buffer     BYTE      BUFMAX + 1 DUP(0)
x_Val      SDWORD    ?
y_Val      SDWORD    ?

.code

main PROC

		 ; set up proc
		 mov	edx, OFFSET sBanner	  ; display the intro
		 call	WriteString
		 call	Crlf                   ; carriage return and line feed to buffer
   	     call	Crlf                   ; adds Crlf
									   ; loop test 3 times
		 mov	ecx, COUNTL             ;set loop count
L1:
		 pushad

		 ; get user input
		 mov	edx, OFFSET getFirst	  ; display first prompt
		 call	WriteString
		 call	InputDecimal           ; input the decimal
		 mov	x_Val, eax
		 mov	edx, OFFSET getSecond	; display second prompt
		 call	WriteString
		 call   InputDecimal           ; input the decimal
		 mov    y_Val, eax
		 call	Crlf                   ; adds TWO ASC to buffer

         ; find GCF
		 mov	edx, OFFSET putResult  ; prepare to display result
         call	WriteString
		 mov	ebx, x_Val			   ; send the x_Val to subroutine
		 mov	ecx, y_Val			   ; send the y_Val to GCD subroutine
         call   GCD			           ; Find the GCD
         call   WriteDec		       ; prints value of GCF from EAX
         call	Crlf                   ; Crlf
         call	Crlf                   ; Crlf

		 popad
loop L1

		 exit
		 call   ExitProcess
main ENDP


;-------------------------------------------------------------------------------
GCD  PROC
;
; Procedure finds the Greatest Common Denominator between two unsigned
; decimals (max size 32bit).
; Receives: x = EBX, y = ECX
; Return: EAX = GCD of x and y
;	int GCD(int x, int y){
;	compare x and y and swap order if x < y
; x = abs(x)
;	 y = abs(y)
;	 do
;	  {
;		 int n = x % y
;		 x = y
;   	 y = n
;	   } while(y > 0)
; 	return x
; 	}
;
;    examples - x = 24, y = 4
;        24 mod 4 = 24 - Int[24/4]*4 = 0	24 mod 4 = n   24/4 = 6  6/4 = 1
;			   y = 0
;
;			   12 mod 3 = 12 - Int[12/3]*3 = 0  n = 3
;			   3 mod 12 = 3 - Int[3/12]*3 = 3
;
;			   42 mod 7 = 42 - Int[6]*7 = 0			exception that proves the rule
;			   7 mod 42 = 7 - Int[7/42]*42 = 7 - 0
;-------------------------------------------------------------------------------

; determine which is larger x or y
		mov   x_val, ebx
		mov   eax, x_Val		        ; tentative x
		call  MakeAbsolute
		mov   x_Val, eax				; save abs(x)

		mov   y_Val, ecx
		mov   eax, y_Val                ; tentative y
		call  MakeAbsolute
		mov   y_Val, eax				; save abs(y)

		mov   ebx, x_Val				; abs(x) in ebx, abs(y) in eax
		cmp   eax, ebx					; compare abs(y) and abs(x)	
		jl	  Continue					; x > y no need to swap

		; swap x and y
		mov		eax, y_Val
		mov		ebx, x_Val
		mov		y_Val, ebx
		mov		x_Val, eax

Continue:
		cmp		ebx, 0
		je		ErrorDivideByZero
		mov		eax, x_Val
		mov		ebx, y_Val

LoopDoWhile:     ; eax already in div register
		cdq                             ; converts dword to qword - prevents overflow
		div		ebx			            ; int n = x/y quotient [24 mod 4 = 6] in eax, remainder in edx [remainder = 0]
		mov		ebx, edx		        ; y = n
		cmp		ebx, 0					; compare y to zero
		jg		LoopDoWhile             ; while (y > 0)

	    ; return GCD in eax
		ret

ErrorDivideByZero: ret -1

GCD ENDP


;-------------------------------------------------------------------------------
MakeAbsolute PROC
;
; Procedure that makes a value absolute.
; Receives: value in EAX
; Return: absolute value in EAX
;-------------------------------------------------------------------------------

		mov		esi, eax                ; copy
		sar		eax, 31                 ; shift
		xor		esi, eax                ; unite
		sub		esi, eax                ; subtract
		mov		eax, esi                ; save

		ret

MakeAbsolute ENDP


;-----------------------------------------------------
InputDecimal PROC
;
; input decimal
; Receives: nothing
; Returns: input in EAX
;-----------------------------------------------------

		mov		ecx,BUFMAX		     ; maximum character count
		mov		edx,OFFSET buffer	 ; point to the buffer
		call	ReadInt         	 ; input the string

		ret

InputDecimal ENDP


END main
