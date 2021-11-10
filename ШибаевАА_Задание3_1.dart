import 'dart:io';
import 'dart:isolate';
import 'dart:async';

void sort(List<Object> array) async {
	List<int> help = [];
	SendPort senPort = array.last as SendPort;
	if (array.last is int){
		array.forEach((elem){
			help.add(elem as int);
		});
	} else
		help = array.first as List<int>;
	int middle = help.length ~/ 2;

	if (help.length < 2)
		senPort.send(help);
	else {
		ReceivePort getPort = ReceivePort();
		Isolate isolate1 = await Isolate.spawn(sort, [help.sublist(0, middle), getPort.sendPort]);
		Isolate isolate2 = await Isolate.spawn(sort, [help.sublist(middle, help.length), getPort.sendPort]);
		List<int> a = [], b = [];
		int i = 0;
		getPort.listen((message){
			switch (i){
				case 0:
					a = message;
				break;
				case 1:
					b = message;
					getPort.close(); 
				break;
			}
			i++;
		}, onDone: () {
			help = [];
			while (!(a.isEmpty) || !(b.isEmpty)){
				if (a.isEmpty){
					help.add(b.first);
					b.removeAt(0);
				} else if (b.isEmpty){
						help.add(a.first);
						a.removeAt(0);
					} else if (a.first < b.first){
							help.add(a.first);
							a.removeAt(0);
						} else {
							help.add(b.first);
							b.removeAt(0);
						}
			}
			senPort.send(help);
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