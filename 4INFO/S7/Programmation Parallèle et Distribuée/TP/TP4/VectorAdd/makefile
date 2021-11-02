
TARGETS = vectorAdd_cpu vectorAdd_gpu


build : $(TARGETS)

vectorAdd_cpu : vectorAdd_example.cpp
    g++ -O3 -std=c++11 $< -o $@

vectorAdd_gpu : vectorAdd_todo.cu
    nvcc -std=c++11 --gpu-architecture=sm_50 $< -o $@

clear :
    rm $(TARGETS)
