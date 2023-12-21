extends Node2D

var numSprites = 6

func _ready():
	changeColor()
	

func changeColor():
	
	var color = Color(randf(),randf(),randf(),0.7)
	while color.v < 0.7: color = Color(randf(),randf(),randf(),0.7)
	
	var step = 0.1666
	var color2 = Color.from_hsv(color.h,color.s, color.v,color.a)
	
	for i in range (0, numSprites):
		
		color2.h += step
		var hue = color2
		
		if i == 0: $ParallaxBackground/ParallaxLayer2/Sprite2D2.self_modulate = hue
		if i == 1: $ParallaxBackground/ParallaxLayer2/Sprite2D.self_modulate = hue
		if i == 2: $ParallaxBackground/ParallaxLayer/Sprite2D2.self_modulate = hue
		if i == 3: $ParallaxBackground/ParallaxLayer/Sprite2D.self_modulate = hue
		if i == 4: $ParallaxBackground/ParallaxLayer3/Sprite2D.self_modulate = hue
		if i == 5: $ParallaxBackground/ParallaxLayer3/Sprite2D2.self_modulate = hue
