//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 29.10.18.
//

// An optimized version of Bubble Sort
void bubbleSort(int a[], int n) {
    int i, j, temp;
    for (i = 1; i < n; ++i) {
        for (j = 0; j < (n - i); ++j) {
            if (a[j] > a[j + 1]) {
                temp = a[j];
                a[j] = a[j + 1];
                a[j + 1] = temp;
            }
        }
    }
}

// Driver program to test above functions
int main() {
    int n = 500; // number of entries in the array
    int numbers[n];
    int i;
    for (i = 0; i < n; i++)
        numbers[i] = n - i;
    bubbleSort(numbers, n);
    return 0;
}
