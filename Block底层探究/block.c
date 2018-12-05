#include "stdio.h"
int main(){

__block int a = 10;
void (^block)(void) = ^{
printf("%d",a);
};
block();
return 0;
}
