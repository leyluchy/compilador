   
    
 ;numbers.asm
;This file was written by Myron Berg of Dickinson State University
;It is used for inputting and outputting numbers into an assembly language
;program.

;This program should be seperately assembled and then linked to the program
;using it.



public  atof, ftoa, itoa, atoi
.model small
.stack 100h
.386
.387

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

displayString                  macro  string          ;write string on screen

;This macro displays a $ terminated string on the screen.

                        pushad

                        lea    dx, string
                        mov    ah, 9
                      int    21h

                        popad

endm

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


getFloatString            macro  string        ;read string from keyboard
local  label1, label2, label3, label4, label5, label6, label7, label8


;This macro gets a string from the user and stores it in a string variable.
;It is used by the AtoF procedure.
;When the enter key is pressed (0Dh), the process ends and a $ is entered
;at the end of the string.
;A backspace key (8) will allow the overwriting of the previous character.
;They only keys entered in the string are the numbers, the negative sign,
;and the decimal.  Only one entry of the decimal and negative sign are
;allowed.  

                        pushad
                        push    edi
                        push    esi

                        lea    si, string

                        mov    bx, si

label1:                mov    ah, 1
                        int    21h

                        cmp    al, 0Dh        ;when enter is pressed,
                        je      label2          ;string is complete.

                        cmp    al, 8          ;backspace key
                        je      label8
                        jmp    label7

label8:                dec    si              ;backspace, so move back
                        cmp    si, bx
                        jl      label6
                        jmp    label1

label6:                mov    si, bx
                        jmp    label1


label7:                cmp    al, '-'        ;has '-' been pressed before?
                        jne    label4
                        cmp    bl, 1
                        je      label1
                        mov    bl, 1

label4:                cmp    al, '.'        ;has '.' been pressed before?
                        jne    label5
                        cmp    bh, 1
                        je      label1
                      mov    bh, 1

label5:                cmp    al, '-'        ;most allowable character
                        jl      label1          ;codes are between - and 9
                        cmp    al, '9'
                        jg      label1
                        cmp    al, '/'
                        je      label1
label3:                mov    [si], al
                        inc    si
                        jmp    label1
label2:                mov    byte ptr [si], '$'    ;add $ to string end

                        mov    al, 0Dh          ;go to new line
                        mov    ah, 0Eh
                        int    10h
                        mov    al, 0Ah  
                        mov    ah, 0Eh
                        int    10h

                        pop    esi
                        pop    edi
                        popad

endm    

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



getIntegerString    macro  string        ;read string from keyboard
local  label1, label2, label3, label4, label5, label6, label7


;This macro gets a string from the user and stores it in a string variable.
;It is used by the AtoI procedure.
;When the enter key is pressed (0Dh), the process ends and a $ is entered
;at the end of the string.
;A backspace key (8) will allow the overwriting of the previous character.
;They only keys entered in the string are the numbers, the negative sign,
;and the decimal.  Only one entry of the decimal is allowed.  Entering a
;decimal will end the process (since this is for integers).


                        pushad
                        push    edi
                        push    esi

                        lea    si, string

                        mov    bx, si

label1:                mov    ah, 1
                        int    21h

                        cmp    al, 0Dh      ;enter key
                        je      label2

                      cmp    al, 8        ;backspace key
                        je      label5
                        jmp    label7

label5:                dec    si          ;backspace, so overwrite 
                        cmp    si, bx        ;previous character
                        jl      label6
                        jmp    label1

label6:                mov    si, bx
                        jmp    label1


label7:                cmp    al, '-'      ;only allow one negative sign
                        jne    label4      ;per string
                        cmp    bl, 1
                        je      label1
                        mov    bl, 1

label4:                cmp    al, '.'      ;most ascii codes allowed are
                        je      label2      ;in this range, except the
                        cmp    al, '-'      ;'/'
                        jl      label1
                        cmp    al, '9'
                        jg      label1
                        cmp    al, '/'
                        je      label1
label3:                mov    [si], al
                        inc    si
                        jmp    label1
label2:                mov    byte ptr [si], '$'                        

                        mov    al, 0Dh    ;proceed to new line.
                        mov    ah, 0Eh
                        int    10h
                        mov    al, 0Ah  
                        mov    ah, 0Eh
                      int    10h

                        pop    esi
                        pop    edi
                        popad

endm    

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.data
      tempStr        db      25 dup (?), '$'
      Int1            dd      ?
      Int2            dd      ?
      realTen        dd      10.0
      integerTen      dd      10
      places          dw      ?
      TooLarge        db      10, 13, 'The value entered '
                      db      'has too many digits.', 10, 13, '$'

.code

begin:

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

AtoF    proc
locals

;This procedure converts a string to a double word sized floating point
;memory variable. It works using the following methods:
;l.    First the string is examined for the number of places after the
;      decimal.  This number is stored in the variable places.  The decimal
;      point is deleted from the string so an integer remains.
;2.    If a negative sign has been entered, a value of -1 is stored
;      for later multiplication with the result.
;3.    By a process of subtracting 30h from each digit, then adding this
;      value to the previous accumulation and multiplying the accumulation
;      by 10, the number is converted from ascii to integer.
;4.    The integer value from step 3 above is loaded into the floating
;      point processor and divided by 10 as many times as there were
;      places entered by the user.



                        
                        pushad
                        push    edi
                        push    esi

                        push    bx
                
                        getFloatString      tempStr
                        lea    si, tempStr

                        mov    bx, 0

@@cycle12:              cmp    byte ptr [bx][si], '$'
                        jne    @@around2
                        mov    places, 0
                        jmp    @@skip2
@@around2:              cmp    byte ptr [bx][si], '.'
                        je      @@done30
                        inc    bx
                        jmp    @@cycle12

@@done30:              mov    places, 0
@@skip:                inc    bx
                        mov    al, byte ptr [bx][si]
                        mov    byte ptr [bx-1][si], al
                        cmp    byte ptr [bx][si], '$'
                        je      @@skip2
                        inc    places
                        jmp    @@skip

@@skip2:                mov    edi, 0
                        mov    edx, 0
                        mov    eax, 0
                        mov    bx, 0

@@cycle:                cmp    byte ptr [si][bx], '$'
                        je      @@done10

                        cmp    byte ptr [si][bx], '-'
                        jne    @@skip10
                        or      edi, -1

                        jmp    @@notAscii

@@skip10:              or      edi, 1
@@skip11:              mov    edx, 0
                        Imul    IntegerTen
                        cmp    edx, 0
                        je      @@InRange
                        displaystring  TooLarge
                        mov    eax, 0
                        jmp    @@done10
                        
@@InRange:              movsx  ecx, byte ptr[si][bx]
                        add    eax, ecx
                        cmp    ecx, 30h
                      jl      @@notAscii
                        sub    eax, 30h
@@notASCii:            inc    bx
                        jmp    @@cycle

@@done10:              mov    edx, 0
                        imul    edi
                        mov    int1, eax
                        finit
                        fild    int1

                        mov    cx, 0
@@cycle2:cmp            cx,    places
                        je      @@done
                        fld    realTen
                      fdivp
                        inc    cx
                        jmp    @@cycle2

@@done:                pop    bx
                        fstp    dword ptr[bx]

                        fwait

                        pop    esi
                        pop    edi
                        popad
                        ret

AtoF    endp



;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

ftoa    proc
locals


;This procedure converts a double word sized floating point to a string
;memory variable. It works using the following methods:
;l.    First the string is cleared.
;2.    The value is multiplied by 10 as many times as there was places  
;      specified by the user.
;3.    This number is stored as an rounded integer using the fist command.
;4.    From the back of the string, digits are added by repeatedly dividing      
;      by ten and using the remainders added to 30h to make ascii codes
;5.    If the value was negative, a '-' is added to the front of the string
;6.    Commas are inserted in the correct places both before and after the
;      decimal point.
;7.    The string is shortened to its minimum length.  It has a $ at the end
;      of the string.


                        pushad
                        push    edi
                        push    esi

                        lea    si, tempstr
                        push    bx
                        mov    bx, 0
@@cycle6:              mov    byte ptr[bx][si], 0
                        inc    bx
                        cmp    bx, 25
                        jl      @@cycle6
                        pop    bx
                        finit
                        fld    dword ptr [bx]
                        fabs
                        mov    places, cx
                        mov    cx, 0
@@cycle:                cmp    cx, places
                        je      @@done
                        fld    realTen
                        fmulp
                        
                        inc    cx
                        jmp    @@cycle

@@done:                fistp  int2

                        fld    dword ptr [bx]
                        ftst
                        fstsw  ax
                        fmulp
                        fwait
                        
                        sahf

                        jae    @@notNeg
                        mov    cl, '-'
                        jmp    @@skip3
@@notNeg:              mov    cl, 0

@@skip3:                mov    bx, 24

                        mov    eax, int2

@@cycle7:              cdq
                        idiv    IntegerTen
                        add    dl, 30h
                        mov    byte ptr [bx][si], dl
                        dec    bx
                        cmp    eax, 0
                        je      @@done5
                        cmp    bx, 0
                        jg      @@cycle7

@@done5:                mov    byte ptr [bx][si], cl

@@cycle8:              dec    bx
                        cmp    bx, 0
                        jl      @@done2
                        mov    byte ptr [bx][si], 0
                        jmp    @@cycle8

                        pop    bx

@@done2:                mov    cx, 25
                        sub    cx, places
                        dec    cx
                        mov    bx, 0

@@cycle3:              cmp    bx, cx
                        je      @@done3
                        mov    al, [bx+1][si]
                        mov    [bx][si], al
                        inc    bx
                        jmp    @@cycle3

@@done3:                mov    byte ptr [bx][si], '.'
                            
                        mov    cl, 0
                        mov    bx, 24

@@cycle101:            cmp    byte ptr [si][bx], '.'
                        je      @@skip102
                        cmp    byte ptr [si][bx], 0
                        je      @@reduce
                        cmp    byte ptr [si][bx], '-'
                        je      @@reduce

                        mov    al, cl
                        cbw
                        mov    ch, 3
                        div    ch
                        cmp    ah, 0
                        je      @@process101

@@atEnd:                inc    cl
                        dec    bx
                        jmp    @@cycle101

@@process101:
                        cmp    al, 0
                        je      @@atEnd

                        mov    dx, bx
                        mov    bx, 1
@@cycle102:            mov    al, [si][bx]
                        mov    [si][bx-1], al
                        
                        cmp    bx, dx
                        je      @@done101
                        inc    bx
                        jmp    @@cycle102

@@done101:              mov    byte ptr [si][bx], ','
                        mov    bx, dx

@@skip102:              mov    cl, 0
                        dec    bx
                        cmp    bx, 0
                        jg      @@cycle101


@@reduce:
;reduce string to shortest length possible


                        mov    di, si
                        mov    bx, 0
@@cycle4:              cmp    byte ptr [si][bx],'$'
                        je      @@done4
                        cmp    byte ptr [si][bx], 0
                      je      @@skip
                        mov    al, [si][bx]
                        mov    [di], al
                        mov    byte ptr [si][bx], 0
                        inc    di
                        inc    bx
                        jmp    @@cycle4
@@skip:                inc    bx
                        jmp    @@cycle4

@@done4:                mov    byte ptr [di], '$'

                        displayString tempStr

                        pop    esi
                      pop    edi
                        popad
                        ret

ftoa    endp



;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

itoa    proc
locals

;This procedure converts a double word sized integer to a string
;memory variable. It works using the following methods:
;l.    First the string is cleared.
;2.    From the back of the string, digits are added by repeatedly dividing      
;      by ten and using the remainders added to 30h to make ascii codes
;3.    If the value was negative, a '-' is added to the front of the string
;4.    Commas are inserted in the correct places.
;5.    The string is shortened to its minimum length.  It has a $ at the end
;      of the string.




                        pushad
                        push    edi
                        push    esi

                        lea    si, tempstr

                        push    bx
                        mov    bx, 0
@@cycle6:              mov    byte ptr[bx][si], 0
                        inc    bx
                        cmp    bx, 25
                        jl      @@cycle6
                        pop    bx
  
                        mov    eax, [bx]
                        
                        cmp    dword ptr [bx], 0
                        jge    @@notNeg
                        mov    cl, '-'
                        not    eax
                        inc    eax
                        jmp    @@skip3
@@notNeg:              mov    cl, 0

@@skip3:                mov    bx, 24

@@cycle7:              cdq
                        idiv    IntegerTen
                        add    dl, 30h
                        mov    byte ptr [bx][si], dl
                        dec    bx
                        cmp    eax, 0
                        je      @@done5
                        cmp    bx, 0
                        jg      @@cycle7

@@done5:                mov    byte ptr [bx][si], cl

@@cycle8:               dec    bx
                        cmp    bx, 0
                        jl      @@done2
                        mov    byte ptr [bx][si], 0
                        jmp    @@cycle8

@@done2:                mov    cl, 0
                        mov    bx, 24

@@cycle101:            cmp    byte ptr [si][bx], 0
                        je      @@reduce
                        cmp    byte ptr [si][bx], '-'
                        je      @@reduce

                        mov    al, cl
                        cbw
                        mov    ch, 3
                        div    ch
                        cmp    ah, 0
                        je      @@process101

@@atEnd:                inc    cl
                        dec    bx
                        jmp    @@cycle101

@@process101:
                        cmp    al, 0
                        je      @@atEnd

                        mov    dx, bx
                        mov    bx, 1
@@cycle102:            mov    al, [si][bx]
                        mov    [si][bx-1], al
                        
                        cmp    bx, dx
                        je      @@done101
                        inc    bx
                        jmp    @@cycle102

@@done101:              mov    byte ptr [si][bx], ','
                        mov    bx, dx
                        mov    cl, 0
                        dec    bx
                        cmp    bx, 0
                        jg      @@cycle101




@@reduce:
                        mov    di, si
                        mov    bx, 0
@@cycle4:              cmp    byte ptr [si][bx],'$'
                        je      @@done4
                        cmp    byte ptr [si][bx], 0
                        je      @@skip
                        mov    al, [si][bx]
                        mov    [di], al
                        mov    byte ptr [si][bx], 0
                        inc    di
                        inc    bx
                      jmp    @@cycle4
@@skip:                inc    bx
                        jmp    @@cycle4

@@done4:                mov    byte ptr [di], '$'

                        DisplayString tempStr

                        pop    esi
                        pop    edi
                        popad
                        ret

itoa    endp

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

atoi    proc
locals

;This procedure converts a string to a double word sized integer
;memory variable. It works using the following methods:
;1.    If a negative sign has been entered, a value of -1 is stored
;      for later multiplication with the result.
;2.    By a process of subtracting 30h from each digit, then adding this
;      value to the previous accumulation and multiplying the accumulation
;      by 10, the number is converted from ascii to integer.



                        pushad
                        push    edi
                        push    esi

                        push    bx

                        getIntegerString      TempStr
                        lea    si, tempstr

                        mov    edi, 0
                        mov    edx, 0
                        mov    eax, 0
                        mov    ebx, 0

@@cycle:                cmp    byte ptr [si][bx], '$'
                        je      @@done10

                        cmp    byte ptr[si][bx], '-'
                        jne    @@skip10
                        or      edi, -1
                        jmp    @@notAScii

@@skip10:              or      edi, 1
@@skip11:              mov    edx, 0
  Imul    IntegerTen

                        cmp    edx, 0
                        je      @@InRange
                        displaystring  TooLarge
                        mov    eax, 0
                        jmp    @@done10

@@InRange:              movsx  ecx, byte ptr[si][bx]
                        add    eax, ecx
                        cmp    ecx, 30h
                        jl      @@notAscii
                        sub    eax, 30h
@@notAscii:            inc    bx
                        jmp    @@cycle

@@done10:              mov    edx, 0
                        imul    edi

                        pop    bx
                        mov    [bx], eax

                        pop    esi
                        pop    edi
                        popad
                        ret

atoi    endp


;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




end    begin
  
  
 
  
  
