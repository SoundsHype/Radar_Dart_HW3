import 'dart:io';
import 'dart:isolate';
import 'dart:async';

List<int> merge(List<List<int>> a){
	List <int> out = [];
	while (!a.isEmpty){
		int min = a[0][0];
		for (int i = 0; i < a.length; i++)
			if (a[i][0] < min)
				min = a[i][0];
		for (int i = 0; i < a.length; i++)
			if (a[i][0] == min){
				out.add(a[i][0]);
				a[i].removeAt(0);
				break;
			}
		for (int i = 0; i < a.length; i++)
			if (a[i].isEmpty)
				a.removeAt(i);
	}
	return out;
}

void sort(List<dynamic> array) async {
	List<int> help = [];
	SendPort senPort = array.last as SendPort;

	help = array.first as List<int>;

	if (help.length < 2)
		senPort.send(help);
	else {
		ReceivePort getPort = ReceivePort();
		List<Isolate> isol = [];
		int N = 20, position = 0;
		if (help.length < N)
			N = help.length;

		int count = help.length ~/ N;
		for (int i = 0; i < N - 1 ; i++)
			isol.add(await Isolate.spawn(sort, [help.sublist(position, position += count), getPort.sendPort]));
		isol.add(await Isolate.spawn(sort, [help.sublist(position, help.length), getPort.sendPort]));

		List<List<int>> all = [];
		getPort.listen((message){
			all.add(message);
			if (all.length == isol.length)
				getPort.close(); 
		}, onDone: () {
			senPort.send(merge(all));
		});

	}
}

class Array{
	List<int> sortArray = [];

	Array(String fileName){
		File myFile = new File(fileName);
		List<String> fileArray = myFile.readAsLinesSync();
		fileArray = fileArray.first.split(" ");
		List<int> intArray = [];
		fileArray.forEach((elem){
			intArray.add(int.parse(elem));
		});
		changeArray = intArray;
	}

	List<int> get getArray => sortArray;

	set changeArray(List<int> array) => sortArray = array;

	void writeIn(String fileName){
		File myFile = new File(fileName);
		myFile.writeAsStringSync("\n\n" + sortArray.join(" "), mode: FileMode.APPEND);
	}
}

void main(){
	var array = Array("array.txt");
	ReceivePort mainIsolatePort = ReceivePort();

	sort([array.getArray, mainIsolatePort.sendPort]);

	mainIsolatePort.listen((message){
		array.changeArray = message;
		mainIsolatePort.close();  
	}, onDone: (){
		array.writeIn("array.txt");
	});
}