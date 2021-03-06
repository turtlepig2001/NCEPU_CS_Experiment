DATAS SEGMENT
    namepar   label    byte
	maxnlen   db     21
	actnlen   db     ?;实际输入个数
	_name     db     21 dup(?)  

	phonepar  label    byte
	maxplen   db     9
	actplen   db     ?
	_phone    db     9 dup(?)

	crlf      db     0dh,0ah,'$';换行

	endaddr   dw     ?

	string1   db     'Input name:','$'
	string2   db     'Input a telephone number:','$'
	string3   db     'Do you want a telephone number?(Y/N)','$'
	string4   db     'name?','$'
	string5   db     'name',16 dup(' '),'tel',0dh,0ah,'$'
	string6   db     'Finish search.',0dh,0ah,'$'
	string7   db     'Invalid input!',0dh,0ah,'$'
	
	count     db     0
	tel_tab   db     50 dup(20 dup(' '),8 dup(' '));共可存放50项电话号码项
	temp      db     20 dup(' '),8 dup(' '),0dh,0ah,'$';临时变量
	swapped   db     0

DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS,ES:DATAS
START:
      MOV AX,DATAS
      MOV DS,AX
      mov     es,ax
      lea     di,tel_tab      ;di中存放表首地址
      
inputloop:
      
      lea     dx,string1
      mov     ah,09h
      int     21h          ;'Input name'
      
      call    input_name
      cmp     actnlen,0    ;没有输入人名时
      jz      advice            ;直接跳到提示是否查找的地方
      cmp     count,50     ;输入上限
      je      advice  
      call    store_name    ;保存人名到tel_tab
                      
      mov     ah,09h       ;'Input a telephone number'
      lea     dx,string2
      int     21h      
      call    input_store_phone ;输入并保存电话号码
      jmp     inputloop

advice:
      cmp     count,1
      jbe     sloop ;如果没有输入或者输入一个 
      call    disp_all  ;显示所有

sloop:
      lea     dx,string3
      mov     ah,09h
      int     21h 
      
      mov     ah,01h
      int     21h      
      ;大小写都需要判断
      cmp     al,'N'
      je      exit
      cmp     al,'n'
      je      exit
      cmp     al,'Y'
      je      sname
      cmp     al,'y'
      je      sname
      
      mov     ah,09
      lea     dx,crlf
      int     21h 
      lea     dx,string7 ;非法输入
      mov     ah,09h
      int     21h      
      
      jmp     sloop
      
sname:      
      mov     ah,09
      lea     dx,crlf
      int     21h      
        
      lea     dx,string4 ;当输入Y时,显示'name?'
      mov     ah,09
      int     21h 
      
      call    input_name ;输入要查找的人名
      mov     ah,09h
      lea     dx,string5
      int     21h
      call    name_search ;查找
	  call    sprint
      jmp     sloop     
exit:
      MOV AH,4CH
      INT 21H 


input_name    proc    near      ;接受人名
      mov     ah,0ah
      lea     dx,namepar
      int     21h
      mov     ah,02h
      mov     dl,0ah ;换行
      int     21h
      
      mov     bh,0
      mov     bl,actnlen
      mov     cx,21
      sub     cx,bx
n:	;满足长度则不循环 
      mov     _name[bx],20h
      inc     bx
      loop    n
      ret
input_name endp            


store_name  proc    near		;存人名
      inc     count
      cld     
      lea     si,_name
      mov     cx,20        ;把name中的前20个字符放入tel_tab中每一个人信息的前20个byte中
      rep     movsb
      ret
store_name  endp   

                  
input_store_phone  proc  near	;接收存入电话号码本中
      
      mov     ah,0ah
      lea     dx,phonepar
      int     21h      
      mov     ah,02h
      mov     dl,0ah ;换行
      int     21h
      
      mov     bh,0
      mov     bl,actplen
      mov     cx,9
      sub     cx,bx ;计算剩下的长度

s:
      mov     _phone[bx],20h ;剩下的地方填充空格
      inc     bx
      loop    s
         
      cld     
      lea     si,_phone
      mov     cx,8      ;把phone中的前8个字符放入tel_tab中每一个人信息的后8个byte中
      rep     movsb    
      ret
input_store_phone endp         

disp_all  proc    near
      mov     ah,09h
      lea     dx,string5
      int     21h
      lea     si,tel_tab
n1:
      lea     di,temp
      mov     cx,14
      rep     movsw
      mov     ah,09h
      lea     dx,temp
      int     21h
      dec     count
      jnz     n1
      ret     
      
disp_all  endp     


name_search proc    near            
      lea     si,tel_tab
      mov     bx,si
      add     endaddr,28
n1:           
      lea     di,_name     ;存放待查找的人名地址
      mov     cx,10
      repe    cmpsw
      jcxz    nase_exit    ;相等
n2:      
      add     bx,28        ;表中下一个比较的人名
      mov     si,bx
      cmp     si,endaddr
      jbe     n1
      ja      notintab
notintab: 
      mov     cx,-1
      ret
nase_exit: 
      mov     si,bx
      lea     di,temp
      mov     cx,14
      rep     movsw
      call    sprint
      jmp     n2
      ret                  
name_search endp  


sprint  proc    near
      cmp     cx,-1
      je      n
      
      mov     ah,09h
      lea     dx,temp     
      int     21h
      ret
n:
      mov     ah,09h
      lea     dx,string6
      int     21h           
      ret
sprint  endp         
CODES ENDS
    END START










