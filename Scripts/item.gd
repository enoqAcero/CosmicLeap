extends Area2D

var speedY = 3.4
var magnet = false



func _physics_process(_delta):
	if magnet == true:
		position += (get_parent().get_node("michi").position - position).normalized() * 25
	position.y += speedY
