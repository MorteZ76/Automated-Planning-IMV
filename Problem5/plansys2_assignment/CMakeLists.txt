cmake_minimum_required(VERSION 3.5)
project(plansys2_assignment)

find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(rclcpp_action REQUIRED)
find_package(plansys2_msgs REQUIRED)
find_package(plansys2_executor REQUIRED)

set(CMAKE_CXX_STANDARD 17)
set(dependencies rclcpp rclcpp_action plansys2_msgs plansys2_executor)

set(action_nodes
  move_normal move_sealing move_drone 
  load_delicate_artifact load_normal_artifact 
  unload_artifact cooling load_pod unload_pod 
  enable_sealing disable_sealing
)

foreach(node ${action_nodes})
  add_executable(${node}_node src/${node}_node.cpp)
  ament_target_dependencies(${node}_node ${dependencies})
endforeach()

install(DIRECTORY launch pddl DESTINATION share/${PROJECT_NAME})
install(TARGETS 
  move_normal_node move_sealing_node move_drone_node 
  load_delicate_artifact_node load_normal_artifact_node 
  unload_artifact_node cooling_node load_pod_node unload_pod_node 
  enable_sealing_node disable_sealing_node
  RUNTIME DESTINATION lib/${PROJECT_NAME}
)

ament_export_dependencies(${dependencies})
ament_package()