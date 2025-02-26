extends TextureRect

var anim = "Rainbow"
var fps = 20
var startedAt

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startedAt = Time.get_unix_time_from_system()
	
	# get the current health values and determine which animation to play
	var fat = ScoreDetail.fat-10
	var sugar = ScoreDetail.sugar - 10
	var water = ScoreDetail.water - 10
	var vitamin = ScoreDetail.vitamin - 10
	var fiber = ScoreDetail.fiber - 10
	var protein = ScoreDetail.protein - 10
	
	#get the correct animation depending on the worse value (the farthest from 0)
	var max = abs(fat)
	if fat>5:
		anim = "Oily"
	elif fat<-5:
		anim = "Rock"
	if abs(sugar)>max:
		if sugar>5:
			anim = "Big"
		elif sugar<-5:
			anim = "Watery"
	if abs(water)>max:
		if water>5:
			anim = "Watery"
		elif water<-5:
			anim = "Rock"
	if abs(vitamin)>max:
		if vitamin>5:
			anim = "Water"
		elif vitamin<-5:
			anim = "Rock"
	if abs(fiber)>max:
		if fiber>5:
			anim = "BigStinkky"
		elif fiber<-5:
			anim = "Oily"
	if abs(protein)>max:
		if protein>5:
			anim = "Watery"
		elif protein<-5:
			anim = "BigStinky"
	# ew, what an awful spaghetti code that was...
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# let's load the animations now
	match anim:
		"Big":
			big()
		"BigStinky":
			big_stinky()
		"Oily":
			oily()
		"Rainbow":
			rainbow()
		"Rock":
			rock()
		"Watery":
			watery()
		_:
			print(anim)

func big():
	animate("Big", 39, 48)

func big_stinky():
	animate("BigStinky", 30, 44)

func oily():
	animate("Oily", 17, 19)

func rainbow():
	animate("Rainbow",50,58)

func rock():
	animate("Rock",37,39)

func watery():
	animate("Watery",17,19)

func animate(path:String, loopBegin:int, loopEnd:int):
	var t = Time.get_unix_time_from_system()-startedAt
	var f = int(t*fps)
	if f>loopEnd:
		f-=loopBegin
		f%=loopEnd-loopBegin
		f+=loopBegin
	var file = "res://Assets/Animation/"+path+"/frame"+str(f).lpad(4,"0")+".png"
	if FileAccess.file_exists(file):
		#if texture!=null:
		#	texture.unreference()
		texture=load(file)
		print(texture.get_reference_count())
