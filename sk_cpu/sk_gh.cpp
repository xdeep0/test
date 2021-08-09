#include <iostream>
#include <vector>
#include <string>
#include <time.h>

using namespace std;

vector<int> dc3(vector<int>&  arr, int k)  ;

bool checkEqual(vector<int>& arr, int i, int j, int len) ;

bool compare(vector<int>& arr, int index0, int index12, vector<int>& rank) ;

void radixPass(vector<int>& arr, vector<int>& indices, int offset, int k);

#define getIndex(i, n) (((i) % 3 == 1 ? 0 : ((n)+2)/3) + (i)/3)

// shin ----------------------
void read_data(char *filename, char *buffer, int num){
	FILE *fh;
	fh = fopen(filename, "r");
	fread(buffer, 1, num, fh);
	buffer[num] = '\0';
	fclose(fh);
}
// -----------------------------

vector<int> dc3(vector<int>&  arr, int k)  {
    int n = arr.size(), n0 = (n+2)/3, n1 = n0, n2 = n/3, n12 = n1 + n2;
    vector<int> indices12(n12);
    for(int i = 0; i*3 < n; i++) {
        indices12[getIndex(i*3 + 1, n)] = i*3 + 1;
        if(i*3+2<n) indices12[getIndex(i*3+2, n)] = i*3+2;
    }
    vector<int> sorted12(indices12);
    for(int pos = 2 ; pos >= 0 ; pos--)  {
        radixPass(arr, sorted12, pos, k);
    }
    vector<int> rank12(n12);
    int last_rank = 0;
    bool notUnique = false;
    for(int i = 0 ; i < n12 ; i++) {
        rank12[getIndex(sorted12[i], n)] =  i != 0 && (notUnique = checkEqual(arr, sorted12[i], sorted12[i-1], 3)) ? last_rank : ++last_rank;
    }
    if(notUnique) {
        vector<int> sa12 = dc3(rank12, last_rank);
        for(int i = 0 ; i < n12 ; i++) {
            sorted12[i] = indices12[sa12[i]];
            rank12[sa12[i]] =  i+1;
        }
    }
    vector<int> sorted0;
    for (int i = 0; i < n12; ++i) {
        if(sorted12[i] % 3 == 1) {
            sorted0.push_back(sorted12[i] - 1);
        }
    }
    radixPass(arr, sorted0, 0, k);
    vector<int> sa;
    int i = 0, j = 0;
    while(i < n0 || j < n12) {
        int index0 = sorted0[i];
        int index12 = sorted12[j];
        if(index12 >= n) {
            j++;
            continue;
        }
        if (i < n0 && (j == n12 || compare(arr, index0, index12, rank12))) {
            sa.push_back((i++, index0));
        } else {
            sa.push_back((j++, index12));
        }
    }
    return sa;
}


void radixPass(vector<int>& arr, vector<int>& indices, int offset, int k) {
    vector<int> count(k + 2, 0);
    for (int i = 0; i < indices.size(); ++i) {
        int j = indices[i] + offset;
        int ch  = j < arr.size() ? arr[j] : 0;
        count[ch + 1]++;
    }
    for (int i = 1; i < count.size(); ++i) {
        count[i] += count[i-1];
    }
    vector<int> temp(indices.size());
    for (int i = 0; i < indices.size(); ++i) {
        int j = indices[i] + offset;
        int ch  = j < arr.size() ? arr[j] : 0;
        temp[count[ch]++] = indices[i];
    }
    indices.assign(temp.begin(), temp.end());
}

bool compare(vector<int>& arr, int index0, int index12, vector<int>& rank) {
    int n = arr.size();
    if(arr[index0] != arr[index12]) {
        return arr[index0] < arr[index12];
    } else if(index0 == n - 1) {
        return false;
    } else if(index12 == n - 1) {
        return true;
    }
    if(index12 % 3 == 1) {
        return rank[getIndex(index0 + 1, n)] < rank[getIndex(index12 + 1, n)];
    }
    return !compare(arr, index12 + 1, index0 + 1, rank);
}

bool checkEqual(vector<int>& arr, int i, int j, int len) {
    if (len == 0)
        return true;
    return i < arr.size() && j < arr.size() && arr[i] == arr[j] && checkEqual(arr, i + 1, j + 1, len - 1);
}


int main() {
    // shin add-------------------
    clock_t start, end;
    double runTime;
    char *filename = "out_lower.txt";
    int n;
    char *data;
    printf("Please input the size of dataset you want to evaluate (10 - 1000000): \t");
    scanf("%d", &n);
    data = (char *) malloc((n+1)*sizeof(char));
    read_data(filename, data, n);
    data[n - 1] = '`';  // '`': 'a' - 1
    vector<int> arr(n);
    for (int i = 0; i < n; i++) {
        arr[i] = (int)(data[i] - '`');
    }
    // -------------------------------

    // vector<int> arr = {'m','i','s','s','i','s','s','i','p','p','i'};
    // for (int i = 0; i < arr.size(); ++i) {
    //     arr[i]-='a';
    // }

    start = clock(); // shin

    // vector<int> sa = dc3(arr, 26); // shin
    vector<int> sa = dc3(arr, 27);

    // shin ----------------
    end = clock();
    runTime = (end - start) / (double) CLOCKS_PER_SEC ;
    printf("CPU linear construct Suffix Array\nNUM: %d \t Time: %f Sec\n", n, runTime);
    // -------------------------


    // for (int i = 0; i < sa.size(); i++)
    //     cout << sa[i] << endl;

    // shin ----------------
    for (int i = 0; i < n; i++) {
        printf("%c ", sa[i]);
    }
    putchar('\n');
    // ---------------------

    free(data);  //shin
    return 0;
}