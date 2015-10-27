BEGIN {
   }

BEG_G {
/*
dot input.dot | gvpr -c -fswimy.g | neato -n2 -Tpng > output.png
  dot input.dot | gvpr -c -fswimy.g | neato -n2  > output.dot

   dot input.dot | gvpr -c -fswimy.g > output.dot | grep -E "(pos)|(bb)"


*/
  // $.bb = "";
  graph_t sg, other_sg;
  graph_t list_sg[];
  node_t n;
  edge_t e;
  int i, j, k;
  double x, y, z, xoff = 0;
  double maxy = 0, miny = 0, minx = 0, maxx = 0;
  double urx, ury, llx, lly, diff = 0;
  double maxx_graph = 0, maxxR = 0;
  string ur, ll;
  int sg_list [graph_t];

  /* max size of the graph  */
  maxy_graph = yOf(urOf($.bb));
  maxx_graph = xOf(urOf($.bb));
  double InchPointRatio = 72.0;
  double textMargin = 12.0;
  int count_sg = -1;
  double offset, offset_cumul = 0, llx_offset;

  if ($.rankdir == "LR") {
    /* COUNT and list all clusters before sorting */
    for (sg=fstsubg($); sg ; sg=nxtsubg(sg)) {
      if (sg.name != "cluster*") continue;
        count_sg = count_sg + 1;
        list_sg[count_sg] = sg;
    }

    /* SORT all subgraphs based on their x pos from left to right */
    for (sg=fstsubg($); sg ; sg=nxtsubg(sg)) {
      if (sg.name != "cluster*") continue;
      graph_t temp;
      for (i = 0; i < (count_sg - 1); ++i)
      {
        for (j = 0; j < count_sg - 1 - i; ++j )
        {
          if (xOf(llOf(list_sg[j].bb)) > xOf(llOf(list_sg[j+1].bb)) )
          {
            temp = list_sg[j+1];
            list_sg[j+1] = list_sg[j];
            list_sg[j] = temp;
          }
        }
      }
    }

    /* MIN and MAX among all sub graphs */
    for (k = 0; k <= count_sg; ++k) {
      lly = (double)yOf(llOf(list_sg[k].bb));
      ury = (double)yOf(urOf(list_sg[k].bb));
      miny = MIN(lly, miny);
      maxy = MAX(ury, maxy);
    }

    /* RESIZE each sub graph to MAX */
    for (k = 0; k <= count_sg; ++k) {
      sg = list_sg[k];
      sscanf (sg.bb, "%f,%f,%f,%f", &llx, &lly, &urx, &ury);
      w = urx - llx;
      h = ury - lly;

      sg.bb = sprintf("%f,%f,%f,%f", llx + xoff, miny, urx + xoff, maxy);
      xoff += w + 10.0;

      sscanf (sg.lp, "%f,%f", &x, &y);
      sg.lp = sprintf("%f,%f", x + xoff / InchPointRatio, maxy - textMargin);
      sg.label += " - " + k;

      // RESIZE FULL graph frame
      new_graph_width = (double)xOf(urOf($.bb)) + offset;
      $.bb = sprintf ("0,0,%f,%f", new_graph_width, maxy_graph);

      // MOVE every other Nodes
      for (n=fstnode(sg); n; n=nxtnode_sg(sg,n)) {
        if ((isSubnode(sg, n) > 0) && (n.shape == "box*")){
          sscanf (n.pos, "%f,%f", &x, &y);
          n.pos = sprintf("%f,%f", x + xoff , y);
          for (e=fstout(n); e; e=nxtout(e)) {
            //e.pos = "";
          }
        }
      }

    }
  }
  ///////////////////////////////////////////////////////////////////

  /* reset all edges of activities */
  for (n=fstnode($); n; n=nxtnode(n)) {
    // if (n.shape == "box*") {
      for (e=fstout(n);e;e=nxtout(e)) {
        // e.pos = "";
      }
    // }
  }

}