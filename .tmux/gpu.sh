#!/usr/bin/env bash

print_gpu_usage() {
    gpuUsage=($(nvidia-smi -q -d UTILIZATION | grep Gpu | awk '{printf "%d\n", $3}'))
    memUsage=($(nvidia-smi | sed -nr 's/.*\s([0-9]+)MiB\s*\/\s*([0-9]+)MiB.*/\1 \2/p'  | awk -v format="%2.f\n" '{printf format, 100*$1/$2}'))
    ids=("⓪ " "① " "② " "③ " "④ " "⑤ " "⑥ " "⑦ ")

    output=""
    for index in ${!gpuUsage[*]}; do
        # output+="$index[${memUsage[$index]}-${gpuUsage[$index]}] "
        if [ "${gpuUsage[$index]}" = "100" ]; then
            output+=$(printf "%s [%2s-FU] " ${ids[$index]} ${memUsage[$index]})
        else
            output+=$(printf "%s [%2s-%-2s] " ${ids[$index]} ${memUsage[$index]} ${gpuUsage[$index]})
        fi
    done

    if [ -z "$output" ]; then
    echo "-"
    else
    echo "GPU: $output"
    fi
}

main() {
  print_gpu_usage
}

main
