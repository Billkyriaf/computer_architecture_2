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

# 1. Simulation Parameters For The Subsystem Memory (Question 1)
First you need to run the following benchmarks to provide the appropriate files to be able to extract the results for them:
    
      $ ./build/ARM/gem5.opt -d spec_results/specbzip configs/example/se.py --cpu-type=MinorCPU --caches --l2cache -c spec_cpu2006/401.bzip2/src/specbzip -o "spec_cpu2006/401.bzip2/data/input.program 10" -I 100000000 
      $ ./build/ARM/gem5.opt -d spec_results/specmcf configs/example/se.py --cpu-type=MinorCPU --caches --l2cache -c spec_cpu2006/429.mcf/src/specmcf -o "spec_cpu2006/429.mcf/data/inp.in" -I 100000000 
      $ ./build/ARM/gem5.opt -d spec_results/spechmmer configs/example/se.py --cpu-type=MinorCPU --caches --l2cache -c spec_cpu2006/456.hmmer/src/spechmmer -o "--fixed 0 --mean 325 --num 45000 --sd 200 --seed 0 spec_cpu2006/456.hmmer/data/bombesin.hmm" -I 100000000 
      $ ./build/ARM/gem5.opt -d spec_results/specsjeng configs/example/se.py --cpu-type=MinorCPU --caches --l2cache -c spec_cpu2006/458.sjeng/src/specsjeng -o "spec_cpu2006/458.sjeng/data/test.txt" -I 100000000 
      $ ./build/ARM/gem5.opt -d spec_results/speclibm configs/example/se.py --cpu-type=MinorCPU --caches --l2cache -c spec_cpu2006/470.lbm/src/speclibm -o "20 spec_cpu2006/470.lbm/data/lbm.in 0 1 spec_cpu2006/470.lbm/data/100_100_130_cf_a.of" -I 100000000 
     
<br />
<br />

## 1.1. The total number of committed instructions
In the table below we will see how many orders were executed and how many were committed <br />

| BenchMarks | Committed Instructions | Executed Instructions | Memory Types | 
| :---: | :---: | :---: | :---: |
| Specbzip | 100000001 | 100196363 | DDR3_1600_8x8 |
| Specmcf | 100000000 | 101102729  | DDR3_1600_8x8 |
| Spechmmer | 100000000 | 101102729 | DDR3_1600_8x8 |
| Specsjeng | 100000000 | 184174857 | DDR3_1600_8x8 | 
| Speclibm | 100000000 | 100003637 | DDR3_1600_8x8 |

<br />
These are all found in each stats.txt file for each benchmark that was done above and they are found:

      system.cpu.committedInsts     NumberOFCommitted Instructions              # Number of instructions committed
      
<br />
      
      system.cpu.committedOps       NumberOFExecuted Instructions          # Number of ops (including micro ops) committed

<br />

Where it NumberOFCommitted Instructions  is 100000000 instructions executed with a limit by the benchmark and NumberOFExecuted Instructions you can see its results in the table below.This difference between committed instructions and executed instructions is due to the dependency on for loops and branches for which it is possible to predict whether they are taken or notTaken by continuing to do the calculations and that is why there are more executed than committed instructions. This is especially apparent in the 4th benchmark where the executed program has many for loops for which it tries to "guess" what will happen in the next iteration of each loop to be executed.In this particular case there is a big failure to predict and that is why it calculates many more. <br />

<br />

## 1.2 The total number of block replacements for the L1 data cache

The table with the block replacements for the L1 data cache:


| BenchMarks | Number of block replacement | 
| :---: | :---: | 
| Specbzip | 10605329 |
| Specmcf | 14199184 | 
| Spechmmer | 6262201 |
| Specsjeng | 73813129 |
| Speclibm | 10119911 |

These are found here: 

      system.cpu.dcache.WriteReq_hits::.cpu.data     NumberOfBlockReplacement              # number of WriteReq hits
      

<br />
<br />


## 1.3 Τhe number of accesses to the L2 cache

The table with the number of accesses to the L2 cache


| BenchMarks | Number of accesses | 
| :---: | :---: | 
| Specbzip | 511345 |
| Specmcf | 684515 | 
| Spechmmer | 65076 |
| Specsjeng | 148 |
| Speclibm | 83 |


These are found here: 
 
      system.l2.overall_hits::total                  NumberOfAccesses                       # number of overall hits
  

<br />

In case gem5 didn't give us this information about the number of accesses to the L2 cache we could say that if we miss the L1 cache in total including data and instructions and how many total acesses we did from the DRAM memory then after subtracting them we will get how many acesses we did for the second hidden memory level L2 cache. (δεν ειμαι σιγουρος για αυτο)

<br />
<br />


# 2. The results from the different benchmarks

## 2.1 Execution time

The time that the time it takes the program to run on the emulated processor, not the time it takes the gem5 to perform the emulation

| BenchMarks | Execution time (s) | 
| :---: | :---: | 
| Specbzip | 0.083982 |
| Specmcf | 0.064955 | 
| Spechmmer | 0.059396 |
| Specsjeng | 0.513528 |
| Speclibm | 0.174671 |

These are found here: 

       sim_seconds                                  timeSeconds                       # Number of seconds simulated

## 2.2 CPI

Cycles Per Instruction for each benchmark

| BenchMarks | CPI | 
| :---: | :---: | 
| Specbzip |  1.679650 |
| Specmcf | 1.299095 | 
| Spechmmer | 1.187917 |
| Specsjeng | 10.270554 |
| Speclibm | 3.493415 |

These are found here: 

       system.cpu.cpi                               cpiValue                      # CPI: cycles per instruction

## 2.3 Total missrates for each benchmark

Here we have the total missrates for the L1 Data cache, L1 Instruction cache and L2 cache.

<img src="https://github.com/NikolaosGian/computer_architecture_2/blob/question_1_b_c/graph/graph.png"> <br />

I notice that in the 2 latest benchmark speclibm, specsjeng there are big miss L2 cache for both instances and data, this is probably due to the existence of for loops and branches that create problems when there is no provision for them. In the spechmmer benchmark we see that we have almost no L1 missrate and a small percentage of L2 cache miss.For the specmcf benchmark there is a lot of L2 data missrate and finally in the specbzip benchmark we see that we have a large L2 instructions missrate.



