.386
.MODEL FLAT, STDCALL


include grafika.inc


.DATA

dlugoscSciezki DD ?
sciezka DD 100 dup(0)
sciezkaSorted DD 100 dup(0)
nazwaPliku DB "\liczby.txt" , 0 
nazwaPlikuSorted DB "\sorted.txt" , 0 
hliczbytxt DD ?
hsortedtxt DD ?
liczbytxtrozmiar DD ?
iloscLiczb Dd 1
pointer DD ?
value DD 0
pomOffset DD ?
uselessInfo DD ?

adresyLiczbZOdczytZpliku DD 100 dup(?)
odczytzplikuRozmiar DD ?
odczytzpliku DD 100 dup(?)
nums DD 255,2,3,4,142,242,4,0,13,2
tablica DD 100 dup(?)
wzor db "%i ",0

nrQsortA PROTO :DWORD,:DWORD

.CODE
compare proc C p1:DWORD, p2:DWORD
    mov eax, p1
    mov edx, p2
    mov eax, [eax]
    mov edx, [edx]
    sub eax, edx
    ret
compare endp


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
	
	;; zamiana kodu spacji na 0 w odczycie
	mov EBX, OFFSET odczytzpliku
	mov EDX, OFFSET adresyLiczbZOdczytZpliku
	mov ECX, 00
	MOV [EDX], EBX
	ADD EDX,4
	.WHILE ECX <= liczbytxtrozmiar
		
		.IF BYTE PTR [EBX] == 20h
			MOV [EBX],BYTE PTR 0
			MOV [EDX], EBX
			ADD [EDX], BYTE PTR 1
			ADD EDX, 4
			ADD iloscLiczb,1
		.ENDIF
		
		INC EBX
		INC ECX
	.ENDW

	;; utworze tablice ktora przechowuje adresy nastepnych liczb z odczytzpliku z poprzedniej petli 



	MOV EDX, adresyLiczbZOdczytZpliku
	MOV ECX,0
	MOV EBX,0
	.WHILE ECX < iloscLiczb
		INVOKE atoi, EDX
		MOV tablica[ebx],EAX
		INC ECX
		MOV EDX, adresyLiczbZOdczytZpliku[ECX * 4]
		ADD EBX, 4
	.ENDW
		
	invoke nrQsortA, OFFSET tablica, iloscLiczb
	
	mov pointer, OFFSET odczytzpliku
	mov EBX, offset tablica
	mov ECX, 0
	.WHILE ECX<iloscLiczb
		
		MOV EAX, tablica[ECX*4]
		push ECX
		INVOKE wsprintfA, pointer, offset wzor, EAX
		pop ECX
		ADD pointer, EAX
		INC ECX
	.ENDW



	INVOKE GetCurrentDirectoryA , 0 , 0			;okreslenie dlugosci sciezki
	INVOKE GetCurrentDirectoryA , EAX , OFFSET sciezkaSorted  ;pobranie aktualnej sciezki

	

	INVOKE lstrcatA, OFFSET sciezkaSorted, OFFSET nazwaPlikuSorted ;nazwa pliku to sciezki

	INVOKE CreateFileA, OFFSET sciezkaSorted, GENERIC_READ or GENERIC_WRITE,0 ,0, CREATE_ALWAYS,0,0  ;uchwyt do pliku
	MOV hsortedtxt, EAX

	INVOKE WriteFile, hsortedtxt, offset odczytzpliku, liczbytxtrozmiar, offset uselessInfo, 0


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