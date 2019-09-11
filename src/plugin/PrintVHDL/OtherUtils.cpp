//
// Created by pmorku on 7/29/18.
//

#include "OtherUtils.h"
#include <assert.h>

namespace SCAM {

    bool OtherUtils::isPowerOfTwo(long int n) {
        if ((n < 1) || (n & n - 1))
            return false;
        return true;
    }

    int OtherUtils::bitPosition(long int n) {
        assert(isPowerOfTwo(n) == true);
        int count = 0;
        while (n > 0) {
            if (n & 1)
                return count;
            else {
                count++;
                n >>= 1;
            }
        }
    }
}