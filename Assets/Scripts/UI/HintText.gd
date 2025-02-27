extends RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# get the current health values and determine which hint to show
	var fat = ScoreDetail.fat-10
	var sugar = ScoreDetail.sugar - 10
	var water = ScoreDetail.water - 10
	var vitamin = ScoreDetail.vitamin - 10
	var fiber = ScoreDetail.fiber - 10
	var protein = ScoreDetail.protein - 10
	
	var hintText = "Wow, Great Job!"
	
	#get the correct text depending on the worse value (the farthest from 0)
	var max = fat;
	if fat>5:
		hintText = "what do you plan to do with all that fat?"
	elif fat<-5:
		hintText = "being skinny is fine, but don't be a skeletton!"
	if abs(sugar)>abs(max):
		if sugar>5:
			hintText = "sugar is a bit too exciting..."
		elif sugar<-5:
			hintText = "sugar can be a great source of energy!"
	if abs(water)>abs(max):
		if water>5:
			hintText = "wobble, wobble, i drank too much~"
		elif water<-5:
			hintText = "aren't you a bit dry?"
	if abs(vitamin)>abs(max):
		if vitamin>5:
			hintText = "too much vitamins isn't super healthy either..."
		elif vitamin<-5:
			hintText = "you won't go anywhere without those vitamins!"
	if abs(fiber)>abs(max):
		if fiber>5:
			hintText = "little round goat poop, too much vegetables."
		elif fiber<-5:
			hintText = "vegetables keep your poop together!"
	if abs(protein)>abs(max):
		if protein>5:
			hintText = "you won't become strong just by eating protein..."
		elif protein<-5:
			hintText = "you need some protein for those muscles!"
	# ew, what an awful spaghetti code that was...
	
	#show the corrct hint
	text = hintText
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
