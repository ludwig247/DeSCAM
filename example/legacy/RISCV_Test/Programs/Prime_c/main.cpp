//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 29.10.18.
//



int main(int argc, char** arg) {
    int n=10000;
    int i;
    int prime_count=0;
    int max_cnt = 10; //How many primes should be computed?
    int numbers[max_cnt];
    int isPrime = 0;

    while(prime_count < max_cnt){
        isPrime = 0;
        for(i = 2; i <= n / 2; ++i)
        {
            if(n % i == 0)
            {
                isPrime = 1;
                break;
            }
        }
        if (isPrime == 0){
            numbers[prime_count] = n;
            ++prime_count;
        }
        n=n+1;
    }
    asm("addi s2, %0, 0"::"r"(numbers[0]));
    asm("addi s3, %0, 0"::"r"(numbers[1]));
    asm("addi s4, %0, 0"::"r"(numbers[2]));
    asm("addi s5, %0, 0"::"r"(numbers[3]));
    asm("addi s6, %0, 0"::"r"(numbers[4]));
    asm("addi s7, %0, 0"::"r"(numbers[5]));
    asm("addi s8, %0, 0"::"r"(numbers[6]));
    asm("addi s9, %0, 0"::"r"(numbers[7]));
    asm("addi s10, %0, 0"::"r"(numbers[8]));
    asm("addi s11, %0, 0"::"r"(numbers[9]));

    return 0;
}
