#!/bin/bash
#%%%% cores available %%%%%%%%%%
#grep '^core id' /proc/cpuinfo |sort -u|wc -l > cores
#Cores=`echo $( cat cores )`
Cores=2
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

res=results
opvol=30.7513
cd $res

cp INCAR-st INCAR

cat > POSCAR<<!
SYSTEM
 -$opvol
   3.644682122593620   0.000000000000000   0.000000000000000
  -2.665179653435862   2.486066207820104   0.000000000000000
  -0.489747922409231  -1.243024697322733   3.390979767465354
  Si
   2
Direct
  0.750000000000000   0.250000000000000   0.500000000000000 
  0.000000000000000   0.000000000000000   0.000000000000000 
!

mpirun -n $Cores vasp > output-bulk.out
wait

awk '/energy  without entropy=/ {ene=$7; print ene} ' OUTCAR > tmp

echo bulk $( cat tmp ) >> bulk.dat
rm tmp


mv OUTCAR OUTCAR-bulk
mv CHGCAR CHGCAR-bulk.vasp
mv DOSCAR DOSCAR-bulk

cd ..

