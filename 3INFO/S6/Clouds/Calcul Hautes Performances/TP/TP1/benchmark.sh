#/bin/bash

if [[ $# -ge 1 ]]
then 
	max=$1
else 
	max=4
fi

calc_time () {
	t=$({ time ./ex3 $1; } 2>&1 | grep real)
	t=${t#real	0m}
	t=${t%s}
	t=${t/','/'.'}
	echo $t
}

t1=$(calc_time 1)
echo "1 thread : $t1"'s'
for i in $(seq 2 $max)
do
	t=$(calc_time $i)
	echo "$i threads : "$t"s, speedup : "$(echo "$t1/$t" | bc -l)
done
