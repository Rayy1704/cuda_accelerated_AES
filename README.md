# ⚡ CUDA-Accelerated AES-128 Cryptographic Engine

![C](https://img.shields.io/badge/C-00599C?style=for-the-badge&logo=c&logoColor=white)
![CUDA](https://img.shields.io/badge/CUDA-76B900?style=for-the-badge&logo=nvidia&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Make](https://img.shields.io/badge/Make-064F8C?style=for-the-badge&logo=make&logoColor=white)

> **A high-throughput, massively parallel implementation of the Advanced Encryption Standard (AES-128), engineered entirely from scratch in plain C and CUDA to bypass global memory bottlenecks.**


---

## 🛠️ Hardware Environment & Tech Stack
* **Language:** C / CUDA C (Built entirely manually to deeply understand byte-level cryptographic transformations)
* **Architecture:** NVIDIA CUDA Toolkit (v12.x+)
* **Build System:** Make
* **Host CPU:** Intel(R) Xeon(R) W-2275 CPU @ 3.30GHz (14 Cores)
* **Device GPU:** NVIDIA RTX A2000 12GB (3328 CUDA Cores)
* **Environment:** Linux (Ubuntu / GIKI Lab Environment)

## 💎 Cryptographic Rigor & Mathematics
This project does not rely on external cryptographic libraries. The sequential baseline and parallel kernels were implemented from the ground up:
* **Galois Field Mathematics:** Implemented custom polynomial arithmetic over `GF(2^8)` to handle the mathematical rigor of the `MixColumns` transformation.
* **NIST FIPS 197 Compliance:** Strict adherence to official specifications, specifically enforcing a **column-major** memory layout for the 4x4 state matrix. Thims layout is mathematically mandated by AES for accurate shift and mix operations.
* **Verification:** Algorithm correctness was continuously verified against official NIST test samples throughout development.

## 🚀 Architecture & CUDA Optimizations
Transitioning the sequential block cipher to a massively parallel GPU architecture required precise management of the CUDA memory hierarchy and thread execution:

* **Massive Thread-Level Parallelism:** Maps the AES encryption logic to process independent 16-byte payloads concurrently across thousands of GPU threads.
* **`__constant__` Memory Broadcasting:** Caches the entire AES S-Box and the 176-byte expanded key schedule directly in device constant memory. Because every thread in a warp requires the same cryptographic variables during a round, this allows a single memory fetch to be instantly broadcast to all 32 threads simultaneously.
* **Strided Memory Access & Cache Utilization:** Due to the NIST-mandated column-major matrix format, thread memory access is naturally strided rather than perfectly coalesced. This is effectively mitigated by the RTX A2000's high-efficiency L1/L2 caches and the massive offloading of bus traffic via the constant memory cache.
* **Control Divergence Mitigation:** Carefully managed kernel execution paths and minimized setup overhead to prevent thread divergence and maintain maximum warp occupancy.

## 🏗️ Project Structure
The repository is strictly modularized, separating the sequential CPU baseline from the highly optimized GPU engine.

```text
cuda_accelerated_AES/
│
├── /c-implementation/           # Sequential CPU Reference (Baseline & Verification)
│   ├── /include/                # Core cryptographic prototypes and I/O declarations
│   │   ├── aes.h
│   │   └── io.h
│   ├── /src/
│   │   ├── main.c               # Entry point and sequential benchmarking
│   │   ├── aes_core.c           # Core state matrix transformations (SubBytes, ShiftRows, MixColumns)
│   │   ├── aes_encryption.c     # Forward cipher implementation
│   │   ├── aes_decryption.c     # Inverse cipher implementation
│   │   └── io.c                 # Hex-to-byte parsing and state matrix logging
│   ├── /input/                  # NIST test vectors and plaintext payloads (data.txt, key.txt)
│   ├── /output/                 # Generated ciphertext and verification outputs
│   ├── Makefile                 # GCC build instructions for the sequential engine
│   └── report.pdf               # Initial CPU implementation report
│
├── /cuda-implementation/        # Massively Parallel GPU Engine 
│   ├── /include/                # Device/Host utility headers
│   │   ├── cuda_aes.h
│   │   └── io.h
│   ├── /src/
│   │   ├── main.cu              # Host (CPU) code: memory allocation, kernel launching, cudaEvent_t timing
│   │   ├── aes_core.cu          # Device (GPU) code: __global__ execution and warp-level transformations
│   │   ├── aes_encryption.cu    # CUDA kernel for parallel block encryption
│   │   ├── aes_decryption.cu    # CUDA kernel for parallel block decryption
│   │   └── io.c                 # Host-side file I/O operations prior to memory transfer
│   ├── /input/                  # Bulk payload files for stress-testing and benchmarking
│   ├── /output/                 # Decrypted validation data
│   └── makefile                 # NVCC (NVIDIA CUDA Compiler) build instructions
│
├── project_manual.pdf           # Comprehensive theoretical background, math breakdown, and architecture documentation
├── LICENSE                      # MIT License
└── README.md                    # Project overview, specifications, and performance metrics