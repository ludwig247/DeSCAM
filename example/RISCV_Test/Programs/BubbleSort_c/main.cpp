//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 29.10.18.
//

// An optimized version of Bubble Sort
void bubbleSort(int a[], int n)
{
    int i,j,temp;
    for(i=1;i<n;++i)
    {
        for(j=0;j<(n-i);++j)
            if(a[j]>a[j+1])
            {
                temp=a[j];
                a[j]=a[j+1];
                a[j+1]=temp;
            }
    }
}

// Driver program to test above functions
int main()
{
    int n = 50; // number of entries in the array
    int numbers[n];
    int i;
    for(i=0; i < n; i++)
        numbers[i] = n-i;
    bubbleSort(numbers, n);

    asm("addi s2, %0, 0"::"r"(numbers[n-10]));
    asm("addi s3, %0, 0"::"r"(numbers[n-9]));
    asm("addi s4, %0, 0"::"r"(numbers[n-8]));
    asm("addi s5, %0, 0"::"r"(numbers[n-7]));
    asm("addi s6, %0, 0"::"r"(numbers[n-6]));
    asm("addi s7, %0, 0"::"r"(numbers[n-5]));
    asm("addi s8, %0, 0"::"r"(numbers[n-4]));
    asm("addi s9, %0, 0"::"r"(numbers[n-3]));
    asm("addi s10, %0, 0"::"r"(numbers[n-2]));
    asm("addi s11, %0, 0"::"r"(numbers[n-1]));

    return 0;
}
