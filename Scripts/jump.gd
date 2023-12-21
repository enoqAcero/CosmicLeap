extends Node2D

var rng = RandomNumberGenerator.new()

var gliderPath = preload("res://Scenes/Glider.tscn")
var fuegoPath = preload("res://Scenes/Fuego.tscn")
var michiLoad = preload("res://Scenes/PlayerCharacter.tscn")
var shieldPath = preload("res://Scenes/Shield.tscn")

var michiInstance
var shieldInstance
var michiSprite
var michiAnimationPlayer
var michiStartPos = Vector2(240,500)
var gliderSprite
var fuegoSprite

var trampolineSprite

var savePath = "res://Save/"
var saveFile = "PlayerSave"
var playerData : Player

var gameRunning = false

var highScore = 0
var score = 0
var prevScore = score

var screenSize : Vector2

#fuerza de brinco inicial
var minJumpForce = 1800
var newMinForce
var maxJumpForce = 8000
var jumpForce
var nextJumpForce
var minBounceFactor = 1
var bounceFactor
var prevBounceFactor
var readyToBounce = false
var bounceFactorControl = true
var multiplier : float
var multiplierCount
var clickControl = false


var posMichi = 0
var michiMinPos

var cameraStartPos = Vector2(240,427)
var cameraControl
var cameraUpControl = false
var cameraDownControl = false
var cameraStart = false
var cameraSpeed = 3
var cameraOffset = 0

var forceFunctionControl = true

var maxHeight

var falling = false
var fallingControl = false
var goingUpControl = false
var michiPos
var prevMichiPos


#items
var startPowerTimer = 3
var coin = preload("res://Scenes/Obstacles/items/coin.tscn")
var StarPower = preload("res://Scenes/Obstacles/items/StarPower.tscn")
var MultiplierPower = preload("res://Scenes/Obstacles/items/MultiplierPower.tscn")
var MagnetPower = preload("res://Scenes/Obstacles/items/MagnetPower.tscn")
var CoinShowerPower = preload("res://Scenes/Obstacles/items/CoinShowerPower.tscn")

#satelites
var platform1 = preload("res://Scenes/Obstacles/Satelites/Platform1.tscn")
var platform2 = preload("res://Scenes/Obstacles/Satelites/Platform2.tscn")
var platform3 = preload("res://Scenes/Obstacles/Satelites/Platform3.tscn")
var platform4 = preload("res://Scenes/Obstacles/Satelites/Platform4.tscn")

#meteoritos
var Meteor1 = preload("res://Scenes/Obstacles/Asteroids/Meteor1.tscn")
var Meteor2 = preload("res://Scenes/Obstacles/Asteroids/Meteor2.tscn")
var Meteor3 = preload("res://Scenes/Obstacles/Asteroids/Meteor3.tscn")
var Meteor4 = preload("res://Scenes/Obstacles/Asteroids/Meteor4.tscn")

var itemScriptPath = preload("res://Scripts/item.gd")
var obsScriptPath = preload("res://Scripts/obstacles.gd")



var items = []

#var Obstacles := [wetSign,cactus,poo,bee,baseball,globo]
var Obstacles := [platform1, platform2, platform3, platform4]
var ObstaclesMeteor := [Meteor1, Meteor2, Meteor3, Meteor4, platform4]
var Powers := [StarPower, MultiplierPower, MagnetPower, CoinShowerPower]

var obstaclesInstance : Array
var itemsInstance : Array
var coinInstance : Array
var coinCounter = 0
var coinString = [3,10]
var controlCoins = 0
var coinXpos = [50, 430]
var lastCoinPos = 0

var obstacleXpos = [150, 350]
var controlObstacles = 0

var finalCoins = 0
var coinWonLabel 

var itemCounterForName = 0
var menuControl = false


var StarPowerActive = false
var MagnetPowerActive = false
var CoinShowerPowerActive = false
var magnetControl = false

var controlAnimation = false

var dificulty = 1
var controlDif = false
var maxDificulty = 10
var playerVelocity = 1000
var platMinSpeed = [7,12]
var meteorMinSpeed = [20,30]

var doubleClick = false
var shieldActive = false
var shieldControl = false
var controlHit = false

func _ready():
	
	
	loadData()
	#loadItems()
	$Menu.visible = true
	trampolineSprite = $Floor.get_node("AnimatedSprite2D")
	screenSize = get_window().size
	coinWonLabel = $CanvasLayer/GameOver.get_node("VBoxContainer/HBoxContainer/CoinNumber")
	
	
	
	$Floor.get_node("Area2D").body_entered.connect(controlBounceEnter)
	$Floor.get_node("Area2D").body_exited.connect(controlBounceExit)
	$Floor.get_node("Area2D2").body_entered.connect(controlBounceHit)
	$Floor.get_node("Area2D3").body_entered.connect(controlAnimationEnter)
	$Floor.get_node("Area2D3").body_exited.connect(controlAnimationExit)
	$AreaBtnControl.mouse_entered.connect(controlMenu)
	$AreaBtnControl.mouse_exited.connect(controlMenu2)
	$Menu.get_node("VBoxContainer/Store").pressed.connect(openStore)
	$Menu.get_node("VBoxContainer/Me").pressed.connect(openMePage)
	$Menu.get_node("VBoxContainer/Settings").pressed.connect(openSettings)
	$store.get_node("Back").pressed.connect(mainMenu)
	$settings.get_node("Back").pressed.connect(mainMenu)
	$mePage.get_node("Back").pressed.connect(mainMenu)
	$CanvasLayer/GameOver.get_node("VBoxContainer/HBoxContainer2/Menu").pressed.connect(exit)
	$CanvasLayer/GameOver.get_node("VBoxContainer/Video").pressed.connect(video)
	michiAnimationPlayer.animation_finished.connect(animationFinished)
	
	SignalManager.changeSkin.connect(changeSkin)
	SignalManager.updateMePage.connect(updateMePage)
	

	
	
	
	
func newGame():
	gameRunning = false
	get_tree().paused = false
	itemCounterForName = 0
	
	
	$CanvasLayer/GameOver.visible = false
	
	michiInstance.prevJumpForce = 700
	clickControl = false
	cameraStart = false
	falling = false
	michiPos = 0
	prevMichiPos = 0
	
	finalCoins = 0
	score = 0
	maxHeight = 0
	michiMinPos = 0
	multiplier = 1
	multiplierCount = 0
	cameraControl = 0
	controlObstacles = 0
	cameraOffset = 0
	coinCounter = 0
	lastCoinPos = 0
	
	StarPowerActive = false
	MagnetPowerActive = false
	CoinShowerPowerActive = false
	magnetControl = false
	
	jumpForce = minJumpForce
	newMinForce = minJumpForce
	nextJumpForce = jumpForce
	bounceFactor = minBounceFactor
	prevBounceFactor = bounceFactor
	

	#clear obstacles
	for obs in obstaclesInstance:
		obs.queue_free()	
	obstaclesInstance.clear()
	for itm in itemsInstance:
		itm.queue_free()
	itemsInstance.clear()
	
	
	michiInstance.force(jumpForce)
	michiInstance.bFactor(bounceFactor)
	
	michiInstance.global_position = michiStartPos
	$Camera2D.global_position = cameraStartPos
	$CanvasLayer/Score.text = "0"
	$CanvasLayer/Multiplier.text = "0"
	$CanvasLayer/FloorDistance.text = "0"
	$CanvasLayer/HighScore.text = str(playerData.highScore)
	
	#update powerup timer
	$StarPowerTimer.wait_time = startPowerTimer +  playerData.StarPowerLvl
	print("StarPower Timer:", startPowerTimer +  playerData.StarPowerLvl)
	$MagnetPowerTimer.wait_time = startPowerTimer +  playerData.MagnetLvl
	$CoinShowerPowerTimer.wait_time = startPowerTimer +  playerData.CoinShowerLvl

func _process(_delta):
	#print($Menu.get_node("VBoxContainer/Store"))
	if michiInstance.global_position.y > michiMinPos:
			michiMinPos = michiInstance.global_position.y
			
	if gameRunning == true:
		
		if falling== true and controlAnimation == false:
			michiAnimationPlayer.play("StartFalling")
			
		if menuControl == false:
			$AreaBtnControl.hide()
			$Menu.visible = false
			$CanvasLayer/JoyStick.visible = true
			
			
			if cameraStart == false:
				var direction = $CanvasLayer/JoyStick.posVector
				if direction:
					if cameraUpControl == false:	
						if direction.y < 0:
							cameraOffset += (direction.y * cameraSpeed)	
						if Input.is_action_pressed("up"):
							cameraOffset -= cameraSpeed
							
					if cameraDownControl == false:
						if direction.y > 0:
							cameraOffset += (direction.y * cameraSpeed)	
						if Input.is_action_pressed("down"):
							cameraOffset += cameraSpeed
							
							
				else:
					direction.y = 0
					
				
							
			if falling == false and posMichi > 500:
				getFallingStatus()	
				
			
		
			#calcular la pos actual de michi con respecto al suelo
			posMichi = (michiInstance.global_position.y - michiMinPos) * -1
			#borrar obstaculos 
			if readyToBounce == true:
				cleanObstacles()
				
				
			if falling == true and posMichi > 5500:
				if controlObstacles == 1:
					#generador de obstaculos
					generateObstacles()
				if controlCoins == 1 and CoinShowerPowerActive == false:
					#generador de monedas cayendo
					generateCoins(0)
			elif falling == false and posMichi > 4000:
				if controlCoins == 1 and CoinShowerPowerActive == false:
					#generador de monedas subiendo
					generateCoins(1)
					
		
			if posMichi > maxHeight:
				maxHeight = posMichi
				
			#cambiar score
				score = maxHeight/10
				
			
			if readyToBounce == true:
				#update bounce factor
				prevBounceFactor = bounceFactor
		
				if Input.is_action_just_pressed("click"):	
					if clickControl == false:
						bounceFactor += 0.2
						michiInstance.bControl(readyToBounce)
						bounceFactorControl = false
						multiplier = multiplier + 0.1
						multiplierCount = multiplierCount + 1
						clickControl = true
				if michiInstance.is_on_floor() and bounceFactorControl == true and bounceFactor <= prevBounceFactor:
					bounceFactor -= 0.15
					bounceFactorControl = false
					multiplier = 1
					multiplierCount = 0
					
				if bounceFactor < minBounceFactor:
					bounceFactor = minBounceFactor
				michiInstance.bFactor(bounceFactor)
				
				if multiplierCount > 0:
					var force = rng.randi_range(5,20)
					jumpForce = jumpForce + (force * multiplier)
					newMinForce = minJumpForce + jumpForce/5
				else:
					var force = rng.randi_range(10,20)
					jumpForce = jumpForce - force 
					newMinForce = minJumpForce + jumpForce/5
					
				if newMinForce < minJumpForce:
					newMinForce = minJumpForce
				if jumpForce > maxJumpForce:
					jumpForce = maxJumpForce
				if jumpForce < newMinForce:
					jumpForce = newMinForce
				michiInstance.force(jumpForce)
					
			
			for obs in obstaclesInstance:
				if is_instance_valid(obs):
					if obs.position.y < ($Camera2D.position.y - screenSize.y * 3):
						removeObstacle(obs, 0)

			for itm in itemsInstance:
				if is_instance_valid(itm):
					if itm.position.y < ($Camera2D.position.y - screenSize.y):
						removeObstacle(itm, 1)
				
			for cn in coinInstance:
				if is_instance_valid(cn):
					if cn.position.y < ($Camera2D.position.y - screenSize.y * 3):
						removeObstacle(cn, 1)	


			if posMichi > 500 and falling == false and goingUpControl == false:
				goingUp()
				
				
			if falling == true and fallingControl == false:
				goingDown()
		
			#move camera
			if cameraControl == 1:
				$Camera2D.position.y = michiInstance.position.y + cameraOffset
			#update score
			$CanvasLayer/Score.text = str(int(score))
			#update muliplier
			$CanvasLayer/Multiplier.text = str(multiplierCount)
			#update floor distance
			$CanvasLayer/FloorDistance.text = str(int(posMichi)/10)
			
			
			
			#handle powers
			if StarPowerActive == true:
				michiInstance.set_collision_layer_value(1, false)
				michiInstance.set_collision_mask_value(1, false)
				michiInstance.scale.x = 5
				michiInstance.scale.y = 5
			else:
				michiInstance.scale.x = 2
				michiInstance.scale.y = 2
				michiInstance.set_collision_layer_value(1, true)
				michiInstance.set_collision_mask_value(1, true)
				
				
			if MagnetPowerActive == true:
				magnetControl = false
				if magnetControl == false:
					MagnetPowerFunc()
					magnetControl = true
			
						
			if CoinShowerPowerActive == true:
				if controlCoins == 1:
					generateCoins(1)
					
			
		
			#increase dificulty
			if controlDif == false and int(score) / 1000 > int(prevScore) / 1000:
				print("IncreaseDificulty")
				controlDif = true
				increaseDificulty()
				
			prevScore = score
				
			
			#manejar estado del escudo
			if shieldActive == true and shieldControl == false:
				shieldControl = true
				activateShield()
				michiInstance.set_collision_layer_value(1, false)
				michiInstance.set_collision_mask_value(1, false)	
				
			
			
	else:
		$AreaBtnControl.show()
		if Input.is_action_just_pressed("click") and menuControl == false:
			gameRunning = true
		
func MagnetPowerFunc():
	for cn in coinInstance:
		if is_instance_valid(cn):
			cn.magnet = true
				
func getFallingStatus():
#ver si el michi esta saltando o cayendo
	michiPos = -michiInstance.global_position.y
	if michiPos <= 0: michiPos = 1
	if michiPos < prevMichiPos:
		falling = true
	prevMichiPos = michiPos
	
	
func cleanObstacles():
	for obs in obstaclesInstance:
		if is_instance_valid(obs):
			obs.queue_free()
	for itm in itemsInstance:
		if is_instance_valid(itm):
			itm.queue_free()
	for cn in coinInstance:
		if is_instance_valid(cn):
			cn.queue_free()
		
	coinInstance.clear()
	obstaclesInstance.clear()
	itemsInstance.clear()		

func goingUp():
	michiInstance.scale.x = 2
	michiInstance.scale.y = 2
	michiAnimationPlayer.play("Fly")
	gliderSprite.visible = false
	goingUpControl = true
	
	if not multiplierCount == 0:
		fuegoSprite.visible = true
		
	if multiplierCount == 1:
		fuegoSprite.visible = true
		fuegoSprite.modulate = Color("#ffffff")
	elif multiplierCount == 2:
		fuegoSprite.visible = true
		fuegoSprite.modulate = Color("#ffffab")
	elif multiplierCount == 3:
		fuegoSprite.modulate = Color("#ff775c")
	elif multiplierCount == 4:
		fuegoSprite.modulate = Color("#ff0000")
	elif multiplierCount == 5:
		fuegoSprite.modulate = Color("#f000be")
		
	
	
	
func controlBounceEnter(body):
	if body.name == "michi":
		michiAnimationPlayer.play("Jump")
		readyToBounce = true
		#$CanvasLayer/FloorDistance.label_settings.font_color = Color("#15fc00")
	
func controlBounceExit(body):
	if body.name == "michi":
		controlAnimation = false
		readyToBounce = false
		bounceFactorControl = true
		falling = false
		prevMichiPos = 0
		clickControl = false
		fallingControl = false
		michiInstance.bControl(readyToBounce)
		
func controlBounceHit(body):
	if body.name == "michi":
		readyToBounce = false
		#$CanvasLayer/FloorDistance.label_settings.font_color = Color(1,1,1,1)
		if gameRunning == true:
			cameraControl = 1
		
func controlAnimationEnter(body):
	if body.name == "michi":
		trampolineSprite.play("jump")
func controlAnimationExit(body):
	if body.name == "michi":
		michiInstance.scale.x = 2
		michiInstance.scale.y = 2
		
		
func generateObstacles():
	if falling == true and controlObstacles == 1:
		randomize()
		
		var posX = rng.randi_range(obstacleXpos[0], obstacleXpos[1])
		var posY = 2000 - posMichi
		
		#probabilidad de obstaculos y items
		var prob = rng.randi_range(0, 100)
		#plataformas
		if prob < 70:
			var obs_type = Obstacles[randi() % (Obstacles.size() - 1)]
			if prob <= 2:
				obs_type = platform4
				
			var obs = obs_type.instantiate()
			obs.set_script(obsScriptPath)
			var obs_x = posX
			var obs_y = posY
			obs.global_position = Vector2(obs_x,obs_y)
			obs.speedX = rng.randf_range(1, 4)
			obs.speedY = rng.randf_range(platMinSpeed[0], platMinSpeed[1])
			

			#var hue = posMichi/float(score)
			#var color = Color.from_hsv(hue,1,1)
			#obs.modulate = color
			addObstacle(obs, 0)
		#meteoritos
		if prob >= 70 and prob < 95:
			var obs_type = ObstaclesMeteor[randi() % Obstacles.size()]
			var obs = obs_type.instantiate()
			obs.set_script(obsScriptPath)
			posY = -posMichi - 900
			var obs_x = posX
			var obs_y = posY
			obs.global_position = Vector2(obs_x,obs_y)
			obs.speedX = rng.randf_range(3, 7)
			obs.speedY = rng.randf_range(meteorMinSpeed[0], meteorMinSpeed[1])
			obs.scale = Vector2(0.5,0.5)
			addObstacle(obs, 0)
		#items
		elif prob >=95:
			var item_type = Powers[randi() % Powers.size()]
			var item = item_type.instantiate()
			item.set_script(itemScriptPath)
			item.speedY = rng.randf_range(platMinSpeed[0], platMinSpeed[1])
			item.global_position = Vector2(posX,posY)
			item.add_to_group("item")
		
			item.name = item.name + str(itemCounterForName)
			itemCounterForName += 1
			var itemName = getName(item.name)
			
			
			if itemName == "StarPower" or item_type == Powers[0]:
				item.add_to_group("StarPower")
			if itemName == "MultiplierPower" or item_type == Powers[1]:
				item.add_to_group("MultiplierPower")
			if itemName == "MagnetPower" or item_type == Powers[2]:
				item.add_to_group("MagnetPower")
			if itemName == "CoinShowerPower" or item_type == Powers[3]:
				item.add_to_group("CoinShower")
		
			addObstacle(item, 1)
			
		controlObstacles = 0
		
#initialPos = 0 Down, initalPos = 1 Up
func generateCoins(initialPos : int):
	if controlCoins == 1:
		randomize()
		
		
		var posY
		var posX = rng.randi_range(coinXpos[0], coinXpos[1])
		
		while lastCoinPos - 33 <= posX and lastCoinPos + 33 >= posX:
			posX = rng.randi_range(coinXpos[0], coinXpos[1])
			
		lastCoinPos = posX
	
		var coinSpeed
		if initialPos == 0:
			posY = 2000 - posMichi
			coinSpeed = rng.randf_range(platMinSpeed[0], platMinSpeed[1])
		else:
			posY = -posMichi - 900
			if CoinShowerPowerActive == true:
				coinSpeed = meteorMinSpeed[1]
			else:
				coinSpeed = 0

		
		var prob = rng.randi_range(0, 100)
		var coinStringSize = rng.randi_range(coinString[0], coinString[1])
		if prob >= 60:
			for i in range (0, coinStringSize):
				var coinI = coin.instantiate()
				coinI.set_script(itemScriptPath)
				coinI.global_position.x = posX
				coinI.global_position.y = posY
				if initialPos == 0:
					posY += 40
				else:
					posY -= 40
				coinI.speedY = coinSpeed
				coinI.add_to_group("item")
				coinI.add_to_group("Coin")
				addObstacle(coinI, 1)
		controlCoins = 0
	
		
func addObstacle(obs, control : int):
	if control == 0:
		obs.body_entered.connect(hitObstacle)
		add_child(obs)
		obstaclesInstance.append(obs)
	else:
		obs.body_entered.connect(Callable(collect).bind(obs))
		add_child(obs)
		if obs.is_in_group("Coin"):
			coinInstance.append(obs)
		else:
			itemsInstance.append(obs)

func removeObstacle(obs, control : int):
	if control == 0:
		obs.queue_free()
		obstaclesInstance.erase(obs)
	else:
		obs.queue_free()
		itemsInstance.erase(obs)
		
func hitObstacle(body): 
	
	if body.name == "michi" and shieldActive == true:
		controlHit = true
		shieldActive = false
		shieldInstance.name = "tempNameShield"
		shieldInstance.queue_free()
		$ShieldOffTimer.start()
	
	if body.name == "michi" and shieldActive == false and controlHit == false:
		gameOver()	
	
func collect(body, obs):
	if body.name == "michi":
		if obs.is_in_group("item"):
			if obs.is_in_group("Coin"):
				for cn in coinInstance:
					if cn == obs:
						handleItemCollection(cn)
						break
			else:
				for itm in itemsInstance:
					if itm == obs:
						handleItemCollection(itm)
						break
			
func handleItemCollection(item):
	#var valorCoin = 1
	#var valorItem = 1
	if item.is_in_group("Coin"):
		removeObstacle(item, 1)
		
	elif item.is_in_group("MultiplierPower"):
		var mult = playerData.MultiplierLvl + 1
		multiplierCount += 1 * mult
		multiplier += 0.1 * mult
		$CanvasLayer/Multiplier.text = str(multiplierCount)
		removeObstacle(item, 1)
	elif item.is_in_group("StarPower"):
		StarPowerActive = true
		$StarPowerTimer.start()
		removeObstacle(item, 1)
	elif item.is_in_group("MagnetPower"):
		MagnetPowerActive = true
		$MagnetPowerTimer.start()
		removeObstacle(item, 1)
	elif item.is_in_group("CoinShower"):
		CoinShowerPowerActive = true
		removeObstacle(item, 1)
		
#que tan seguido salen los obstaculos
func _on_obstacle_timer_timeout():
	if gameRunning == true:
		randomize()
		var minTime = 1
		var maxTime = 2
		controlObstacles = 1 
		$ObstacleTimer.set_wait_time(rng.randf_range(minTime, maxTime))
		
		
func gameOver():
	$Menu.visible = false
	$CanvasLayer/JoyStick.visible = false
	if playerData.highScore < score:
		playerData.highScore = score	
		save()
	
	if score >= 10000: finalCoins = int((score/120) * 1.5)
	elif score >= 8000: finalCoins = int((score/120) * 1.4)
	elif score >= 6000: finalCoins = int((score/120) * 1.3)
	elif score >= 4000: finalCoins = int((score/120) * 1.2)
	elif score >= 2000: finalCoins = int((score/120) * 1.1)
	elif score < 2000: finalCoins = int(score/120)
	finalCoins += coinCounter
	coinWonLabel.text = str(finalCoins)
	$CanvasLayer/GameOver.visible = true
	get_tree().paused = true
	gameRunning = false
		
		

func loadData():
	if ResourceLoader.exists(savePath + saveFile + ".tres"):
		playerData = ResourceLoader.load(savePath + saveFile + ".tres")
	else:
		var newPlayerData = Player.new()
		ResourceSaver.save(newPlayerData, (savePath + saveFile + ".tres" ))
		playerData = ResourceLoader.load(savePath + saveFile + ".tres")
		
	addMichi()
	newGame()
	
func save():
	playerData.coins += finalCoins
	ResourceSaver.save(playerData, savePath + saveFile + ".tres")
	
func exit():
	get_tree().paused = false
	get_tree().reload_current_scene()

		
func addMichi():
	
	var glider = gliderPath.instantiate()
	var fuego = fuegoPath.instantiate()
	
	var michi
	if michiLoad != null:
		michi = michiLoad.instantiate()
	michi.global_position = michiStartPos
	michi.scale = Vector2(2, 2)
	michi.z_index = 3
	add_child(michi)
	michiInstance = michi
	michiInstance.name = "michi"
	
	glider.global_position = Vector2(0,-10)
	glider.name = "glider"
	glider.z_index = -1
	michiInstance.add_child(glider)

	
	fuego.global_position = Vector2(-5,13)
	fuego.name = "fuego"
	fuego.z_index = -1
	michiInstance.add_child(fuego)
	
	gliderSprite = michiInstance.get_node("glider").get_node("Sprite2D")
	if $store.visible == true or $mePage.visible == true:
		gliderSprite.visible = true
	else:
		gliderSprite.visible = false
	var gliderIndex = playerData.gliderIndex
	gliderSprite.texture = playerData.gliders[gliderIndex].skinType
	
	fuegoSprite = michiInstance.get_node("fuego").get_node("AnimatedSprite2D")
	fuegoSprite.visible = false
	
	michiSprite = michiInstance.get_node("Sprite2D")
	michiAnimationPlayer = michiInstance.get_node("AnimationPlayer")
	var index = playerData.skinIndex
	michiSprite.texture =  playerData.skins[index].skinType

	
	

func changeSkin():
	michiInstance.name = "tempNameMichi"
	michiInstance.queue_free()
	loadData()
	michiInstance.force(400)
	michiInstance.bControl(false)

func activateShield():
	var shield = shieldPath.instantiate()
	shield.global_position = Vector2(0,0)
	shield.name = "shield"
	shield.z_index = -2
	michiInstance.add_child(shield)
	shieldInstance = shield
	playerData.shieldCount -= 1
	
	
func updateMePage():
	for btn in $mePage.btnInstanceChar:
		btn.queue_free()
	$mePage.btnInstanceChar.clear()
	for btn in $mePage.btnInstanceGlider:
		btn.queue_free()
	$mePage.btnInstanceGlider.clear()
	for hbox in $mePage.hboxInstance:
		hbox.queue_free()
	$mePage.hboxInstance.clear()
	
	$mePage.addCharacters()
	$mePage.addGliders()
	
	
func goingDown():
	#michiAnimationPlayer.stop()
	michiInstance.scale.x = 2
	michiInstance.scale.y = 2
	#michiSprite.play("WalkingDown")
	gliderSprite.visible = true
	#paraguasSprite.play("default")
	fallingControl = true
	goingUpControl = false
	fuegoSprite.visible = false


func video():
	finalCoins = finalCoins * 2
	save()


func _on_up_body_entered(body):
	if body.name == "michi":
		cameraDownControl = true


func _on_up_body_exited(body):
	if body.name == "michi":
		cameraDownControl = false


func _on_down_body_entered(body):
	if body.name == "michi":
		cameraUpControl = true


func _on_down_body_exited(body):
	if body.name == "michi":
		cameraUpControl = false


func getName(itemName : String) -> String:
	var result = ""
	for letter in itemName:
		if not letter.is_valid_int():
			result += letter
	return(result)


func openStore():
	$AreaBtnControl/CollisionShape2D.scale.x = 10
	$AreaBtnControl/CollisionShape2D.scale.y = 15
	michiInstance.force(400)
	michiInstance.bControl(false)
	menuControl = true
	gameRunning = false
	$Menu.hide()
	$store.show()
	gliderSprite.visible = true
	
func openSettings():
	michiInstance.force(400)
	michiInstance.bControl(false)
	$AreaBtnControl/CollisionShape2D.scale.x = 10
	$AreaBtnControl/CollisionShape2D.scale.y = 15
	menuControl = true
	gameRunning = false
	$Menu.hide()
	$settings.show()
	gliderSprite.visible = true

func mainMenu():
	menuControl = false
	michiInstance.force(700)
	michiInstance.bControl(true)
	gameRunning = false
	$AreaBtnControl/CollisionShape2D.scale.x = 1
	$AreaBtnControl/CollisionShape2D.scale.y = 1
	$store.hide()
	$settings.hide()
	$mePage.hide()
	$Menu.show()
	gliderSprite.visible = false
	newGame()
	
	

func controlMenu():
	menuControl = true
func controlMenu2():
	menuControl = false
	
	
func openMePage():
	$AreaBtnControl/CollisionShape2D.scale.x = 10
	$AreaBtnControl/CollisionShape2D.scale.y = 15
	michiInstance.force(400)
	michiInstance.bControl(false)
	menuControl = true
	gameRunning = false
	$Menu.hide()
	$mePage.show()
	gliderSprite.visible = true


func _on_coin_timer_timeout():
	randomize()
	var minTime
	var maxTime
	#generar monedas cayendo
	if gameRunning == true and falling == true:
		minTime = 0.5
		maxTime = 1.2
		controlCoins = 1 
		$CoinTimer.set_wait_time(rng.randf_range(minTime, maxTime))
	#generar monedas subiendo
	else:
		minTime = 0.06
		maxTime = 0.1
		controlCoins = 1 
		$CoinTimer.set_wait_time(rng.randf_range(minTime, maxTime))
		
	#generar monedas cayendo
	if gameRunning == true and falling == true and CoinShowerPowerActive == true:
		minTime = 0.06
		maxTime = 0.1
		controlCoins = 1 
		$CoinTimer.set_wait_time(rng.randf_range(minTime, maxTime))

func _on_star_power_timer_timeout():
	StarPowerActive = false
	
func _on_magnet_power_timer_timeout():
	MagnetPowerActive = false
	magnetControl = false

func _on_coin_shower_power_timer_timeout():
	CoinShowerPowerActive = false

func animationFinished(anim_name):
	if anim_name == "StartFalling":
		controlAnimation = true
		michiAnimationPlayer.play("Falling")
	
	
func increaseDificulty():
	if dificulty < maxDificulty:
		dificulty += 1
		#velocidad del jugador
		playerVelocity += 100
		michiInstance.maxVelocity = playerVelocity
			
		for i in range (0, platMinSpeed.size()):
			#velocidad en y de plataformas
			platMinSpeed[i] = platMinSpeed[i] * (1.02)
		for i in range (0, meteorMinSpeed.size()):
			#velocidad en y de meteoritos
			meteorMinSpeed[i] = meteorMinSpeed[i] * (1.05)
		
		controlDif = false

func _input(_event):
	if Input.is_action_just_pressed("click"):
		$DoubleClickTimer.start()
		if doubleClick == true and shieldActive == false and playerData.shieldCount >= 1:
			shieldActive = true
			
		doubleClick = true
		
	

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		save()
	

func _on_double_click_timer_timeout():
	doubleClick = false


func _on_shield_off_timer_timeout():
	michiInstance.set_collision_layer_value(1, true)
	michiInstance.set_collision_mask_value(1, true)
	controlHit = false
	shieldControl = false
