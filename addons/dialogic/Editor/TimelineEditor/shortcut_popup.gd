@tool
extends PanelContainer


var shortcuts := [

	{"shortcut":"Ctrl+T", 			"text":"插入文本 (Text) 事件", "editor":"VisualEditor"},
	{"shortcut":"Ctrl+Shift+T", "text":"插入当前角色的文本事件", "editor":"VisualEditor"},
	{"shortcut":"Ctrl+Alt+T", 	"text":"插入上一角色的文本事件", "editor":"VisualEditor"},
	{"shortcut":"Ctrl+E", 			"text":"插入角色加入 (Join) 事件", "editor":"VisualEditor"},
	{"shortcut":"Ctrl+Shift+E", "text":"插入角色更新 (Update) 事件", "editor":"VisualEditor"},
	{"shortcut":"Ctrl+Alt+E", 	"text":"插入角色离开 (Leave) 事件", "editor":"VisualEditor"},
	{"shortcut":"Ctrl+J", 			"text":"插入跳转 (Jump) 事件", "editor":"VisualEditor"},
	{"shortcut":"Ctrl+L", 			"text":"插入锚点标签 (Label) 事件", "editor":"VisualEditor"},
	{},
	{"shortcut":"Alt+Up", 		"text":"将选中的事件/代码行上移"},
	{"shortcut":"Alt+Down", 	"text":"将选中的事件/代码行下移"},
	{},
	{"shortcut":"Ctrl+F", 			"text":"搜索"},
	{"shortcut":"Ctrl+R", 			"text":"替换"},
	{},
	{"shortcut":"Ctrl+F5", 			"text":"播放时间轴", "platform":"-macOS"},
	{"shortcut":"Ctrl+B", 			"text":"播放时间轴", "platform":"macOS"},
	{"shortcut":"Ctrl+F6", 			"text":"从这里开始播放时间轴", "platform":"-macOS"},
	{"shortcut":"Ctrl+Shift+B", 	"text":"从这里开始播放时间轴", "platform":"macOS"},

	{},
	{"shortcut":"Ctrl+C", 			"text":"复制"},
	{"shortcut":"Ctrl+V", 			"text":"粘贴"},
	{"shortcut":"Ctrl+D", 			"text":"复制选定的事件/代码行"},
	{"shortcut":"Ctrl+X", 			"text":"剪切选定的事件/代码行"},
	{"shortcut":"Ctrl+K", 			"text":"注释/取消注释" , "editor":"TextEditor"},
	{"shortcut":"Delete", 			"text":"删除事件", "editor":"VisualEditor"},
	{},
	{"shortcut":"Ctrl+A", 			"text":"全选"},
	{"shortcut":"Ctrl+Shift+A", 	"text":"取消全选", "editor":"VisualEditor"},
	{"shortcut":"Up", 				"text":"选中上一个事件", "editor":"VisualEditor"},
	{"shortcut":"Down", 			"text":"选中下一个事件", "editor":"VisualEditor"},
	{},
	{"shortcut":"Ctrl+Z", 			"text":"撤销"},
	{"shortcut":"Ctrl+Shift+Z", 	"text":"重做"},
	{},
]

func _process_shortcuts_for_platform(shortcuts: Array) -> Array:
	var formatted = []
	for shortcut in shortcuts:
		if not (shortcut is Dictionary and "shortcut" in shortcut):
			continue

		var shortcut_text = shortcut["shortcut"]

		if OS.has_feature("macos"):
			shortcut_text = shortcut_text.replace("Ctrl", "Command")
			shortcut_text = shortcut_text.replace("Alt", "Opt")

		var entry = shortcut.duplicate()
		entry["shortcut"] = shortcut_text
		formatted.append(entry)

	return formatted

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if owner.get_parent() is SubViewport:
		return

	%CloseShortcutPanel.icon = get_theme_icon("Close", "EditorIcons")
	get_theme_stylebox("panel").bg_color = get_theme_color("dark_color_3", "Editor")


func reload_shortcuts() -> void:
	for i in %ShortcutList.get_children():
		i.queue_free()

	var is_text_editor: bool = %TextEditor.visible
	for i in _process_shortcuts_for_platform(shortcuts):
		if i.is_empty():
			%ShortcutList.add_child(HSeparator.new())
			%ShortcutList.add_child(HSeparator.new())
			continue

		if "editor" in i and not get_node("%"+i.editor).visible:
			continue

		if "platform" in i:
			var platform := OS.get_name()
			if not (platform == i.platform.trim_prefix("-") != i.platform.begins_with("-")):
				continue

		var hbox := HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 0)
		for key_text in i.shortcut.split("+"):
			if hbox.get_child_count():
				var plus_l := Label.new()
				plus_l.text = "+"
				hbox.add_child(plus_l)

			var key := Button.new()
			if key_text == "Up":
				key.icon = get_theme_icon("ArrowUp", "EditorIcons")
			elif key_text == "Down":
				key.icon = get_theme_icon("ArrowDown", "EditorIcons")
			else:
				key_text = key_text.replace("Alt/Opt", "Opt" if OS.get_name() == "macOS" else "Alt")
				key.text = key_text
			key.disabled = true
			key.theme_type_variation = "ShortcutKeyLabel"
			key.add_theme_font_override("font", get_theme_font("source", "EditorFonts"))
			hbox.add_child(key)

		%ShortcutList.add_child(hbox)

		var text := Label.new()
		text.text = i.text.replace("事件/代码行", "代码行" if is_text_editor else "事件")
		text.theme_type_variation = "DialogicHintText2"
		%ShortcutList.add_child(text)


func open():
	if visible:
		close()
		return
	reload_shortcuts()

	show()
	await get_tree().process_frame
	size = get_parent().size - Vector2(100, 100)*DialogicUtil.get_editor_scale()
	size.x = %ShortcutList.get_minimum_size().x + 100
	size.y = min(size.y, %ShortcutList.get_minimum_size().y+100)
	global_position = get_parent().global_position+get_parent().size/2-size/2


func _on_close_shortcut_panel_pressed() -> void:
	close()

func close() -> void:
	hide()
