#!/bin/bash
#%%%% cores available %%%%%%%%%%
#grep '^core id' /proc/cpuinfo |sort -u|wc -l > cores
#Cores=`echo $( cat cores )`
Cores=2
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sys=????
encut = ????

res=results

cd $res

rm W* CHG*

for k
in 1 2 3 4 5 ...; do

cat > INCAR<<!
SYSTEM = ???? 

ISMEAR = -5          # Wavefunction occupancies
ENCUT = $encut         # what is the encut?

LCHARG = .FALSE. # Do not write charge density to save time
#LORBIT = 11

#%%%%%%%%%% PARALLELIZATION %%%%%%%%%%%%%%%%%%%%%%%
#LPLANE=T !T if num nodes << NGX,NGY,NGZ
NCORE=$Cores ! cores per procesor
NSIM=1  ! 
!

cat > KPOINTS<<!
Silicon Atom   # System label
0              # Automatic generation
Monkhorst      # Generation scheme
$k $k $k          # Sampling - in this case single gamma point only
0 0 0          # Shift
!

mpirun -n $Cores vasp > output-$k.out
wait

awk '/energy  without entropy=/ {ene=$7; print ene} ' OUTCAR > tmp
head -2 IBZKPT | tail -1 > tmp1 
awk '/generate k-points for:/ {i=$4 " "$5" " $6; print i } ' OUTCAR > tmp2


echo $k $( cat tmp ) $( cat tmp1 ) $( cat tmp2 ) >> kps.dat
rm tmp*
cp INCAR INCAR-st

done

cd ..
