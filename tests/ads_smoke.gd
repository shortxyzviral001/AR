extends Node
## Verifie AdsManager : consentement, generation de la page locale (desktop),
## et non-remise de la recompense avant le delai minimum. N'ouvre JAMAIS le
## navigateur (on n'appelle pas show_rewarded).

func _ready() -> void:
	# Consentement
	AdsManager.set_consent(true)
	print("ADS_TEST has_consent=", AdsManager.has_consent())
	print("ADS_TEST can_show=", AdsManager.can_show_rewarded())

	# Page locale desktop (sans ouvrir le navigateur)
	var ok: bool = AdsManager._write_desktop_ad_page()
	print("ADS_TEST write_page=", ok)
	if ok:
		var f: FileAccess = FileAccess.open(OS.get_user_data_dir() + "/" + AdsManager.DESKTOP_AD_PAGE_NAME, FileAccess.READ)
		if f != null:
			var html: String = f.get_as_text()
			f.close()
			print("ADS_TEST has_zone=", html.contains("highperformanceformat") or html.contains("effectivecpmnetwork"))
			print("ADS_TEST cache_busted=", html.contains("cb="))
		else:
			print("ADS_TEST read_page=FAIL")

	# Recompense impossible avant le delai minimum (aucune pub lancee)
	print("ADS_TEST pop_before=", AdsManager.pop_reward())

	# Statut (ne doit pas crasher sur desktop)
	print("ADS_TEST status=", AdsManager.get_status().substr(0, 60))

	AdsManager.set_consent(false)
	get_tree().quit(0)
