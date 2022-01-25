# Simulink Model generation using MATLAB Commands and Functions  
The main task of this example is to create and fill in a .slx file using the MATLAB script. MATLAB has an extensive API (Application Program Interface) for building and modifying Simulink models from MATLAB code. This may be from either the MATLAB command line, from within a function or script, or from anywhere that m-code can be executed.  
  
The primary functions for this:  
+ `add_block`  
+ `add_line`  
+ `set_param` 
+ `get_param` 
  
Required version of MATLAB 2021b and higher      
  
## Sine Wave Model  
To run the example use `just_sin_wave.m`. The script checks for the existence of the `test_system.slx` file. The file is then recreated. Each script startup overwrites the Simulink model `test_system.slx`. The script will add new blocks to the scheme space:  
  
![Creating blocks](pic/1.png)  
  
After that, the script adds links between the blocks:  
  
![Adding lines](pic/2.png)  
  
Block parameters are changed and simulation is started. To close the model, you must press the Enter key in the Matlab console. The result of the script:  
  
![Creating blocks](pic/3.png)   
  
## 2 Bar Mechanism  
To run the example use `two_bar_mech.m`.  
  
  
  
