#!/bin/bash
failed_extensions=()
file='/tmp/extensions.txt'
extension_count=$(<$file wc -l)
lines=$(cat $file)
for line in $lines
do
        trunk install $line
        psql -c "create extension if not exists \"$line\" cascade;"
        if [ $? -ne 0 ]; then
            echo "CREATE EXTENSION command failed"
            failed_extensions+=("$line")
        fi
        printf "\n\n"
done
failure_count=${#failed_extensions[@]}
percent=$(awk "BEGIN { pc=100*${failure_count}/${extension_count}; i=int(pc); print (pc-i<0.5)?i:i+1 }")
printf "***FAILURE COUNT***\n"
echo "$failure_count / $extension_count ($percent%)"
printf "\n\n***FAILED EXTENSIONS***\n"
for failed in "${failed_extensions[@]}"
do
      echo $failed
done
