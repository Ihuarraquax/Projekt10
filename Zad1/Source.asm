.386
.MODEL FLAT, STDCALL

include grafika.inc

ExitProcess			PROTO :DWORD
SetDlgItemTextA		PROTO :DWORD,:DWORD, :DWORD
SetDlgItemInt		PROTO :DWORD,:DWORD, :DWORD, :DWORD
SendDlgItemMessageA	PROTO :DWORD,:DWORD, :DWORD, :DWORD, :DWORD

.DATA

	hinst	DWORD	0
	hicon	DWORD	0
	hcur 	DWORD	0
	hmenu	DWORD	0
	hfile	DWORD	0

nread	DWORD	0

	
	tdlg1	BYTE		"DLG1",0
	ALIGN 4
	tmenu	BYTE		"MENU1",0
	ALIGN 4
	tOK	      BYTE		"OK",0
	ALIGN 4
	terr 	BYTE		32 dup(0)	; bufor komunikatu
	tnagl	BYTE		32 dup(0)	; bufor nag³ówka
	buffor	BYTE		32 dup(0)
	empty	BYTE		32 dup(0)
	wiadomosc	BYTE		32 dup(0)
	dataWritten	BYTE		32 dup(0)
	nBuff	BYTE		32 dup(0)
	path byte "C:\Users\Hubii\Desktop\NP\NISKOPOZIOMOWE-master\NISKOPOZIOMOWE-master\Lab10\Zad1\dane.txt",0



.CODE

WndProc PROC uses EBX ESI EDI windowHandle:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD

	.IF uMSG ==  WM_INITDIALOG
		jmp	wmINITDIALOG
	.ENDIF

	.IF uMSG ==  WM_CLOSE
		jmp	wmCLOSE
	.ENDIF

	.IF uMSG ==  WM_COMMAND
		jmp	wmCOMMAND
	.ENDIF

	.IF uMSG ==  WM_MOUSEMOVE
		jmp	wmMOUSEMOVE
	.ENDIF

	 mov	EAX, 0
	 jmp	konWNDPROC 

	wmINITDIALOG:
		;zmodyfikuj ikone aplikacji tutaj

		INVOKE LoadIcon , hinst , 11
        mov hicon ,EAX
		INVOKE SendMessageA , windowHandle , WM_SETICON , ICON_SMALL , hicon

		INVOKE LoadCursorA,hinst,12
		mov hcur,EAX

		INVOKE LoadMenu,hinst,OFFSET tmenu
		mov hmenu,EAX
		INVOKE SetMenu, windowHandle, hmenu 

		INVOKE LoadString, hinst,1,OFFSET buffor,32 
		INVOKE LoadString, hinst,3,OFFSET wiadomosc,32 
		INVOKE LoadString, hinst,4,OFFSET empty,32 


		;-------------- przyklady jak mozna wysylac wiadomosc imiedzy oknami
		INVOKE SetDlgItemTextA, windowHandle, 2, offset wiadomosc			;wyslanie textu
		;INVOKE SetDlgItemInt, windowHandle, 1, -10, 1					;wyslanie inta
		
		INVOKE SendDlgItemMessageA, windowHandle, 1, WM_GETTEXT, 32, offset buffor



		mov EAX, 1
		jmp	konWNDPROC 

	wmCLOSE:
		INVOKE DestroyMenu,hmenu
		INVOKE EndDialog, windowHandle, 0	
		 
		 mov EAX, 1
		jmp	konWNDPROC

	wmCOMMAND: 
		.IF wParam ==  105 ;identyfikator kliknietego elementu nadany mu w pliku zasobow tutaj to button "START"
			INVOKE MessageBoxA,0,OFFSET tOK,OFFSET tnagl,0

			mov EAX, 1
			jmp	konWNDPROC
		.ENDIF

		.IF wParam ==  150
			jmp wmCLOSE

			mov EAX, 1
			jmp	konWNDPROC
		.ENDIF

		.IF wParam ==  102 
			INVOKE SetDlgItemTextA, windowHandle, 2, offset empty
			INVOKE SetDlgItemTextA, windowHandle, 1, offset empty
			mov EAX, 1
			jmp	konWNDPROC
		.ENDIF

	wmKOPIUJ: 
		.IF wParam ==  107 ;identyfikator kliknietego elementu nadany mu w pliku zasobow tutaj to button "START"
			INVOKE SendDlgItemMessageA, windowHandle, 1, WM_GETTEXT, 32, offset buffor
			INVOKE SetDlgItemTextA, windowHandle, 2, offset buffor

			mov EAX, 1
			jmp	konWNDPROC
		.ENDIF


	wmSAVE:
		.IF wParam ==  151 ;identyfikator kliknietego elementu nadany mu w pliku zasobow tutaj to button "START"
			INVOKE GetCurrentDirectoryA , nBuff , OFFSET buffor			
			INVOKE CreateFileA , OFFSET path , GENERIC_READ OR GENERIC_WRITE, 0 , 0 ,CREATE_ALWAYS, 0 , 0
			
			mov hfile, EAX

			INVOKE SendDlgItemMessageA, windowHandle, 2, WM_GETTEXT, 32, offset buffor
			INVOKE WriteFile , hfile , OFFSET buffor , 32 , OFFSET dataWritten , 0

			mov EAX, 1
			jmp	konWNDPROC
		.ENDIF

	


	wmMOUSEMOVE:
		INVOKE SetCursor,hcur
		
		mov EAX, 1
		jmp	konWNDPROC


	konWNDPROC:	
		ret

WndProc	ENDP


main PROC

	INVOKE GetModuleHandleA, 0
	mov	hinst, EAX
	
	INVOKE DialogBoxParamA, hinst,OFFSET tdlg1, 0, OFFSET WndProc, 0
	;tworzenie okna dialogowego

	.IF EAX == 0
			jmp	etkon
	.ENDIF

	.IF EAX == -1
		jmp	err0
	.ENDIF	

	err0:
		INVOKE LoadString, hinst,2,OFFSET terr,32
		INVOKE MessageBoxA,0,OFFSET terr,OFFSET tnagl,0

	etkon:

	INVOKE ExitProcess, 0

main ENDP

END