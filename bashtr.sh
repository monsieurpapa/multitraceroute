 #!/bin/bash
 
 #enter info about their network  and location
 #the info get appended to the final output
chmod +x bashtr.sh
list=$(cat "servers.txt")
mkdir -p servers 
for name in $list
do
    echo $name > servers/$name
done

#Traceroute each file and save that to a new file:
#On windows tracert is the equivalent command to traceroute

for file in servers/*
do
    name=$(echo ${file##*/})
    echo "doing " $name
	if [[ "$OSTYPE" == "msys"* ]]; then
		tracert $name > $name.txt
	else 
	     traceroute -I $name > $name.txt
	fi
done

ls -1 | grep -v 'servers.txt' | cat *.txt > results.txt
#ls -1 | grep -v 'servers.txt' | paste -d ';' *.txt > results.csv | paste -d ' ' - -
# ls -1 | grep -v 'servers.txt' | paste -d ';' *.txt > results.csv | paste -d ';' - -


#compare the server IP in the first line, with the server IP in the last line.
for newfile in *.txt
do
    textname=$(echo $newfile)
    first=$(head -1 $textname | awk '{print $4}' | cut -d ',' -f 1)
    last=$(tail -1 $textname | awk '{print $3}')
    if [ $first = $last ]
    then
        echo "Yes -" $textname
    fi
done
