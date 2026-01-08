#!/bin/bash

ITERATIONS=500
CPU=15
OUTPUT_FILE=""

PRE=""
RUN=""
BENCH="perf stat -C $CPU -x, -e duration_time -- taskset -c $CPU $RUN"

times=()

echo "Starting $ITERATIONS iterations on core $CPU..."

sudo -v

for ((i=1; i<=ITERATIONS; i++)); do
    eval "$PRE" > /dev/null 2>&1

    sync; echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null
    
    result=$($BENCH 2>&1)
    
    exec_time=$(echo "$result" | tail -n 1 | cut -d, -f1)
    exec_time=$(printf "%010d" "$exec_time" | sed -E 's/(.*)(.{9})/\1.\2/; s/0+$//; s/\.$//')   

    times+=("$exec_time")

    echo "Iteration $i/$ITERATIONS: $exec_time s"
done

echo "PRE=$PRE" > "$OUTPUT_FILE"
echo "RUN=$RUN" >> "$OUTPUT_FILE"
echo "${times[@]}" >> "$OUTPUT_FILE"

echo "Done. Commands and times saved to $OUTPUT_FILE"
