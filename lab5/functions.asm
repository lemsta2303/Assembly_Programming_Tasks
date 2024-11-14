.686
.model flat
.XMM
public _dylatacja_czasu

.data

.code

_dylatacja_czasu PROC
	push ebp ;ebp+8 <- delta_t_zero, ebp+12 <- predkosc
	mov ebp ,esp 
	sub esp, 8
	push ebx
	push esi
	push edi
	
		mov dword ptr [ebp-4], 300000000 ; c
		mov dword ptr [ebp-8], 1 ;jedynka potrezbna w mianowniku
		finit
		fld dword ptr [ebp+12]
		fld dword ptr [ebp+12] ; st(0) = st(1) = predkosc
		fmulp ; st(0) = predkosc^2
		fild dword ptr [ebp-4]
		fild dword ptr [ebp-4] ; st(0) = st(1) = c
		fmulp ; st(0) = c^2, st(1) = predkosc^2
		fdivp ; st(0) = (predkosc^2)/(c^2)
		fild dword ptr [ebp-8] ; st(0) = 1 , st(1) = (predkosc^2)/c^2
		fxch ; st(0) = (predkosc^2)/(c^2), st(1) = 1
		fsubp ; st(0) = 1 - (predkosc^2)/(c^2)
		fsqrt ; st(0) = sqrt(1 - (predkosc^2)/(c^2))

		fild dword ptr [ebp+8] ; st(0) = delta_t_zero, st(1) = sqrt(1 - (predkosc^2)/(c^2))
		fxch 
		fdivp

	
	pop edi
	pop esi
	pop ebx
	add esp, 8
	pop ebp
	
	ret
_dylatacja_czasu ENDP

_szybki_max PROC
	push ebp
	 mov ebp, esp
	 push ebx
	 push esi
	 push edi



		 mov esi, [ebp+8] ; adres pierwszej tablicy
		 mov edi, [ebp+12] ; adres drugiej tablicy
		 mov ebx, [ebp+16]; adres tablicy z wynikiem
		 mov edx, [ebp+20] ; n
		; ³adowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
		; kowych 32-bitowych - liczby zostaj¹ pobrane z tablicy,
		; której adres poczatkowy podany jest w rejestrze ESI
		; interpretacja mnemonika "movups" :
		; mov - operacja przes³ania,
		; u - unaligned (adres obszaru nie jest podzielny przez 16),
		; p - packed (do rejestru ³adowane s¹ od razu cztery liczby),
		; s - short (inaczej float, liczby zmiennoprzecinkowe
		; 32-bitowe)
		
		 
		 mov eax, 0
		 next_eight_numbers:
			 movups xmm5, [esi]
			 movups xmm6, [edi]
			 PMAXSW xmm5, xmm6
			; zapisanie wyniku sumowania w tablicy w pamiêci
			 movups [ebx], xmm5
			 add esi, 16
			 add edi, 16
			 add ebx, 16
			

		 add eax, 8
		 cmp eax, edx
		 jb next_eight_numbers




	 pop edi
	 pop esi
	 pop ebx
	 pop ebp
	 ret
_szybki_max ENDP

END