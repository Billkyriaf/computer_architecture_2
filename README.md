<div id="top"></div>

<br />
<div align="center">
  <h1 align="center">Computer Architecture Assignment 2</h1>
  <h3 align="center">Aristotle University of Thessaloniki</h3>
  <h4 align="center">School of Electrical & Computer Engineering</h4>
  <p align="center">
    Contributors: Kyriafinis Vasilis, Nikolaos Giannopoulos
    <br />
    Winter Semester 2021 - 2022
    <br />
    <br />
  </p>
</div>
<br />

- [1. Simulation Parameters For The Subsystem Memory (Question 1)](#1-simulation-parameters-for-the-subsystem-memory-question-1)
  - [1.1. The total number of committed instructions](#11-the-total-number-of-committed-instructions)
  - [1.2. The total number of block replacements for the L1 data cache](#12-the-total-number-of-block-replacements-for-the-l1-data-cache)
  - [1.3. Τhe number of accesses to the L2 cache](#13-τhe-number-of-accesses-to-the-l2-cache)
- [2. The results from the different benchmarks](#2-the-results-from-the-different-benchmarks)
  - [2.1. Execution time](#21-execution-time)
  - [2.2. CPI](#22-cpi)
  - [2.3. Total miss rates for each benchmark](#23-total-miss-rates-for-each-benchmark)
- [3. Cache memory optimizations (Question 2)](#3-cache-memory-optimizations-question-2)
  - [3.1. Specbzip](#31-specbzip)
    - [L1 size](#l1-size)
    - [L2 size](#l2-size)
    - [Cache line size (Block size)](#cache-line-size-block-size)

# 1. Simulation Parameters For The Subsystem Memory (Question 1)
The following benchmarks were run in order to produce the information needed:
    
    $ ./build/ARM/gem5.opt -d spec_results/specbzip configs/example/se.py --cpu-type=MinorCPU --caches --l2cache -c spec_cpu2006/401.bzip2/src/specbzip -o "spec_cpu2006/401.bzip2/data/input.program 10" -I 100000000 
    $ ./build/ARM/gem5.opt -d spec_results/specmcf configs/example/se.py --cpu-type=MinorCPU --caches --l2cache -c spec_cpu2006/429.mcf/src/specmcf -o "spec_cpu2006/429.mcf/data/inp.in" -I 100000000 
    $ ./build/ARM/gem5.opt -d spec_results/spechmmer configs/example/se.py --cpu-type=MinorCPU --caches --l2cache -c spec_cpu2006/456.hmmer/src/spechmmer -o "--fixed 0 --mean 325 --num 45000 --sd 200 --seed 0 spec_cpu2006/456.hmmer/data/bombesin.hmm" -I 100000000 
    $ ./build/ARM/gem5.opt -d spec_results/specsjeng configs/example/se.py --cpu-type=MinorCPU --caches --l2cache -c spec_cpu2006/458.sjeng/src/specsjeng -o "spec_cpu2006/458.sjeng/data/test.txt" -I 100000000 
    $ ./build/ARM/gem5.opt -d spec_results/speclibm configs/example/se.py --cpu-type=MinorCPU --caches --l2cache -c spec_cpu2006/470.lbm/src/speclibm -o "20 spec_cpu2006/470.lbm/data/lbm.in 0 1 spec_cpu2006/470.lbm/data/100_100_130_cf_a.of" -I 100000000 
     
<br />
<br />

## 1.1. The total number of committed instructions
The table below we shows the numbers of committed instructions along with the executed instructions.<br />

| BenchMarks | Committed Instructions | Executed Instructions | Memory Types  |
| :--------: | :--------------------: | :-------------------: | :-----------: |
|  Specbzip  |       100000001        |       100196363       | DDR3_1600_8x8 |
|  Specmcf   |       100000000        |       101102729       | DDR3_1600_8x8 |
| Spechmmer  |       100000000        |       101102729       | DDR3_1600_8x8 |
| Specsjeng  |       100000000        |       184174857       | DDR3_1600_8x8 |
|  Speclibm  |       100000000        |       100003637       | DDR3_1600_8x8 |

<br />
The number of committed instructions are found in this entry in the [stats.txt](spec_results) file: 

    system.cpu.committedInsts   NumberOFCommitted Instructions   # Number of instructions committed
      
<br />

The number of executed instructions is found int his entry in the [stats.txt](spec_results) file:
      
    system.cpu.committedOps   NumberOFExecuted Instructions   # Number of ops (including micro ops) committed

<br />

> The executed instructions are always more or at least equal to the committed instructions. This happens because the CPU simulated supports speculative execution. With speculative execution the CPU does not need to wait for the calculation of the branch instructions but as the name suggests it speculates on the result of the branch and continues execution based on this speculation. The predicted result will not always be correct. In those cases the executed instructions are never committed to the registers and instead are discarded. This becomes apparent in the 4th benchmark where the executed program has many for loops hence it has many branch instructions that the branch predictor tries to "guess" the outcome. 

Where it NumberOFCommitted Instructions  is 100000000 instructions executed with a limit by the benchmark and NumberOFExecuted Instructions you can see its results in the table below.This difference between committed instructions and executed instructions is due to the dependency on for loops and branches for which it is possible to predict whether they are taken or notTaken by continuing to do the calculations and that is why there are more executed than committed instructions. This is especially apparent in the 4th benchmark where the executed program has many for loops for which it tries to "guess" what will happen in the next iteration of each loop to be executed.In this particular case there is a big failure to predict and that is why it calculates many more. <br />

<br />

## 1.2. The total number of block replacements for the L1 data cache

The table with the block replacements for the L1 data cache:


| BenchMarks | Block replacements dcache |
| :--------: | :-----------------------: |
|  Specbzip  |          710569           |
|  Specmcf   |           54452           |
| Spechmmer  |           65718           |
| Specsjeng  |          5262377          |
|  Speclibm  |          1486955          |

The L1 block replacements for the dcache can be found in the bellow line:  

    system.cpu.dcache.replacements number_of_replacements # number of replacements
      

<br />
<br />


## 1.3. Τhe number of accesses to the L2 cache

The table with the number of accesses to the L2 cache


| BenchMarks | Number of accesses |
| :--------: | :----------------: |
|  Specbzip  |       712341       |
|  Specmcf   |       724390       |
| Spechmmer  |       70563        |
| Specsjeng  |      5264051       |
|  Speclibm  |      1488538       |


The number of accesses are found here: 
 
    system.l2.overall_accesses::total  number_of_accesses   # number of overall (read+write) accesses
  

<br />

> In case gem5 didn't give us this information about the number of accesses to the L2 cache we could say that if we miss the L1 cache in total including data and instructions and how many total accesses we did from the DRAM memory then after subtracting them we will get how many accesses we did for the second hidden memory level L2 cache. (δεν ειμαι σιγουρος για αυτο)

<br />
<br />


# 2. The results from the different benchmarks

## 2.1. Execution time

The time that the it takes the program to run on the emulated processor, not the time it takes the gem5 to perform the emulation

| BenchMarks | Execution time (s) |
| :--------: | :----------------: |
|  Specbzip  |      0.083982      |
|  Specmcf   |      0.064955      |
| Spechmmer  |      0.059396      |
| Specsjeng  |      0.513528      |
|  Speclibm  |      0.174671      |

These are found here: 

    sim_seconds  timeSeconds   # Number of seconds simulated

## 2.2. CPI

Cycles Per Instruction for each benchmark

| BenchMarks |    CPI    |
| :--------: | :-------: |
|  Specbzip  | 1.679650  |
|  Specmcf   | 1.299095  |
| Spechmmer  | 1.187917  |
| Specsjeng  | 10.270554 |
|  Speclibm  | 3.493415  |

These are found here: 

       system.cpu.cpi  cpiValue   # CPI: cycles per instruction

## 2.3. Total miss rates for each benchmark

Here we have the total miss rates for the L1 Data cache, L1 Instruction cache and L2 cache.

<img src="graph/graph.png"> <br />

I notice that in the 2 latest benchmark speclibm, specsjeng there are big miss L2 cache for both instances and data, this is probably due to the existence of for loops and branches that create problems when there is no provision for them. In the spechmmer benchmark we see that we have almost no L1 miss rate and a small percentage of L2 cache miss.For the specmcf benchmark there is a lot of L2 data miss rate and finally in the specbzip benchmark we see that we have a large L2 instructions miss rate.



# 3. Cache memory optimizations (Question 2)

The information regarding the cache configuration for each benchmark can be found in the respective [`config.json`](spec_results) file.

## 3.1. Specbzip

Initially `specbzip` was run with the following [configuration](spec_results/specbzip/config.json):

|      Cache      | Size  |   Associativity    | Block size |
| :-------------: | :---: | :----------------: | :--------: |
|     L1 Data     | 64 kB | 2 sets associative |  64 bytes  |
| L1 Instructions | 32 kB | 2 sets associative |  64 bytes  |
|  L2 (Unified)   | 2 MB  | 8 sets associative |  64 bytes  |


To find the best memory optimizations the above parameters were tested one at a time 


From the [`stats.txt`](spec_results/specbzip/stats.txt) file we can extract some useful information about the initial performance. 

|         |   CPI    | dcache overall Miss Rate | icache overall Miss Rate | L2 overall Miss Rate |
| :-----: | :------: | :----------------------: | :----------------------: | :------------------: |
| Initial | 1.673333 |         0.014248         |         0.000077         |       0.295244       |


The overall misses for the `L1 icache` are 751. Based on that the first test will be to increase only the `L1 dcache` with everything else remaining the same.

### L1 size

| L1 dcache  size |   CPI    | dcache overall Miss Rate | icache overall Miss Rate | L2 overall Miss Rate |
| :-------------: | :------: | :----------------------: | :----------------------: | :------------------: |
|      16 kB      | 1.672106 |         0.021704         |         0.000078         |       0.187641       |
|      32 kB      | 1.638240 |         0.017837         |         0.000077         |       0.230498       |
|      64 kB      | 1.603996 |         0.014139         |         0.000077         |       0.295238       |
|     128 kB      | 1.576537 |         0.011140         |         0.000077         |       0.382576       |
|     256 kB      | 1.547263 |         0.008178         |         0.000077         |       0.540433       |


Increasing the size of the `L1 dcache` has no effect on `icache overall Miss Rate` as expected. The `CPI` reduces as the size of the cache increases as the `dcache overall Miss Rate` does too. The only disadvantage is that the `L2 overall Miss Rate` increases. This is the case because although the overall misses for L2 cache remained the same the total accesses were drastically reduced because L1 was bigger.


### L2 size

With everything keeping the same value and the L1 size being 256kB (the best result of the previous experiment) we start incrementing the size of the L2 cache.


| L2 cache size |   CPI    | dcache overall Miss Rate | icache overall Miss Rate | L2 overall Miss Rate |
| :-----------: | :------: | :----------------------: | :----------------------: | :------------------: |
|     1 MB      | 1.563444 |         0.008178         |         0.000077         |       0.608474       |
|     2 MB      | 1.547263 |         0.008178         |         0.000077         |       0.540433       |
|     4 MB      | 1.532711 |         0.008175         |         0.000077         |       0.483740       |

Increasing the size of the L2 cache improves the CPI further. Again as expected the `L2 overall Miss Rate` reduced because L2 can now hold more data than before.


### Cache line size (Block size)

From the previous tests it was determined that the best size for `L1` is `256kB` and for `L2` is `4 MB`. With that as a starting point the next thing to test is the effect the cache line size has to the simulated program.

| Cacheline size |   CPI    | dcache overall Miss Rate | icache overall Miss Rate | L2 overall Miss Rate |
| :------------: | :------: | :----------------------: | :----------------------: | :------------------: |
|    16 bytes    | 1.778735 |         0.018826         |         0.000096         |       0.710575       |
|    32 bytes    | 1.634486 |         0.012306         |         0.000087         |       0.612453       |
|    64 bytes    | 1.532711 |         0.008175         |         0.000077         |       0.483740       |
|   128 bytes    | 1.526626 |         0.006756         |         0.000067         |       0.347057       |
|   256 bytes    | 1.517955 |         0.006603         |         0.000064         |       0.231678       |
|   512 bytes    | 1.529753 |         0.007321         |         0.000057         |       0.154287       |
|   1024 bytes   | 1.576398 |         0.008637         |         0.000122         |       0.108546       |


Increasing the `cacheline` size brought an improvement on all the aspects that are monitored here. There is a limit to the size though and it is `256 bytes`. Above that value the locality of the program is hurt meaning there are data fetched from the memory with every block that are further apart and hence they are not useful at the current time. This fills the caches with unwanted data reducing performance. 