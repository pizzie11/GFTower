class_name Enemy
extends StaticBody

enum STATE {sleep, awake, hit, fire, death}
const GRAVITY = -0.5
const MOVESPEED = 0.5
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_state = STATE.sleep

var awoken_body

var colliding = false
var reverse_direction = false
var dead = false

var health = 20

var attack = preload("res://projectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	var move_vector = Vector3()
	if current_state == STATE.sleep:
		pass
	elif current_state == STATE.awake:
		move_vector = translation - awoken_body.translation
		move_vector.y = 0
		move_vector = move_vector.normalized()
		move_vector = move_vector *MOVESPEED
		
		$FloorDetector.translation = move_vector
		$FloorDetector.force_raycast_update()
		#If theres no floor where we wanna go, dont go there, reverse direction for a bit
		if !$FloorDetector.is_colliding():
			reverse_direction = true
			$ReverseTimer.start()
		if reverse_direction:
			move_vector = -move_vector
		
		look_at(awoken_body.translation, Vector3(0,1,0))
		rotation.x = 0
		rotation.z = 0
		if $AttackTimer.time_left == 0:
			$AttackTimer.start()
	elif current_state == STATE.hit:
		pass
	elif current_state == STATE.fire:
		if $ChargeTimer.time_left == 0:
			$ChargeTimer.start()
	elif current_state == STATE.death:
		rotation.z = 90
		dead = true
		
	if !colliding:
			move_vector.y += GRAVITY
	if !dead:
		translation = translation.linear_interpolate(translation+move_vector, 0.1)

func hit(damage, source):
	health -= damage
	if health > 0:
		current_state = STATE.hit
		$StunTimer.start()
		awoken_body = source
	else: 
		$StunTimer.stop()
		current_state = STATE.death
		set_collision_layer_bit(3,false)
		set_collision_mask_bit(3,false)
		set_collision_layer_bit(1,false)
		set_collision_mask_bit(1,false)
		$Viewer.monitoring = false
		$BottomCollider.monitoring = false
		$ReverseTimer.stop()
		$AttackTimer.stop()
		$ChargeTimer.stop()
		$DechargeTimer.stop()
	
func _on_Area_body_entered(body):
	if !(current_state == STATE.death):
		current_state = STATE.awake
		awoken_body = body


func _on_Collider_body_entered(body):
	colliding = true


func _on_Collider_body_exited(body):
	colliding = false


func _on_ReverseTimer_timeout():
	reverse_direction = false


func _on_StunTimer_timeout():
	current_state = STATE.awake


func _on_AttackTimer_timeout():
	current_state = STATE.fire


func _on_ChargeTimer_timeout():
	var new_attack = attack.instance() 
	new_attack.translation = translation
	new_attack.target = awoken_body.translation
	get_parent().add_child(new_attack)
	
	$DechargeTimer.start()


func _on_DechargeTimer_timeout():
	current_state = STATE.awake
	$AttackTimer.start()
