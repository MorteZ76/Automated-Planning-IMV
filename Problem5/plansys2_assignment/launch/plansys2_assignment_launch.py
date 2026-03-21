import os
from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch.actions import IncludeLaunchDescription
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch_ros.actions import Node

def generate_launch_description():
    pkg_dir = get_package_share_directory('plansys2_assignment')

    plansys2_cmd = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(os.path.join(
            get_package_share_directory('plansys2_bringup'),
            'launch', 'plansys2_bringup_launch_monolithic.py')),
        launch_arguments={
            'model_file': os.path.join(pkg_dir, 'pddl', 'domain.pddl'),
            'problem_file': os.path.join(pkg_dir, 'pddl', 'problem.pddl')  # <-- ADD THIS LINE
        }.items())

    action_nodes = [
        'move_normal', 'move_sealing', 'move_drone', 'load_delicate_artifact',
        'load_normal_artifact', 'unload_artifact', 'cooling', 'load_pod',
        'unload_pod', 'enable_sealing', 'disable_sealing'
    ]

    nodes = [Node(package='plansys2_assignment', executable=f'{a}_node', name=f'{a}_node', output='screen') for a in action_nodes]

    return LaunchDescription([plansys2_cmd] + nodes)