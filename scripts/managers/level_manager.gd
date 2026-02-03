extends Node2D

@export var player: Node2D
@export var chunk_scenes: Array[PackedScene]
@onready var dialog_ui: CanvasLayer = $UI
@onready var chunks: Node2D = $Chunks

const TILE_SIZE: int = 16
const CHUNK_X: int = 24 * TILE_SIZE
const CHUNK_Y: int = 12 * TILE_SIZE
const CHUNKS_TO_KEEP := 3

var question_type: Array = ["mc", "tf", "identify", "enum"]
var mode_ctr: int = 0
var mode_index: int = 0

var current_chunk_index : int = 0
var active_chunks: Dictionary = {}  # index -> Node

var question_data: Dictionary

func _ready():
	for i in range(CHUNKS_TO_KEEP):
		_spawn_chunk(i)

func _process(_delta):
	var player_chunk := int(player.global_position.x / CHUNK_X)

	if player_chunk > current_chunk_index:
		current_chunk_index = player_chunk
		_update_chunks()

func _spawn_chunk(index: int) -> void:
	if active_chunks.has(index):
		return
	
	if mode_index > 3:
		return

	var scene: PackedScene = chunk_scenes[mode_index]
	var chunk = scene.instantiate()

	chunk.position = Vector2(index * CHUNK_X, 0)
	chunks.add_child(chunk)

	# Inject question data
	var question_data = question_manager.get_question_by_type(question_type[mode_index])
	if chunk.has_method("setup_question"):
		chunk.setup_question(question_data)

	# Mode logic
	mode_ctr += 1
	if mode_ctr % 5 == 0:
		mode_index += 1
		mode_ctr = 0

	active_chunks[index] = chunk

func _update_chunks() -> void:
	# Always ensure current + next chunk exist
	_spawn_chunk(current_chunk_index + 1)
	_spawn_chunk(current_chunk_index + 2)

	# Destroy only the chunk that is too far behind
	var destroy_index := current_chunk_index - 2
	_delete_chunk(destroy_index)

func _delete_chunk(index: int) -> void:
	if not active_chunks.has(index):
		return

	active_chunks[index].queue_free()
	active_chunks.erase(index)
