#!/bin/bash

# variables

user=$(whoami)
gem5=/home/$user/Gem5/my_gem5  # Gem5 path

benchmark=specbzip
benchmark_files='-c spec_cpu2006/401.bzip2/src/specbzip -o "spec_cpu2006/401.bzip2/data/input.program 10" -I 100000000'

current_dir=$(pwd)/test_results
declare -i index=0

# change directory to gem5
cd $gem5

# ~~~~~~~~~~~~~~~~   gem5 simulation flags   ~~~~~~~~~~~~~~~~

#CPU
cpu_type="--cpu-type=MinorCPU"
cpu_clock=" --cpu-clock=1GHz"


# ~~~~~~~~~~~~~~~~   Test 1 L1 size ~~~~~~~~~~~~~~~~

# L1 cache max 512KB (L1_i + L1_d)
l1d_size=("--l1d_size=16kB" "--l1d_size=32kB" "--l1d_size=64kB" "--l1d_size=128kB" "--l1d_size=256kB")
l1d_assoc="--l1d_assoc=2"

l1i_size="--l1i_size=32kB"
l1i_assoc="--l1i_assoc=2"

# L2 cache max 4MB
l2_size="--l2_size=2MB"
l2_assoc="--l2_assoc=8"


cacheline_size="--cacheline_size=64"

# run the sim for every item in the l1d_size list
for val in ${l1d_size[*]}; do 
    ./build/ARM/gem5.opt -d $current_dir/${benchmark}_l1d_size_$index configs/example/se.py $cpu_type $cpu_clock --caches --l2cache $val $l1d_assoc $l1i_size $l1i_assoc $l2_size $l2_assoc $cacheline_size $benchmark_files &
    index=$(($index + 1))
done


# ~~~~~~~~~~~~~~~~   Test 2 L2 size ~~~~~~~~~~~~~~~~

# L1 cache max 512KB (L1_i + L1_d)
l1d_size="--l1d_size=256kB"
l1d_assoc="--l1d_assoc=2"

l1i_size="--l1i_size=32kB"
l1i_assoc="--l1i_assoc=2"

# L2 cache max 4MB
l2_size=("--l2_size=1024kB" "--l2_size=2048kB" "--l2_size=4096kB")
l2_assoc="--l2_assoc=8"


cacheline_size="--cacheline_size=64"


index=$((0))
# run the sim for every item in the l2d_size list
for val in ${l2_size[*]}; do 
    ./build/ARM/gem5.opt -d $current_dir/${benchmark}_l2_size_$index configs/example/se.py $cpu_type $cpu_clock --caches --l2cache $l1d_size $l1d_assoc $l1i_size $l1i_assoc $val $l2_assoc $cacheline_size $benchmark_files &
    index=$(($index + 1))
done


# ~~~~~~~~~~~~~~~~   Test 3 cache line size ~~~~~~~~~~~~~~~~

L1 cache max 512KB (L1_i + L1_d)
l1d_size="--l1d_size=256kB"
l1d_assoc="--l1d_assoc=2"

l1i_size="--l1i_size=32kB"
l1i_assoc="--l1i_assoc=2"

# L2 cache max 4MB
l2_size="--l2_size=4096kB"
l2_assoc="--l2_assoc=8"


cacheline_size=("--cacheline_size=16" "--cacheline_size=32" "--cacheline_size=64" "--cacheline_size=128" "--cacheline_size=256" "--cacheline_size=512" "--cacheline_size=1024")


index=$((0))
# run the sim for every item in the l2d_size list
for val in ${cacheline_size[*]}; do 
    ./build/ARM/gem5.opt -d $current_dir/${benchmark}_cacheline_size_$index configs/example/se.py $cpu_type $cpu_clock --caches --l2cache $l1d_size $l1d_assoc $l1i_size $l1i_assoc $l2_size $l2_assoc $val $benchmark_files &
    index=$(($index + 1))
done

# ~~~~~~~~~~~~~~~~   Test 4 l1 instruction size ~~~~~~~~~~~~~~~~

# L1 cache max 512KB (L1_i + L1_d)
l1d_size="--l1d_size=256kB"
l1d_assoc="--l1d_assoc=2"

l1i_size=("--l1i_size=16kB" "--l1i_size=32kB" "--l1i_size=64kB" "--l1i_size=128kB" "--l1i_size=256kB")
l1i_assoc="--l1i_assoc=2"

# L2 cache max 4MB
l2_size="--l2_size=4096kB"
l2_assoc="--l2_assoc=8"


cacheline_size="--cacheline_size=256"


index=$((0))
# run the sim for every item in the l2d_size list
for val in ${l1i_size[*]}; do 
    ./build/ARM/gem5.opt -d $current_dir/${benchmark}_l1i_size_$index configs/example/se.py $cpu_type $cpu_clock --caches --l2cache $l1d_size $l1d_assoc $val $l1i_assoc $l2_size $l2_assoc $cacheline_size $benchmark_files &
    index=$(($index + 1))
done


# ~~~~~~~~~~~~~~~~   Test 5 l1 data associativity ~~~~~~~~~~~~~~~~

# L1 cache max 512KB (L1_i + L1_d)
l1d_size="--l1d_size=256kB"
l1d_assoc=("--l1d_assoc=2" "--l1d_assoc=4" "--l1d_assoc=8" "--l1d_assoc=1024")  # 1024 is fully associative because there are 1024 blocks

l1i_size="--l1i_size=256kB"
l1i_assoc="--l1i_assoc=2"

# L2 cache max 4MB
l2_size="--l2_size=4096kB"
l2_assoc="--l2_assoc=8"


cacheline_size="--cacheline_size=256"


index=$((0))
# run the sim for every item in the l2d_size list
for val in ${l1d_assoc[*]}; do 
    ./build/ARM/gem5.opt -d $current_dir/${benchmark}_l1d_assoc_$index configs/example/se.py $cpu_type $cpu_clock --caches --l2cache $l1d_size $val $l1i_size $l1i_assoc $l2_size $l2_assoc $cacheline_size $benchmark_files &
    index=$(($index + 1))
done


# ~~~~~~~~~~~~~~~~   Test 6 l2 associativity ~~~~~~~~~~~~~~~~

# L1 cache max 512KB (L1_i + L1_d)
l1d_size="--l1d_size=256kB"
l1d_assoc="--l1d_assoc=1024"  # fully associative

l1i_size="--l1i_size=256kB"
l1i_assoc="--l1i_assoc=2"

# L2 cache max 4MB
l2_size="--l2_size=4096kB"
l2_assoc=("--l2_assoc=4" "--l2_assoc=8" "--l2_assoc=16" "--l2_assoc=32")


cacheline_size="--cacheline_size=256"


index=$((0))
# run the sim for every item in the l2d_size list
for val in ${l2_assoc[*]}; do 
    ./build/ARM/gem5.opt -d $current_dir/${benchmark}_l2_assoc_$index configs/example/se.py $cpu_type $cpu_clock --caches --l2cache $l1d_size $l1d_assoc $l1i_size $l1i_assoc $l2_size $val $cacheline_size $benchmark_files &
    index=$(($index + 1))
done