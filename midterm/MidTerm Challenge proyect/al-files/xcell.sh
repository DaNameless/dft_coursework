#!/bin/bash
#%%%% cores available %%%%%%%%%%
#grep '^core id' /proc/cpuinfo |sort -u|wc -l > cores
#Cores=`echo $( cat cores )`
Cores=2
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

res=results
k = ????

cd $res
rm W* CHG*

cp INCAR-st INCAR 

for vol
in ; do

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


cat > KPOINTS<<!
Silicon Atom   # System label
0              # Automatic generation
Monkhorst      # Generation scheme
$k $k $k          # Sampling - in this case single gamma point only
0 0 0          # Shift
!


mpirun -n $Cores vasp > output-$lat.out
wait

awk '/energy  without entropy=/ {ene=$7; print ene} ' OUTCAR > tmp
tail -2 OSZICAR | awk '/DAV/ {x=$2; print x} ' > tmp2

echo $vol $( cat tmp ) $( cat tmp2 ) >> cell.dat

done
cd ..
