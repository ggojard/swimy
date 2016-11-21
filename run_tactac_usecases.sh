



for file in "/input"/"tactac"*".dot"
do
  dot "input"/${file##*/} -Tpng -o "output"/${file##*/}.png
  echo "  input"/${file##*/} -Tpng -o "output"/${file##*/}.png
  
done
