%include "io.inc"
section .data
    multi dd 0.1
section .bss
    negative_signal resd 0x1
    point_position resd 0x1
    array_adress resd 0x1
    text_num1 resb 0x40
    array_num1 resd 0xA
    array_num2 resd 0xA
    array_result resd 0xA
    float1 DD 0x1
    float2 DD 0x1
section .text
global main
main:
    MOV EBP, ESP               ; Removing garbage
    XOR EAX, EAX               ; Removing garbage
    XOR EBX, EBX
    XOR ECX, ECX
    XOR EDX, EDX
    XOR ESI, 0xA
    XOR EDI, EDI
    PRINT_STRING "Digit two numbers and a operator:"
    NEWLINE
    GET_STRING text_num1, 0x40 ; User call
    CALL str_to_array
    LEA EDI, [array_num1]     ; Convert string to a integer array
    CALL array_to_float        ; Convert an array containing each number as an integer to a float with all number. 
    LEA EDI, [array_num2]
    CALL array_to_float
    MOVSS XMM0, [float1]
    MOVSS XMM1, [float2]
    CMP EBX, 0x2B
    JE add_result
    CMP EBX, 0x2D
    JE sub_result
    CMP EBX, 0x2A
    JE mul_result
    CMP EBX, 0x2F
    JE div_result
    XOR EAX, EAX
    RET
    
    
    
str_to_array:                  ;Convert each char into an integer and add to the array
    PUSH EAX
    PUSH ECX
    PUSH EDX
    MOV BL, 0x40
    first_array:
        MOVZX EAX, BYTE [text_num1+ECX]
        CMP BL, AL
        JL second_array
        CMP AL, 0x2B
        JE signal_catcher
        CMP AL, 0x2D
        JE signal_catcher 
        CMP AL, 0x2A
        JE signal_catcher 
        CMP AL, 0x2F
        JE signal_catcher  
        SUB EAX, 0x30
        MOV [array_num1 + ECX*0x4], EAX
        ;PRINT_DEC 0x1, [array_num1 + ECX * 0x4] ; Converter output test
        INC ECX
        JMP first_array
     second_array:
        MOVZX EAX, BYTE [text_num1+ECX]
        CMP AL, 0x00
        JE end 
        SUB EAX, 0x30
        MOV [array_num2 + EDX*0x4], EAX
        ;PRINT_DEC 0x1, [array_num1 + ECX * 0x4] ; Converter output test
        INC ECX
        INC EDX
        JMP second_array
        signal_catcher:
            MOV BL, AL
            INC ECX
            JMP first_array
        end:
            POP EDX
            POP ECX
            POP EAX
            RET       
array_to_float:
     PUSH EAX
     PUSH EBX
     PUSH ECX
     PUSH EDX
     XOR EAX, EAX 
     _loop2:
        MOV EBX, DWORD [EDI + ECX*0x4]
        ;CMP EBX, 32
        ;JE end_step1
        CMP ECX, ESI
        JG mid_jump
        CMP EBX, -2
        JE point_catcher
        IMUL EAX, 10
        ADD EAX, EBX
        INC ECX
        JMP _loop2
        point_catcher:
            MOV ESI, ECX
            MOV EDX, ECX
            INC ECX
            MOV EDX, ECX
            JMP _loop2
        mid_jump:
            CMP ECX, EDX
            JG after_point
            CVTSI2SS XMM0, EAX
            MOVSS XMM1, [multi]
            MOVSS XMM2, [multi]
            XOR EAX, EAX
            JMP after_point
        after_point:
            CVTSI2SS XMM3, EBX
            MULSS XMM3, XMM1
            ADDSS XMM0, XMM3
            MULSS XMM1, XMM2
            INC ECX
            CMP ECX, 9
            JE end_step1
            JMP _loop2      
        end_step1:
            XOR EAX, EAX
            XOR ECX, ECX
            LEA EDX, [array_num2]
            CMP EDI, EDX
            JE end_step2
            MOVSS DWORD [float1], XMM0
            CVTTSS2SI EAX, [float1]
            ;PRINT_DEC 4, EAX
            ;NEWLINE
            POP EDX
            POP ECX
            POP EBX
            POP EAX
            RET
        end_step2: 
            MOVSS DWORD [float2], XMM0
            CVTTSS2SI EAX, [float2]
            ;PRINT_DEC 4, EAX
            ;NEWLINE
            POP EDX
            POP ECX
            POP EBX
            POP EAX
            RET
add_result:                         
    ADDSS XMM0, XMM1
    ;CVTTSS2SI EAX, XMM0
    ;PRINT_DEC 4, EAX
    JMP float_to_string
sub_result:
    UCOMISS XMM0, XMM1
    JB negative_num                         
    SUBSS XMM0, XMM1
    ;CVTTSS2SI EAX, XMM0
    ;PRINT_DEC 4, EAX
    JMP float_to_string
negative_num:
    SUBSS XMM1, XMM0
    MOVSS XMM0, XMM1  
    MOV EAX, 0x1
    MOV [negative_signal], EAX
    JMP float_to_string
mul_result:                         
    MULSS XMM0, XMM1
    ;CVTTSS2SI EAX, XMM0
    ;PRINT_DEC 4, EAX
    JMP float_to_string
div_result:                         
    DIVSS XMM0, XMM1
    ;CVTTSS2SI EAX, XMM0
    ;PRINT_DEC 4, EAX
    JMP float_to_string
    
float_to_string:
    XOR EAX, EAX               
    MOV EBX, 10
    XOR ECX, ECX
    XOR EDX, EDX
    XOR EDI, EDI
    CVTSI2SS XMM2, EBX
    CVTTSS2SI EAX, XMM0
    CVTSI2SS XMM1, EAX
    SUBSS XMM0, XMM1
    ;CVTTSS2SI ESI, XMM0
    div_op:
        ;PRINT_DEC 4, EAX
        ;NEWLINE
        DIV EBX
        ;PRINT_DEC 4, EAX
        ;NEWLINE
        ;PRINT_DEC 4, EDX
        ;NEWLINE
        PUSH EDX
        XOR EDX, EDX
        INC EDI
        CMP EAX, 0
        JE op_1
        JMP div_op
    op_1:
       CMP ECX, EDI
       JE op_2
       POP EAX
       ;PRINT_DEC 4, EAX
       MOV [array_result + ECX*0x4], EAX
       INC ECX
       XOR EDX, EDX
       JMP op_1
    op_2:
       MOV EBX, -2
       MOV [array_result + ECX*0x4], EBX
       MOV EDI, ECX
       ADD EDI, 2
       INC ECX
       MOV EAX, ESI
       JMP op_3
    op_3:
       CMP ECX, 10
       JE op_end
       MULSS XMM0, XMM2
       CVTTSS2SI ESI, XMM0
       MOV [array_result + ECX*0x4], ESI
       INC ECX
    op_end:
        XOR EAX, EAX
        XOR ECX, ECX
        MOV EBX, [negative_signal]
        JMP output
        RET
    
output:
     CMP EBX, 1
     JE print_signal
     MOV EAX, [array_result + ECX*0x4]
     ADD EAX, 48
     PRINT_CHAR EAX
     INC ECX
     CMP ECX, 5
       JE finish
     JMP output
     print_signal:
        MOV EAX, 0x2D
        PRINT_CHAR EAX
        INC ECX
        DEC EBX
        JMP output
finish:
    XOR EAX, EAX
    RET