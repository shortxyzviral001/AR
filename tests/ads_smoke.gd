extends Node
## Verifie AdsManager (Adsterra) : consentement, plafond quotidien, et
## non-remise de la recompense avant le delai minimum. N'ouvre JAMAIS le
## navigateur (on n'appelle pas show_rewarded()).

func _ready() -> void:
	# Consentement
	AdsManager.set_consent(true)
	print("ADS_TEST has_consent=", AdsManager.has_consent())
	print("ADS_TEST can_show=", AdsManager.can_show_rewarded())

	# URLs Adsterra correctement configurees (pas de placeholder oublie)
	print("ADS_TEST rewarded_url_ok=", AdsManager.AD_REWARDED_URL.begins_with("https://"))
	print("ADS_TEST smartlink_url_ok=", AdsManager.AD_SMARTLINK_URL.begins_with("https://"))

	# Recompense impossible avant le delai minimum (aucune pub lancee)
	print("ADS_TEST pop_before=", AdsManager.pop_reward())

	# Plafond quotidien respecte (valeur par defaut raisonnable, > 0)
	print("ADS_TEST daily_cap_positive=", AdsManager.MAX_REWARDED_PER_DAY > 0)
	print("ADS_TEST views_remaining=", AdsManager.views_remaining_today())

	# Statut (ne doit pas crasher)
	print("ADS_TEST status=", AdsManager.get_status().substr(0, 60))

	AdsManager.set_consent(false)
	get_tree().quit(0)
