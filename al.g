BEG_G {
  graph_t sg;
  node_t n;
  edge_t e;
  double x, y, z, xoff = 0;
  double delta, miny = 1000.0, maxy = 0;
  double w, h;
  double llx, lly, urx, ury;
  string ur;

  // Get MIN and MAX of clusters
  for (sg=fstsubg($);sg;sg=nxtsubg(sg)) {
    if (sg.name != "cluster*") continue;
    y = (double)yOf(urOf(sg.bb));
    maxy = MAX(y,maxy);
    y = (double)yOf(llOf(sg.bb));
    miny = MIN(y,miny);
  }

  // RESIZE and MOVE clusters
  for (sg=fstsubg($);sg;sg=nxtsubg(sg)) {
    if (sg.name != "cluster*") continue;

    sscanf (sg.bb, "%f,%f,%f,%f", &llx, &lly, &urx, &ury);
    w = urx - llx;
    h = ury - lly;

    // RESIZE GRAPH drawing area
    $.bb = (double)xOf(urOf($.bb)) + xoff + 30.0;

    // if(xoff == 0) {xoff = llx;}
    // sg.bb = sprintf("%f,%f,%f,%f", xoff, miny, xoff + w, maxy);
    sg.bb = sprintf("%f,%f,%f,%f", llx + xoff, miny, urx + xoff, maxy);
    sg.lp = sprintf ("%.03f,%.03f",llx + xoff + 40.0, maxy - 12.0);
    sg.label += " + " + (string)xoff;

    // MOVE every Nodes inside cluster
    for (n=fstnode(sg); n; n=nxtnode_sg(sg,n)) {
      if ((isSubnode(sg, n) > 0) && (n.shape == "box*")){
        sscanf (n.pos, "%f,%f", &x, &y);
        n.pos = sprintf("%f,%f", x + xoff, y);
        n.label += " + " + (string)xoff;
        // RE-DRAW edges
        for (e=fstout(n); e; e=nxtout(e)) {
          e.pos = "";
        }
      }
    }

    // xoff = urx;
    xoff += w + 10.0;
  }
  // REDRAW edges for Events and Results
  for (n=fstnode($);n;n=nxtnode(n)) {
    if (n.shape == "triangle*") {
      n.pos = sprintf ("%s,%s", xOf(n.pos), maxy);
      for (e=fstout(n);e;e=nxtout(e)) {
        e.pos = "";
      }
    }

    if (n.shape == "invtriangle*") {
      // n.pos = sprintf ("%f,%s", xOf(urOf($.bb)) - 30.0, yOf(n.pos));
      for (e=fstin(n);e;e=nxtin(e)) {
        e.pos = "";
      }
    }
  }

}

