.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC 
extern __read : PROC 
extern _MessageBoxA@16 : PROC 
extern _MessageBoxW@16 : PROC

public _main
.data
	magazyn db 'kot, g',234 ,182 ,  ', pies i g',234 ,182
	koniec_magazynu db ?
	dlugosc_magazynu dd ?
	answer_utf dw 80 dup (?)
	final_answer dw 80 dup (?)

.code
_main PROC
	mov eax, offset koniec_magazynu - offset magazyn
	mov dlugosc_magazynu, eax


	xor ebx, ebx
	xor esi, esi ;to bedzie inedks magazynu
	xor edi, edi ;indeks odpoweidzi
	next_letter:
		mov bl, magazyn[esi]
		cmp bl, 128
		jae not_standard_ascii
			mov bh, 0
			
		not_standard_ascii:

		;podmiana dla wszystkich polskich znakow
		cmp bl, 177
		jne one
			mov bx, 0105h
		one:

		cmp bl, 230
		jne two
			mov bx, 0107h
		two:

		cmp bl, 234
		jne three
			mov bx, 0119h
		three:

		cmp bl, 179
		jne four
			mov bx, 142h
		four:

		cmp bl, 241
		jne five
			mov bx, 144h
		five:

		cmp bl, 243
		jne six
			mov bx, 00F3h
		six:

		cmp bl, 182
		jne seven
			mov bx, 15Bh
		seven:

		cmp bl, 188
		jne eight
			mov bx, 17Ah
		eight:

		cmp bl, 191
		jne nine
			mov bx, 17Ch
		nine:

		mov answer_utf[edi], bx
	add edi,2
	inc esi
	cmp esi,dlugosc_magazynu
	jb next_letter


	;zamiana ci¹u znaku 'gêœ' na emotikone gêœi ( 0xD83E 0xDD86 )
	add eax, dlugosc_magazynu
	;add eax, dlugosc_magazynu
	mov dlugosc_magazynu, eax ;podwojenie dlugosci magazynu, bo teraz w utf kazda litera ma 2 bajty

	xor esi, esi ; indeks bufora
	xor edi, edi ; indeks ostatecznej odpowiedzi

	next_sign:
		cmp answer_utf[esi], 'g'
		jne not_ges

		cmp answer_utf[esi+2], 0119h ;ê
		jne not_ges

		cmp answer_utf[esi+4], 015Bh ;œ
		jne not_ges

		;wykryto ges
		mov final_answer[edi], 0D83Eh
		mov final_answer[edi+2], 0DD86h
		add edi, 4
		add esi, 4
		jmp skip_adding_normal_letter

		not_ges:

		mov cx, answer_utf[esi]
		add final_answer[edi], cx
		add edi, 2

		skip_adding_normal_letter:

	add esi,2
	cmp esi, dlugosc_magazynu
	jb next_sign




	
 push 0
 push OFFSET final_answer
 push OFFSET final_answer
 push 0
 call _MessageBoxW@16
 add esp,16



 push 0
 call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END