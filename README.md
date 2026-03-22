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
planutils run downward domain.pddl problem.pddl -- --search "lazy_greedy([ff(),cea()],preferred=[ff(),cea()])"
```   
(Repeat these commands in the Problem2 folder for the multi-agent/capacity version).

## 3. Running HTN Planning (Problem 3)
Problem 3 requires the **PANDA** framework to process Hierarchical Task Networks (HDDL).
```bash
cd ../Problem3
# Run the HTN solver using the planutils wrapper
planutils run panda domain.hddl problem.hddl
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
Problem 5 must be run in a native ROS 2 Humble/Iron environment (outside the standard planutils container) because it requires building and linking C++ Action Nodes.

### 1. Environment Setup (Host Terminal)
If you do not have ROS 2 installed locally, use the official Docker image. Ensure you are in the root of your project directory before running the command to mount your workspace correctly.
```bash
# Exit the planutils container if you are still in it
exit

# Start the ROS 2 Humble container with path conversion disabled
# Note: We mount to /workspace for a cleaner path structure
MSYS_NO_PATHCONV=1 docker run -it --name plansys_vault --privileged -v "/$(pwd):/workspace" osrf/ros:humble-desktop
```

### 2. Dependency Installation & Build (Terminal 1)
Once inside the ROS 2 container, install the PlanSys2 framework and build the Martian Vault package.
```bash
# 1. Update package index and install PlanSys2 + Build Tools
apt update
apt install -y ros-humble-plansys2* \
                python3-colcon-common-extensions \
                python3-rosdep

# 2. Update rosdep metadata
rosdep update

# 3. Navigate to the project folder
# Note: We use /workspace to avoid Git Bash path mangling
cd /workspace/Problem5/plansys2_assignment

# 4. Install workspace-specific dependencies
rosdep install --from-paths src --ignore-src -r -y

# 5. Build and Source the workspace
# Safety: If you have moved the folder, run 'rm -rf build/ install/ log/' first
colcon build --symlink-install
source install/setup.bash

# 6. Launch the PlanSys2 system and Action Nodes
ros2 launch plansys2_assignment plansys2_assignment_launch.py
```
### 3. Problem Initialization & Execution (Terminal 2)
While Terminal 1 is running, open a second terminal to "feed" the world state and trigger the plan.

```bash
# 1. Enter the running container
docker exec -it plansys_vault bash

# 2. Source the ROS 2 and local environment
source /opt/ros/humble/setup.bash
cd /workspace/Problem5/plansys2_assignment
source install/setup.bash

# 3. Load state and run via the One-Shot Pipe 
# This uses your commands.txt to initialize and execute in one sequence
(cat commands.txt; sleep 5) | ros2 run plansys2_terminal plansys2_terminal

```
### Technical Note: Hardware Coordination
The PlanSys2 executor handles the concurrent execution of the drone_1 and curator_1 actions. During the run phase, Terminal 1 will display real-time logs from the C++ nodes (e.g., cooling_node, move_drone_node) as they interact with the simulated environment to secure the artifacts.
