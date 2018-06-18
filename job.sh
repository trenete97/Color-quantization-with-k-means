#!/bin/bash
export PATH=/Soft/cuda/8.0.61/bin:$PATH
### Directivas para el gestor de colas
# Asegurar que el job se ejecuta en el directorio actual
#$ -cwd
# Asegurar que el job mantiene las variables de entorno del shell lamador
#$ -V
# Cambiar el nombre del job
#$ -N Quantization 
# Cambiar el shell
#$ -S /bin/bash

#setenv IMAGE "subaru.bmp"

#setenv NITERATIONS 10
#setenv SEED 99
#setenv NCOLORS 10 # max 12 (shared memory is 48k)

#./cuda-quantization.exe ${IMAGE} ${NITERATIONS} ${SEED} ${NCOLORS}
#./cuda-quantization.exe ${IMAGE} ${NITERATIONS} ${SEED} ${NCOLORS}

./quantization.exe subaru.bmp 10 99 12
./cuda-quantization.exe subaru.bmp 10 99 12
./cuda-quantization_v0.exe subaru.bmp 10 99 12
./cuda-quantization_v2.exe subaru.bmp 10 99 12
./cuda-quantization_v3.exe subaru.bmp 10 99 12
./cuda-quantization_v4.exe subaru.bmp 10 99 12
./cuda-quantization_v5.exe subaru.bmp 10 99 12
#./cuda-quantization_v6.exe subaru.bmp 10 99 12
#./cuda-quantization_v56.exe subaru.bmp 10 99 12

#nvprof --print-gpu-trace --unified-memory-profiling off ./cuda-quantization.exe subaru.bmp 10 80 10

