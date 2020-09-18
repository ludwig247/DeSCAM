//
// Created by Tobias Jauch on 28.04.2020.
//
#include "../../Interfaces/Interfaces.h"
#include "systemc.h"

SC_MODULE (BubbleSort) {

    //data
    int data_in[10] = {5,9,2,8,6,4,1,3,7,0};
    int data_out[10];

    //Algorithm
    void sortAlgorithm(int data[], int n){

        int i, j, swap;

        for (i=0;i<n-1;i++){
            for(j=0;j<n-i-1;j++){
                if(data[j] > data[j+1]){
                    swap = data[j];
                    data[j] = data[j+1];
                    data[j+1] = swap;
                }
            }
        }
    }

    SC_CTOR (BubbleSort)
    {
        SC_THREAD(fsm);
    }

    void fsm()
    {

          int n = sizeof(data_in)/sizeof(data_in[0]);
        cout << "Number of Elements: " << random << endl;

        for(int i=0;i<n;i++){
            cout << "Element " << i << " of data_in is: " << data_in[i] <<endl;
        }

        sortAlgorithm(data_in, n);

        cout << " " << endl;

        for(int i=0;i<n;i++){
            cout << "Element " << i << " of data_in is: " << data_in[i] <<endl;
        }
    }
};


