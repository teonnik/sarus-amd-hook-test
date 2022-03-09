#include <iostream>
#include <numeric>
#include <vector>

#include "hipblas.h"

// Checks for hip errors and prints information
void hipCall(hipError_t err, const unsigned int line) noexcept {
  if (err != hipSuccess) {
    std::cout << "!! hip error at line " << line << " : "
              << hipGetErrorString(err) << std::endl;
    std::terminate();
  }
}

#define HIP_CALL(hip_f) hipCall((hip_f), __LINE__)

// Checks for hipblas errors and prints information
void hipblasCall(hipblasStatus_t st, const unsigned int line) {
  if (st != HIPBLAS_STATUS_SUCCESS) {
    std::cout << "!! hipblas error at line " << line << " : " << st
              << std::endl;
    std::terminate();
  }
}

#define HIPBLAS_CALL(hipblas_f) hipblasCall((hipblas_f), __LINE__)

int main() {
  // Allocate and initialize arrays on host
  int n = 1000;
  std::vector<double> x_h(n, 2.0);
  std::vector<double> y_h(n, 3.0);
  double alpha_h = 2.0;
  int incx = 1;
  int incy = 1;

  // Copy host arrays to device arrays
  double *x_d;
  double *y_d;
  double *alpha_d;
  std::size_t sz = n * sizeof(double);
  HIP_CALL(hipMemcpy(x_d, x_h.data(), sz, hipMemcpyHostToDevice));
  HIP_CALL(hipMemcpy(y_d, y_h.data(), sz, hipMemcpyHostToDevice));
  HIP_CALL(hipMemcpy(alpha_d, &alpha_h, sizeof(double), hipMemcpyHostToDevice));

  // Do AXPY: y = a * x + y
  hipblasHandle_t handle;
  HIPBLAS_CALL(hipblasCreate(&handle));
  HIPBLAS_CALL(hipblasDaxpy(handle, n, alpha_d, x_d, incx, y_d, incy));
  HIPBLAS_CALL(hipblasDestroy(handle));

  // Copy y from device to host and sum all elements
  HIP_CALL(hipMemcpy(y_h.data(), y_d, sz, hipMemcpyDeviceToHost));
  double sum = std::accumulate(y_h.begin(), y_h.end(), 0.0);

  // Print expected and actual results
  std::cout << "Expected : " << n * 7.0 << std::endl;
  std::cout << "Actual   : " << sum << std::endl;
}
