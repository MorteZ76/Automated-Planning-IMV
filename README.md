# Automated-Planning-IMV
PDDL &amp; HDDL models for the Interplanetary Museum Vault (IMV) space scenario. Features a progression from STRIPS to Temporal planning and a ROS 2 PlanSys2 implementation. Includes autonomous curators and drones managing artifact relocation under seismic constraints.

## 1. Repository Setup and Containerization

First, clone the repository and start the $planutils$ container, which provides a pre-configured environment for **Fast Downward**, **Optic**, and **TFD**.

```bash
# Clone the repository
git clone https://github.com/MorteZ76/Automated-Planning-IMV
cd Automated-Planning-IMV

# Start the Planutils container with your local files mounted
# Note: --privileged is required to allow Singularity/Apptainer to run inside Docker
docker run -it --privileged -v "/$(pwd):/root/workspace" aiplanning/planutils:latest
```
Once inside the container, navigate to your files and initialize the environment:

```bash
# Move to the mounted project directory
cd /root/workspace

# Initialize planutils and install the required solvers
planutils activate
planutils install downward optic tfd panda
```   
## 2. Running Classical Planning (Problems 1 & 2)
These problems use Fast Downward to find optimal and satisficing plans for artifact relocation.

### For Optimal Solution (A* Blind):
This configuration guarantees the shortest path but results in high state expansion
```bash
cd Problem1
planutils run downward domain.pddl problem.pddl -- --search "astar(blind())"
```   
### For Satisficing Solution (LAMA-First):
```bash
planutils run downward domain.pddl problem.pddl --alias lama-first
```   
(Repeat these commands in the Problem2 folder for the multi-agent/capacity version).

## 3. Running HTN Planning (Problem 3)
Problem 3 requires the **PANDA** framework to process Hierarchical Task Networks (HDDL).
```bash
cd ../Problem3
# Ensure panda is installed or use the PANDA container/server
# Example command for a local PANDA installation:
panda-client domain.hddl problem.hddl
``` 
This will utilize the hhRC(hFF) heuristic to solve the task decomposition.

## 4. Running Temporal Planning (Problem 4)
This step uses Optic or TFD to handle durative actions and concurrent robot tasks.
### Using Optic (Greedy Search):
```bash
cd ../Problem4
planutils run optic domain.pddl problem.pddl
```
### Using TFD (Anytime Search):
```bash
planutils run tfd domain.pddl problem.pddl
```
## 5. PlanSys2 & ROS 2 Deployment (Problem 5)
Problem 5 must be run in a ROS 2 Humble/Iron environment (outside the standard planutils container) as it involves building C++ nodes.
```bash
# Move to the PlanSys2 package directory
cd ../Problem5/plansys2-assignment

# Install dependencies and build the package
rosdep install --from-paths src --ignore-src -r -y
colcon build --symlink-install

# Source the workspace and launch the system
source install/setup.bash
ros2 launch plansys2_assignment_launch.py
```
This will initialize the cooling-node.cpp and other action nodes to simulate the Martian vault execution.
