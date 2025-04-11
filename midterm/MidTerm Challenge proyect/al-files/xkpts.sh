#!/bin/bash
#%%%% cores available %%%%%%%%%%
#grep '^core id' /proc/cpuinfo |sort -u|wc -l > cores
#Cores=`echo $( cat cores )`
Cores=2
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sys=al.POSCAR
encut=400

res=results

cd $res

rm W* CHG*

for k
in 15 16 17 18 19 20 21 22 23 24 25 26 27 28; do

cat > INCAR<<!
SYSTEM = Al

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
Al             # System label
0              # Automatic generation
Gamma          # Generation scheme
$k $k $k       # Sampling - in this case single gamma point only
0 0 0          # Shift
!

mpirun -n $Cores vasp > output-$k.out
wait

awk '/energy  without entropy=/ {ene=$7; print ene} ' OUTCAR > tmp
head -2 IBZKPT | tail -1 > tmp1 
awk '/generate k-points for:/ {i=$4 " "$5" " $6; print i } ' OUTCAR > tmp2


echo $k $( cat tmp ) $( cat tmp1 ) $( cat tmp2 ) >> kps.dat
rm tmp*
cp INCAR INCAR-bulk

done

cd ..
