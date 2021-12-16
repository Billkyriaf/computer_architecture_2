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
    - [3.1.1. L1 data cache size](#311-l1-data-cache-size)
    - [3.1.2. L2 size](#312-l2-size)
    - [3.1.3. Cache line size (Block size)](#313-cache-line-size-block-size)
    - [3.1.4. L1 instruction cache size](#314-l1-instruction-cache-size)
    - [3.1.5. L1 dcache associativity](#315-l1-dcache-associativity)
    - [3.1.6. L2 associativity](#316-l2-associativity)
    - [3.1.7. Final design](#317-final-design)
  - [3.2. Specmcf](#32-specmcf)
    - [3.2.1. L1 data cache size](#321-l1-data-cache-size)
    - [3.2.2. L2 size](#322-l2-size)
    - [3.2.3. Cache line size (Block size)](#323-cache-line-size-block-size)
    - [3.2.4. L1 instruction cache size](#324-l1-instruction-cache-size)
    - [3.2.5. L1 icache associativity](#325-l1-icache-associativity)
    - [3.2.6. L2 associativity](#326-l2-associativity)
    - [3.2.7. Final design](#327-final-design)

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

The information regarding the cache configuration for each benchmark can be found in the respective [`config.json`](spec_results) file. Initially all the simulations were run with the mentioned config files:

|      Cache      | Size  |   Associativity    | Block size |
| :-------------: | :---: | :----------------: | :--------: |
|     L1 Data     | 64 kB | 2 sets associative |  64 bytes  |
| L1 Instructions | 32 kB | 2 sets associative |  64 bytes  |
|  L2 (Unified)   | 2 MB  | 8 sets associative |  64 bytes  |

## 3.1. Specbzip


To find the best memory optimizations the above parameters were tested one at a time 


From the [`stats.txt`](spec_results/specbzip/stats.txt) file we can extract some useful information about the initial performance. 

|         |   CPI    | dcache overall Miss Rate | icache overall Miss Rate | L2 overall Miss Rate |
| :-----: | :------: | :----------------------: | :----------------------: | :------------------: |
| Initial | 1.673333 |         0.014248         |         0.000077         |       0.295244       |


The overall misses for the `L1 icache` are 751. Based on that the first test will be to increase only the `L1 dcache` with everything else remaining the same.

### 3.1.1. L1 data cache size

| L1 dcache  size |   CPI    | dcache overall Miss Rate | icache overall Miss Rate | L2 overall Miss Rate |
| :-------------: | :------: | :----------------------: | :----------------------: | :------------------: |
|      16 kB      | 1.672106 |         0.021704         |         0.000078         |       0.187641       |
|      32 kB      | 1.638240 |         0.017837         |         0.000077         |       0.230498       |
|      64 kB      | 1.603996 |         0.014139         |         0.000077         |       0.295238       |
|     128 kB      | 1.576537 |         0.011140         |         0.000077         |       0.382576       |
|     256 kB      | 1.547263 |         0.008178         |         0.000077         |       0.540433       |


Increasing the size of the `L1 dcache` has no effect on `icache overall Miss Rate` as expected. The `CPI` reduces as the size of the cache increases as the `dcache overall Miss Rate` does too. The only disadvantage is that the `L2 overall Miss Rate` increases. This is the case because although the overall misses for L2 cache remained the same the total accesses were drastically reduced because L1 was bigger.


### 3.1.2. L2 size

With everything keeping the same value and the L1 size being 256kB (the best result of the previous experiment) we start incrementing the size of the L2 cache.


| L2 cache size |   CPI    | dcache overall Miss Rate | icache overall Miss Rate | L2 overall Miss Rate |
| :-----------: | :------: | :----------------------: | :----------------------: | :------------------: |
|     1 MB      | 1.563444 |         0.008178         |         0.000077         |       0.608474       |
|     2 MB      | 1.547263 |         0.008178         |         0.000077         |       0.540433       |
|     4 MB      | 1.532711 |         0.008175         |         0.000077         |       0.483740       |

Increasing the size of the L2 cache improves the CPI further. Again as expected the `L2 overall Miss Rate` reduced because L2 can now hold more data than before.


### 3.1.3. Cache line size (Block size)

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

### 3.1.4. L1 instruction cache size

At this point the pattern is clean. Everything tested before this point is kept at the optimal value and the only the tested variable changes. 

| L1 icache  size |   CPI    | dcache overall Miss Rate | icache overall Miss Rate | L2 overall Miss Rate |
| :-------------: | :------: | :----------------------: | :----------------------: | :------------------: |
|      16 kB      | 1.518483 |         0.006603         |         0.000081         |       0.231680       |
|      32 kB      | 1.517955 |         0.006603         |         0.000064         |       0.231678       |
|      64 kB      | 1.518456 |         0.006603         |         0.000045         |       0.231669       |
|     128 kB      | 1.517251 |         0.006603         |         0.000040         |       0.231680       |
|     256 kB      | 1.517252 |         0.006603         |         0.000039         |       0.231679       |

As it was mentioned before this program has very few icache misses so increasing the `L1 icache` gave very little to none performance improvement.

### 3.1.5. L1 dcache associativity

| L1 dcache  associativity |   CPI    | dcache overall Miss Rate | icache overall Miss Rate | L2 overall Miss Rate |
| :----------------------: | :------: | :----------------------: | :----------------------: | :------------------: |
|          2 way           | 1.517252 |         0.006603         |         0.000039         |       0.231679       |
|          4 way           | 1.517044 |         0.006323         |         0.000039         |       0.242710       |
|          8 way           | 1.517718 |         0.006250         |         0.000039         |       0.245758       |
|           full           | 1.509679 |         0.005320         |         0.000039         |       0.292270       |


Full set associative gives the best CPI for this simulation. Fully associative cache i generally great for performance but is very complex from the hardware perspective. Since this is L1 cache and is only 256kB in size this is a relatively realistic scenario.

### 3.1.6. L2 associativity

| L2 associativity |   CPI    | dcache overall Miss Rate | icache overall Miss Rate | L2 overall Miss Rate |
| :--------------: | :------: | :----------------------: | :----------------------: | :------------------: |
|      4 way       | 1.508460 |         0.005324         |         0.000039         |       0.292949       |
|      8 way       | 1.509679 |         0.005320         |         0.000039         |       0.292270       |
|      16 way      | 1.508105 |         0.005298         |         0.000039         |       0.287279       |
|      32 way      | 1.507638 |         0.005298         |         0.000039         |       0.287651       |


L2 also benefits from associativity but as it is 16 time larger that L1 we can not realistically go to a fully associative design. The 32 way associativity seems like a good balance.

### 3.1.7. Final design

| Design aspect | L1 dcache  size | L1 dcache  associativity | L1 icache  size | L1 icache  associativity | L2 cache size | L2 associativity | Cacheline size |
| :-----------: | :-------------: | :----------------------: | :-------------: | :----------------------: | :-----------: | :--------------: | :------------: |
|               |     256 kB      |    fully associative     |     256 kB      |          2 way           |     4 MB      |      32 way      |   256 bytes    |

## 3.2. Specmcf

The procedure is the same with the first simulation.

### 3.2.1. L1 data cache size

| L1 dcache  size |   CPI    | dcache overall Miss Rate | icache overall Miss Rate | L2 overall Miss Rate |
| :-------------: | :------: | :----------------------: | :----------------------: | :------------------: |
|      16 kB      | 1.326323 |         0.008184         |         0.023542         |       0.042767       |
|      32 kB      | 1.281189 |         0.002478         |         0.023624         |       0.054347       |
|      64 kB      | 1.278885 |         0.002079         |         0.023625         |       0.055082       |
|     128 kB      | 1.277895 |         0.001925         |         0.023625         |       0.055381       |
|     256 kB      | 1.277542 |         0.001844         |         0.023625         |       0.055540       |


Increasing the size of the `L1 dcache` has no effect on `icache overall Miss Rate` as expected. The `CPI` reduces as the size of the cache increases as the `dcache overall Miss Rate` does too. The only disadvantage is that the `L2 overall Miss Rate` increases. This is the case because although the overall misses for L2 cache remained the same the total accesses were drastically reduced because L1 was bigger.


### 3.2.2. L2 size

With everything keeping the same value and the L1 size being 256kB (the best result of the previous experiment) we start incrementing the size of the L2 cache.


| L2 cache size |   CPI    | dcache overall Miss Rate | icache overall Miss Rate | L2 overall Miss Rate |
| :-----------: | :------: | :----------------------: | :----------------------: | :------------------: |
|     1 MB      | 1.280194 |         0.001844         |         0.023625         |       0.059948       |
|     2 MB      | 1.277542 |         0.001844         |         0.023625         |       0.055540       |
|     4 MB      | 1.277379 |         0.001844         |         0.023625         |       0.055127       |

Increasing the size of the L2 cache improves the CPI but not too much. Again as expected the `L2 overall Miss Rate` reduced because L2 can now hold more data than before. The affects of the size increase for the L2 cache are modest. This is because the limiting factor for this benchmark is the `L1 icache` where most of the misses happen.


### 3.2.3. Cache line size (Block size)

From the previous tests it was determined that the best size for `L1` is `256kB` and for `L2` is `4 MB`. With that as a starting point the next thing to test is the effect the cache line size has to the simulated program.

| Cacheline size |   CPI    | dcache overall Miss Rate | icache overall Miss Rate | L2 overall Miss Rate |
| :------------: | :------: | :----------------------: | :----------------------: | :------------------: |
|    16 bytes    | 1.390975 |         0.004429         |         0.014546         |       0.210064       |
|    32 bytes    | 1.224059 |         0.002946         |         0.013170         |       0.160583       |
|    64 bytes    | 1.277308 |         0.001844         |         0.023625         |       0.055128       |
|   128 bytes    | 1.318068 |         0.001074         |         0.034839         |       0.020608       |
|   256 bytes    | 1.291262 |         0.000672         |         0.032593         |       0.011582       |
|   512 bytes    | 1.368126 |         0.000493         |         0.039855         |       0.004910       |
|   1024 bytes   | 1.493633 |         0.000469         |         0.038898         |       0.002582       |


Increasing the `cacheline` size brought an improvement on some of the aspects that are monitored here. The `L1 dcache miss rate` and `L2 miss rate`  seem to be positively affected by the increase. On the other hand `L1 icache` and the overall `CPI` are negatively affected. A good middle ground is `256 kB` because `CPI` and `L1 dcache miss rate` drop a little and the other two values are greatly favored.

### 3.2.4. L1 instruction cache size

At this point the pattern is clean. Everything tested before this point is kept at the optimal value and the only the tested variable changes. 

| L1 icache  size |   CPI    | dcache overall Miss Rate | icache overall Miss Rate | L2 overall Miss Rate |
| :-------------: | :------: | :----------------------: | :----------------------: | :------------------: |
|      16 kB      | 1.476380 |         0.000672         |         0.063960         |       0.006017       |
|      32 kB      | 1.291262 |         0.000672         |         0.032593         |       0.011582       |
|      64 kB      | 1.099167 |         0.000672         |         0.000027         |       0.513670       |
|     128 kB      | 1.099075 |         0.000672         |         0.000009         |       0.526280       |
|     256 kB      | 1.099075 |         0.000672         |         0.000009         |       0.526335       |

This test clearly shows the previous bottleneck on the `L1 icache`. This is a benchmark that runs multiple instructions on a relatively small amount of data. Increasing the size of `L1 icache` the `CPI` approached 1. The disadvantage here is the sudden increase in `L2 miss rate`. From 32kB to 64kB the `L1 icache misses` went from 847293 to just 709, meaning in that point most of the used instructions started to fit in the `L1 icache`. The sudden increase of the `L2 miss rate` is there because the total number of misses drastically lessened from 856085 initially to just 9499. 

### 3.2.5. L1 icache associativity

| L1 icache  associativity |   CPI    | dcache overall Miss Rate | icache overall Miss Rate | L2 overall Miss Rate |
| :----------------------: | :------: | :----------------------: | :----------------------: | :------------------: |
|          2 way           | 1.099075 |         0.000672         |         0.000009         |       0.526335       |
|          4 way           | 1.099075 |         0.000672         |         0.000009         |       0.526335       |
|          8 way           | 1.099075 |         0.000672         |         0.000009         |       0.526335       |
|           full           | 1.099075 |         0.000672         |         0.000009         |       0.526335       |

Changing `L1 icache associativity` has no effect on the program. This is the case because above the 64kB of `icache` the instruction misses are so few that there is a very small number of block replacements in the `L1 icache`. Obviously in a situation like that we would choose the 2 way associative since it is the most easy to manufacture among the rest of the options.

### 3.2.6. L2 associativity

| L1 associativity |   CPI    | dcache overall Miss Rate | icache overall Miss Rate | L2 overall Miss Rate |
| :--------------: | :------: | :----------------------: | :----------------------: | :------------------: |
|      4 way       | 1.098808 |         0.000621         |         0.000009         |       0.569636       |
|      8 way       | 1.098808 |         0.000621         |         0.000009         |       0.569636       |
|      16 way      | 1.098808 |         0.000621         |         0.000009         |       0.569636       |
|      32 way      | 1.098808 |         0.000621         |         0.000009         |       0.569636       |


The same as the `L1 icache associativity` stands here too. There are very few misses for the `L2 cache` to benefit from a 16 or 32 set associative design. So the choice here is the "less" associative cache. 

### 3.2.7. Final design

| Design aspect | L1 dcache  size | L1 dcache  associativity | L1 icache  size | L1 icache  associativity | L2 cache size | L2 associativity | Cacheline size |
| :-----------: | :-------------: | :----------------------: | :-------------: | :----------------------: | :-----------: | :--------------: | :------------: |
|               |     256 kB      |          2 way           |      64 kB      |          2 way           |     4 MB      |      4 way       |   256 bytes    |
