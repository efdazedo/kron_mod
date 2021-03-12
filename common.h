#ifndef COMMON_H
#define COMMON_H 1


#ifdef USE_DOUBLE
#define ZTYPE real(kind=dp)
#define GEMM dgemm
#define conjg(x) dble(x)
#else
#define ZTYPE complex(kind=dp)
#define GEMM zgemm
#endif


#endif
