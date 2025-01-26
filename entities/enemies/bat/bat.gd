extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var T_RayCast: RayCast2D = $Raycasts/TopRayCast
@onready var L_RayCast: RayCast2D = $Raycasts/LeftRayCast
@onready var R_RayCast: RayCast2D = $Raycasts/RightRayCast
@onready var D_RayCast: RayCast2D = $Raycasts/DownRayCast

@export var GRAVITY : int = 980
@export var x_velocity = 1.5
@export var y_velocity = 1.0
@export var y_offset = 30.0
@export var vertical_impulse_on_die = 300
@export var max_hit = 1


var num_hit : int = 0
var died : bool = false
var ontop : bool = false
var flying : bool = false
var coming_back : bool = false
@onready var spawn : Vector2 = global_position
var character : CharacterBody2D = null

func die() -> void:
	died = true
	$CollisionShape2D.set("disabled",true)
	$AnimationPlayer.play('die')
	velocity.y = -vertical_impulse_on_die

func _on_animation_finished() -> void:
	if sprite.animation == 'ceiling_out':
		sprite.play('flying')
	elif sprite.animation == 'hit' and not died:
		sprite.play('flying')

func _on_trigger_area_body_entered(body: Node2D) -> void:
	character = body
	if not flying:
		flying = not flying
		sprite.play('ceiling_out')
	elif flying:
		coming_back = false

func _on_trigger_area_body_exited(body: Node2D) -> void:
	if body == character and flying:
		character = null
		coming_back = true

func _physics_process(delta: float) -> void:
	if died:
		velocity.y += GRAVITY * delta
		move_and_slide()
		return
	
	if character and flying:
		global_position.x = move_toward(
			global_position.x,
			character.global_position.x,
			x_velocity)
		global_position.y = move_toward(
			global_position.y,
			character.global_position.y + y_offset,
			y_velocity)
		move_and_slide()
		
		if character.global_position.x - global_position.x < 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
		
	elif coming_back:
		global_position.x = move_toward(
			global_position.x,
			spawn.x,
			x_velocity)
		global_position.y = move_toward(
			global_position.y,
			spawn.y,
			y_velocity)
		move_and_slide()
		
		if spawn == global_position:
			flying = false
			coming_back = false
			sprite.play('idle')
			
		if spawn.x - global_position.x < 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
			
	
	if T_RayCast.is_colliding():
		if not ontop:
			ontop = true
			sprite.play("hit")
			num_hit += 1
			if num_hit >= max_hit:
				die()
	elif not T_RayCast.is_colliding() and ontop:
		ontop = false
	
	if R_RayCast.is_colliding():
		var collider = R_RayCast.get_collider()
		if collider and collider.is_in_group('Player'):
			collider.die()
	elif L_RayCast.is_colliding():
		var collider = L_RayCast.get_collider()
		if collider and collider.is_in_group('Player'):
			collider.die()
	elif D_RayCast.is_colliding():
		var collider = D_RayCast.get_collider()
		if collider and collider.is_in_group('Player'):
			collider.die()
