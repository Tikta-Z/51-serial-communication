ORG 0000H
		LJMP START	
ORG 0003H
		LJMP K2
ORG 0013H
		LJMP K3
ORG 0023H
		LJMP SEND
ORG 0030H
START:	MOV SCON,#40H	;���ô��пڹ�����ʽ1
		SETB IT1        ;�����ⲿ�ж�1�½��ش���
		SETB IT0        ;�����ⲿ�ж�0�½��ش���
		MOV PCON,#00H	;SMODΪ0�������ʲ��ӱ�
		MOV TMOD,#20H	;��ʱ��������ʽ2
		MOV TH1,#0FDH	;����ʳ�ֵ
		MOV TL1,#0FDH	
		SETB EA			;������
		SETB EX1		;�ⲿ�ж�1����
		SETB EX0		;�ⲿ�ж�0����
		SJMP $
			
K3:		SETB ES			;���п�����
		SETB TR1		;����ʱ��1
		MOV A,#0F9H
		MOV SBUF,A
		RETI
		
K2:		SETB ES			;���п�����
		SETB TR1		;����ʱ��1
		MOV A,#0E7H
		MOV SBUF,A
		RETI

SEND:	CLR TI
		MOV SBUF,A
		JNZ RETEN			;AΪ0��رշ��ͳ���
		CLR TR1
		CLR ES
RETEN:	RETI
		
		
		END