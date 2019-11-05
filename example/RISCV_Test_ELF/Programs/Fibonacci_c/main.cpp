//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 29.10.18.
//


int main(int argc, char** arg) {
        int n=1000;//Enter the number of terms of Fibonacci series you want (no smaller than 10)
        int numbers[n];
        int c, first = 0, second = 1, next;

        for ( c = 0 ; c < n ; c++ )
        {
            if ( c <= 1 )
                next = c;
            else
            {
                next = first + second;
                first = second;
                second = next;
            }
            numbers[c] = next;
        }

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
