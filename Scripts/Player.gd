extends CharacterBody2D

var horizontalForce = 600
var gravity  = 700
var jumpForce = 0
var prevJumpForce = 0
var bounceFactor = 1
var readyToBounce = false


var maxVelocity = 1000

var area1
var area2

var joystick
var direction

func _ready():
	joystick = get_parent().get_node("CanvasLayer/JoyStick")
	$".".set_collision_layer_value(2, true)
	$".".set_collision_mask_value(2, true)

func _physics_process(delta):
	direction = joystick.posVector
	if direction:
		velocity.x = direction.x * horizontalForce
	else: 
		velocity.x = 0
	
	if velocity.y > maxVelocity:
		velocity.y = maxVelocity
	else:
		velocity.y += gravity * delta
	
	if Input.is_action_pressed("right"):
		velocity.x += horizontalForce
		print("RIGHT")
	if Input.is_action_pressed("left"):
		velocity.x -= horizontalForce
	
	
	
	if is_on_floor() and readyToBounce == false: #and Input.is_action_just_pressed("click"):
		if jumpForce > prevJumpForce:
			jumpForce = prevJumpForce
		velocity.y = -jumpForce
		prevJumpForce = jumpForce
	if is_on_floor() and readyToBounce == true:
		velocity.y = -jumpForce * bounceFactor
		prevJumpForce = jumpForce
		
	move_and_slide()


#controlar si se salto en el trampolin
func bControl(control : bool):
	if control == true:
		readyToBounce = true
	else:
		readyToBounce = false
	
#modificar el factor de salto en trampolin	
func bFactor(factor : float):
	bounceFactor = factor

#modificar el factor de fuerza de salto
func force(factor : float):
	jumpForce = factor






	
