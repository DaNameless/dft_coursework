#!/bin/bash
#%%%% cores available %%%%%%%%%%
#grep '^core id' /proc/cpuinfo |sort -u|wc -l > cores
#Cores=`echo $( cat cores )`
Cores=2
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

res=results

cd $res
rm W* CHG*

cp INCAR-st INCAR 

for vol
in 27.70 28.20 28.70 29.20 29.70 30.20 30.70 31.20 31.70 32.20 32.70 \
33.20 33.70 34.20 34.70 ; do

cat > POSCAR<<!
SYSTEM
 -$vol
   3.644682122593620   0.000000000000000   0.000000000000000
  -2.665179653435862   2.486066207820104   0.000000000000000
  -0.489747922409231  -1.243024697322733   3.390979767465354
  Si
   2
Direct
  0.750000000000000   0.250000000000000   0.500000000000000 
  0.000000000000000   0.000000000000000   0.000000000000000 
!

mpirun -n $Cores vasp > output-$lat.out
wait

awk '/energy  without entropy=/ {ene=$7; print ene} ' OUTCAR > tmp
tail -2 OSZICAR | awk '/DAV/ {x=$2; print x} ' > tmp2

echo $vol $( cat tmp ) $( cat tmp2 ) >> cell.dat

done
cd ..
