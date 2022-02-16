#ifndef CUDA_GSTREAMER_LIBRARY_CUH
#define CUDA_GSTREAMER_LIBRARY_CUH

#include <cuda.h>
#include <cudaEGL.h>

extern "C" {

typedef enum {
    COLOR_FORMAT_Y8 = 0,
    COLOR_FORMAT_U8_V8,
    COLOR_FORMAT_RGBA,
    COLOR_FORMAT_NONE
} ColorFormat;

typedef struct {

    void (*fGPUProcess)(EGLImageKHR image, void **userPtr);

    void (*fPreProcess)(void **sBaseAddr,
                        unsigned int *smemsize,
                        unsigned int *swidth,
                        unsigned int *sheight,
                        unsigned int *spitch,
                        ColorFormat *sformat,
                        unsigned int nsurfcount,
                        void **userPtr);

    void (*fPostProcess)(void **sBaseAddr,
                         unsigned int *smemsize,
                         unsigned int *swidth,
                         unsigned int *sheight,
                         unsigned int *spitch,
                         ColorFormat *sformat,
                         unsigned int nsurfcount,
                         void **userPtr);
} CustomerFunction;

void init(CustomerFunction *cf);
void deinit();
};
#endif //CUDA_GSTREAMER_LIBRARY_CUH
