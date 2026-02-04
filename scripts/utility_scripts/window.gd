extends Window

@onready var table := $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer

@export var header_font: Font
@export var header_font_size: int = 16

@export var body_font: Font
@export var body_font_size: int = 16

const ROW_HEIGHT := 36
const HEADER_COLOR := Color(1.0, 1.0, 0.3)
const ROW_A := Color(0.90, 0.90, 0.90)
const ROW_B := Color(0.80, 0.80, 0.80)

var table_data := [
	["Control", "Description"],
	["Pointer", "Provides a way to move and resize the controls form"],
	["PictureBox", "Displays icons/bitmaps and metafiles. It displays text or acts as a visual container for other controls."],
	["TextBox", "Used to display message and enter text."],
	["Frame", "Serves as a visual and functional container for controls"],
	["CommandButton", "Used to carry out the specified action when the user chooses it."],
	["CheckBox", "Displays a True/False or Yes/No option."],
	["OptionButton", "Allows the user to select only one option even if it displays multiple choices."],
	["ListBox", "Displays a list of items from which a user can select one."],
	["ComboBox", "Contains a TextBox and a ListBox. Allows typing or selection."],
	["HScrollBar / VScrollBar", "Allows the user to select a value within a specified range."],
	["Timer", "Executes timer events at specified intervals of time"],
	["DriveListBox", "Displays valid disk drives and allows selection."],
	["DirListBox", "Allows the user to select directories and paths."],
	["FileListBox", "Displays files from which a user can select one."],
	["Shape", "Used to add shapes such as rectangle, square, or circle"],
	["Line", "Used to draw straight lines on a Form"],
	["Image", "Displays images but with less capability than PictureBox"],
	["Data", "Connects to an existing database and displays information."],
	["OLE", "Links or embeds objects from other Windows applications."],
	["Label", "Displays text that the user cannot modify or interact with."]
]

func _ready():
	# Ensure the table expands horizontally
	hide()
	table.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	build_table(table_data)

func build_table(data: Array) -> void:
	# Clear previous rows
	for child in table.get_children():
		child.queue_free()

	for i in range(data.size()):
		add_row(
			data[i][0],
			data[i][1],
			i == 0,        # header
			i              # row index for alternating colors
		)

func add_row(title: String, description: String, is_header: bool, row_index: int):
	var row_panel := PanelContainer.new()
	row_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row_panel.size_flags_vertical = Control.SIZE_FILL

	# Background
	var style := StyleBoxFlat.new()
	if is_header:
		style.bg_color = HEADER_COLOR
	else:
		style.bg_color = ROW_A if row_index % 2 == 0 else ROW_B
	style.set_corner_radius_all(6)
	row_panel.add_theme_stylebox_override("panel", style)

	table.add_child(row_panel)

	# Padding
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_bottom", 6)
	row_panel.add_child(margin)

	# Row layout
	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin.add_child(row)

	# Column 1
	var name := Label.new()
	name.text = title
	name.custom_minimum_size = Vector2(180, 0)
	name.size_flags_horizontal = Control.SIZE_FILL
	name.size_flags_vertical = Control.SIZE_FILL
	name.autowrap_mode = TextServer.AUTOWRAP_WORD

	# Column 2
	var desc := Label.new()
	desc.text = description
	desc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	desc.size_flags_vertical = Control.SIZE_FILL
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD
	
	name.add_theme_color_override("font_color", Color.BLACK)
	desc.add_theme_color_override("font_color", Color.BLACK)
	
	# Font application
	if is_header:
		if header_font:
			name.add_theme_font_override("font", header_font)
			desc.add_theme_font_override("font", header_font)

		name.add_theme_font_size_override("font_size", header_font_size)
		desc.add_theme_font_size_override("font_size", header_font_size)
	else:
		if body_font:
			name.add_theme_font_override("font", body_font)
			desc.add_theme_font_override("font", body_font)

		name.add_theme_font_size_override("font_size", body_font_size)
		desc.add_theme_font_size_override("font_size", body_font_size)

	row.add_child(name)
	row.add_child(desc)

func _on_close_requested() -> void:
	hide()
