#include "library.cuh"

#include <stdio.h>

#define BOX_WIDTH 32
#define BOX_HEIGHT 32

void preprocess(void **sBaseAddr,
                unsigned int *smemsize,
                unsigned int *swidth,
                unsigned int *sheight,
                unsigned int *spitch,
                ColorFormat *sformat,
                unsigned int nsurfcount,
                void ** userPtr)
{
//    printf("PREPROCESSING\n");
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
//    printf("POSTPROCESSING\n");
}


__global__ void addLabelsKernel(int* pDevPtr, int pitch){
    int row = blockIdx.y*blockDim.y + threadIdx.y;
    int col = blockIdx.x*blockDim.x + threadIdx.x;
    char * pElement = (char*)pDevPtr + row * pitch + col * 2;
    pElement[0] = 0;
    pElement[1] = 0;
    return;
}

static int add_labels(CUdevice *p_dev_ptr, int pitch){

    dim3 threadsPerBlock(BOX_WIDTH, BOX_HEIGHT);
    dim3 blocks(3,3);
    addLabelsKernel<<<blocks,threadsPerBlock>>>((int*)p_dev_ptr, pitch);
    return 0;

}

void gpu_process(EGLImageKHR image, void ** userPtr){

    CUresult status;
    CUeglFrame eglFrame;
    CUgraphicsResource pResource = NULL;

    cudaFree(0);

    status = cuGraphicsEGLRegisterImage(&pResource, image, CU_GRAPHICS_MAP_RESOURCE_FLAGS_NONE);

    if (status != CUDA_SUCCESS) {
        printf("cuGraphicsEGLRegisterImage failed : %d \n", status);
        return;
    }

    status = cuGraphicsResourceGetMappedEglFrame( &eglFrame, pResource, 0, 0);
    if (status != CUDA_SUCCESS) {
        printf ("cuGraphicsSubResourceGetMappedArray failed\n");
    }

    status = cuCtxSynchronize();
    if (status != CUDA_SUCCESS) {
        printf ("cuCtxSynchronize failed \n");
    }

//    if (eglFrame.frameType == CU_EGL_FRAME_TYPE_PITCH) {
//        if (eglFrame.eglColorFormat == CU_EGL_COLOR_FORMAT_RGBA) {
//            printf("USING RGBA\n");
//        } else if (eglFrame.eglColorFormat == CU_EGL_COLOR_FORMAT_YUV420_SEMIPLANAR) {
//            printf("USING YUV420\n");
//
//        } else
//            printf ("Invalid eglcolorformat\n");
//    }
    add_labels((CUdevice *) eglFrame.frame.pPitch[0], eglFrame.pitch);

    status = cuCtxSynchronize();
    status = cuGraphicsUnregisterResource(pResource);


    //    printf("GPU_PROCESSING\n");
}

extern "C" void init(CustomerFunction *cf){
    cf->fPreProcess = preprocess;
    cf->fGPUProcess = gpu_process;
    cf->fPostProcess = post_process;
}

extern "C" void deinit(){
    printf("deinited\n");
}