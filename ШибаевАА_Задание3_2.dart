import 'dart:io';

class Node{
	double d;
	int? pi;
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
			elem.d = 1.0 / 0.0;
			elem.pi = null;
		});
		nodes[base].d = 0;
	}

	Graf(String fileName){
		File myFile = new File(fileName);
		List<String> line = myFile.readAsLinesSync();
		for (int i = 0; i < line.length; i++)
			nodes.add(Node(1.0 / 0.0, null));
		for (int i = 0; i < line.length; i++){
			List<String> help = line[i].split(" ");
			for (int j = 0; j < help.length; j++){
				if (help[j] != "n")
					edges.add(Edge(i, j, int.parse(help[j])));
			}
		}
	}

	void relax(Edge temp){
		if (nodes[temp.v].d > (nodes[temp.u].d + temp.w)){
			nodes[temp.v].d = nodes[temp.u].d + temp.w;
			nodes[temp.v].pi = temp.u;
		}
	}

	bool bellman_ford(int base){
		init(base - 1);
		for (int i = 0; i < nodes.length; i++)
			edges.forEach((elem){
				relax(elem);
			});
		for (int i = 0; i < edges.length; i++)
			if (nodes[edges[i].v].d > (nodes[edges[i].u].d + edges[i].w))
				return false;
		return true;
	}
}

void main(){
	var graf = Graf("graf.txt");
	if (!graf.bellman_ford(1))
		print("Graf have negative weight cycle");
	else
		for (int i = 1; i <= graf.nodes.length; i++)
			print("Node $i: ${graf.nodes[i-1].d}");
}