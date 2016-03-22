############### Script to restart DAM runs #################

damdir=~/fat/dam
casedir=$1
nprev=$2

# Check that nprev specified
if [ -z "${nprev}" ]; then
   printf "No nprev specified"
   exit
fi 

# Change filenames so data doesn't get overwritten
for f in ${casedir}/data/*[st].nc; do
    mv $f ${f%.nc}${nprev}.nc
done

#rename log, copy nml
mv ${casedir}/log ${casedir}/log${nprev}
cp ${casedir}/nml ${casedir}/nml${nprev}

# Change ivdata_path in nml file
cd $casedir
sed -e "s|ivdata_path = .*|ivdata_path = \'${casedir}/data/snapshot${nprev}.nc\'|" \
   < ${damdir}/${casedir}/nml > ${damdir}/${casedir}/nml_post
mv nml_post nml

# Submit job
sbatch submit 
