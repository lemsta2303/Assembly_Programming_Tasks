.686 
.model flat

public fibonacci

.code

fibonacci PROC c,  liczba_k:dword
    ;prolog dzieje sie auitomattycznie dzieki PROC c
    sub esp,0 ; miejsce na zmienne lokalne
    push ebx ;pushowanie rejestrow
    push esi
    push edi
        mov eax, -1
        cmp liczba_k, 47
        ja end_function

        mov eax, 0
        cmp liczba_k, 0
        je end_function

        mov eax, 1
        cmp liczba_k, 1
        je end_function

        mov eax, 1
        cmp liczba_k, 2
        je end_function

        xor eax, eax
        ;tu co sie dzieje dla k > 2

        mov esi, dword ptr liczba_k
        dec esi
        push esi
        call fibonacci
        add esp, 4

       
        mov edi, eax

        mov esi, dword ptr liczba_k
        sub esi ,2
        push esi
        call fibonacci
        add esp, 4

        add edi, eax
           
       

        mov eax, edi
        end_function:
    pop edi ;odtwarzanie rejestrow ze stosu
    pop esi
    pop ebx
    add esp,0 ;usuwanie zmiennych lokalnych
    ret
fibonacci ENDP

END