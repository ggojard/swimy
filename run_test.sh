#!/bin/sh
#
# generate graph for test of a gvpr script in the graph transformation
#

# if [ $# != 0 ]
# then
#   echo "Usages:"
#   echo "  generate.sh [scope]"
#   echo "    [scope] = all | simple | complex"
#   echo ""
#   echo "Examples:"
#   echo "  generate.sh all"
#   echo "  create-release.sh 2.9.0 tags/RELEASE_2_9_0"
#   exit 65
# fi

echo "--------- START generating DOT ---------"

dot input/input.dot -o output_d.dot
echo " - output_d.dot"

dot input/input.dot | neato -n2 > output_dn.dot
echo " - output_dn.dot"

dot input/input.dot | gvpr -c -fal2.g | neato -n2 > output_dsn.dot
echo " - output_dsn.dot"

# dot input/input_boucle_constraints.dot > output_d_boucle_constraints.dot
# neato -n2 output_d_boucle_constraints.dot -Tpng > output/output_n_boucle_constraints.png
echo " - output/test.png"

echo
echo "--------- START generating PNG ---------"

dot input/input.dot -Tpng -o output/output_d.png
echo " - output/output_d.png"

dot input/input.dot | neato -n2 -Tpng > output/output_dn.png
echo " - output/output_dn.png"

dot input/input.dot | gvpr -c -fal2.g | neato -n2 -Tpng > output/output_dsn.png
echo " - output/output_dsn.png"
#
# dot input/input_simple.dot -Tpng > output/output_d_simple.png
# echo " - output/output_d_simple.png"
#
# dot input/input_simple.dot | gvpr -c -fal2.g | neato -n2 -Tpng > output/output_dsn_simple.png
# echo " - output/output_simple_dsn.png"

dot input/input_boucle.dot | gvpr -c -fal2.g | neato -n2 -Tpng > output/output_dsn_boucle.png
echo " - output/output_dsn_boucle.png"

dot input/input_boucle_constraints.dot -Tpng > output/output_d_boucle_constraints.png
echo " - output/output_d_boucle_constraints.png"

dot input/input_boucle_constraints.dot | neato -n2 -Tpng > output/output_dn_boucle_constraints.png
echo " - output/output_dn_boucle_constraints.png"

dot input/input_boucle_constraints.dot | gvpr -c -fal2.g | neato -n2 -Tpng > output/output_dsn_boucle_constraints.png
echo " - output/output_dsn_boucle_constraints.png"

echo