#include <stdio.h>
#include <string.h>
// #include <stdlib.h>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <cuda.h>
#include <cuda_runtime.h>

// (char* T, char* BWT, int* SA, int n) {
__global__ void test(char *A, char *B, int *C,int n) {
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	if (i >= n) return;
    B[i] = C[i] == 0 ? '$' : A[C[i] - 1];
    // B[index] = A[index] == '0' ? '$' : A[index];
}

int main () {
    int n = 12;
	thrust::host_vector<char> h_A(n + 1);
    thrust::host_vector<char> h_B(n + 1);
	thrust::device_vector<char> d_A;
    thrust::device_vector<char> d_B;

    char *T = (char *)malloc((n + 1) * sizeof(char));
    for (int i = 0; i < n; i++) {
        T[i] = "mississippi$"[i];
    }

    int SA_tmp[] = {11,10,7,4,1,0,9,8,6,3,5,2};
    int *SA = (int *)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) {
        SA[i] = SA_tmp[i];
    }


    // for (int i = 0; i < n; i++) {
    //     h_A[i] = '0' + i;
    // }

	d_A = h_A;
    d_B = h_B;

    dim3 block(32, 1);
    dim3 grid((n + block.x - 1) / block.x, 1);
	char *pd_A = thrust::raw_pointer_cast(&d_A[0]);
	char *pd_B = thrust::raw_pointer_cast(&d_B[0]);

	test<<< grid, block >>>(T, pd_B, SA, n);

    h_B = d_B;

    for (int i = 0; i < n; i++) {
        printf("%c ", h_B[i]);
    }

}