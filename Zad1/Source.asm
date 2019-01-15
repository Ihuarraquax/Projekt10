.386
.MODEL FLAT, STDCALL


include grafika.inc



 

.DATA

dlugoscSciezki DD ?
sciezka DD 100 dup(0)
nazwaPliku DB "\liczby.txt" , 0 
hliczbytxt DD ?
liczbytxtrozmiar DD ?

odczytzplikuRozmiar DD ?
odczytzpliku DB 100 dup(?)
tablica DW 100 dup(?)

 


.CODE



main PROC
		
	INVOKE GetCurrentDirectoryA , 0 , 0			;okreslenie dlugosci sciezki
	INVOKE GetCurrentDirectoryA , EAX , OFFSET sciezka  ;pobranie aktualnej sciezki

	INVOKE lstrcatA, OFFSET sciezka, OFFSET nazwaPliku ;nazwa pliku to sciezki

	INVOKE CreateFileA, OFFSET sciezka, GENERIC_READ or GENERIC_WRITE,0 ,0, OPEN_EXISTING,0,0  ;uchwyt do pliku
	MOV hliczbytxt, EAX

	INVOKE SetFilePointer, hliczbytxt, 0 , 0, FILE_END ; sprawdzenie wielkosci pliku
	MOV liczbytxtrozmiar,EAX
	INVOKE SetFilePointer, hliczbytxt, 0 , 0, FILE_BEGIN

	INVOKE ReadFile, hliczbytxt, OFFSET odczytzpliku, liczbytxtrozmiar, OFFSET odczytzplikuRozmiar, 0
	
	INVOKE atoi, offset odczytzpliku

	







	invoke ExitProcess, 0

main ENDP



atoi proc uses esi edx inputBuffAddr:DWORD
	mov esi, inputBuffAddr
	xor edx, edx
	xor EAX, EAX
	mov AL, BYTE PTR [esi]
	cmp eax, 2dh
	je parseNegative

	.Repeat
		lodsb
		.Break .if !eax
		imul edx, edx, 10
		sub eax, "0"
		add edx, eax
	.Until 0
	mov EAX, EDX
	jmp endatoi

	parseNegative:
	inc esi
	.Repeat
		lodsb
		.Break .if !eax
		imul edx, edx, 10
		sub eax, "0"
		add edx, eax
	.Until 0

	xor EAX,EAX
	sub EAX, EDX
	jmp endatoi

	endatoi:
	ret
atoi endp

END