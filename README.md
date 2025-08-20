# Compressed Sensing Biossonar

## What is this code?

This code is the piece of software used for simulating a dolphin sonar in the case where it tries to recognize 
an object by sending only one single click. This code makes all the simulations using a software called k-Wave
and the results are processed by using a technique called compressed sensing. This software was made for a scientific
research made in 2025 by me while in my masters degree at IP Paris, the .pdf of the article will be soon available.

## How to make it work?

### Necessary software and packages
This code was made using MATLAB R2024b with the packages k-Wave 1.4.0, Communications Toolbox 22.4, Image Processing
Toolbox 24.2 and Statistics and Machine Learning Toolbox 24.2.

### What is the flux of the code?

This code is divided into 6 scripts. 5 of them follow an order going from a to e and the last one just runs all of 
them in this order. An object $Simulation$ is also defined. It will basically carry many parameters from the simulation
and functions that will mask many parameter passages, facilitating for the final user.

>a_simulation_routine.m

- This script runs the simulation itself. Some important hyperparameters that can be adjusted are for example the
simulation time, the number of sensors, position of the emitter, level of noise, etc.

- The simulation also needsan object to be places in front of it. The ones used in the article are in the folder 
$object_images$ and go from 1 to 4. When runing this script, this will be a settable parameter too.

>b_sparse_coding.m

- This script takes the readings from the previous one and applies sparse coding to it, obtaining a reconstruction
vector $g$.

- This script defines an important hyperparameter $\lambda$ that controls the level of sparsity of the solution.

- For our scenario, the dictionary used in the compressed sensing technique is previously calculated. They are
  too heavy for being on github, so, you'll have to generate on your machine (will be done automatizally).
  However, if any changes are made on the number of voxels, position of the emitter, number and positions of sensors, etc.,
  this dictionary will need to be regenerated. The code saves only the information on the number of sensors, since
  it was the only thing needed for the article.

  - One other important thing is a non-computable mask. This mask is defined here and defines a mask of points that
    won't enter in the dictionary, reducing the space. This was created so that solutions from high noise scenarios
    wouldn't concentrate in signals = 0 from the dictionary.

>c_gen_resoult_routine.m

- This script transforms the vector $g$ into a "probability map" of solutions and plots it over the ground truth object.

- It defines important variables, the $\sigma$, which controls the standard deviation of each point and $Th$ wich is the
  threshold of values that will not be considered. 

>d_measure_accuracy.m

- Script that will measure the accuracy and error of the solution generated previously.

>e_inverse_rec.m

- Script that will make an inverse reconstruction of the original object by only using the results obtained from the
  compressed sensing.

>full_routine.m

- Simply runs all previous scripts in order. Im **important to set the values on each script before executing this one.**


## Reproductibility

Upon following these instructions, you should be able to have the same results as the ones shown in the original article.

