#!/bin/bash

nf=$1

allSolsFile="allSolsFile.txt"
if [ ! -f $allSolsFile ]
then
    touch $allSolsFile
fi

allStatsFile="allStatsFile.txt"
if [ ! -f $allStatsFile ]
then
    touch $allStatsFile
fi

longNameFixFile="longNameFixFiles.txt"
touch $longNameFixFile
cntLong=($(wc -l $longNameFixFile))

allFixFile="allFix.txt"
if [ -f $allFixFile ]
then
    rm $allFixFile
fi
touch $allFixFile
MAX_SUBMITTED_JOBS=20
count=1
for i in *.fix
do
    printf "\n\n"
    #echo $i
    if [ -s $i ]
    then
	#echo "file non empty"
	name=`basename $i .fix`
	if [ ! -f stats_$name.txt ] && (( count < MAX_SUBMITTED_JOBS ))
	then
	    #echo "not proecessed yet"
	    len=${#name}
	    nameFixFile=$name.fix
	    if (( len > 50 )) 
	    then
		echo "$cntLong,$name" >> $longNameFixFile
		echo $cntLong
		mv $i $cntLong.fix
		nameFixFile=$cntLong.fix
		cntLong=$((cntLong+1))
	    fi
	    #echo $nameFixFile
	    echo $nameFixFile >> $allFixFile
	    count=$((count+1))
	    echo "count: $count"
#	    if (( count > MAX_SUBMITTED_JOBS ))
#	    then
#		break
#	    fi
	elif [[ -f stats_$name.txt && -s stats_$name.txt ]]
	then
	    #echo "file processed, prodeeding to gather results and delete"
	    while IFS= read -r line
	    do
		if [[ ! $line == n* ]]
		then
		    echo "$name,$line" >> $allStatsFile
		fi
	    done < stats_$name.txt
	    rm stats_$name.txt
	    cat solutionRepresentatives_$name.txt >> $allSolsFile
	    rm solutionRepresentatives_$name.txt
	    rm $i
	    rm $name.out
	    rm $name.err
	    rm log_$name.txt
	fi
    fi
done

count=1

python make-condor-marsd.py allFix.txt $count $nf

nFixFiles=($(wc -l $allFixFile))
return $nFixFiles
#condor_submit submit-solve-1.cmd

#while read p
#do
#    python make-condor-marsd.py $p $count $nf
#    count=$((count+1))
#done <allSubmit.txt

#return 1
