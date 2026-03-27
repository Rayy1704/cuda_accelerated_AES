# ⚡ GPU-Accelerated AES Cryptography (CUDA)

![C++](https://img.shields.io/badge/C++-00599C?style=for-the-badge&logo=c%2B%2B&logoColor=white)
![CUDA](https://img.shields.io/badge/CUDA-76B900?style=for-the-badge&logo=nvidia&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![CMake](https://img.shields.io/badge/CMake-064F8C?style=for-the-badge&logo=cmake&logoColor=white)

> **A high-performance implementation of the Advanced Encryption Standard (AES-128) leveraging NVIDIA's Parallel Compute Architecture.**

---

## 🛠️ Tech Stack & Tools
* **Language:** C++17 / CUDA C
* **Parallel Computing:** NVIDIA CUDA Toolkit (v12.x+)
* **Build System:** CMake
* **Profiling:** NVIDIA Nsight Systems & Nsight Compute
* **Environment:** Linux (Ubuntu / GIKI Lab Environment)

## 💎 Key Features
* **📦 Highly Modularized:** Clean separation between the CPU reference model, CUDA kernels, and File I/O handlers.
* **🚀 Massive Parallelism:** Maps the AES block-cipher logic to thousands of GPU threads for "embarrassingly parallel" workloads.
* **🧠 Memory Optimization:** Utilizes `__constant__` memory for S-Box lookups and Shared Memory for Round Key caching to minimize Global Memory latency.
* **📊 Benchmarking Suite:** Integrated timing using `cudaEvent_t` to compare CPU vs. GPU throughput (Gbps).
* **🛠️ Hex-to-Byte Pipeline:** Custom-built robust parser for processing hexadecimal text-based input files.

## 🏗️ Project Architecture
The project is strictly modularized to allow for easy extension (e.g., adding RSA or ChaCha20):
1.  `/src/cpu`: Single-threaded C++ reference implementation for verification.
2.  `/src/cuda`: Optimized GPU kernels and memory management logic.
3.  `/src/common`: Shared headers, S-Box tables, and utility functions.
4.  `/logs`: Dedicated debug stream for intermediate state logging ($4 \times 4$ matrices).

---

## 📈 Performance Preview
| Implementation | File Size | Throughput | Speedup |
| :--- | :--- | :--- | :--- |
| **CPU (Sequential)** | 100MB | ~0.5 Gbps | 1x |
| **GPU (Naive CUDA)** | 100MB | ~12.0 Gbps | 24x |
| **GPU (Optimized)** | 100MB | **~45.0 Gbps** | **90x** |

---
*Developed by **Rayyan Hassan Salman** - Computer Science @ GIKI*
