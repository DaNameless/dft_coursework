#!/bin/bash
#%%%% cores available %%%%%%%%%%
#grep '^core id' /proc/cpuinfo |sort -u|wc -l > cores
#Cores=`echo $( cat cores )`
Cores=2
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sys=al.POSCAR #POSCAR file name
res=results

mkdir $res

cd $res

cp ../$sys POSCAR
cp ../POTCAR .

cp ../KPOINTS .

for en
in 250 300 350 400 450 500 550 600 650 700 750 800 850 900; do

cat > INCAR<<!
SYSTEM = Al

ISMEAR = -5          # Wavefunction occupancies
ENCUT = $en          # what is the encut?

LCHARG = .FALSE.     # Do not write charge density to save time
#LORBIT = 11

#%%%%%%%%%% PARALLELIZATION %%%%%%%%%%%%%%%%%%%%%%%
#LPLANE=T !T if num nodes << NGX,NGY,NGZ
NCORE=$Cores ! cores per procesor
NSIM=1  ! 
!


mpirun -n $Cores vasp > output-$en.out
wait

awk '/energy  without entropy=/ {i=$7; print i} ' OUTCAR > tmp

echo $en $( cat tmp ) >> ecut.dat
rm tmp 

done

cd ..
