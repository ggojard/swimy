BEG_G {
/*
exec line:
dot gg.dot | gvpr -c -falign_top.g | neato -n2 -Tpng > out_gg_LR_loop.png
*/
  graph_t sg, other_sg;
  node_t n;
  edge_t e;
  double delta, y, maxy = 0, miny = 0, minx = 0, maxx = 0;
  double lly, ury;
  double maxx_graph = 0, maxxR = 0;
  string ur, ll;

  /* max size of the graph  */
  maxy_graph = yOf(urOf($.bb));
  maxx_graph = xOf(urOf($.bb));

  if ($.rankdir == "LR") {

    /* For each sub graph */
    /* get LL Low Left position of each subgraph */
    /* get UR Upper Right position of each subgraph */
    /* get min and max of every position */
    for (sg=fstsubg($); sg ; sg=nxtsubg(sg)) {
      if (sg.name != "cluster*") continue;
      lly = (double)yOf(llOf(sg.bb));
      ury = (double)yOf(urOf(sg.bb));
      miny = MIN(lly, miny);
      maxy = MAX(ury, maxy);
    }

    /* for each sub graph */
    for (sg=fstsubg($);sg;sg=nxtsubg(sg)) {
      if (sg.name != "cluster*") continue;
      llx = (double)xOf(llOf(sg.bb));
      urx = (double)xOf(urOf(sg.bb));
      delta = maxy-yOf(sg.bb);
      sg.bb = sprintf ("%s,%s,%.03f,%.03f", llx, miny, urx, maxy_graph);
      sg.lp = sprintf ("%s,%.03f", xOf(sg.lp), maxy); //yOf(sg.lp)+delta
    }

    /* push all events to min left */
    for (n=fstnode($);n;n=nxtnode(n)) {
      if (n.shape == "triangle*") {
        n.pos = sprintf ("%s,%s", xOf(n.pos), maxy_graph); //yOf(n.pos));
        for (e=fstout(n);e;e=nxtout(e)) {
          e.pos = "";
        }
      }
    }

    /* push all results to max right */
    for (n=fstnode($);n;n=nxtnode(n)) {
      if (n.shape == "invtriangle*") {
        n.pos = sprintf ("%s,%s", maxx_graph, yOf(n.pos));
        for (e=fstin(n);e;e=nxtin(e)) {
          e.pos = "";
        }
      }
    }

  }
  else {

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