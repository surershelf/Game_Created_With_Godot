extends Node

@export var mob_scene: PackedScene
var score


# Called when the node enters the scene tree for the first time.
func _ready():
	#starta o game
	#new_game()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#chamado da instancia do player, do sinal hit(), renomeamos para game_over
#pois assim é disparado o hit() que dispara o game_over()
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

#funcao para iniciar o game e resetar td
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	#reseta os mobs
	get_tree().call_group("mobs", "queue_free")
	$Music.play()

#att o score
func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	
func _on_mob_timer_timeout() -> void:
	#cria uma instacia de mob
	var mob = mob_scene.instantiate()
	
	#escolhe uma posicao aleatoria no MobPath
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf() # gera a posicao aleatoria
	
	#Seta a direcao do mob perpendicular a direcao do MobPath
	var direction = mob_spawn_location.rotation + PI / 2
	
	#Seta a direcao aleatoria do Mob
	mob.position = mob_spawn_location.position
	
	#Adiciona mais posicoes aleatorias
	direction += randf_range(-PI / 4, PI / 4 )
	mob.rotation = direction
	
	#Escolhe a velocidade do Mob 
	var velocity = Vector2(randf_range(150.0,250.0),0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	#spawna o mob e adiciona main scene
	add_child(mob)
