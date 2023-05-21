#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#include <shnet/time.h>

float newatan(float x)
{
    if (fabs(x) < 0.08518)
    {
        return x - (x * x * x) / 4.05;
    }
    else
    {
        return M_PI_2 * (1 - 2 * signbit(x)) - (3.75 * x) / (3.75 * x * x + 1);
    }
}

extern float empty_function(float x);
extern float asm_atan(float x);

#define NUM 10000000

int main() {
	uint64_t start, end, overhead;
	double avg, std;


	float* temp_arr = malloc(sizeof(float) * NUM);
	start = time_get_time();
	for(uint64_t i = 0; i < NUM; ++i) {
		temp_arr[i] = empty_function(i);
	}
	end = time_get_time();
	overhead = end - start;
	printf("empty: %lfms\n", (double)(end - start) / time_ms_to_ns(1));
	avg = 0;
	std = 0;
	for(uint64_t i = 0; i < NUM; ++i) {
		avg += temp_arr[i];
	}
	avg /= NUM;
	for(uint64_t i = 0; i < NUM; ++i) {
		std += (temp_arr[i] - avg) * (temp_arr[i] - avg);
	}
	std /= NUM;
	std = sqrt(std);
	printf("avg: %lf\nstd: %lf\n", avg, std);


	float* atan_arr = malloc(sizeof(float) * NUM);
	start = time_get_time();
	for(uint64_t i = 0; i < NUM; ++i) {
		atan_arr[i] = atan(i);
	}
	end = time_get_time() - overhead;
	printf("atan: %lfms\n", (double)(end - start) / time_ms_to_ns(1));
	avg = 0;
	std = 0;
	for(uint64_t i = 0; i < NUM; ++i) {
		avg += atan_arr[i];
	}
	avg /= NUM;
	for(uint64_t i = 0; i < NUM; ++i) {
		std += (atan_arr[i] - avg) * (atan_arr[i] - avg);
	}
	std /= NUM;
	std = sqrt(std);
	printf("avg: %lf\nstd: %lf\n", avg, std);


	float* newatan_arr = malloc(sizeof(float) * NUM);
	start = time_get_time();
	for(uint64_t i = 0; i < NUM; ++i) {
		newatan_arr[i] = newatan(i);
	}
	end = time_get_time() - overhead;
	printf("newatan: %lfms\n", (double)(end - start) / time_ms_to_ns(1));
	avg = 0;
	std = 0;
	for(uint64_t i = 0; i < NUM; ++i) {
		avg += newatan_arr[i];
	}
	avg /= NUM;
	for(uint64_t i = 0; i < NUM; ++i) {
		std += (newatan_arr[i] - avg) * (newatan_arr[i] - avg);
	}
	std /= NUM;
	std = sqrt(std);
	printf("avg: %lf\nstd: %lf\n", avg, std);


	float* asm_atan_arr = malloc(sizeof(float) * NUM);
	start = time_get_time();
	for(uint64_t i = 0; i < NUM; ++i) {
		asm_atan_arr[i] = asm_atan(i);
	}
	end = time_get_time() - overhead;
	printf("asm_atan: %lfms\n", (double)(end - start) / time_ms_to_ns(1));
	avg = 0;
	std = 0;
	for(uint64_t i = 0; i < NUM; ++i) {
		avg += asm_atan_arr[i];
	}
	avg /= NUM;
	for(uint64_t i = 0; i < NUM; ++i) {
		std += (asm_atan_arr[i] - avg) * (asm_atan_arr[i] - avg);
	}
	std /= NUM;
	std = sqrt(std);
	printf("avg: %lf\nstd: %lf\n", avg, std);
}
