#include <math.h>
#include <stdio.h>

extern float asm_atan(float x);

int main() {
	for(float i = 0.08; i < 4; i += 0.001) {
		printf("atan(%f): %f\n", i, atan(i));
		printf("asm (%f): %f\n\n", i, asm_atan(i));
	}
	return 0;
}
