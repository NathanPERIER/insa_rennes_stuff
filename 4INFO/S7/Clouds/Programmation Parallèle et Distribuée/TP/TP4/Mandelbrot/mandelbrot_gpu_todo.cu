#include <fstream>
#include <iostream>
#include <vector>
#include <chrono>
#include <string>
//
#include <cuComplex.h>
//
#define MaxIteration 255;  //!< Le nombre max d'itération est 255, soit de base le blanc.
//
static void HandleError(	cudaError_t err,
                            const char *file,
                            int line )
{
    if (err != cudaSuccess)
    {
        printf( "%s in %s at line %d\n", cudaGetErrorString( err ),
        file, line );
        exit( EXIT_FAILURE );
    }
}
#define HANDLE_ERROR( err ) (HandleError( err, __FILE__, __LINE__ ))
// Cette méthode sert uniquement à sauvegarder le vecteur sous forme d'une image en niveau de gris sur 8 bits.
void save_pgm(  const char*                         filename,
                const size_t                        width,
                const size_t                        height,
                const std::vector<std::uint8_t>&   data)
{
    std::ofstream fout{ filename };
    // L'en-tête
    fout << "P2\n" << width << " " << height << " 255\n";
    for (size_t row = 0; row < height; ++row)
    {
        for (size_t col = 0; col < width; ++col)
        {
            fout << (col ? " " : "")
                 << static_cast<unsigned>(data[row * width + col]);
        }
        fout << "\n";
    }
    fout.close();
}
//
__global__ void mandel_kernel_double(std::uint8_t* img, const size_t width, const size_t height) {
    unsigned int index = blockIdx.x * blockDim.x + threadIdx.x;
	const double aspect = static_cast<double>(width) / static_cast<double>(height);
	double myrow = static_cast<double>(index) / static_cast<double>(width);
	double mycol = static_cast<double>(index % width);
	double mag = 0.0;
	std::uint8_t lim = MaxIteration;
	myrow /= height;
	mycol /= width;
	cuDoubleComplex z0 = make_cuDoubleComplex(aspect * (2*mycol - 1) - 0.5, 2*myrow - 1);
	cuDoubleComplex z = make_cuDoubleComplex(0.0, 0.0);
	do {
		z = cuCadd(cuCmul(z, z), z0);
		mag = cuCabs(z);
	} while(lim-- && mag < 4.0);
	img[index] = lim;
}
//
int main(int argc, char* argv[])
{
    if (argc != 3)
    {
        std::cerr << "Usage:\n"
                  << argv[0] << " [width] [height]\n";
        return 1;
    }
    const size_t width  = std::stoul(argv[1]);
    const size_t height = std::stoul(argv[2]);
	std::uint8_t* img_GPU;
    std::vector<std::uint8_t> image(height * width, 0);
    HANDLE_ERROR(cudaMalloc((void**)&img_GPU, width * height * sizeof(std::uint8_t)));
	// Note : il est possible de manipuler le pointeur de données sous-jacent au vecteur via la méthode '.data()'
    auto t0 = std::chrono::high_resolution_clock::now();
	// mandel_kernel_double<<<ceil((double)(width*height)/32.0), 32>>>(...);
    // TODO : Appeler mandel_kernel_double
    auto t1 = std::chrono::high_resolution_clock::now();
    
	std::cout << "Generation of Mandelbrot set for image size " << width << " x " << height << " took "
              << std::chrono::duration<double>(t1-t0).count() << " seconds (GPU version)\n";
    save_pgm("output_GPU.pgm", width, height, image);
}
