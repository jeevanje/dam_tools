# Script to extract grd file from nc file
ncfile=$1
grdfile=$2

ncks -v z $ncfile | sed -e "1,/^$/ d" -e "s|z\[[0-9]*\]=\([0-9]*.[0-9]*\) m|\1|" > $grdfile