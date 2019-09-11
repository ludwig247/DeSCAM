//
// Created by Paulius Morkunas (paulius.morku@gmail.com) on 30.11.18.
// Source: https://www.geeksforgeeks.org/binary-search/ 

// C program to implement recursive Binary Search 
// A recursive binary search function. It returns  
// location of x in given array arr[l..r] is present,  
// otherwise -1 
int binarySearch(int arr[], int l, int r, int x) 
{ 
   if (r >= l) 
   { 
        int mid = l + (r - l)/2; 
  
        // If the element is present at the middle  
        // itself 
        if (arr[mid] == x)   
            return mid; 
  
        // If element is smaller than mid, then  
        // it can only be present in left subarray 
        if (arr[mid] > x)  
            return binarySearch(arr, l, mid-1, x); 
  
        // Else the element can only be present 
        // in right subarray 
        return binarySearch(arr, mid+1, r, x); 
   } 
  
   // We reach here when element is not  
   // present in array 
   return -1; 
} 
  
int main(void) 
{ 
	int n = 50; // number of entries in the array
	int array[n];
    int i;
    for(i = 0; i < n; i++)
        array[i] = n;
	int x = 10; 
	int result = binarySearch(array, 0, n-1, x); 

	return 0; 
} 

