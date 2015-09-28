# swimy

Swimy tranforms clusters in a graph into swimlanes like in processes modeling.


## Usage

Use a sample_graph.dot as an input


##Commande lines
You need to choose if you want the graph to be Top / Bottom or Left / right.


### Top Bottom TB
In the input file, use the following line:
rankdir=TB;overlap=scalexy;splines=ortho;sep=1;nodesep=1;

Then run this command:
dot gg.dot | gvpr -c -falign_left.g | neato -n2 -Tpng > out_gg_TB_loop.png


### Left Right LR
In the input file, use the following line:
rankdir=LR;overlap=scalexy;splines=ortho;sep=1;nodesep=1;

Then run this command:
dot gg.dot | gvpr -c -falign_top.g | neato -n2 -Tpng > out_gg_LR_loop.png
