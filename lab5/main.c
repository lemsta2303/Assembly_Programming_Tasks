#include <stdio.h>
float dylatacja_czasu(unsigned int delta_t_zero, float predkosc);
void szybki_max(short int t_1[], short int t_2[], short int t_wynik[], int n);

int main() {

	/*float wynik1 = dylatacja_czasu(10, 10000.0f); // wynik = 10.00000
		float wynik2 = dylatacja_czasu(10, 200000000.0f); // wynik = 13.41641
		float wynik3 = dylatacja_czasu(60, 270000000.0f); // wynik = 137.64944

		printf("wynik: %f\n", wynik1);
		printf("wynik: %f\n", wynik2);
		printf("wynik: %f\n", wynik3);*/
		
	short int val1[16] = { 1, -1, 2, -2, 3, -3, 4, -4, 5, -5, 6, -6, 7, -7, -8, 8 };

	short int val2[16] = { -3, -2, -1, 0, 1, 2, 3, 4, 256, -256, 257, -257, 258, -258, 0, 0 };

	short int wynik[16];

	szybki_max(val1, val2, wynik, 16); // -> wynik = {1, -1, 2, 0, 3, 2, 4, 4, 256, -5, 257, -6, 258, -7, 0, 8}

	for (int i = 0; i < 16; i++) {
		printf("%hd ", wynik[i]);
	}
	return 0;
}