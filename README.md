# swimy

Swimy tranforms clusters in a graph into swimlanes like in processes modeling.

A first dot execution get the graph calculated and then pipe it to Swimy which does the magic and finally neato produce the final output.


Based on the type of nodes, swimy :
- moves triangle are locked on the left (or on the top).
- moves invtriangle are locked to the left (or the bottom).
- and clean every edges points to give some space to each line.

## Usage

For each sub graph (ie cluster), every LL (low left) position is capture and compare to the other one in order to find the one closest to the right.
Let's to the same with the UR (upper right) position to guess the one closest to the top of the graph.

It is required:
- to set a precise set of shapes for your nodes shape=triangle.
- to set constraint=false on some of your edges, the one that are not part of the happy path. otherwise your clusters may hide other.

##Commande lines
You need to choose if you want the graph to be "Top / Bottom" or "Left / right".
Use a input.dot as a sample graph.

Run the following command:
dot input.dot | gvpr -c -fswimy.g | neato -n2 -Tpng > output.png

or use those command to see intermiadary steps:
dot input.dot -o output.dot
neato -T png -O output.dot
dot input.dot | gvpr -c -falign_top.g -o output.dot


If you want to change the layout of you diagram, just change in input.dot, the rankdir value to TB or LR:

rankdir=TB;overlap=scalexy;splines=ortho;sep=1;nodesep=1;
rankdir=LR;overlap=scalexy;splines=ortho;sep=1;nodesep=1;
