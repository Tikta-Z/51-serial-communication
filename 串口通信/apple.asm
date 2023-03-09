LED 	 BIT	P2.4
ORG 0000H
JMP START1
ORG 000BH
JMP TIM0D

START1:	MOV TMOD,#11H
		SETB EA
		CPL	 LED
		LCALL DELAY1
		CPL	 LED
		LCALL START
		LJMP END1
							
START:	SETB ET0
				
START0:	MOV 30H,#00
NEXT:	MOV A,30H
		MOV DPTR,#TABLE
		MOVC A,@A+DPTR		;取出音符
		MOV R2,A
		JZ END0				;A为00则歌曲结束
		ANL A,#0FH
		MOV R5,A			;取出节拍放在R5
		MOV A,R2
		SWAP A
		ANL A,#0FH			;取出音调放在A
		JNZ SING			;A不为0跳转
		JMP END0
SING:	DEC A
		MOV 22H,A
		RL A
		MOV DPTR,#TABLE1
		MOVC A,@A+DPTR		;取出高位的初值
		MOV TH0,A			
		MOV 21H,A
		MOV A,22H
		RL A
		INC A
		MOVC A,@A+DPTR		;取出低位的初值
		MOV TL0,A
		MOV 20H,A
		SETB TR0
D1:		LCALL DELAY		;输出一个音符
		INC 30H
		JMP NEXT
END0:	CLR TR0			;停止播放
		RET
TIM0:	PUSH ACC
		PUSH PSW
		MOV TL0,20H		;重新装入初值
		MOV TH0,21H
		CPL P2.7       	;输出音频数据
		POP PSW
		POP ACC
		RETI
  DELAY:MOV R7,#02		;延时0.13s×R5
    D2:	MOV R4,#100
    D3:	MOV R3,#248
		DJNZ R3,$
		DJNZ R4,D3
		DJNZ R7,D2
		DJNZ R5,DELAY
		RET
		
DELAY1:	MOV R7,#50		;延时3S
D21:		MOV R4,#100
D31:		MOV R3,#250
		DJNZ R3,$
		DJNZ R4,D31
		DJNZ R7,D21
		RET

TABLE1:
		DW 63625,63833,64019,64104,64260,64440,64524			;音律表
		DW 64580,64685,64778,64820,64898,64968,65030
		DW 65058
		;	1	  2		 3    4	     5	   6     7   低音
		;   8	  9	     A	  B 	 C	   D     E  中音
		;   F										 高音
TABLE:	DB	0A4H,84H,94H,64H,0A2H,92H,83H,92H,64H 	;高位为音律，低位为节拍时间
		DB	0A4H,84H,94H,94H,0C2H,0A2H,72H,84H	
		DB  00H		

QIJI:   DB	64H,74H,88H,88H,88H,0A4H,0A4H,0A4H
		DB  9CH,54H,54H,0A8H,0A8H,0A8H,94H,94H,94H,
		DB  8CH,88H,74H,64H,64H,8CH,88H,74H,54H,54H
		DB	8CH,84H,84H,98H,68H,74H,84H,84H,74H,7CH

QIJI:   DB	62H,72H,84H,84H,84H,0A2H,0A2H,0A2H
		DB  96H,52H,52H,0A4H,0A4H,0A4H,92H,92H,92H
		DB  86H,84H,72H,62H,62H,86H,84H,72H,52H,52H
		DB	86H,82H,82H,94H,64H,72H,82H,82H,72H,76H



END1:
END