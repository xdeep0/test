#include <stdio.h>
#include <string.h>
// #include <stdlib.h>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <cuda.h>
#include <cuda_runtime.h>

__global__ void test(int *A, int *B, int n) {
	int index = blockIdx.x * blockDim.x + threadIdx.x;
	if (index >= n) return;
    B[index] = A[index];
}

int main () {
    int n = 5;
	thrust::host_vector<int> h_A(n + 1);
    thrust::host_vector<int> h_B(n + 1);
	thrust::device_vector<int> d_A;
    thrust::device_vector<int> d_B;

    for (int i = 0; i < n; i++) {
        h_A[i] = i;
    }

	d_A = h_A;
    d_B = h_B;

    dim3 block(32, 1);
    dim3 grid((n + block.x - 1) / block.x, 1);
	int *pd_A = thrust::raw_pointer_cast(&d_A[0]);
	int *pd_B = thrust::raw_pointer_cast(&d_B[0]);

	test<<< grid, block >>>(pd_A, pd_B, n);

    h_B = d_B;

    for (int i = 0; i < n; i++) {
        printf("%d ", h_B[i]);
    }

}