#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

int *positiveOddEven(int num1, int num2) {
  static int listOfNumbers[4] = {};  // C doesn't allow local array to return
  listOfNumbers[0] = num1;
  listOfNumbers[1] = (num2*(num2+1)) / 2;  // Sum of n positive numbers
  listOfNumbers[2] = num2*num2;  // Sum of n odd numbers
  listOfNumbers[3] = num2*(num2 + 1);  // Sum of n even numbers
  return listOfNumbers;  // returning pointer to an array
}

// Test Function
void testFunction() {
  int num1[3] = {1, 5, 8};
  int num2[3] = {1, 112, 1113};
  int ans[4];
  int answer[3][4] = {{1, 1, 1, 2}, {5, 6328, 12544, 12656}, {8, 619941, 1238769, 1239882}};
  for(int i = 0; i < 3; ++i) {
    int * testingArray = positiveOddEven(num1[i], num2[i]);
    for(int j = 0; j < 4; ++j){
      ans[j] = *(testingArray+j);
      assert(ans[j] == answer[i][j]);
    }
  }
  printf("%s\n", "Test cases passed" );
}

void mainHelper() {
  int P, firstNum, secondNum;
  int *result;
  scanf("%d", &P);
  for(int i = 0; i < P; ++i) {
    scanf("%d", &firstNum);
    scanf("%d", &secondNum);
    result = positiveOddEven(firstNum, secondNum);  //Pointing to pointer returning function
    for(int i = 0; i < 4; ++i) {
      printf("%d ", *(result+i));  // derefrencing the pointer with an memory address increment of i
    }
    printf("\n");
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
