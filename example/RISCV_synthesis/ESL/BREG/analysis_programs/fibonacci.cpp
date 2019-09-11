//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 29.10.18.
//


int main(int argc, char **arg) {
    int n = 15000; //Enter the number of terms of Fibonacci series you want (no smaller than 10)
    int numbers[n];
    int c, first = 0, second = 1, next;

    for (c = 0; c < n; c++) {
        if (c <= 1) {
            next = c;
        } else {
            next = first + second;
            first = second;
            second = next;
        }
        numbers[c] = next;
    }
    return 0;
}
