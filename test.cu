// #include <stdio.h>
// // #include <string.h>
// // #include <stdlib.h>
// #include <thrust/host_vector.h>
// #include <thrust/device_vector.h>
// #include <cuda.h>
// #include <cuda_runtime.h>

// // (char* T, char* BWT, int* SA, int n) {
// __global__ void test(char *A, char *B, int *C,int n) {
// 	int i = blockIdx.x * blockDim.x + threadIdx.x;
// 	if (i >= n) return;
//     B[i] = C[i] == 0 ? '$' : A[C[i] - 1];
// }

// int main () {
//     const int n = 12;
//     char A[] = "mississippi$";
// 	thrust::host_vector<char> h_B(n);
// 	thrust::device_vector<char> d_B = h_B;

//     // char *T = (char *)malloc((n + 1) * sizeof(char));
//     // for (int i = 0; i < n; i++) {
//     //     T[i] = "mississippi$"[i];
//     // }
//     // char T[] = "mississippi$";

//     // int SA_tmp[] = {11,10,7,4,1,0,9,8,6,3,5,2};
//     // int *SA = (int *)malloc(n * sizeof(int));
//     // for (int i = 0; i < n; i++) {
//     //     SA[i] = SA_tmp[i];
//     // }
//     // int SA[] = {11,10,7,4,1,0,9,8,6,3,5,2};
//     int C[] = {11,10,7,4,1,0,9,8,6,3,5,2};

// 	// d_B = h_B;

//     dim3 block(8, 1);
//     dim3 grid((n + block.x - 1) / block.x, 1);
// 	char *pd_B = thrust::raw_pointer_cast(&d_B[0]);

// 	// test<<< grid, block >>>(T, pd_B, SA, n);
//     test<<< grid, block >>>(A, pd_B, C, n);

//     h_B = d_B;

//     for (int i = 0; i < n; i++) {
//         printf("%c ", h_B[i]);
//     }

// }
#include <stdio.h>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <cuda.h>
#include <cuda_runtime.h>

__global__ void test(char* A, char* B, int* C, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    B[i] = C[i] != 0 ? A[C[i] - 1] : '$';
}

int main() {
    const int n = 12;
    char A[] = "mississippi$";
    int C[] = { 11,10,7,4,1,0,9,8,6,3,5,2 };

    thrust::device_vector<char> d_A(A, A+n);
    thrust::device_vector<char> d_B(n);
    thrust::device_vector<int>  d_C(C, C+n);

    dim3 block(8, 1);
    dim3 grid((n + block.x - 1) / block.x, 1);
    test<<<grid, block >>>(
        thrust::raw_pointer_cast(&d_A[0]),
        thrust::raw_pointer_cast(&d_B[0]),
        thrust::raw_pointer_cast(&d_C[0]),
        n);

    thrust::host_vector<char> h_B = d_B;

    for (int i = 0; i < n; i++) {
        printf("%c ", h_B[i]);
    }
}
