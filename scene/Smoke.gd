extends CanvasModulate
var wavy = 0

func _ready():
	get_node(".").set_color(Color(1,1,1,0.5))
	
func _process(delta):
	
	if wavy == 0:
		get_node(".").set_color(get_color() + Color(0,0,0,.005))
		
	if get_node(".").get_color().a > .4 or wavy == 1:
		get_node(".").set_color(get_color() - Color(0,0,0,.005))
		wavy = 1
		
	if wavy == 1 and (get_node(".").get_color().a < .1):
		wavy = 0
