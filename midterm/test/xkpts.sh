#!/bin/bash
#%%%% cores available %%%%%%%%%%
#grep '^core id' /proc/cpuinfo |sort -u|wc -l > cores
#Cores=`echo $( cat cores )`
Cores=2
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sys=POSCAR-si-sym141
encut=400

res=results

cd $res

rm W* CHG*

for k
in 0.2953097 0.2701770 0.2576106 0.2450442 0.2261947 0.2073451 0.2010619 \
0.1822124 0.1759292 0.1633628 0.1570796 0.1507964 \
0.1445133 0.1382301 0.1319469 0.1256637; do

cat > INCAR<<!
SYSTEM = POSCAR-si-sym141 

ISMEAR = -5          # Wavefunction occupancies
ENCUT = $encut         # what is the encut?
KSPACING = $k        # what is kpoints grid space?

LCHARG = .FALSE. # Do not write charge density to save time
#LORBIT = 11

#%%%%%%%%%% PARALLELIZATION %%%%%%%%%%%%%%%%%%%%%%%
#LPLANE=T !T if num nodes << NGX,NGY,NGZ
NCORE=$Cores ! cores per procesor
NSIM=1  ! 
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
