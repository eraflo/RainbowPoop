@tool
extends Node

static var poly
static var lastPoly
static var p00
static var p01
static var p10
static var p11
static var lcol
static var ogLcol
static var rcol
static var ogRcol
static var started = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("a")
	# retrieve the nodes we need
	poly=get_child(-1)
	lcol=get_child(0)
	rcol=get_child(1)
	# store the OG values 
	ogLcol = lcol.polygon.duplicate()
	ogRcol = rcol.polygon.duplicate()
	lastPoly = poly.polygon.duplicate()
	for i in range(poly.polygon.size()):
		if poly.polygon[i].x>0.5:
			if poly.polygon[i].y>0.5:
				p11=i
			else:
				p10=i
		else:
			if poly.polygon[i].y>0.5:
				p01=i
			else:
				p00=i
	print("[["+str(p00)+","+str(p01)+"],["+str(p10)+","+str(p11)+"]")
	started = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not started:
		_ready()
	for i in range(4):
		if lastPoly[i]!=poly.polygon[i]:
			lastPoly = poly.polygon.duplicate()
			recomputePoints()
			break
			
func recomputePoints() -> void:
	var p=poly.polygon
	for i in range(lcol.polygon.size()):
		var xc=ogLcol[i].x
		var yc=ogLcol[i].y
		lcol.polygon[i]=(p[p11]*yc+p[p10]*(1-yc))*xc+(p[p01]*yc+p[p00]*(1-yc))*(1-xc)
	for i in range(rcol.polygon.size()):
		var xc=ogRcol[i].x
		var yc=ogRcol[i].y
		rcol.polygon[i]=(p[p11]*yc+p[p10]*(1-yc))*xc+(p[p01]*yc+p[p00]*(1-yc))*(1-xc)
