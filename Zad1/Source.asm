.386
.MODEL FLAT, STDCALL

include grafika.inc

 

.DATA

dlugoscSciezki DD ?
sciezka DD 100 dup(0)
nazwaPliku DB "\liczby.txt" , 0 
hliczbytxt DD ?
liczbytxtrozmiar DD ?

odczytzpliku DD 100 dup(?)
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

	fread(hliczbytxt, OFFSET tablica,liczbytxtrozmiar)







	invoke ExitProcess, 0

main ENDP

END