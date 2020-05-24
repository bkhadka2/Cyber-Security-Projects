#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

char **fizzbuzz(int fizzNum, int buzzNum, int num) {  // returning base address of an array of strings
  char buffer[20];
  static char *arrayOfString[7];
  for(int i = 1; i <= num; ++i) {
    if(i % fizzNum == 0 && i % buzzNum == 0) {
      arrayOfString[i-1] = "FizzBuzz";
    }
    else if(i % fizzNum == 0) {
      arrayOfString[i-1] = "Fizz";
    }
    else if(i % buzzNum == 0) {
      arrayOfString[i-1] = "Buzz";
    }
    else {
      sprintf(buffer, "%d", i);  // converting integer into string
      char *strings = strdup(buffer); // duplicating and copying the buffer into strings variable
      arrayOfString[i-1] = strings;
    }
  }
  return arrayOfString;  // Returning the base address of an array
}

void testFunction() {
  int fizz[3] = {3, 4, 5};
  int buzz[3] = {4, 5, 6};
  int numOfIteration[1] = {7};
  char *testingAnswer[3][10] = {{"1", "2", "Fizz", "Buzz", "5", "Fizz", "7"}, {"1", "2", "3", "Fizz", "Buzz", "6", "7"}, {"1", "2", "3", "4", "Fizz", "Buzz", "7"}};
  char *answer[7];
  for(int i = 0; i < 3; ++i) {
    char ** testing = fizzbuzz(fizz[i], buzz[i], numOfIteration[0]);
    for(int j = 0; j < numOfIteration[0]; ++j) {
      answer[j] = *(testing + j);
    }
    for(int k = 0; k < numOfIteration[0]; ++k) {
      for(int l = 0; l < strlen(answer[k]) ; ++l) {
        assert(testingAnswer[i][k][l] == answer[k][l]);
      }
    }
  }
  printf("%s\n", "Test cases passed" );
}

void mainHelper() {
  int x, y, n;
  scanf("%d", &x);  //inputting values in a variable
  scanf("%d", &y);
  scanf("%d", &n);
  char **a;
  a = fizzbuzz(x, y, n);
  for(int i = 0; i < n; ++i) {
    printf("%s\n", a[i]);
  }
}

int main(int argc, const char ** argv) {
  if(argc > 1 && strncmp(argv[1], "test", 4) == 0) {
    testFunction();
  }
  else {
    mainHelper();
  }
  return 0;
}
