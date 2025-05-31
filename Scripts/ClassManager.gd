extends Node
3  class_name ClassManager
4  
5  var classes: Dictionary = {}
6  
7  func _ready():
8      load_classes()
9  
20     else:
21         push_error("Failed to open classes.json.")