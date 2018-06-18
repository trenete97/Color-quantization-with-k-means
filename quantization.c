#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/times.h>
#include <sys/resource.h>
#include "bmp.h"

typedef struct Color {
    unsigned int r, g, b;
} Color;

//Global variables:
int Size, Size_row, N_colors, N_iterations;

float GetTime(void)        
{
  struct timeval tim;
  struct rusage ru;
  getrusage(RUSAGE_SELF, &ru);
  tim=ru.ru_utime;
  return ((double)tim.tv_sec + (double)tim.tv_usec / 1000000.0)*1000.0;
}

int square(int value) {
    return value * value;
}

int getIndexColor(int index) {
    int i = (index*3/Size_row);
    int j = ((index*3)%Size_row);
    return i * Size_row + j;
}

void display_means(Color means[]) {
    int i;
    for (i = 0; i < N_colors; ++i) {
        fprintf(stderr, "mean %d:  ", i);
        fprintf(stderr, "r: %d, ", means[i].r);
        fprintf(stderr, "g: %d, ", means[i].g);
        fprintf(stderr, "b: %d\n", means[i].b);
        
    }
    fprintf(stderr, "\n");
}

void display_assigns(int assigns[]) {
    int i;
    for (i = 0; i < Size; ++i) {
        fprintf(stderr, "%d:  %d\n", i, assigns[i]);
    }
}

void init_means(Color means[], unsigned char *im) {
    int r;
    int i;
    for (i = 0; i < N_colors; ++i) {
        r = rand() % Size;
        int index = getIndexColor(r);
        means[i].r = im[index+2];
        means[i].g = im[index+1];
        means[i].b = im[index];
    }
}

void find_best_mean_seq(Color means[], int assigns[], unsigned char *im, int N, int ncolors) {
    int i;
    for (i = 0; i < N; ++i) {
        int j;
        int index = (i*3/Size_row) * Size_row + ((i*3)%Size_row);
        int dist_min = -1;
        int dist_act, assign;
        for (j = 0; j < ncolors; ++j) {
            dist_act = square(im[index+2] - means[j].r) + square(im[index+1] - means[j].g) + square(im[index] - means[j].b);
            if (dist_min == -1 || dist_act < dist_min) {
                dist_min = dist_act;
                assign = j;  
            }
        }
        assigns[i] = assign;
    }
}

void sum_up_and_count_points(Color new_means[], int assigns[], unsigned char *im, int N, int counts[]) {
    int i;
    for (i = 0; i < Size; ++i) {
        int imeans = assigns[i];
        int index = getIndexColor(i);
        new_means[imeans].r += im[index+2];
        new_means[imeans].g += im[index+1];
        new_means[imeans].b += im[index];
        counts[imeans] += 1;
    }
    
}

void execute_k_means(Color means[], int assigns[], unsigned char *im) {
    int it;
    Color *new_means = malloc(N_colors*sizeof(Color));
    int *counts = malloc (N_colors * sizeof (int));
    for (it = 0; it < N_iterations; ++it) {
        
        //for each pixel find the best mean.
        find_best_mean_seq(means, assigns, im, Size, N_colors);
        
        //set counts and new_means to 0
        memset (counts, 0, sizeof (int) * N_colors);
        memset (new_means, 0, sizeof (Color) * N_colors);
        //Sum up and count points for each cluster.
        sum_up_and_count_points(new_means, assigns, im, Size, counts);
        //Divide sums by counts to get new centroids.
        
        int i;
        for (i = 0; i < N_colors; ++i) {
            //Turn 0/0 into 0/1 to avoid zero division.
            if(counts[i] == 0) counts[i] = 1;
            means[i].r = new_means[i].r / counts[i];
            means[i].g = new_means[i].g / counts[i];
            means[i].b = new_means[i].b / counts[i];
        }
    }
    free(new_means);
    free(counts);
}

void assign_colors(Color means[], int assigns[], unsigned char *im) {
    int i;
    for (i = 0; i < Size; ++i) {
        int index = getIndexColor(i);
        im[index]=means[assigns[i]].b;
        im[index + 1]=means[assigns[i]].g;
        im[index + 2]=means[assigns[i]].r;  
    }
}

int main(int c, char *v[])
{
    if (c < 4 || c > 5) {
        fprintf(stderr, "usage: %s ppm_file n_iterations seed n_colors\n", v[0]);
        return -1;
    }
    
    else if (c == 4) N_colors = 16;
    else if (c == 5) N_colors = atoi(v[4]) ? : 16;
    
    //read image:
    bmpInfoHeader infoHeader;
    unsigned char *im= LoadBMP(v[1], &infoHeader);
    
    //init variables globals:
    N_iterations = atoi(v[2]);
    Size_row = ((infoHeader.width*3 + 3) / 4) * 4;
    int width = infoHeader.width;
    int height = infoHeader.height;
    Size = width * height;
    
    //init seed
    srand(atoi(v[3])); 
    
    //inicialitzar means:
    Color *means = malloc(N_colors*sizeof(Color));
    init_means(means, im);
    
    ///display means inti
    //fprintf(stderr, "Means init:\n");
    //display_means(means);
    
    
    int *assigns = malloc(Size*sizeof(int)); //vector d'assignacions (cada
                                             //pixel a un i_mean)
    float t1 = GetTime();
    
    //executem k means:
    execute_k_means(means, assigns, im);
    //assignem colors:
    assign_colors(means, assigns, im);
    
    float t2=GetTime();
    
    float SeqTime = (t2-t1);
	
    printf("Tiempo Total Version SEQUENCIAL %4.6f ms\n", SeqTime);
    
    
    ///display means final
    //fprintf(stderr, "Means final:\n");
    //display_means(means);

    //save image
    SaveBMP("sortida.bmp", &infoHeader, im);
    //DisplayInfo("sortida.bmp", &infoHeader);    
         
    free(im);
    free(assigns);
    free(means);
    return 0;
}
