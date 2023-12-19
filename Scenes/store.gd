extends Control

var savePath = "res://Save/"
var saveFile = "PlayerSave"
var playerData : Player
var colN = 3 #numero de columnas de skins
var hboxSeparation = 50

func _ready():
	loadData()
	addSkins()



func addSkins():
	var hboxIndex = 0
	for i in range (0, playerData.skins.size()):
		print("Skin added")
		
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

			
			
			var nameLabel = Label.new()
			nameLabel.text = playerData.skins[index].name
			
			var priceLabel = Label.new()
			priceLabel.text = str(playerData.skins[index].price)
			
			var buyBtn = Button.new()
			buyBtn.name = "buy" + str(index)
			if playerData.skins[index].owned == true:
				buyBtn.disabled = true
				
			buyBtn.pressed.connect(Callable(BuyButtonPressed).bind(index))
			
			hbox.add_child(vbox)
			vbox.add_child(skin)
			vbox.add_child(nameLabel)
			vbox.add_child(priceLabel)
			vbox.add_child(buyBtn)
		
		$ScrollContainer/Control/VBoxContainer.add_child(hbox)
		hboxIndex += colN
			
func BuyButtonPressed(index : int):
	print("Index Shop: ", index)
func loadData():
	if ResourceLoader.exists(savePath + saveFile + ".tres"):
		playerData = ResourceLoader.load(savePath + saveFile + ".tres")
	else:
		var newPlayerData = Player.new()
		ResourceSaver.save(newPlayerData, (savePath + saveFile + ".tres" ))
		playerData = ResourceLoader.load(savePath + saveFile + ".tres")
		
