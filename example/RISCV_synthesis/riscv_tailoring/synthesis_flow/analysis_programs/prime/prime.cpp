//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 29.10.18.
//

int main(int argc, char **arg) {
    int n = 15;
    int i;
    int prime_count = 0;
    int max_cnt = 4; //How many primes should be computed?
    int numbers[max_cnt];
    int isPrime = 0;

    while (prime_count < max_cnt) {
        isPrime = 0;
        for (i = 2; i <= n / 2; ++i) {
            if (n % i == 0) {
                isPrime = 1;
                break;
            }
        }
        if (isPrime == 0) {
            numbers[prime_count] = n;
            ++prime_count;
        }
        n = n + 1;
    }
    return 0;
}
