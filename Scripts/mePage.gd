extends Control

var savePath = "res://Save/"
var saveFile = "PlayerSave"
var playerData : Player
var colN = 3 #numero de columnas de skins
var hboxSeparation = 100
var btnInstanceChar = []
var btnInstanceGlider = []
var hboxInstance = []

var powerBarSteps = (100/8)

var starPowerBtn
var starPowerBar


func _ready():
	loadData()
	
	
	$TabContainer/Upgrades/CoinShowerPower.get_node("FondoItems").hide()
	$TabContainer/Upgrades/MagnetPower.get_node("FondoItems").hide()
	$TabContainer/Upgrades/MulitplierPower.get_node("FondoItems").hide()
	$TabContainer/Upgrades/StarPower/StarPower.get_node("FondoItems").hide()
	
	
	#poner nodos de botones y barras
	starPowerBtn = $TabContainer/Upgrades/StarPower/VBoxContainer/Button
	starPowerBar = $TabContainer/Upgrades/StarPower/VBoxContainer/TextureProgressBar
	
	#conectar botones de powerUps
	starPowerBtn.pressed.connect(StarPowerUpgrade)
	
	addCharacters()
	addGliders()
	loadBars()
	
	
func loadBars():
	starPowerBar.value = playerData.StarPowerLvl * powerBarSteps
	
	
	
	
func addCharacters():
	var indexCount = 0
	for i in range (0, playerData.skins.size()):
		var skinCount = 0
		
		
		if indexCount >= playerData.skins.size(): break
		
		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override("separation", hboxSeparation)
		hbox.name = "hbox"+str(i)
		while skinCount < colN:
			var index = indexCount
			if index >= playerData.skins.size(): break
			
			var vbox = VBoxContainer.new()
			vbox.add_theme_constant_override("separation", 10 * colN)
			
			var skin = Sprite2D.new()
			skin.texture = playerData.skins[index].skinType
			skin.hframes = 13
			skin.scale = Vector2(2,2)
			
			var nameLabel = Label.new()
			nameLabel.text = playerData.skins[index].name
			
			var selectBtn = Button.new()
			selectBtn.name = "buy" + str(index)
			if playerData.skins[index].active == true:
				selectBtn.disabled = true
				selectBtn.text = "Selected"
			else:
				selectBtn.text = "Select"
			
			if playerData.skins[index].owned == true:
				hbox.add_child(vbox)
				vbox.add_child(skin)
				vbox.add_child(nameLabel)
				vbox.add_child(selectBtn)
				skinCount = skinCount + 1
			
			btnInstanceChar.append(selectBtn)
			selectBtn.pressed.connect(Callable(SelectButtonPressed).bind(index, 0))
			indexCount += 1
		
		$TabContainer/Characters/Control/VBoxContainer.add_child(hbox)
		hboxInstance.append(hbox)
			
func SelectButtonPressed(index : int, control : int):
	
	if control == 0:
		var otherIndex = playerData.skinIndex
		
		btnInstanceChar[index].disabled = true
		btnInstanceChar[index].text = "Selected"
		btnInstanceChar[otherIndex].text = "Select"
		btnInstanceChar[otherIndex].disabled = false
		
		playerData.skins[index].active = true
		playerData.skins[otherIndex].active = false
		playerData.skinIndex = index
		
		
	if control == 1:
		var otherIndex = playerData.gliderIndex
		btnInstanceGlider[index].disabled = true
		btnInstanceGlider[index].text = "Selected"
		btnInstanceGlider[otherIndex].text = "Select"
		btnInstanceGlider[otherIndex].disabled = false
		
		playerData.gliders[index].active = true
		playerData.gliders[otherIndex].active = false
		playerData.gliderIndex = index
		
		
	save()
	SignalManager.changeSkin.emit()
func addGliders():
	var indexCount = 0
	for i in range (0, playerData.gliders.size()):
		var skinCount = 0
		
		
		if indexCount >= playerData.gliders.size(): break
		
		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override("separation", hboxSeparation)
		hbox.name = "hbox"+str(i)
		while skinCount < colN:
			var index = indexCount
			if index >= playerData.gliders.size(): break
			
			var vbox = VBoxContainer.new()
			vbox.add_theme_constant_override("separation", 10 * colN)
			
			
			var skin = Sprite2D.new()
			skin.texture = playerData.gliders[index].skinType
			skin.hframes = 1
			skin.scale = Vector2(2,2)

			var nameLabel = Label.new()
			nameLabel.text = playerData.gliders[index].name
		
			var selectBtn = Button.new()
			selectBtn.name = "buy" + str(index)
			if playerData.gliders[index].active == true:
				selectBtn.disabled = true
				selectBtn.text = "Selected"
			else:
				selectBtn.text = "Select"
			
			if playerData.gliders[index].owned == true:
				hbox.add_child(vbox)
				vbox.add_child(skin)
				vbox.add_child(nameLabel)
				vbox.add_child(selectBtn)
				skinCount = skinCount + 1
			
			btnInstanceGlider.append(selectBtn)
			selectBtn.pressed.connect(Callable(SelectButtonPressed).bind(index,1))
			indexCount += 1
		
		$TabContainer/Gliders/Control/VBoxContainer.add_child(hbox)
		hboxInstance.append(hbox)
		
func StarPowerUpgrade():
	playerData.StarPowerLvl += 1
	starPowerBar.value = playerData.StarPowerLvl * powerBarSteps
	save()
		
		
	
	
func loadData():
	if ResourceLoader.exists(savePath + saveFile + ".tres"):
		playerData = ResourceLoader.load(savePath + saveFile + ".tres")
	else:
		var newPlayerData = Player.new()
		ResourceSaver.save(newPlayerData, (savePath + saveFile + ".tres" ))
		playerData = ResourceLoader.load(savePath + saveFile + ".tres")
		
func save():
	ResourceSaver.save(playerData, savePath + saveFile + ".tres")
