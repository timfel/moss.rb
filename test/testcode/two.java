public class QuickSort{
  public static void main(String a[]){
  int i;
  int array[] = {12,9,4,99,120,1,3,10,13};

  System.out.println("\n\n RoseIndia\n\n");
  System.out.println(" Quick Sort\n\n");
  System.out.println("Values Before the sort:\n");
  for(i = 0; i < array.length; i++)
  System.out.print( array[i]+"  ");
  System.out.println();
  quick_srt(array,0,array.length-1);
  System.out.print("Values after the sort:\n");
  for(i = 0; i <array.length; i++)
  System.out.print(array[i]+"  ");
  System.out.println();
  System.out.println("PAUSE");
  }

  public static void quick_srt(int array[],int low, int n){
  int lo = low;
  int hi = n;
  if (lo >= n) {
  return;
  }
  int mid = array[(lo + hi) / 2];
  while (lo < hi) {
  while (lo<hi && array[lo] < mid) {
  lo++;
  }
  while (lo<hi && array[hi] > mid) {
  hi--;
  }
  if (lo < hi) {
  int T = array[lo];
  array[lo] = array[hi];
  array[hi] = T;
  }
  }
  if (hi < lo) {
  int T = hi;
  hi = lo;
  lo = T;
  }
  quick_srt(array, low, lo);
  quick_srt(array, lo == low ? lo+1 : lo, n);
  }
}
