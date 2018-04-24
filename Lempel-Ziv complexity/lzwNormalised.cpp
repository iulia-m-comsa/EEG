/* Computes the Lempel-Ziv-Welch complexity.
 *
 * To compile: mex lzwNormalised.cpp
 * Then, to run: complexity = lzwNormalised('00010111011111011', 10);
 *
 * The first parameter is a string containing only 0s and 1s.
 * The second parameter is a non-negative integer representing the number
 * of shuffles performed on the given string to normalise the result. If 
 * zero, no normalisation is performed.
 *
 * Hint: you can use int2str([0 1 1 1 0 0 1 0 1]) and then remove spaces
 * to construct the input string.
 *
 * Author: 
 * Iulia M. Comșa
 * imc31@cam.ac.uk
 * February 2017
 *
 */

#include <string>
#include <vector>
#include <numeric>
#include <unordered_map>
#include <algorithm>

#include "mex.h"

using namespace std;

/* Computes Lempel-Ziv-Welch complexity. 
 * See S1 in Schartner et al. (2015) for an explanation.
 * Input must be a string of 1s and 0s only.
 */
int lzw(const string& input) {
	unordered_map<string, bool> dictionary = { { "0", true }, { "1", true } };
	int s = 0;
	int e = 1;
	string subsequence;
	subsequence += input[s];

	while (e < input.size()) {
		subsequence += input[e];
		if (dictionary.find(subsequence) == dictionary.end()) {
			dictionary.insert(make_pair(subsequence, true));
			s = e;
			subsequence.clear();
			subsequence += input[s];
		}
		++e;
	}
	return dictionary.size();
}

/* Computes normalised Lempel-Ziv-Welch complexity.
 * Inputs:
 *  a string of 0s and 1s
 *  a non-negative integer indicating the desired number of normalisations 
 *    (if 0, does not normalise).
 * Output: the normalised Lempel-Ziv-Welch complexity.
 */
double lzwNormalised(string input, int nrShuffles) {
	int complexity = lzw(input);
    
    if (nrShuffles == 0) {
        return complexity;
    }
    
    if (nrShuffles < 0) {
        mexErrMsgIdAndTxt( "MATLAB:lzw:invalidInput",
              "Invalid number of randomisations requested.");
    }

	vector<int> complexities;
	while (nrShuffles--) {
		random_shuffle(input.begin(), input.end());
		complexities.push_back(lzw(input));
	}
	return complexity / (accumulate(complexities.begin(), complexities.end(), 0.0) / complexities.size());
}


/* Main function, see lzwNormalised for arguments. */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    char *input_buf;
    int nrShuffles;
    
    // Check inputs and outputs.
    if(nrhs != 2) 
        mexErrMsgIdAndTxt( "MATLAB:lzw:invalidNumInputs",
              "Two inputs required.");
    else if(nlhs > 1) 
        mexErrMsgIdAndTxt( "MATLAB:lzw:maxlhs",
              "Too many output arguments.");
    if (mxIsChar(prhs[0]) != 1)
        mexErrMsgIdAndTxt( "MATLAB:lzw:inputNotString",
              "First input must be a string.");
    if (mxIsNumeric(prhs[1]) != 1)
    {
        mexErrMsgIdAndTxt( "MATLAB:lzw:inputNotNumeric",
              "Second input must be an integer.");
    }
    
    // Convert the input arguments.
    input_buf = mxArrayToString(prhs[0]);
    string input_str(input_buf);
    nrShuffles = mxGetScalar(prhs[1]);
    
    // Compute complexity.
    plhs[0] = mxCreateDoubleScalar(lzwNormalised(input_buf, nrShuffles));
    
    // Free memory.
    mxFree(input_buf);
}