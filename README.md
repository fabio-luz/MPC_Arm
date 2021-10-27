# MPC_Arm

An MPC algorithm was developed using acados MATLAB interface for a 6-DOF robotic arm, using a first-order model to represent it. 

## How to use

1. Install the acados' MATLAB interface from https://github.com/acados/acados;
2. Change the variables *example_dir*, *acados_dir*, *casadi_dir*, *matlab_interface_dir*, and *mex_template_dir* in the file **acados_env_variables_windows.m** provided by acados to meet the path directories of your installation;
3. Choose between 1 to 6 options for the reference position on the function **input_gen.m**;
4. Run the program **main.m**.

If you want to use the algorithm for any other manipulator, it is required to change the **forward_kinematics.m** to meet the structure of your arm and change the parameters or use a more complete model.
