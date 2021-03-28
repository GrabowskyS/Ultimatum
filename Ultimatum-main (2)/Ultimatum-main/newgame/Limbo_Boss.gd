extends KinematicBody2D


func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	self.z_index = self.position.y
