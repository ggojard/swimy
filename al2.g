BEG_G {
  //  --- VARIABLES
  graph_t sg;
  node_t n;
  edge_t e;
  double x, y, z, xoff = 0;
  double delta, miny = 1000.0, maxy = 0, minx = 1000.0, maxx = 0;
  double w, h;
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
    if (n.shape == "invtriangle*") {
      x_result = (double)xOf(n.pos);
      maxx_result = MAX(x_result,maxx_result);
    }
  }

  // --- RESIZE and MOVE clusters
  for (sg=fstsubg($);sg;sg=nxtsubg(sg)) {
    if (sg.name != "cluster*") continue;

    sscanf (sg.bb, "%f,%f,%f,%f", &llx, &lly, &urx, &ury);
    sg.bb = sprintf("%f,%f,%f,%f", llx, miny, urx, maxy);
    sg.lp = sprintf ("%.03f,%.03f",llx + 40.0, maxy - 12.0);
  }


  // --- REDRAW edges for Events and Results
  for (n=fstnode($);n;n=nxtnode(n)) {
    if (n.shape == "triangle*") {
      n.pos = sprintf ("%s,%s", xOf(n.pos), maxy);
      for (e=fstout(n);e;e=nxtout(e)) {
        e.pos = "";
      }
    }
    if (n.shape == "invtriangle*") {
      n.pos = sprintf ("%f,%s", maxx_result, yOf(n.pos));
      for (e=fstin(n);e;e=nxtin(e)) {
        e.pos = "";
      }
    }
  }

}

