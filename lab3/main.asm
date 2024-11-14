.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC

public _main

.data	
	znaki db 8 dup (?) ;uzywane przy wyswietl
	obszar db 12 dup (?) ;uzywane przy wczytaj
	dziesiec dd 10 ; uzywane przy wczytaj
	answer db 100 dup (?)
	dwanascie dd 12 
	dzielna dd 0
	przerwa dd 0
	dzielnik dd 0
	

.code

_wyswietl_EAX PROC
	pusha

		mov esi, 10 ; indeks w tablicy 'znaki'
		mov ebx, 10 ; dzielnik r�wny 10
		konwersja:
			mov edx, 0 ; zerowanie starszej cz�ci dzielnej
			div ebx ; dzielenie przez 10, reszta w EDX, iloraz w EAX
			add dl, 30H ; zamiana reszty z dzielenia na kod ASCII
			mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
			dec esi ; zmniejszenie indeksu
			cmp eax, 0 ; sprawdzenie czy iloraz = 0
		jne konwersja ; skok, gdy iloraz niezerowy
		; wype�nienie pozosta�ych bajt�w spacjami i wpisanie
		; znak�w nowego wiersza
		wypeln:
			or esi, esi
			jz wyswietl ; skok, gdy ESI = 0
				mov byte PTR znaki [esi], 20H ; kod spacji
				dec esi ; zmniejszenie indeksu
		jmp wypeln
		wyswietl:
			mov byte PTR znaki [0], 0AH ; kod nowego wiersza
			mov byte PTR znaki [11], 0AH ; kod nowego wiersza
			; wy�wietlenie cyfr na ekranie
			push dword PTR 12 ; liczba wy�wietlanych znak�w
			push dword PTR OFFSET znaki ; adres wy�w. obszaru
			push dword PTR 1; numer urz�dzenia (ekran ma numer 1)
			call __write ; wy�wietlenie liczby na ekranie
			add esp, 12 ; usuni�cie parametr�w ze stosu

	popa
	ret
_wyswietl_EAX ENDP

_wczytaj_do_EAX PROC
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp

		push dword PTR 12 ; max ilo�� znak�w wczytywanej liczby
		push dword PTR OFFSET obszar ; adres obszaru pami�ci
		push dword PTR 0; numer urz�dzenia (0 dla klawiatury)
		call __read ; odczytywanie znak�w z klawiatury
		add esp, 12 ; usuni�cie parametr�w ze stosu
		mov eax, 0 	; bie��ca warto�� przekszta�canej liczby przechowywana jest w rejestrze EAX; przyjmujemy 0 jako warto�� pocz�tkow�
		mov ebx, OFFSET obszar ; adres obszaru ze znakami
		pobieraj_znaki:
			mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie ASCII
			inc ebx ; zwi�kszenie indeksu
			cmp cl,10 ; sprawdzenie czy naci�ni�to Enter
			je byl_enter ; skok, gdy naci�ni�to Enter
				sub cl, 30H ; zamiana kodu ASCII na warto�� cyfry
				movzx ecx, cl ; przechowanie warto�ci cyfry w rejestrze ECX		
				mul dword PTR dziesiec ; mno�enie wcze�niej obliczonej warto�ci razy 10
				add eax, ecx ; dodanie ostatnio odczytanej cyfry
				jmp pobieraj_znaki ; skok na pocz�tek p�tli
		byl_enter:
		; warto�� binarna wprowadzonej liczby znajduje si� teraz w rejestrze EAX

	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
_wczytaj_do_EAX ENDP

wyswietl_eax_precision_cl PROC
	pusha

		mov esi, 7 ; indeks w tablicy 'znaki'
		mov ebx, 10 ; dzielnik r�wny 10
		konwersja:
			mov edx, 0 ; zerowanie starszej cz�ci dzielnej
			div ebx ; dzielenie przez 10, reszta w EDX, iloraz w EAX
			add dl, 30H ; zamiana reszty z dzielenia na kod ASCII
			mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
			dec esi ; zmniejszenie indeksu
			cmp eax, 0 ; sprawdzenie czy iloraz = 0
		jne konwersja ; skok, gdy iloraz niezerowy
		; wype�nienie pozosta�ych bajt�w spacjami i wpisanie
		; znak�w nowego wiersza
		wypeln:
			or esi, esi
			jz wyswietl ; skok, gdy ESI = 0
				mov byte PTR znaki [esi], 20H ; kod spacji
				dec esi ; zmniejszenie indeksu
		jmp wypeln
		wyswietl:
			;iloscia cyfr po prawej jest cl
			mov edi, 7
			xor esi, esi
			next_sign:
				mov dl, znaki[edi]
				cmp dl, 20h
				jne normal_change_one
					mov answer[edi],'0'
					jmp changed_on_zero
				normal_change_one:
				cmp dl, 0
				jne normal_change_two
					mov answer[edi], '0'
					jmp changed_on_zero
				normal_change_two:
				
				mov answer[edi], dl
				changed_on_zero:
				dec edi
			dec cl
			jnz next_sign
			mov answer[edi], '.' ;dodanie kropki
			
			mov esi, edi ; w esi zapamietujemy stary indeks edi (bez uwzglednienia kropki)
			dec edi ;odjecie edi bo kropke dodalismy
			
		
			next_sign_after_dot:
				mov dl, znaki[esi]
				mov answer[edi], dl
				dec edi
				dec esi
			cmp znaki[esi], 20h
			jne next_sign_after_dot
				
			inc edi ;dodajemy do edi jeden, zeby sprawdzic czy jest cyfra njabardizej po lewej
			cmp answer[edi], 20h
			jne finish_converting
				mov answer[edi], '0'
			finish_converting:
			; wy�wietlenie cyfr na ekranie
			push dword PTR 12 ; liczba wy�wietlanych znak�w
			push dword PTR OFFSET answer ; adres wy�w. obszaru
			push dword PTR 1; numer urz�dzenia (ekran ma numer 1)
			call __write ; wy�wietlenie liczby na ekranie
			add esp, 12 ; usuni�cie parametr�w ze stosu

	popa
	ret
wyswietl_eax_precision_cl ENDP

wczytaj_eax_b12 PROC
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp

		push dword PTR 12 ; max ilo�� znak�w wczytywanej liczby
		push dword PTR OFFSET obszar ; adres obszaru pami�ci
		push dword PTR 0; numer urz�dzenia (0 dla klawiatury)
		call __read ; odczytywanie znak�w z klawiatury
		add esp, 12 ; usuni�cie parametr�w ze stosu
		mov eax, 0 	; bie��ca warto�� przekszta�canej liczby przechowywana jest w rejestrze EAX; przyjmujemy 0 jako warto�� pocz�tkow�
		mov ebx, OFFSET obszar ; adres obszaru ze znakami
		pobieraj_znaki:
			mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie ASCII
			inc ebx ; zwi�kszenie indeksu
			cmp cl,10 ; sprawdzenie czy naci�ni�to Enter
			je byl_enter ; skok, gdy naci�ni�to Enter

				cmp cl, 'A'
				jne not_big_a
					mov cl, 10
					jmp b12_after_conversion
				not_big_a:
				cmp cl, 'a'
				jne not_a
					mov cl, 10
					jmp b12_after_conversion
				not_a:
				cmp cl, 'b'
				jne not_b
					mov cl, 11
					jmp b12_after_conversion
				not_b:
				cmp cl, 'B'
				jne not_big_b
					mov cl, 11
					jmp b12_after_conversion
				not_big_b:
				sub cl, 30H ; zamiana kodu ASCII na warto�� cyfry
				b12_after_conversion:
				movzx ecx, cl ; przechowanie warto�ci cyfry w rejestrze ECX		
				mul dword PTR dwanascie ; mno�enie wcze�niej obliczonej warto�ci razy 10
				add eax, ecx ; dodanie ostatnio odczytanej cyfry
				jmp pobieraj_znaki ; skok na pocz�tek p�tli
		byl_enter:
		; warto�� binarna wprowadzonej liczby znajduje si� teraz w rejestrze EAX

	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
wczytaj_eax_b12 ENDP


_main PROC

	;call _wczytaj_do_EAX
	
	;mov eax, 10
	mov cl,3
	;call wyswietl_eax_precision_cl

	call wczytaj_eax_b12
	mov [dzielna], eax

	call wczytaj_eax_b12
	mov [dzielnik], eax

	mov edx, 0
	mov eax, [dzielna]
	mov ebx, 1000
	mul ebx
	xor ecx, ecx
	mov esi, [dzielnik]
	mov ecx, esi
	div ecx
	mov cl, 3
	call wyswietl_eax_precision_cl


	push 0
	call _ExitProcess@4 ; zako�czenie programu
 _main ENDP
END