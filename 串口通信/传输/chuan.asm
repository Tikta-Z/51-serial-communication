ORG 0000H
		LJMP START	
ORG 0003H
		LJMP K2
ORG 0013H
		LJMP K3
ORG 0023H
		LJMP SEND
ORG 0030H
START:	MOV SCON,#40H	;设置串行口工作方式1
		SETB IT1        ;设置外部中断1下降沿触发
		SETB IT0        ;设置外部中断0下降沿触发
		MOV PCON,#00H	;SMOD为0，波特率不加倍
		MOV TMOD,#20H	;定时器工作方式2
		MOV TH1,#0FDH	;溢出率初值
		MOV TL1,#0FDH	
		SETB EA			;总允许
		SETB EX1		;外部中断1允许
		SETB EX0		;外部中断0允许
		SJMP $
			
K3:		SETB ES			;串行口允许
		SETB TR1		;开定时器1
		MOV A,#0F9H
		MOV SBUF,A
		RETI
		
K2:		SETB ES			;串行口允许
		SETB TR1		;开定时器1
		MOV A,#0E7H
		MOV SBUF,A
		RETI

SEND:	CLR TI
		MOV SBUF,A
		JNZ RETEN			;A为0则关闭发送程序
		CLR TR1
		CLR ES
RETEN:	RETI
		
		
		END