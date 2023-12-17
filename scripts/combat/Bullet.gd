extends Sprite2D

var splash
var damage
var velocity := Vector2()

var time_alive := 0.0

func _ready():
	$Area2D.area_entered.connect(area_entered)

func _process(delta):
	time_alive += delta
	
	position += velocity * delta
	rotation = -velocity.normalized().angle_to(Vector2(0, -1))
	
	if time_alive >= 8.0:
		queue_free.call_deferred()

func area_entered(area):
	if area.get_parent() is Enemy:
		area.get_parent().damage(damage)
		queue_free.call_deferred()
