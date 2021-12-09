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

| BenchMark | Committed Instructions | Executed Instructions | Memory Types | 
| :---: | :---: | :---: | :---: |
| Specbzip | 100000001 | 100196363 | DDR3_1600_8x8 |
| Specmcf | 100000000 | 101102729  | DDR3_1600_8x8 |
| Spechmmer | 100000000 | 101102729 | DDR3_1600_8x8 |
| Specsjeng | 100000000 | 184174857 | DDR3_1600_8x8 | 
| Speclibm | 100000000 | 100003637 | DDR3_1600_8x8 |

<br />
These are all found in each stats.txt file for each benchmark that was done above and they are found:

      system.cpu.committedInsts                   NumberOFCommitted Instructions                       # Number of instructions committed
      
<br />
      
      system.cpu.committedOps                     NumberOFExecuted Instructions                         # Number of ops (including micro ops) committed

<br />

Where it NumberOFCommitted Instructions  is 100000000 instructions executed with a limit by the benchmark and NumberOFExecuted Instructions you can see its results in the table below.This difference between committed instructions and executed instructions is due to the dependency on for loops and branches for which it is possible to predict whether they are taken or notTaken by continuing to do the calculations and that is why there are more executed than committed instructions. This is especially apparent in the 4th benchmark where the executed program has many for loops for which it tries to "guess" what will happen in the next iteration of each loop to be executed.In this particular case there is a big failure to predict and that is why it calculates many more. <br />

<br />

## 1.2 The total number of block replacements for the L1 data cache

The table with the block replacements for the L1 data cache:


| BenchMark |  |  |
| :---: | :---: | :---: |
| Specbzip |  |  | 
| Specmcf |  |   |
| Spechmmer |  |  | 
| Specsjeng |  |  |
| Speclibm |  |  |




