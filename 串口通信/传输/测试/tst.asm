LED 	 BIT	P2.4
CLOCK    DATA	33H

ORG 0000H
		LJMP START	
ORG 000BH
		LJMP TIM0
ORG 0013H
		LJMP K3


ORG 0030H
START:	
		SETB IT1        ;�����ⲿ�ж�1�½��ش���
		SETB EX1
		SETB PT0
		CLR  PX1
		MOV TMOD,#11H
		SETB ET0
		SETB EA
		SETB F0
		SJMP $
			
K3:		CPL	 LED
		LCALL DELAY1
		CPL	 LED
		LCALL START1
		RETI
			
START1:	SETB ET0
		
START0:	MOV 30H,#00
NEXT:	MOV A,30H
		MOV DPTR,#TABLE
		MOVC A,@A+DPTR		;ȡ������
		MOV R2,A
		JZ END0				;AΪ00���������
		ANL A,#0FH
		MOV R5,A			;ȡ�����ķ���R5
		MOV A,R2
		SWAP A
		ANL A,#0FH			;ȡ����������A
		JNZ SING			;A��Ϊ0��ת
		JMP END0
SING:	DEC A
		MOV 22H,A
		RL A
		MOV DPTR,#TABLE1
		MOVC A,@A+DPTR		;ȡ����λ�ĳ�ֵ
		MOV TH0,A			
		MOV 21H,A
		MOV A,22H
		RL A
		INC A
		MOVC A,@A+DPTR		;ȡ����λ�ĳ�ֵ
		MOV TL0,A
		MOV 20H,A
		SETB TR0
D1:		LCALL DELAY		;���һ������
		INC 30H
		JMP NEXT
END0:	CLR TR0			;ֹͣ����
		RET
		
TIM0:	PUSH ACC
		PUSH PSW
		MOV TL0,20H		;����װ���ֵ
		MOV TH0,21H
		CPL P2.7       	;�����Ƶ����
		POP PSW
		POP ACC
		RETI
		
  DELAY:MOV R7,#02		;��ʱ0.13s��R5
    D2:	MOV R4,#100
    D3:	MOV R3,#248
		DJNZ R3,$
		DJNZ R4,D3
		DJNZ R7,D2
		DJNZ R5,DELAY
		RET
		
DELAY1:	MOV R7,#50		;��ʱ3S
D21:		MOV R4,#100
D31:		MOV R3,#250
		DJNZ R3,$
		DJNZ R4,D31
		DJNZ R7,D21
		RET
		
T1_INT:PUSH	 ACC		  ;????
			 PUSH	 PSW
  		       CLR	 TR1			 
             MOV   TH1,#3CH    ;????????
             MOV   TL1,#0B0H  
			 SETB	 TR1
			 INC	 CLOCK        ;????1
			 MOV	 A,CLOCK
			 CJNE	 A,#5, TMPL
       TMPL:JC	 RETURN	  ;??0.5s??
			 CPL	 LED		  ;?0.5s????
			 MOV	 CLOCK,#0	  ;?????
     RETURN:POP	 PSW
			 POP	 ACC 
			 RETI
			 

TABLE1:
		DW 63625,63833,64019,64104,64260,64440,64524			;���ɱ�
		DW 64580,64685,64778,64820,64898,64968,65030
		DW 65058
		;	1	  2		 3    4	     5	   6     7   ����
		;   8	  9	     A	  B 	 C	   D     E  ����
		;   F										 ����

TABLE:	DB	0A4H,84H,94H,64H,0A2H,92H,83H,92H,64H 	;��λΪ���ɣ���λΪ����ʱ��
		DB	0A4H,84H,94H,94H,0C2H,0A2H,72H,84H	
		DB  00H	

END