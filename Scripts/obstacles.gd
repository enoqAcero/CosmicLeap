extends Area2D

var speedY = 0.0
var speedX = 0.0
var dir = 0
var control = 0



var prob

func _ready():
	randomize()
	var rng = RandomNumberGenerator.new()
	prob = rng.randi_range(0, 100)
	
	$".".body_entered.connect(bodyEntered)

func _process(_delta):
	position.y += speedY
	
	if control == 0:
		if prob >= 50: dir = -1
		else: dir = 1
		control = 1
	
	if dir == -1:
		position.x -= speedX
	elif dir == 1:
		position.x += speedX


func bodyEntered(body):
	if body.name == "Right":
		dir = -1
		
	if body.name == "Left":
		dir = 1
		
