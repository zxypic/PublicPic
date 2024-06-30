# include <stdio.h>
# define N 5

int main() {
    int a[N];
    int i;
    a[0]=1,a[1]=2;
    for (i = 2; i < N; i++)
    {
        a[i]=3*a[i-2]+a[i-1]+1;
    }
    printf("%d\n",a[N-1]);
    
    int x = 1,y;
    do { y = x*2+1;x=y; } while (y<30);
    printf("y==%d\nx=%d",y,x);
}