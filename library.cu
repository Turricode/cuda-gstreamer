#include "library.cuh"

#include <stdio.h>

void preprocess(void **sBaseAddr,
                unsigned int *smemsize,
                unsigned int *swidth,
                unsigned int *sheight,
                unsigned int *spitch,
                ColorFormat *sformat,
                unsigned int nsurfcount,
                void ** userPtr)
{
    printf("PREPROCESSING\n");
}

void post_process(void **sBaseAddr,
                  unsigned int *smemsize,
                  unsigned int *swidth,
                  unsigned int *sheight,
                  unsigned int *spitch,
                  ColorFormat *sformat,
                  unsigned int nsurfcount,
                  void ** userPtr)
{
    printf("POSTPROCESSING\n");
}

void gpu_process(EGLImageKHR image, void ** userPtr){
    printf("GPU_PROCESSING\n");
}

extern "C" void init(CustomerFunction *cf){
    cf->fPreProcess = preprocess;
    cf->fGPUProcess = gpu_process;
    cf->fPostProcess = post_process;
}

extern "C" void deinit(){
    printf("deinited\n");
}