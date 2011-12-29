public class Cut {
   public int getMaximum(int[] eelLengths, int maxCuts) {	
	   int count=0;
	   for (int i = 0; i < eelLengths.length; i++) {
		   if(eelLengths[i]==10)count++;
	   }
	   eel=new int[eelLengths.length-count];
	   int place=0;
	   for (int i = 0; i < eelLengths.length; i++) {
		   if(eelLengths[i]==10)continue;
		   eel[place++]=eelLengths[i];
	   }
	   memo = new int[eel.length][102][maxCuts+2];
	   for (int i = 0; i < memo.length; i++) {
		   for (int j = 0; j < memo[i].length; j++) {
			   Arrays.fill(memo[i][j], -1); 
		   }
	   }
	   return dfs(0, 0, maxCuts)+count;
   }
   int [] eel;
   int [][][] memo;
   int dfs (int start , int here , int left){
	   if(start==eel.length)return 0;
	   if(perfectLuck(start,here))return memo[start][here][left]=dfs(start+1,0,left)+1;
	   if(left==0)return 0;
	   if(memo[start][here][left]!=-1)return memo[start][here][left];
	   int ret=0;
	   if(cancut(start,here))ret=Math.max(ret, dfs(start,here+1,left-1)+1);
	   ret=Math.max(ret, dfs(start+1,0,left));
	   return memo[start][here][left]=ret;
   }

private boolean cancut(int start, int here) {
	// TODO Auto-generated method stub
	return eel[start]-here*10>10;
}

private boolean perfectLuck(int start, int here) {
	// TODO Auto-generated method stub
	return eel[start]-here*10==10;
}
}