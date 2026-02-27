@tool
extends Control

var current_info := {}
@onready var editor_view := find_parent('EditorView')


func _ready() -> void:
	await editor_view.ready
	theme = editor_view.theme

	%Install.icon = editor_view.get_theme_icon("AssetLib", "EditorIcons")
	%LoadingIcon.texture = editor_view.get_theme_icon("KeyTrackScale", "EditorIcons")
	%InstallWarning.modulate = editor_view.get_theme_color("warning_color", "Editor")
	%CloseButton.icon = editor_view.get_theme_icon("Close", "EditorIcons")
	EditorInterface.get_resource_filesystem().resources_reimported.connect(_on_resources_reimported)


func open() -> void:
	get_parent().popup_centered_ratio(0.5)
	get_parent().mode = Window.MODE_WINDOWED
	get_parent().grab_focus()


func load_info(info:Dictionary, update_type:int) -> void:
	current_info = info
	if update_type == 2:
		%State.text = "没有可用信息"
		%UpdateName.text = "无法访问版本。"
		%UpdateName.add_theme_color_override("font_color", editor_view.get_theme_color("readonly_color", "Editor"))
		%Content.text = "您可能没有连接到互联网。"
		%ShortInfo.text = "尴，这里发生了什么？"
		%ReadFull.hide()
		%Install.disabled = true
		return

	# If we are up to date (or beyond):
	if info.is_empty():
		info['name'] = "You are in the future, Marty!"
		info["body"] = "# 😎 You are using the WIP branch!\nSeems like you are using a version that isn't even released yet. Be careful and give us your feedback ;)"
		info["published_at"] = "????T"
		info["author"] = {'login':"???"}
		%State.text = "我们在哪，博士？"
		%UpdateName.add_theme_color_override("font_color", editor_view.get_theme_color("property_color_z", "Editor"))
		%Install.disabled = true

	elif update_type == 0:
		%State.text = "有可用更新！"
		%UpdateName.add_theme_color_override("font_color", editor_view.get_theme_color("warning_color", "Editor"))
		%Install.disabled = false
	else:
		%State.text = "已是最新版本："
		%UpdateName.add_theme_color_override("font_color", editor_view.get_theme_color("success_color", "Editor"))
		%Install.disabled = true

	%UpdateName.text = info.name
	%Content.text = markdown_to_bbcode(info.body).get_slice("\n[font_size", 0).strip_edges()
	%ShortInfo.text = "发布于 " + info.published_at.substr(0, info.published_at.find('T')) + " 由 " + info.author.login
	if info.has("html_url"):
		%ReadFull.uri = info.html_url
		%ReadFull.show()
	else:
		%ReadFull.hide()
	if info.has('reactions'):
		%Reactions.show()
		var reactions := {"laugh":"😂", "hooray":"🎉", "confused":"😕", "heart":"❤️", "rocket":"🚀", "eyes":"👀"}
		for i in reactions:
			%Reactions.get_node(i.capitalize()).visible = info.reactions[i] > 0
			%Reactions.get_node(i.capitalize()).text = reactions[i]+" "+str(int(info.reactions[i])) if info.reactions[i] > 0 else reactions[i]
		if info.reactions['+1']+info.reactions['-1'] > 0:
			%Reactions.get_node("Likes").visible = true
			%Reactions.get_node("Likes").text = "👍 "+str(int(info.reactions['+1']+info.reactions['-1']))
		else:
			%Reactions.get_node("Likes").visible = false
	else:
		%Reactions.hide()

func _on_window_close_requested() -> void:
	get_parent().visible = false


func _on_install_pressed() -> void:
	find_parent('UpdateManager').request_update_download()

	%InfoLabel.text = "下载中，这可能需要一点时间。"
	%Loading.show()
	%LoadingIcon.create_tween().set_loops().tween_property(%LoadingIcon, 'rotation', 2*PI, 1).from(0)


func _on_refresh_pressed() -> void:
	find_parent('UpdateManager').request_update_check()


func _on_update_manager_downdload_completed(result:int):
	%Loading.hide()
	match result:
		0: # success
			%InfoLabel.text = "安装成功，需要重启！"
			%InfoLabel.modulate = editor_view.get_theme_color("success_color", "Editor")
			%Restart.show()
			%Restart.grab_focus()
		1: # failure
			%InfoLabel.text = "下载失败。"
			%InfoLabel.modulate = editor_view.get_theme_color("readonly_color", "Editor")


func _on_resources_reimported(resources:Array) -> void:
	if is_inside_tree():
		await get_tree().process_frame
		get_parent().grab_focus()


func markdown_to_bbcode(text:String) -> String:
	var font_sizes := {1:20, 2:16, 3:16,4:14, 5:14}
	var title_regex := RegEx.create_from_string('(^|\n)((?<level>#+)(?<title>.*))\\n')
	var res := title_regex.search(text)
	while res:
		text = text.replace(res.get_string(2), '[font_size='+str(font_sizes[len(res.get_string('level'))])+']'+res.get_string('title').strip_edges()+'[/font_size]')
		res = title_regex.search(text)

	var link_regex := RegEx.create_from_string('(?<!\\!)\\[(?<text>[^\\]]*)]\\((?<link>[^)]*)\\)')
	res = link_regex.search(text)
	while res:
		text = text.replace(res.get_string(), '[url='+res.get_string('link')+']'+res.get_string('text').strip_edges()+'[/url]')
		res = link_regex.search(text)

	var image_regex := RegEx.create_from_string('\\!\\[(?<text>[^\\]]*)]\\((?<link>[^)]*)\\)\n*')
	res = image_regex.search(text)
	while res:
		text = text.replace(res.get_string(), '[url='+res.get_string('link')+']'+res.get_string('text').strip_edges()+'[/url]')
		res = image_regex.search(text)

	var italics_regex := RegEx.create_from_string('\\*(?<text>[^\\*\\n]*)\\*')
	res = italics_regex.search(text)
	while res:
		text = text.replace(res.get_string(), '[i]'+res.get_string('text').strip_edges()+'[/i]')
		res = italics_regex.search(text)

	var bullets_regex := RegEx.create_from_string('(?<=\\n)(\\*|-)(?<text>[^\\*\\n]*)\\n')
	res = bullets_regex.search(text)
	while res:
		text = text.replace(res.get_string(), '[ul]'+res.get_string('text').strip_edges()+'[/ul]\n')
		res = bullets_regex.search(text)

	var small_code_regex := RegEx.create_from_string('(?<!`)`(?<text>[^`]+)`')
	res = small_code_regex.search(text)
	while res:
		text = text.replace(res.get_string(), '[code][color='+get_theme_color("accent_color", "Editor").to_html()+']'+res.get_string('text').strip_edges()+'[/color][/code]')
		res = small_code_regex.search(text)

	var big_code_regex := RegEx.create_from_string('(?<!`)```(?<text>[^`]+)```')
	res = big_code_regex.search(text)
	while res:
		text = text.replace(res.get_string(), '[code][bgcolor='+get_theme_color("box_selection_fill_color", "Editor").to_html()+']'+res.get_string('text').strip_edges()+'[/bgcolor][/code]')
		res = big_code_regex.search(text)

	return text



func _on_content_meta_clicked(meta:Variant) -> void:
	OS.shell_open(str(meta))


func _on_install_mouse_entered() -> void:
	if not %Install.disabled:
		%InstallWarning.show()


func _on_install_mouse_exited() -> void:
	%InstallWarning.hide()


func _on_restart_pressed() -> void:
	EditorInterface.restart_editor(true)


func _on_close_button_pressed() -> void:
	get_parent().hide()
