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
t:	mov es:[bx],al		;用空格清屏
	inc bx
	loop t
	mov ax,data
	mov ds,ax
;======== show year ================
	mov si,0
	mov cx,21
	mov dx,0101h	;dh=1,dl=1从第一行一列开始
datayear:
	push cx
	push dx
	mov cx,0402h
	mov dl,1
	call show_strcx
	pop dx
	inc dh		;行增加
	pop cx
	loop datayear
;======== show sum =============
	mov di,350		;指向data段最后的地址
	mov cx,21	
datasum:
	push cx
	mov ax,[si]		; 低位
	mov dx,[si+2]	; 高位
	dec di		;先将di减1,使最后为0
	call lcall
	add si,4
	pop cx
	loop datasum
	
	inc di
	mov si,di	;传递已转换的ASCII码首址
	mov cx,21
lshowsum:
	push cx
	mov dh,cl	;行
	mov dl,8	;列
	mov cl,2	;颜色属性
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
	
	inc di		;指向第一个数
	mov si,di
	mov cx,21
lshowshouru:
	push cx		;cx入栈
	mov dh,cl	;行显示
	mov dl,30	;列显示
	mov cl,2
	call show_str
	inc si
	pop cx		;cx出栈
	jcxz oklshowshouru
	dec cx
	jmp short lshowshouru
oklshowshouru:

	mov ax,4c00h
	int 21h
;======================
lcall:
	mov cx,10	;除数设为10
	call divdw
	add cl,30h	;转换成ASCII码
	mov [di],cl
	mov cx,ax	;确认商为0
	or cx,dx
	dec di
	jcxz oklcall
	jmp short lcall
oklcall:	
	ret

divdw:
	; 参数:ax低16位,dx高16位,cx除数16位
	; 结果:ax低16位,dx高16位,cx余数
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
	; ds指向字符串首址,si寻址
	; es指向ASCII码地址,di寻址
	; dh行号，dl列号，cl颜色
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
	; ds指向字符串首址
	; dh行号，dl列号，cl颜色
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

cleardata:		;清除用过的内存
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


