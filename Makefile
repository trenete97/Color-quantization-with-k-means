CUDA_HOME   = /Soft/cuda/8.0.61

NVCC        = $(CUDA_HOME)/bin/nvcc
NVCC_FLAGS  = -O3 -Wno-deprecated-gpu-targets -I$(CUDA_HOME)/include -I$(CUDA_HOME)/sdk/CUDALibraries/common/inc
LD_FLAGS    = -Wno-deprecated-gpu-targets -lcudart -Xlinker -rpath,$(CUDA_HOME)/lib64 -I$(CUDA_HOME)/sdk/CUDALibraries/common/lib

EXEC        = cuda-quantization.exe
OBJC        = cuda-quantization.o bmp.o

EXEC0        = cuda-quantization_v0.exe
OBJC0        = cuda-quantization_v0.o bmp.o

EXEC2        = cuda-quantization_v2.exe
OBJC2        = cuda-quantization_v2.o bmp.o

EXEC3        = cuda-quantization_v3.exe
OBJC3        = cuda-quantization_v3.o bmp.o

EXEC4        = cuda-quantization_v4.exe
OBJC4        = cuda-quantization_v4.o bmp.o

EXEC5        = cuda-quantization_v5.exe
OBJC5        = cuda-quantization_v5.o bmp.o

EXEC6        = cuda-quantization_v6.exe
OBJC6        = cuda-quantization_v6.o bmp.o

EXEC56        = cuda-quantization_v56.exe
OBJC56        = cuda-quantization_v56.o bmp.o

EXE         = quantization.exe
OBJ         = quantization.o bmp.o

default: $(EXEC) $(EXEC0) $(EXEC2) $(EXEC3) $(EXEC4) $(EXEC5) $(EXEC6) $(EXEC56) $(EXE)

quantization: quantization.c
	gcc -o quantization.exe quantization.c bmp.c bmp.h -Wall
	
bmp.o: bmp.h bmp.c
	gcc -c bmp.c
	
quantization.o: quantization.c
	gcc -c quantization.c -Wall

cuda-quantization.o: cuda-quantization.cu
	$(NVCC) -c cuda-quantization.cu $(NVCC_FLAGS)
	
cuda-quantization_v0.o: cuda-quantization_v0.cu
	$(NVCC) -c cuda-quantization_v0.cu $(NVCC_FLAGS)

cuda-quantization_v2.o: cuda-quantization_v2.cu
	$(NVCC) -c cuda-quantization_v2.cu $(NVCC_FLAGS)
	
cuda-quantization_v3.o: cuda-quantization_v3.cu
	$(NVCC) -c cuda-quantization_v3.cu $(NVCC_FLAGS)
	
cuda-quantization_v4.o: cuda-quantization_v4.cu
	$(NVCC) -c cuda-quantization_v4.cu $(NVCC_FLAGS)
	
cuda-quantization_v5.o: cuda-quantization_v5.cu
	$(NVCC) -c cuda-quantization_v5.cu $(NVCC_FLAGS)
	
cuda-quantization_v6.o: cuda-quantization_v6.cu
	$(NVCC) -c cuda-quantization_v6.cu $(NVCC_FLAGS)

cuda-quantization_v56.o: cuda-quantization_v56.cu
	$(NVCC) -c cuda-quantization_v56.cu $(NVCC_FLAGS)
	

$(EXE): $(OBJ)
	gcc $(OBJ) -o $(EXE)

$(EXEC): $(OBJC) 
	$(NVCC) $(OBJC) -o $(EXEC)  $(LD_FLAGS)

$(EXEC0): $(OBJC0) 
	$(NVCC) $(OBJC0) -o $(EXEC0)  $(LD_FLAGS)

$(EXEC2): $(OBJC2) 
	$(NVCC) $(OBJC2) -o $(EXEC2)  $(LD_FLAGS)
	
$(EXEC3): $(OBJC3) 
	$(NVCC) $(OBJC3) -o $(EXEC3)  $(LD_FLAGS)

$(EXEC4): $(OBJC4) 
	$(NVCC) $(OBJC4) -o $(EXEC4)  $(LD_FLAGS)
	
$(EXEC5): $(OBJC5) 
	$(NVCC) $(OBJC5) -o $(EXEC5)  $(LD_FLAGS)

$(EXEC56): $(OBJC56) 
	$(NVCC) $(OBJC56) -o $(EXEC56)  $(LD_FLAGS)
	
$(EXEC6): $(OBJC6) 
	$(NVCC) $(OBJC6) -o $(EXEC6)  $(LD_FLAGS)

clean:
	rm -rf *.o *.exe sortida.bmp Quantization.*
