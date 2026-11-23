extends Node

const CACHE_INFO_PATH := "user://cache_info.json"
const CACHE_DIRS := ["user://vulkan", "user://shader_cache"]
const MAX_AGE_DAYS := 30 # Età massima dei singoli file in giorni
const SCAN_INTERVAL_DAYS := 1 # Ogni quanti giorni eseguire il controllo dei file vecchi

func _ready() -> void:
	_manage_cache()

func _manage_cache() -> void:
	var start_ticks := Time.get_ticks_msec()
	var current_version: String = ProjectSettings.get_setting("application/config/version", "1.0.0")
	var current_time := int(Time.get_unix_time_from_system())
	var cache_data := _load_cache_info()

	var saved_version: String = cache_data.get("version", "")
	var last_scan: int = cache_data.get("last_scan", 0)
	var last_scan_elapsed: int = cache_data.get("last_scan_elapsed_ms", 0)

	var scan_executed := false

	# 1. Se la versione è cambiata, svuota tutto
	if saved_version != current_version:
		if saved_version != "":
			print("Cambio versione (%s -> %s): pulizia totale cache..." % [saved_version, current_version])
			for dir_path in CACHE_DIRS:
				_clean_directory(dir_path, true)
			scan_executed = true
		
		last_scan = current_time
		last_scan_elapsed = Time.get_ticks_msec() - start_ticks if scan_executed else 0

	# 2. Altrimenti, controlla se è passato abbastanza tempo dall'ultima scansione
	elif (current_time - last_scan) >= (SCAN_INTERVAL_DAYS * 86400):
		print("Avvio scansione periodica file cache obsoleti...")
		var max_age_seconds := MAX_AGE_DAYS * 86400
		for dir_path in CACHE_DIRS:
			_clean_directory(dir_path, false, current_time, max_age_seconds)
		
		scan_executed = true
		last_scan = current_time
		last_scan_elapsed = Time.get_ticks_msec() - start_ticks

	# Calcola il tempo totale di questa esecuzione (pulizia inclusa, se avvenuta)
	var total_check_elapsed := Time.get_ticks_msec() - start_ticks

	# Aggiorna il JSON ad ogni avvio preservando i dati dell'ultima vera pulizia
	_save_cache_info(
		current_version,
		last_scan,
		last_scan_elapsed,
		current_time,
		total_check_elapsed,
		scan_executed
	)

func _load_cache_info() -> Dictionary:
	if not FileAccess.file_exists(CACHE_INFO_PATH):
		return {}
	
	var file := FileAccess.open(CACHE_INFO_PATH, FileAccess.READ)
	if not file:
		return {}
	
	var json := JSON.new()
	if json.parse(file.get_as_text()) == OK and typeof(json.data) == TYPE_DICTIONARY:
		return json.data
	
	return {}

func _save_cache_info(
	version: String,
	last_scan: int,
	last_scan_elapsed: int,
	last_check: int,
	last_check_elapsed: int,
	scan_executed: bool
) -> void:
	var data := {
		"version": version,
		"last_scan": last_scan,
		"last_scan_readable": Time.get_datetime_string_from_unix_time(last_scan),
		"last_scan_elapsed_ms": last_scan_elapsed,
		"last_check": last_check,
		"last_check_readable": Time.get_datetime_string_from_unix_time(last_check),
		"last_check_elapsed_ms": last_check_elapsed,
		"last_check_performed_scan": scan_executed
	}
	var file := FileAccess.open(CACHE_INFO_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t"))

func _clean_directory(path: String, force_all: bool, current_time: int = 0, max_age_sec: int = 0) -> bool:
	var dir := DirAccess.open(path)
	if not dir:
		return true

	var is_empty := true
	dir.list_dir_begin()
	var file_name := dir.get_next()

	while file_name != "":
		if file_name != "." and file_name != "..":
			var full_path := path.path_join(file_name)
			if dir.current_is_dir():
				var sub_empty := _clean_directory(full_path, force_all, current_time, max_age_sec)
				if force_all or sub_empty:
					dir.remove(file_name)
				else:
					is_empty = false
			else:
				var should_delete := force_all
				if not should_delete:
					var mod_time := FileAccess.get_modified_time(full_path)
					if mod_time > 0 and (current_time - mod_time) > max_age_sec:
						should_delete = true

				if should_delete:
					dir.remove(file_name)
				else:
					is_empty = false
		file_name = dir.get_next()

	dir.list_dir_end()
	return is_empty
