/* Some useless stuff I purposely added */
/* More
    useless stuff */
    
/** nicee */
 
public class HeapSorter 
{
    private static int[] a;
    private static int n;

    public static void sort(int[] a0)
    {
        a=a0;
        n=a.length;
        heapsort();
    }

    private static void heapsort()
    {
        buildheap();
        while (n>1)
        {
            n--;
            exchange (0, n);
            downheap (0);
        } 
    }

    private static void buildheap()
    {
        for (int v=n/2-1; v>=0; v--)
            downheap (v);
    }

    private static void downheap(int v)
    {
        int w=2*v+1;    // first descendant of v
        while (w<n)
        {
            if (w+1<n)    // is there a second descendant?
                if (a[w+1]>a[w]) w++;
            // w is the descendant of v with maximum label

            if (a[v]>=a[w]) return;  // v has heap property
            // otherwise
            exchange(v, w);  // exchange labels of v and w
            v=w;        // continue
            w=2*v+1;
        }
    }

    private static void exchange(int i, int j)
    {
        int t=a[i];
        a[i]=a[j];
        a[j]=t;
    }

}    // end class HeapSorter