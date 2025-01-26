extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var WL_RayCast: RayCast2D = $RayCasts/WallLeft
@onready var WR_RayCast: RayCast2D = $RayCasts/WallRight
@onready var GLD_RayCast: RayCast2D = $RayCasts/GroundLeftDown
@onready var GRD_RayCast: RayCast2D = $RayCasts/GroundRightDown

@onready var PFL_RayCast: RayCast2D = $RayCasts/PlayerFarLeft
@onready var PFR_RayCast: RayCast2D = $RayCasts/PlayerFarRight
@onready var PCL_RayCast: RayCast2D = $RayCasts/PlayerCloseLeft
@onready var PCR_RayCast: RayCast2D = $RayCasts/PlayerCloseRight
@onready var PCT_RayCast: RayCast2D = $RayCasts/PlayerCloseTop


@export var GRAVITY : int = 980
@export var speed : float = 50.0
@export var angry_speed : float = 150.0
@export var change_direction_cooldown : float = 1.0
@export var max_hit : int = 3
@export var RIGID_BODY_PUSH_FORCE = 100.0

var direction = -1
var ontop = false
var angry = false
var died = false
var n_hit = 0

func change_direction():
	direction = -direction
	sprite.flip_h = not sprite.flip_h

func die() -> void:
	died = true
	$CollisionShape2D.set("disabled",true)
	$AnimationPlayer.play('die')
	velocity.y = -200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play('walk')
	
	
func _on_change_direction_cooldown_timeout() -> void:
	if not died:
		sprite.play('walk')
		change_direction()

func _on_triggered_area_body_entered(body: Node2D) -> void:
	if not died:
		sprite.play('run')
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation in ['hit1','hit2'] and not died:
		sprite.play('run')
	
func _physics_process(delta: float) -> void:
	if died: 
		velocity.y += GRAVITY * delta
		move_and_slide()
		return
		
	if direction == 1 and (WR_RayCast.is_colliding() or (!GRD_RayCast.is_colliding())) and sprite.animation not in ['hit1','hit2']:
		sprite.play('idle')
		if $ChangeDirectionCooldown.is_stopped():
			$ChangeDirectionCooldown.start(change_direction_cooldown)
	elif direction == -1 and (WL_RayCast.is_colliding() or (!GLD_RayCast.is_colliding())) and sprite.animation not in ['hit1','hit2']:
		sprite.play('idle')
		if $ChangeDirectionCooldown.is_stopped():
			$ChangeDirectionCooldown.start(change_direction_cooldown)
	
	if sprite.animation not in ['hit1','hit2']:
		if PFR_RayCast.is_colliding():
			if direction == -1: change_direction()
			sprite.play('run')
			angry = true
		elif PFL_RayCast.is_colliding():
			if direction == 1: change_direction()
			sprite.play('run')
			angry = true
		elif $TriggeredArea.has_overlapping_bodies():
			sprite.play('run')
			angry = true
		elif sprite.animation not in ['idle']:
			sprite.play('walk')
			angry = false
	
	if PCT_RayCast.is_colliding() and not ontop:
		n_hit+=1
		if n_hit < max_hit:
			sprite.play('hit1')
			ontop = true
		else:
			die()
	elif not PCT_RayCast.is_colliding() and ontop:
		ontop = false
		
	if PCL_RayCast.is_colliding():
		var collider = PCL_RayCast.get_collider()
		if collider and collider.is_in_group('Player'):
			collider.die()
	elif PCR_RayCast.is_colliding():
		var collider = PCR_RayCast.get_collider()
		if collider and collider.is_in_group('Player'):
			collider.die()
	
	if (GRD_RayCast.is_colliding() and direction == 1) or (GLD_RayCast.is_colliding() and direction == -1) and sprite.animation not in ['hit1','hit2']:
		velocity.x = direction * (speed if not angry else angry_speed)
	else:
		velocity.x = 0
	velocity.y += GRAVITY * delta
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			collider.apply_central_impulse(-collision.get_normal() * RIGID_BODY_PUSH_FORCE)
