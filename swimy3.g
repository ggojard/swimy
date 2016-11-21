BEG_G {
  //  --- VARIABLES
  graph_t sg;
  node_t n;
  edge_t e;
  double x, y, z, xoff = 0;
  double delta, miny = 1000.0, maxy = 0, minx = 1000.0, maxx = 0;
  double w, h, offset;
  double llx, lly, urx, ury, x_result, maxx_result;
  string ur;
  int isFirstCluster = 0;

  // --- Get MIN and MAX of clusters
  for (sg=fstsubg($);sg;sg=nxtsubg(sg)) {
    if (sg.name != "cluster*") continue;
    x = (double)xOf(llOf(sg.bb));
    minx = MIN(x,minx);
    x = (double)xOf(urOf(sg.bb));
    maxx = MAX(x,maxx);
    y = (double)yOf(urOf(sg.bb));
    maxy = MAX(y,maxy);
    y = (double)yOf(llOf(sg.bb));
    miny = MIN(y,miny);
  }
  // --- Get max result pos
  for (n=fstnode($);n;n=nxtnode(n)) {
    if (n.shape == "note*") {
      x_result = (double)xOf(n.pos);
      maxx_result = MAX(x_result,maxx_result);
    }
  }
  // box act
  // note invtriangle result
  // rect triange event

  w = 0.0;
  h = 0.0;
  pos = 0.0;

  // --- RESIZE and MOVE clusters
  for (sg=fstsubg($);sg;sg=nxtsubg(sg)) {
    if (sg.name != "cluster*") continue;

    sscanf (sg.bb, "%f,%f,%f,%f", &llx, &lly, &urx, &ury);
    w = urx - llx;
    h = ury - lly;
    offset = lly - pos;

    sg.bb = sprintf("%f,%f,%f,%f", minx, pos, maxx, pos + h);
    sg.lp = sprintf("%.03f,%.03f", minx + 50.0, pos + h - 12.0);
    sg.label += " / " + (string)h;
  // }

    // MOVE every Nodes inside cluster
    for (n=fstnode(sg); n; n=nxtnode_sg(sg,n)) {
      if ((isSubnode(sg, n) > 0) && (n.shape == "box*")){
        sscanf (n.pos, "%f,%f", &x, &y);
        n.pos = sprintf("%f,%f", x, y - offset );

        for (e=fstout(n);e;e=nxtout(e)) {
          e.pos = "";
        }
      }
    }
    pos = pos + h;
  }


  // --- REDRAW edges for Events and Results
  for (n=fstnode($);n;n=nxtnode(n)) {
    if (n.shape == "rect*") {
      n.pos = sprintf ("%s,%s", xOf(n.pos), maxy);
      for (e=fstout(n);e;e=nxtout(e)) {
        e.pos = "";
      }
    }
    if (n.shape == "note*") {
      n.pos = sprintf ("%f,%s", maxx_result, yOf(n.pos));
      for (e=fstin(n);e;e=nxtin(e)) {
        e.pos = "";
      }
    }
  }

  // // RE-DRAW edges
  // for (n=fstnode($);n;n=nxtnode(n)) {
  //   for (e=fstout(n);e;e=nxtout(e)) {
  //     e.pos = "";
  //   }
  // }

}

