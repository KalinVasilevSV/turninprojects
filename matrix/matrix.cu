#include <stdlib.h>
#include <stdio.h>

__global__
void add(double *a, double *b, double *c, long size){
  long stride = blockDim.x;
  long index = blockIdx.x*stride+threadIdx.x;

   for (long i=index; i < size; i+=stride)
     for (long j=0; j < size; j++){
       c[i*size+j] = 0.0;
       for (long k=0; k < size; k++)
         c[i*size+j] += a[i*size+k] * b[k*size+j];
    }
}

void Test(void);

int main(int argc, char *argv[])
{
    printf("testing... \n");
    long size = argc==1 ? 3 : atol(argv[1]);

  double A[size][size];
  double B[size][size];
  double C[size][size];

  A[0][0] = 14.0; A[0][1] = 9.0;  A[0][2] = 3.0;
  A[1][0] = 2.0;  A[1][1] = 11.0; A[1][2] = 15.0;
  A[2][0] = 0.0;  A[2][1] = 12.0; A[2][2] = 17.0;

  B[0][0] = 12.0; B[0][1] = 25.0; B[0][2] = 5.0;
  B[1][0] = 9.0;  B[1][1] = 10.0; B[1][2] = 0.0;
  B[2][0] = 8.0;  B[2][1] = 5.0;  B[2][2] = 1.0;

//  printf("test matrix A... \n");
//    for(int i=0;i<size;i++){
//        for(int j=0;j<size;j++)
//            printf("%4.1f ",A[i][j]);
//        printf("\n");
//    }
//
//  printf("test matrix B... \n");
//    for(int i=0;i<size;i++){
//        for(int j=0;j<size;j++)
//            printf("%4.1f ",B[i][j]);
//        printf("\n");
//    }

    printf("actual work ... \n");
    double *a, *b,*c;

    cudaMallocManaged(&a,sizeof(double)*size*size);
    cudaMallocManaged(&b,sizeof(double)*size*size);
    cudaMallocManaged(&c,sizeof(double)*size*size);


   for (long i=0; i < 3; i++)
     for (long j=0; j < 3; j++){
       a[i*3+j] = A[i][j];
       b[i*3+j] = B[i][j];
     }

    add<<<2,1024>>>(a,b,c,size);

    cudaDeviceSynchronize();

//    for (long i=0; i < size; i++){
//        for (long j=0; j < size; j++)
//            printf("%4.1f ", c[i*size+j]);
//        printf("\n");
//    }

    cudaFree(a);
    cudaFree(b);
    cudaFree(c);
}
