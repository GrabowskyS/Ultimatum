extends KinematicBody2D

export var speed = 220
var screen_size

var canDoubleHit = false
var isDoubleHitActive = false

var holder
var facing_right
var moveFrameArray = [
	[load("res://PunchSpriteSheet.png"), Rect2(Vector2(629, 0), Vector2(77, 100)),
	Rect2(Vector2(787, 3), Vector2(63, 97))] 
]

var tempAnim
var anim_new
onready var animationPlayer = $AnimationPlayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var isPunching = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
func _physics_process(_delta):
	self.z_index = self.position.y
	var velocity = Vector2()

# watches for specific frames to see when one can input punch a second time to make the double punch
	if ($Sprite.texture == moveFrameArray[0][0]):
		if ($Sprite.region_rect == moveFrameArray[0][1] or $Sprite.region_rect == moveFrameArray[0][2]):
			if (Input.is_action_just_pressed("punch") and canDoubleHit):
				isDoubleHitActive = true
				anim_new = "Double Punch"
				canDoubleHit = false
				doubleHitPlay()
	else:
		canDoubleHit = false

# watches for punch and if double punch is available
	if (Input.is_action_just_pressed("punch") and !isDoubleHitActive):
		canDoubleHit = true
		isPunching = true
		tempAnim = "Punch"
		
	if (!isPunching):
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
		if velocity != Vector2.ZERO:
			tempAnim = "Walk"
			if (velocity.x < 0.1):
				facing_right = false
				$Sprite.scale.x = -1
			elif (velocity.x > 0.1):
				facing_right = true
				$Sprite.scale.x = 1
			
		else:
			tempAnim = "Idle"
			if facing_right:
				$Sprite.scale.x = 1
			else:
				$Sprite.scale.x = -1
	
	
	
	velocity = move_and_slide(velocity * speed)
	
	#Checking on every frame, not every key
	animationSwapper(tempAnim)
	
# Swaps animations properly and doesn't override them with multiple inputs
func animationSwapper(anim):
	if (anim != anim_new and !isDoubleHitActive):
		anim_new = anim
		animationPlayer.play(anim)

#double punch playing function
func doubleHitPlay():
	animationPlayer.stop()
	animationPlayer.play("Double Punch")

# finishes animations so they don't loop or get stuck
func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "Punch"):
		isPunching = false
	elif (anim_name == "Double Punch"):
		isPunching = false
		isDoubleHitActive = false

# area for hits
func _on_HurtArea_area_entered(area):
	if (area.get_parent().get_node_or_null("enemy") != null):
		print(area.get_parent().name)
