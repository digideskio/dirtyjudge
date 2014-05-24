#include <stdio.h>
#include <iostream>
#include <algorithm>
using namespace std;

#define long long long
#define f1(i,n) for (int i=1; i<=n; i++)
#define f0(i,n) for (int i=0; i<n; i++)

#define N 10000007
int Left[N], Right[N], Child[N], Peak=0;
long GCD[N];

int create(long Value){
  int id = ++Peak;
  Left[id]=Right[id]=0;
  GCD[id]=Value;
  return id;
}

struct node1 {
  int ll, rr, id;
  void update(int u, long Value){
    if (ll>u || u>rr) return ;
    if (ll==rr) { GCD[id]=Value; return; }
    expand(id);
    left().update(u, Value);
    right().update(u, Value);
    update(id);
  }
  long gcd_range(int L, int R){
    if (L>rr || ll>R || L>R) return 0;
    if (L<=ll && rr<=R || GCD[id]==0) return GCD[id];
    long G1 = left().gcd_range(L, R);
    long G2 = right().gcd_range(L, R);
    return __gcd(G1, G2);
  }
};

struct node2 {
  int ll, rr, id;
  void update(int u, int u1, long Value){
    if (ll>u || u>rr) return ;
    if (ll==rr) { child().update(u1, Value); return; }
    if (!Left[id]) expand(id);
    left().update(u, u1, Value);
    right().update(u, u1, Value);
    child().;
  }
  long gcd_range(int L, int R){
    if (L>rr || ll>R || L>R) return 0;
    if (L<=ll && rr<=R || GCD[id]==0) return GCD[id];
    long G1 = left().gcd_range(L, R);
    long G2 = right().gcd_range(L, R);
    return __gcd(G1, G2);
  }
}

main(){

}


