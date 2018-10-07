# Color quantization with k-means CUDA
Raul Montoya, Martí Ferret

Color quantization is the process of reducing the number of distinct colors used in an image. The goal of the color quantization is to obtain a compressed image as similar as possibile to the original one. The key factor for achieving this is the selection of the color palette by choosing the colors that most summarizes the original image.

We created a CUDA version of the color quantization with k-means algorithm (implemented in c) and we experimented with the use of threads to see how powerfull is the parallelism. We implemented some versions explained in the documentation document.
