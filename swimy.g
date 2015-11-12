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
  int k = 0;
  double delta, y, maxy = 0, miny = 0, minx = 0, maxx = 0;
  double lly, ury, llx = 0, diff = 0;
  double maxx_graph = 0, maxxR = 0;
  string ur, ll;
  int sg_list [graph_t];

  // max size of the graph
  maxy_graph = yOf(urOf($.bb));
  maxx_graph = xOf(urOf($.bb));
  int count_sg = -1;
  double offset, offset_cumul = 0, llx_offset;

  if ($.rankdir == "LR") {
    /* For each sub graph */
    /* get LL Low Left position of each subgraph */
    /* get UR Upper Right position of each sub graph */
    /* get min and max of every position */

    // Count and list all clusters before sorting
    for (sg=fstsubg($); sg ; sg=nxtsubg(sg)) {
      if (sg.name != "cluster*") continue;
        count_sg = count_sg + 1;
        list_sg[count_sg] = sg;
    }

    // sort all subgraphs based on their x pos from left to right
    for (sg=fstsubg($); sg ; sg=nxtsubg(sg)) {
      if (sg.name != "cluster*") continue;
      int i, j;
      graph_t temp;
      for (i = 0; i < (count_sg - 1); ++i)
      {
         for (j = 0; j < count_sg - 1 - i; ++j )
         {
              // if (list_sg[j] > list_sg[j+1])
              if (xOf(llOf(list_sg[j].bb)) > xOf(llOf(list_sg[j+1].bb)) )
              {
                   temp = list_sg[j+1];
                   list_sg[j+1] = list_sg[j];
                   list_sg[j] = temp;
              }
         }
       }
    }

    // MIN and MAX among all sub graphs
    for (k = 0; k <= count_sg; ++k) {
      lly = (double)yOf(llOf(list_sg[k].bb));
      ury = (double)yOf(urOf(list_sg[k].bb));
      miny = MIN(lly, miny);
      maxy = MAX(ury, maxy);
    }

    // RESIZE the first cluster
    list_sg[0].bb = sprintf ("%s,%s,%.03f,%.03f", xOf(llOf(list_sg[0].bb)), miny, xOf(urOf(list_sg[0].bb)), maxy_graph);
    list_sg[0].lp = sprintf ("%s,%.03f", xOf(list_sg[0].lp), maxy);

    // RESIZE each sub graph to MAX
    for (k = 1; k <= count_sg; ++k) {

      sscanf (n.pos, "%f,%f", &x, &y);
      n.pos = sprintf("%f,%f",  x + xoff[n], y);

      llx = (double)xOf(llOf(list_sg[k].bb));
      urx = (double)xOf(urOf(list_sg[k].bb));
      llx_previous = (double)xOf(llOf(list_sg[k-1].bb));
      urx_previous = (double)xOf(urOf(list_sg[k-1].bb));

      delta = (double)llx - (double)urx_previous;
      // si cluster actuel est

      if (delta <= 0) {
        // clusters are on each other, Need to move them
        offset = (double)urx_previous - (double)llx_previous;
      }
      else {
        // cluster are not on each other, no need to move them
        offset = 0.0;
      }

      // Resize FULL graph frame
      // if (k < count_sg) { // except for the last cluster
        new_graph_width = (double)xOf(urOf($.bb)) + offset;
        $.bb = sprintf ("0,0,%.0f,%.0f", new_graph_width, (double)yOf(urOf($.bb)));
      // }

      // Move cluster and labels
      offset_cumul = offset_cumul + offset + 10.0;
      // offset_cumul = offset_cumul + largeur du previous cluster + marge de 10.0
      llx = llx + offset_cumul;
      urx = urx + offset_cumul;
      list_sg[k].bb = sprintf ("%s,%s,%.01f,%.01f", llx, miny, urx, maxy_graph);
      double lpx = xOf(list_sg[k].lp) + offset_cumul;
      list_sg[k].lp = sprintf ("%s,%.03f", lpx, maxy);

      // move every other Nodes
      for (n=fstnode(list_sg[k]);n;n=nxtnode_sg(list_sg[k],n)) {
        if (n == NULL){
          break;
        }
        if ((isSubnode(list_sg[k], n) > 0) && (n.shape == "box*")){
          double newX = xOf(n.pos) + offset_cumul;
          n.pos = sprintf ("%.0f,%.0f", newX, yOf(n.pos));
          n.label += sprintf (" - %.0f,%.0f", newX, yOf(n.pos));
        }
      }
    }

    maxy_graph = yOf(urOf($.bb));
    maxx_graph = xOf(urOf($.bb));

    /* push all events to min left */
    for (n=fstnode($);n;n=nxtnode(n)) {
      if (n.shape == "triangle*") {
        n.pos = sprintf ("%.01f,%.0f", xOf(n.pos), yOf(n.pos)); //xOf(n.pos), maxy_graph);
        for (e=fstout(n);e;e=nxtout(e)) {
          e.pos = "";
        }
      }
    }

    /* push all results to max right */
    for (n=fstnode($);n;n=nxtnode(n)) {
      if (n.shape == "invtriangle*") {
        n.pos = sprintf ("%f,%f", maxx_graph, yOf(n.pos)); // xOf(n.pos), yOf(n.pos));
        for (e=fstin(n);e;e=nxtin(e)) {
          e.pos = "";
        }
      }
    }

  }
  else { /////////////////////// for TB  /////////////////////////////////////

    /* for each sub graph */
    /* get LL Low Left position of each subgraph */
    /* get UR Upper Right position of each subgraph */
    /* get min and max of every position*/
    for (sg=fstsubg($); sg ; sg=nxtsubg(sg)) {
      if (sg.name == "cluster*") {
        llx = (double)xOf(llOf(sg.bb));
        urx = (double)xOf(urOf(sg.bb));
        minx = MIN(llx, minx);
        maxx = MAX(urx, maxx);
      }
    }

    /* for each sub graph */
    for (sg=fstsubg($);sg;sg=nxtsubg(sg)) {
      if (sg.name == "cluster*") {
        lly = (double)yOf(llOf(sg.bb));
        ury = (double)yOf(urOf(sg.bb));
        delta = minx-xOf(sg.bb);
        sg.bb = sprintf ("%s,%s,%.03f,%.03f", minx, lly, maxx_graph, ury);
        // sg.lp = sprintf ("%.03f,%s",xOf(sg.lp)+delta, yOf(sg.lp));
        sg.lp = sprintf ("%.03f,%s",30.0, yOf(sg.lp));
      }
    }


    /* find max result pos right */
    for (n=fstnode($);n;n=nxtnode(n)) {
      if (n.shape == "invtriangle*") {
        maxxR = MAX((double)xOf(n.pos), maxxR);
        n.pos = sprintf ("%s,%s", xOf(n.pos), "0" );
        for (e=fstin(n);e;e=nxtin(e)) {
          e.pos = "";
        }
      }
    }

  }

  /* ****************** IN ALL CASES */
  /* reset all edges of activities */
  for (n=fstnode($);n;n=nxtnode(n)) {
    if (n.shape == "box*") {
      for (e=fstout(n);e;e=nxtout(e)) {
        e.pos = "";
        // printf("Node %s - indegree %d, outdegree %d\n", n.name, n.indegree, n.outdegree);
      }
      // n.label = n.label + sprintf (": %s,%s", n.indegree, n.outdegree);

      // n.height = n.height + (n.indegree + n.outdegree) * 0.10;
      // n.width = n.width + (n.indegree + n.outdegree) * 0.10;
    }
  }

}