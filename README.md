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

For the first benchmark (first command mentioned above)

 αυτα που θελουμε ειναι σε αυτα τα σημεια 
system.cpu.committedInsts                        5712                       # Number of instructions committed
system.cpu.committedOps                         10314                       # Number of ops (including micro ops) committed

For the second benchmark (second command mentioned above)

For the third benchmark (third command mentioned above)

For the fourth benchmark (fourth command mentioned above)

For the fifth benchmark (fifth command mentioned above)
