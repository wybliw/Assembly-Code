assume cs:code
data segment 
	db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db '1993','1994','1995'
    
    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
    
    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
    dw 11542,11430,15257,17800
	
	db 140 dup (0)
data ends

data1 segment
	db  ' '
data1 ends

code segment
start:  
	mov ax,data1
	mov ds,ax
	mov ax,0b800h
	mov es,ax
	mov bx,160
	mov al,[0]
	mov cx,3360
t:	mov es:[bx],al		;�ÿո�����
	inc bx
	loop t
	mov ax,data
	mov ds,ax
;======== show year ================
	mov si,0
	mov cx,21
	mov dx,0101h	;dh=1,dl=1�ӵ�һ��һ�п�ʼ
datayear:
	push cx
	push dx
	mov cx,0402h
	mov dl,1
	call show_strcx
	pop dx
	inc dh		;������
	pop cx
	loop datayear
;======== show sum =============
	mov di,350		;ָ��data�����ĵ�ַ
	mov cx,21	
datasum:
	push cx
	mov ax,[si]		; ��λ
	mov dx,[si+2]	; ��λ
	dec di		;�Ƚ�di��1,ʹ���Ϊ0
	call lcall
	add si,4
	pop cx
	loop datasum
	
	inc di
	mov si,di	;������ת����ASCII����ַ
	mov cx,21
lshowsum:
	push cx
	mov dh,cl	;��
	mov dl,8	;��
	mov cl,2	;��ɫ����
	call show_str
	inc si
	pop cx
	jcxz oklshowsum
	dec cx
	jmp short lshowsum
oklshowsum:
;========= show men =============	
	call cleardata
	mov di,350
	mov si,168
	mov cx,21
datamen:
	push cx
	mov dx,0
	mov ax,[si]
	dec di
	call lcall
	add si,2
	pop cx
	loop datamen

	inc di
	mov si,di
	mov cx,21
lshowmen:
	push cx
	mov dh,cl
	mov dl,20
	mov cl,2
	call show_str
	inc si
	pop cx
	jcxz oklshowmen
	dec cx
	jmp short lshowmen
oklshowmen:
;========= show shouru =============
	call cleardata
	mov si,84
	mov bp,168
	mov di,350
	mov cx,21
showshouru:
	push cx
	mov ax,[si]
	mov dx,[si+2]
	mov cx,ds:[bp]
	div cx
	mov dx,0
	dec di
	call lcall
	add si,4
	add bp,2
	pop cx
	loop showshouru
	
	inc di		;ָ���һ����
	mov si,di
	mov cx,21
lshowshouru:
	push cx		;cx��ջ
	mov dh,cl	;����ʾ
	mov dl,30	;����ʾ
	mov cl,2
	call show_str
	inc si
	pop cx		;cx��ջ
	jcxz oklshowshouru
	dec cx
	jmp short lshowshouru
oklshowshouru:

	mov ax,4c00h
	int 21h
;======================
lcall:
	mov cx,10	;������Ϊ10
	call divdw
	add cl,30h	;ת����ASCII��
	mov [di],cl
	mov cx,ax	;ȷ����Ϊ0
	or cx,dx
	dec di
	jcxz oklcall
	jmp short lcall
oklcall:	
	ret

divdw:
	; ����:ax��16λ,dx��16λ,cx����16λ
	; ���:ax��16λ,dx��16λ,cx����
	push ax
	mov ax,dx
	mov dx,0
	div cx
	mov bx,ax
	pop ax
	div cx
	mov cx,dx
	mov dx,bx
	ret

show_str:
	; dsָ���ַ�����ַ,siѰַ
	; esָ��ASCII���ַ,diѰַ
	; dh�кţ�dl�кţ�cl��ɫ
	mov ax,0b800h
	mov es,ax
	mov al,160
	mul dh
	mov bx,ax	; row	
	mov ax,2
	mul dl
	sub ax,2
	mov di,ax	; colum
	mov ah,cl
lshow_str:
	mov al,ds:[si]
	mov cx,0
	mov cl,al
	jcxz show_str_ok
	mov es:[bx+di],ax
	inc si
	add di,2
	jmp short lshow_str
show_str_ok:
	ret

show_strcx:
	; dsָ���ַ�����ַ
	; dh�кţ�dl�кţ�cl��ɫ
	mov ax,0b800h
	mov es,ax
	mov al,160
	mul dh
	mov bx,ax	; row	
	mov ax,2
	mul dl
	sub ax,2
	mov di,ax	; colum
	mov ah,cl
	mov cl,ch
	mov cl,0
	mov cx,4
lshow_strcx:
	mov al,ds:[si]
	mov es:[bx+di],ax
	inc si
	add di,2
	loop lshow_strcx
	ret

cleardata:		;����ù����ڴ�
	mov di,210
	mov cx,70
	mov ax,0
cleard:
	mov [di],ax
	add di,2
	loop cleard
	ret

code ends
end start


