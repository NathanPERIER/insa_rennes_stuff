
TARGETS = mandelbrot_cpu mandelbrot_gpu


build : $(TARGETS)

mandelbrot_cpu : mandelbrot_cpu_example.cpp
    g++ -O3 -std=c++11 $< -o $@

mandelbrot_gpu : mandelbrot_gpu_todo.cu
    nvcc -std=c++11 --gpu-architecture=sm_50 $< -o $@

clear : 
    rm $(TARGETS)
