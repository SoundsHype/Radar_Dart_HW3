void main(){
	List<List<int>> a = [[38, 89, 96], [8, 30, 51], [13, 14, 23, 51]];
	while (!a.isEmpty){
		int min = a[0][0];
		for (int i = 0; i < a.length; i++)
			if (a[i][0] < min)
				min = a[i][0];
		for (int i = 0; i < a.length; i++)
			if (a[i][0] == min){
				print(a[i][0]);
				a[i].removeAt(0);
				break;
			}
		for (int i = 0; i < a.length; i++)
			if (a[i].isEmpty)
				a.removeAt(i);
	}
	print("Hello");
}