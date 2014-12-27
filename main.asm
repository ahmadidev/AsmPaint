TITLE 'Paint program'

.MODEL SMALL

.DATA
COLOR DB 0CDH	; متغییر رنگ

.CODE

MAIN PROC
	CALL INIT	; تابع شروع برنامه
	
	; شروع حالت گرافیکی
	MOV AH, 0	; عدد 0 برای حالت گرافیکی
	MOV AL, 12H	; حالت 16 رنگ و دقت 640*480
	INT 10H		; وقفه ی عملیات گرافیکی از بایوس
	
	DRAW:		; شروع قسمت ترسیم
	
	; تابع بررسی فشردن کلید Q
	CALL QUIT_IF_Q
	
	; لود کردن مختصات موس
	CALL LOAD_MOUSE
	
	TEST BX, 01B	; مقایسه بیت 0 برای چپ کلیک
	JZ DRAW			; بازگشت به شروع اگر صفر نتیجه صفر بود
	
	CALL PDOT		; فراخوانی تابع روشن کردن پیکسل
	
	JMP DRAW		; پرش به شروع قسمت ترسیم
	
	CALL EXIT		; تابع پایان برنامه
ENDP MAIN

PROC LOAD_MOUSE
	MOV AX, 3	; دریافت مشخصات و مختصات موس
	INT 33H		; وقفه ی مرتبط با توابع موس
	
	RET			; بازگشت به قسمت فراخوانی کرده
ENDP LOAD_MOUSE

PROC QUIT_IF_Q
	MOV AH, 01H	; بررسی فشرده شدن کلید
	INT 16H		; وقفه ی مرتبط با کبورد
	
	; اگر کلیدی فشرده شده باشد
	; رجیستر ZR=0 می شود
	
	JNZ CHECK_KEY	; اگر کلیدی فشرده شده بود برو به بررسی کلید
	RET
	
	; اگر کلید q فشرده شده بود خارج شو از برنامه
	CHECK_KEY:
	MOV AH, 0H	; خواندن کلید فشرده شده
	INT 16H
	
	CMP AL, 'q'	; مقایسه ی کلید فشرده شده با q
	JE EXIT		; اگر یکی بودند، به خروج برو
	
	RET
ENDP QUIT_IF_Q

PROC INIT
	MOV AX, @data	; مقدار دهی اولیه ی سگمنت داده
	MOV DS, AX
	
	RET
ENDP INIT

PROC PDOT
	MOV AH, 0CH		; سرویس نوشتن پیکسل
	MOV BH, 0H		; صفحه ی فعال
	MOV AL, COLOR	; Color
	; CX - محور X که توس موس تعیین شده
	; DX - محور Y که توس موس تعیین شده
	INT 10H			; وقفه ی گرافیکی

	RET
ENDP PDOT

PROC EXIT
	MOV AX, 4C00H	; خروج از برنامه
	INT 21H
ENDP EXIT

END
