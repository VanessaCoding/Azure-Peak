GLOBAL_LIST_INIT(preferred_ui_languages, build_preferred_ui_languages())

/// Add new selectable TGUI languages from other modules by defining subtypes.
/datum/preferred_ui_language
	var/display_name
	var/language_code

/datum/preferred_ui_language/english
	display_name = "English"
	language_code = DEFAULT_PREFERRED_UI_LANGUAGE

/client
	var/preferred_ui_language = DEFAULT_PREFERRED_UI_LANGUAGE

/proc/build_preferred_ui_languages()
	. = list()
	for(var/language_path in subtypesof(/datum/preferred_ui_language))
		var/datum/preferred_ui_language/language = language_path
		var/display_name = initial(language.display_name)
		var/language_code = initial(language.language_code)
		if(!display_name || !language_code)
			continue
		.[display_name] = language_code

/proc/get_preferred_ui_language_display_name(language_code)
	for(var/display_name in GLOB.preferred_ui_languages)
		if(GLOB.preferred_ui_languages[display_name] == language_code)
			return display_name

/proc/is_preferred_ui_language_available(language_code)
	return get_preferred_ui_language_display_name(language_code) ? TRUE : FALSE

/client/verb/change_prefered_language()
	set name = "Change Preferred TGUI Language"
	set category = "OOC"
	set desc = "Change your preferred TGUI language for multilingual interfaces."

	var/list/language_choices = GLOB.preferred_ui_languages
	var/current_language = preferred_ui_language
	if(!is_preferred_ui_language_available(current_language))
		current_language = DEFAULT_PREFERRED_UI_LANGUAGE
		preferred_ui_language = current_language

	var/current_language_display_name = get_preferred_ui_language_display_name(current_language) || "English"
	var/selection = input(src, "Choose your preferred UI language.", "Preferred Language", current_language_display_name) as null|anything in language_choices
	if(!selection)
		return

	preferred_ui_language = language_choices[selection]
	to_chat(src, span_notice("Preferred UI language set to [selection]. Reopen interfaces to apply it."))
