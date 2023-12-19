extends Node2D

@export var posVector : Vector2
var pressing = false

var knob
var ring
var initialPos = Vector2(250,500)

var maxLength = 50
var deadZone = 5

func _ready():
	knob = $Knob
	ring = $Ring
	

func _process(delta):
	#if pressing == false:
		#knob.visible = false
		#ring.visible = false
	#elif pressing == true:
		#knob.visible = true
		#ring.visible = true
	if pressing == true:
		if knob.get_global_mouse_position().distance_to(initialPos) <= maxLength:
			knob.global_position = get_global_mouse_position()
		else:
			var angle = initialPos.angle_to_point(get_global_mouse_position())
			knob.global_position.x = initialPos.x + cos(angle)*maxLength
			knob.global_position.y = initialPos.y + sin(angle)*maxLength
		calculateVector()
	else:
		knob.global_position = lerp(knob.global_position, initialPos, delta*10)
		posVector =  Vector2(0,0)
	#print(posVector)

func calculateVector():
	if abs((knob.global_position.x - initialPos.x)) >= deadZone:
		posVector.x = (knob.global_position.x - initialPos.x)/maxLength
		posVector.y = (knob.global_position.y - initialPos.y)/maxLength

func _on_button_button_down():
	if pressing == false:
		initialPos = get_global_mouse_position()
		ring.global_position = initialPos
		knob.global_position = initialPos
	pressing = true


func _on_button_button_up():
	pressing = false
