@tool
extends EditorPlugin

## Adds a "pin" button next to the script path field in the Attach Script
## dialog. Clicking it lets the user set a default folder for new scripts.

const CONFIG_PATH := "res://addons/scriptory/scriptory.cfg"
const PIN_BUTTON_NAME := "ScriptoryPinButton"
const PIN_ICON_NAME := "Favorites"

var saved_default_path: String = ""
var script_create_dialog: ScriptCreateDialog
var current_file_dialog: EditorFileDialog


func _enter_tree() -> void:
	_load_saved_path()
	script_create_dialog = get_script_create_dialog()
	if not script_create_dialog.visibility_changed.is_connected(_on_dialog_visibility_changed):
		script_create_dialog.visibility_changed.connect(_on_dialog_visibility_changed)


func _exit_tree() -> void:
	pass


## --- Dialog lifecycle ---

func _on_dialog_visibility_changed() -> void:
	if not script_create_dialog.visible:
		return

	_ensure_pin_button()
	_apply_default_path()


func _ensure_pin_button() -> void:
	if script_create_dialog.find_child(PIN_BUTTON_NAME, true, false):
		return

	var line_edit := _find_path_line_edit()
	if line_edit == null:
		push_warning("Scriptory: could not find the script path field")
		return

	var pin_button := Button.new()
	pin_button.name = PIN_BUTTON_NAME
	pin_button.icon = script_create_dialog.get_theme_icon(PIN_ICON_NAME, "EditorIcons")
	pin_button.tooltip_text = "Save current folder as default path"
	pin_button.pressed.connect(_on_pin_pressed)

	line_edit.get_parent().add_child(pin_button)


func _apply_default_path() -> void:
	if saved_default_path.is_empty():
		return

	var line_edit := _find_path_line_edit()
	if line_edit == null:
		return

	var filename := line_edit.text.get_file()
	var new_path := saved_default_path.path_join(filename)

	line_edit.text = new_path
	line_edit.emit_signal("text_changed", new_path)  # forces Godot's built-in validation to re-run


func _find_path_line_edit() -> LineEdit:
	for line_edit in script_create_dialog.find_children("*", "LineEdit", true, false):
		if line_edit.text.begins_with("res://"):
			return line_edit
	return null


## --- Folder picker ---

func _on_pin_pressed() -> void:
	_close_file_dialog()

	current_file_dialog = EditorFileDialog.new()
	current_file_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_DIR
	current_file_dialog.access = EditorFileDialog.ACCESS_RESOURCES
	current_file_dialog.dir_selected.connect(_on_folder_selected)
	current_file_dialog.canceled.connect(_close_file_dialog)

	script_create_dialog.add_child(current_file_dialog)
	current_file_dialog.popup_centered_ratio()


func _on_folder_selected(dir: String) -> void:
	saved_default_path = dir
	_save_default_path(dir)
	_apply_default_path()
	_close_file_dialog()


func _close_file_dialog() -> void:
	if is_instance_valid(current_file_dialog):
		current_file_dialog.queue_free()
	current_file_dialog = null


## --- Persistence ---

func _load_saved_path() -> void:
	var config := ConfigFile.new()
	if config.load(CONFIG_PATH) == OK:
		saved_default_path = config.get_value("settings", "default_path", "")


func _save_default_path(dir: String) -> void:
	var config := ConfigFile.new()
	config.load(CONFIG_PATH)
	config.set_value("settings", "default_path", dir)

	if config.save(CONFIG_PATH) != OK:
		push_error("Scriptory: failed to save config")
	else:
		EditorInterface.get_resource_filesystem().update_file(CONFIG_PATH)
