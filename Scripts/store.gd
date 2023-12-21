extends Control

var savePath = "res://Save/"
var saveFile = "PlayerSave"
var playerData : Player
var colN = 3 #numero de columnas de skins
var hboxSeparation = 100
var CharbtnInstance = []
var GliderbtnInstance = []

func _ready():
	loadData()
	addCharacters()
	addGliders()



func addCharacters():
	var hboxIndex = 0
	for i in range (0, playerData.skins.size()):
		
		if hboxIndex >= playerData.skins.size(): break
		
		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override("separation", hboxSeparation)
		hbox.name = "hbox"+str(i)
		for j in range (0,colN):
			var vbox = VBoxContainer.new()
			vbox.add_theme_constant_override("separation", 10 * colN)
			
			var index = j+hboxIndex
			if index >= playerData.skins.size(): break
			var skin = Sprite2D.new()
			skin.texture = playerData.skins[index].skinType
			skin.hframes = 13
			skin.scale = Vector2(2,2)

			
			
			var nameLabel = Label.new()
			nameLabel.text = playerData.skins[index].name
			
			var priceLabel = Label.new()
			priceLabel.text = str(playerData.skins[index].price)
			
			var buyBtn = Button.new()
			buyBtn.name = "buy" + str(index)
			if playerData.skins[index].owned == true:
				buyBtn.disabled = true
				buyBtn.text = "Owned"
			else:
				buyBtn.text = "Buy"
				
			if playerData.skins[index].price > playerData.coins:
				buyBtn.disabled = true
			
			hbox.add_child(vbox)
			vbox.add_child(skin)
			vbox.add_child(nameLabel)
			vbox.add_child(priceLabel)
			vbox.add_child(buyBtn)
			
			CharbtnInstance.append(buyBtn)
			buyBtn.pressed.connect(Callable(BuyButtonPressed).bind(index, 0))
		
		$TabContainer/Characters/Control/VBoxContainer.add_child(hbox)
		hboxIndex += colN
			
func BuyButtonPressed(index : int, control : int):
	
	if control == 0:
		CharbtnInstance[index].disabled = true
		CharbtnInstance[index].text = "Owned"
		
		playerData.coins = playerData.coins - playerData.skins[index].price
		playerData.skins[index].owned = true
		playerData.skins[index].active = true
		playerData.skins[playerData.skinIndex].active = false
		playerData.skinIndex = index
	
	
	if control == 1:
		GliderbtnInstance[index].disabled = true
		GliderbtnInstance[index].text = "Owned"
		
		playerData.coins = playerData.coins - playerData.gliders[index].price
		playerData.gliders[index].owned = true
		playerData.gliders[index].active = true
		playerData.gliders[playerData.gliderIndex].active = false
		playerData.gliderIndex = index
		
	save()
	SignalManager.changeSkin.emit()
	SignalManager.updateMePage.emit()
	
	
func addGliders():
	var hboxIndex = 0
	for i in range (0, playerData.gliders.size()):
		
		if hboxIndex >= playerData.gliders.size(): break
		
		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override("separation", hboxSeparation)
		hbox.name = "hbox"+str(i)
		for j in range (0,colN):
			var vbox = VBoxContainer.new()
			vbox.add_theme_constant_override("separation", 10 * colN)
			
			var index = j+hboxIndex
			if index >= playerData.gliders.size(): break
			var skin = Sprite2D.new()
			skin.texture = playerData.gliders[index].skinType
			skin.hframes = 1
			skin.scale = Vector2(2,2)

			
			
			var nameLabel = Label.new()
			nameLabel.text = playerData.gliders[index].name
			
			var priceLabel = Label.new()
			priceLabel.text = str(playerData.gliders[index].price)
			
			var buyBtn = Button.new()
			buyBtn.name = "buy" + str(index)
			if playerData.gliders[index].owned == true:
				buyBtn.disabled = true
				buyBtn.text = "Owned"
			else:
				buyBtn.text = "Buy"
				
			if playerData.gliders[index].price > playerData.coins:
				buyBtn.disabled = true
			
			hbox.add_child(vbox)
			vbox.add_child(skin)
			vbox.add_child(nameLabel)
			vbox.add_child(priceLabel)
			vbox.add_child(buyBtn)
			
			GliderbtnInstance.append(buyBtn)
			buyBtn.pressed.connect(Callable(BuyButtonPressed).bind(index, 1))
		
		$TabContainer/Gliders/Control/VBoxContainer.add_child(hbox)
		hboxIndex += colN
	
func loadData():
	if ResourceLoader.exists(savePath + saveFile + ".tres"):
		playerData = ResourceLoader.load(savePath + saveFile + ".tres")
	else:
		var newPlayerData = Player.new()
		ResourceSaver.save(newPlayerData, (savePath + saveFile + ".tres" ))
		playerData = ResourceLoader.load(savePath + saveFile + ".tres")
		
func save():
	ResourceSaver.save(playerData, savePath + saveFile + ".tres")
