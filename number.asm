   
    
 ;number.asm
;These are macros for use in Assembly Language Class.
;They are for integer and floating point input and output.
;They were written by Myron Berg at Dickinson State University
;4/1/99




extrn atoi:proc, itoa:proc, atof:proc, ftoa:proc

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

GetInteger              macro    number
;gets an integer and stores it in a double word sized variable
                lea    bx, number
                call    AtoI

endm

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

GetFloat                macro  number
;gets a floating point and stores it in a double word sized variable

                lea    bx, number
                call    atof
endm

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

DisplayFloat              macro  Number, places
;displays a floating point double word sized variable on the screen 

                lea    bx, number
                mov    cx, places
                call    ftoa

endm

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

DisplayInteger            macro  number
;displays an double word sized variable on the screen
                            
                lea    bx, number
                call    itoa

endm
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  
 
  
  
