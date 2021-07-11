#include <stdio.h>
// #include <string.h>
// #include <stdlib.h>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
// #include <cuda.h>
// #include <cuda_runtime.h>

// (char* T, char* BWT, int* SA, int n) {
__global__ void test(char *A, char *B, int *C,int n) {
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	if (i >= n) return;
    B[i] = C[i] == 0 ? '$' : A[C[i] - 1];
}

int main () {
    int n = 12;
	thrust::host_vector<char> h_A(n);
	thrust::device_vector<char> d_A;

    char *T = (char *)malloc((n + 1) * sizeof(char));
    for (int i = 0; i < n; i++) {
        T[i] = "mississippi$"[i];
    }

    int SA_tmp[] = {11,10,7,4,1,0,9,8,6,3,5,2};
    int *SA = (int *)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) {
        SA[i] = SA_tmp[i];
    }

	d_A = h_A;

    dim3 block(32, 1);
    dim3 grid((n + block.x - 1) / block.x, 1);
	char *pd_A = thrust::raw_pointer_cast(&d_A[0]);

	test<<< grid, block >>>(T, pd_A, SA, n);

    h_A = d_A;

    for (int i = 0; i < n; i++) {
        printf("%c ", h_A[i]);
    }

}