ORG 0000H
JMP START
ORG 000BH
JMP TIM0
TABLE1:
		DW 64021,64103,64260,64400				;���ɱ�
		DW 64524,64580,64684,64777
		DW 64820,64898,64968,65030
		DW 64934								
TABLE:	DB 42h,82h,82h,82h,84h,02h,72h			;��λΪ���ɣ���λΪ����ʱ��
		DB 62h,72h,62h,52h,48h
		DB 0b2h,0b2h,0b2h,0b2h,0b4h,02h,0a2h
		DB 12h,0a2h,0d2h,92h,88h
		DB 82h,0b2h,0b2h,0a2h,84h,02h,72h
		DB 62h,72h,62h,52h,44h,02h,12h
		DB 12h,62h,62h,52h,44h,02h,82h
		DB 72h,62h,52h,32h,48h
		DB 00h									
START:
		MOV TMOD,#01H  		;T0������ʽ1
		MOV IE,#82H			
START0:	MOV 30H,#00
NEXT:	MOV A,30H
		MOV DPTR,#TABLE
		MOVC A,@A+DPTR
		MOV R2,A
		JZ END0
		ANL A,#0FH
		MOV R5,A
		MOV A,R2
		SWAP A
		ANL A,#0FH
		JNZ SING
		CLR TR0
		JMP D1
SING:	DEC A
		MOV 22H,A
		RL A
		MOV DPTR,#TABLE1
		MOVC A,@A+DPTR
		MOV TH0,A
		MOV 21H,A
		MOV A,22H
		RL A
		INC A
		MOVC A,@A+DPTR
		MOV TL0,A
		MOV 20H,A
		SETB TR0
D1:		LCALL DELAY		;���һ������
		INC 30H
		JMP NEXT
END0:	CLR TR0			;ֹͣ����
		JMP START0
TIM0:	PUSH ACC
		PUSH PSW
		MOV TL0,20H		;����װ���ֵ
		MOV TH0,21H
		CPL P2.7       	;�����Ƶ����
		POP PSW
		POP ACC
		RETI
  DELAY:MOV R7,#02
    D2:	MOV R4,#125
    D3:	MOV R3,#248
		DJNZ R3,$
		DJNZ R4,d3
		DJNZ R7,d2
		DJNZ R5,delay
		RET

END