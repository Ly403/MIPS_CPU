#include <stdio.h> 
int main()
{
	int K = 5, N = 10, broken = 5; //�����N��¥��K���������ڵ�5��¥��
	int best = 0x7fffffff; //int�����ֵ
	int eggs, num;
	bool finalFlag;
	for (int z = 0; z <= K; z++) {
		bool flag = false;//��ʼ��Ϊûˤ��
        int dp[z + 1][N + 1] = {};

		int m = 0;
		while (dp[z][m] < N) {
			m++;
			for (int k = 1; k <= z; k++) {
				dp[k][m] = dp[k][m - 1] + dp[k - 1][m - 1] + 1;
				flag = dp[k][m] >= broken;//��ǰ��dp[k][m]����broken¥�����һ������������
			}
		}
		if (best > m + z) {
			best = m + z;
			eggs = z;
			num = m;
			finalFlag = flag;
		}	
	}
	printf("eggs = %d\n", eggs);
	printf("num = %d\n", num);
	printf("flag = %d\n", finalFlag);
	printf("best = %d\n", best);
	return 0;
}
