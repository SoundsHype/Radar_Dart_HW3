import 'dart:io';

class Node{
	int? d, pi;
	Node(this.d, this.pi);
}

class Edge{
	int u, v, w;
	Edge(this.u, this.v, this.w);
}

class Graf{
	List<Edge> edges = [];
	List<Node> nodes = [];

	void init(int base){
		nodes.forEach((elem){
			elem.d = null;
			elem.pi = null;
		});
		nodes[base].d = 0;
	}

	Graf(String fileName){
		File myFile = new File(fileName);
		List<String> line = myFile.readAsLinesSync();
		for (int i = 0; i < line.length; i++)
			nodes.add(Node(null, null));
		for (int i = 0; i < line.length; i++){
			List<String> help = line[i].split(" ");
			for (int j = 0; j < help.length; j++){
				if (help[j] != "n")
					edges.add(Edge(i, j, int.parse(help[j])));
			}
		}
	}

	void relax(Edge temp){
		if (nodes[temp.v].d == null && nodes[temp.u].d == null){
			nodes[temp.v].d = temp.w;
			nodes[temp.v].pi = temp.u;
			return;
		}
		if (nodes[temp.v].d == null){
			nodes[temp.v].d = nodes[temp.u].d! + temp.w;
			nodes[temp.v].pi = temp.u;
			return;
		}
		if (nodes[temp.u].d == null)
			if (nodes[temp.v].d! > temp.w){
				nodes[temp.v].d = temp.w;
				nodes[temp.v].pi = temp.u;
				return;
			} else
				return;
		if (nodes[temp.v].d! > (nodes[temp.u].d! + temp.w)){
			nodes[temp.v].d = nodes[temp.u].d! + temp.w;
			nodes[temp.v].pi = temp.u;
		}

	}

	void bellman_ford(int base){
		init(base - 1);
		for (int i = 0; i < nodes.length; i++)
			edges.forEach((elem){
				relax(elem);
			});
	}
}

void main(){
	var graf = Graf("graf.txt");
	graf.bellman_ford(2);
	for (int i = 1; i <= graf.nodes.length; i++)
		print("Node $i: ${graf.nodes[i-1].d}");
}

	
	