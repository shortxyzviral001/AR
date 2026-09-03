extends Node
## Autoload : parametres persistants du joueur (difficulte, controles tactiles, langue).

const SAVE_PATH: String = "user://settings.cfg"

enum Difficulty { EASY, NORMAL, HARD }

# -- Translations dictionary (FR / EN) ----------------------------------------
const TRANSLATIONS: Dictionary = {
	"fr": {
		# Language picker
		"lang_title": "Choisis ta langue",
		"lang_subtitle": "Select your language",
		"lang_fr": "Francais",
		"lang_en": "English",
		"lang_confirm": "Confirmer",
		# Start screen
		"start_title": "Astro Recolte",
		"start_play": "Jouer",
		"start_shop": "Boutique",
		"start_leaderboard": "Classement",
		"start_settings": "Parametres",
		"start_credits": "Credits",
		"start_change_pseudo": "Changer de pseudo",
		"start_daily_reward": "Bonus quotidien : +%d cristaux (serie de %d jour%s) !",
		"start_info": "Attrape les etoiles, evite les meteores.\nPseudo : %s",
		"start_difficulty": "Difficulte : %s",
		"start_high_score": "Meilleur score local : %d",
		# Pseudo screen
		"pseudo_title": "Choisis ton pseudo",
		"pseudo_hint": "3 a 16 caracteres : lettres, chiffres, - ou _.\nUnique parmi tous les joueurs.",
		"pseudo_placeholder": "TonPseudo",
		"pseudo_confirm": "Valider",
		"pseudo_invalid": "Pseudo invalide (3-16 caracteres, lettres/chiffres/-/_).",
		"pseudo_checking": "Verification...",
		"pseudo_taken": "Ce pseudo est deja pris, essaie-en un autre.",
		"pseudo_error": "Connexion impossible pour verifier ce pseudo. Reessaie.",
		"pseudo_random": "🎲 Aleatoire",
		# Game over
		"gameover_title": "Mission terminee",
		"gameover_score": "Score : %d  |  Temps : %ds\n%s\n+%d cristaux (%d au total)",
		"gameover_new_record": "Nouveau record local !",
		"gameover_record": "Record local : %d",
		"gameover_submitting": "Envoi du score au classement...",
		"gameover_replay": "Rejouer",
		"gameover_leaderboard": "Classement",
		"gameover_rewarded": "Regarder une pub pour x2 cristaux (+%d)",
		"gameover_rewarded_active": "Pub en cours...",
		"gameover_rewarded_unavailable": "Pub indisponible, retentez...",
		"gameover_reward_disabled": "Publicites desactivees (Parametres)",
		"gameover_reward_capped": "Plus de pubs aujourd'hui (%d/%d)",
		"gameover_new_record_online": "Nouveau record en ligne ! (%d pts)",
		"gameover_score_sent": "Score envoye. Ton record en ligne tient toujours.",
		"gameover_score_error": "Connexion au classement impossible pour l'instant.",
		"gameover_x2_active": "Bonus x2 active !",
		"gameover_x2_body": "Score : %d  |  Temps : %ds\nNouveau record local !\n+%d cristaux (+%d bonus) = %d au total",
		# Consent screen
		"consent_title": "Publicites",
		"consent_body": "Le jeu affiche des publicites uniquement si tu cliques sur le bouton\nx2 cristaux - jamais automatiquement.\nAutorises-tu l'affichage de ces publicites ?\n(Tu pourras changer d'avis dans Parametres.)",
		"consent_accept": "Accepter",
		"consent_decline": "Refuser",
		"ad_waiting": "Regarde la pub... %ds",
		"ad_return": "Reviens au jeu pour recevoir ton bonus !",
		"ad_continue": "J'ai regarde - Continuer",
		"ad_interstitial_prompt": "Une pub t'interesse ? Clique ici (ou ferme).",
		# Pause
		"pause_title": "Pause",
		"pause_status": "Score : %d  -  Temps : %ds",
		"pause_resume": "Reprendre",
		"pause_settings": "Parametres",
		"pause_quit": "Quitter la partie",
		# Settings (fullscreen)
		"settings_title": "Parametres",
		"settings_language": "Langue",
		"settings_difficulty": "Difficulte",
		"settings_touch": "Afficher les controles tactiles",
		"settings_audio": "Audio",
		"settings_sfx": "Effets sonores",
		"settings_music": "Musique",
		"settings_vol_music": "Volume musique",
		"settings_vol_sfx": "Volume effets",
		"settings_vol_cine": "Volume cinematiques",
		"settings_accessibility": "Accessibilite",
		"settings_reduce_motion": "Reduire les secousses d'ecran",
		"settings_high_contrast": "Contraste eleve",
		"settings_progression": "Progression",
		"settings_progress": "%d cristaux - %d / %d ensembles - meilleur combo : x%d",
		"settings_open_shop": "Ouvrir la boutique",
		"settings_ads": "Publicites",
		"settings_ads_toggle": "Autoriser les publicites (x2 cristaux)",
		"settings_misc": "Divers",
		"settings_reset_score": "Reinitialiser le record local",
		"settings_reset_done": "Fait !",
		"settings_replay_tutorial": "Revoir le tutoriel",
		"settings_credits": "Credits",
		"settings_back": "Retour",
		# Leaderboard
		"lb_title": "Classement",
		"lb_loading": "Chargement...",
		"lb_empty": "Aucun score en ligne pour le moment (ou connexion indisponible).",
		"lb_retrying": "Nouvelle tentative...",
		"lb_header": "Classe par ratio score/temps :",
		"lb_entry": "[b]%d.[/b] %s — score %d en %ds (%.2f pts/s)",
		"lb_back": "Retour",
		# Tutorial
		"tutorial_title": "Bienvenue !",
		"tutorial_step1": "Deplace ton vaisseau avec les fleches/ZQSD, le stick tactile, ou en maintenant le clic gauche.",
		"tutorial_step2": "Le tir est automatique : concentre-toi sur l'esquive et le positionnement.",
		"tutorial_step3": "Attrape les etoiles jaunes (score + cristaux), evite les meteores et les malus violets/jaunes.",
		"tutorial_step4": "Des vaisseaux ennemis apparaissent : ton tir les detruit automatiquement, ou tu peux les esquiver.",
		"tutorial_step5": "Toutes les ~40 secondes, un boss de secteur arrive avec sa propre barre de vie et un pattern de tir signature.",
		"tutorial_step6": "Depense tes cristaux dans la Boutique pour debloquer de nouvelles coques, trainees et insignes.",
		"tutorial_got_it": "Compris, on y va !",
		# Shop
		"shop_title": "Boutique",
		"shop_crystals": "%d cristaux",
		"shop_progress": "%d / %d ensembles possedes - equipe : %s",
		"shop_page": "Page %d / %d",
		"shop_sort_asc": "Trier : prix croissant",
		"shop_sort_desc": "Trier : prix decroissant",
		"shop_prev": "< Precedent",
		"shop_next": "Suivant >",
		"shop_back": "Retour",
		"shop_equip": "Equiper",
		"shop_equipped": "Equipe",
		"shop_try": "Voir sur mon vaisseau",
		"shop_filter_all": "Tous",
		"shop_filter_common": "Commun",
		"shop_filter_rare": "Rare",
		"shop_filter_epic": "Epique",
		"shop_filter_legendary": "Legendaire",
		# Credits
		"credits_title": "Credits",
		"credits_studio": "multidevsn",
		"credits_role": "Developpement, design et code",
		"credits_thanks": "Merci d'avoir joue a Astro Recolte !\nChaque partie, chaque cristal collecte fait vivre le jeu.",
		"credits_engine": "Cree avec Godot Engine",
		"credits_back": "Retour",
		# Difficulty labels
		"diff_easy": "Facile",
		"diff_normal": "Normal",
		"diff_hard": "Difficile",
		# Misc
		"currency_format": "%d cr.",
		"crystals_format": "%d cristaux",
		"hud_score": "Score  %d",
		"hud_lives": "Vies  %d",
		"hud_time": "Temps  %ds",
		# Combo HUD
		"combo_label": "COMBO",
		# Power-ups
		"powerup_shield": "Bouclier !",
		"powerup_speed": "Vitesse + !",
		# Boss victory
		"boss_victory": "BOSS VAINCU !",
		"next_sector": "SECTEUR SUIVANT",
		# Stats section
		"settings_stats": "Statistiques",
		"stat_games_played": "Parties jouees : %d",
		"stat_best_score": "Meilleur score : %d",
		"stat_best_combo": "Meilleur combo : x%d",
		"stat_crystals_earned": "Cristaux gagnes (total) : %d",
		"stat_bosses_defeated": "Boss vaincus : %d",
		"stat_sets_owned": "Ensembles possedes : %d / %d",
		# Achievements
		"achievements_title": "Succes",
		"ach_first_game": "Premier vol",
		"ach_first_game_desc": "Jouer a sa premiere partie",
		"ach_combo_25": "Combo fou",
		"ach_combo_25_desc": "Atteindre x25 combo",
		"ach_combo_50": "Combo legendaire",
		"ach_combo_50_desc": "Atteindre x50 combo",
		"ach_boss_1": "Chasseur de boss",
		"ach_boss_1_desc": "Vaincre 1 boss",
		"ach_boss_10": "Tueur de boss",
		"ach_boss_10_desc": "Vaincre 10 boss",
		"ach_score_5000": "Score stellaire",
		"ach_score_5000_desc": "Atteindre 5000 points",
		"ach_score_10000": "Score cosmique",
		"ach_score_10000_desc": "Atteindre 10000 points",
		"ach_sets_50": "Collectionneur",
		"ach_sets_50_desc": "Collectionner 50 ensembles",
		"ach_crystals_1000": "Magnat de cristaux",
		"ach_crystals_1000_desc": "Gagner 1000 cristaux (total)",
		# Update notification
		"update_title": "Mise a jour disponible",
		"update_body": "Une nouvelle version (%s) est disponible !",
		"update_changelog": "Nouveautes :",
		"update_download": "Telecharger",
		"update_later": "Plus tard",
		"update_check": "Verifier les mises a jour",
		"update_none": "Vous avez la derniere version !",
		"update_error": "Impossible de verifier pour le moment.",
		# Cinematics
		"cine_welcome": "BIENVENUE DANS L'ESPACE",
		"cine_subtitle": "Preparez-vous...",
		"cine_boss_warning": "ALERTE",
		"cine_boss_approach": "Un ennemi puissant approche...",
		"cine_prepare": "Preparez-vous au combat !",
		"cine_fly_safe": "Voyagez securise, pilote.",
		# Story cinematics
		"story_skip": "Passer",
		"cine_nova_name": "NOVA",
		"cine_pilot_name": "CAPITAINE",
		"cine_scourge_name": "LE FLEAU",
		"cine_line_1a": "Capitaine ! La Ceinture est calme aujourd'hui. Conditions de recolte parfaites.",
		"cine_line_1b": "Chaque cristal recolte alimente toute la Ceinture. C'est notre mission.",
		"cine_line_1c": "Mais cette lumiere... Elle apparait chaque nuit. On dirait un signal.",
		"cine_line_2a": "Capitaine ! Un signal de detresse en provenance du Secteur 4 !",
		"cine_line_2b": "C'est... c'est LE FLEAU ! Il devore les champs de cristaux !",
		"cine_line_2c": "Il s'est deja emparé de trois secteurs. Personne n'a survécu.",
		"cine_line_3a": "S'il atteint le Coeur de la Ceinture, tout disparaitra pour toujours.",
		"cine_line_3b": "Capitaine... vous etes la derniere lumiere. Le dernier recolteur.",
		"cine_line_4a": "Alors on recolte. On se bat. Et on protege notre maison.",
		"cine_title_main": "ASTRO RECOLTE",
		"cine_title_sub": "La Derniere Recolte",
		"cine_tap_hint": "Touchez pour continuer",
		# Zone transitions
		"zone_intro_0": "Ceinture Bleue — Lesport d'entree",
		"zone_intro_1": "Nebuleuse Violette — Les mysteres s'epaississent",			"zone_intro_2": "Ceinture Ambree — La dangerosite augmente",
			"zone_intro_3": "Zone Cramoisie — Le seuil de la gloire",
			"zone_intro_4": "Abysses Emeraude — L'ultime epreuve",
	},
	"en": {
		# Language picker
		"lang_title": "Choose your language",
		"lang_subtitle": "Choisis ta langue",
		"lang_fr": "Francais",
		"lang_en": "English",
		"lang_confirm": "Confirm",
		# Start screen
		"start_title": "Astro Harvest",
		"start_play": "Play",
		"start_shop": "Shop",
		"start_leaderboard": "Leaderboard",
		"start_settings": "Settings",
		"start_credits": "Credits",
		"start_change_pseudo": "Change nickname",
		"start_daily_reward": "Daily bonus: +%d crystals (%d day streak)!",
		"start_info": "Catch the stars, dodge the meteors.\nNickname: %s",
		"start_difficulty": "Difficulty: %s",
		"start_high_score": "Local best: %d",
		# Pseudo screen
		"pseudo_title": "Choose your nickname",
		"pseudo_hint": "3 to 16 characters: letters, digits, - or _.\nMust be unique among all players.",
		"pseudo_placeholder": "YourNickname",
		"pseudo_confirm": "Confirm",
		"pseudo_invalid": "Invalid nickname (3-16 chars, letters/digits/-/_).",
		"pseudo_checking": "Checking...",
		"pseudo_taken": "That nickname is taken, try another one.",
		"pseudo_error": "Unable to verify nickname. Try again.",
		"pseudo_random": "🎲 Random",
		# Game over
		"gameover_title": "Mission Complete",
		"gameover_score": "Score: %d  |  Time: %ds\n%s\n+%d crystals (%d total)",
		"gameover_new_record": "New local record!",
		"gameover_record": "Local record: %d",
		"gameover_submitting": "Submitting score...",
		"gameover_replay": "Play Again",
		"gameover_leaderboard": "Leaderboard",
		"gameover_rewarded": "Watch an ad for x2 crystals (+%d)",
		"gameover_rewarded_active": "Ad playing...",
		"gameover_rewarded_unavailable": "Ad unavailable, try again...",
		"gameover_reward_disabled": "Ads disabled (Settings)",
		"gameover_reward_capped": "No more ads today (%d/%d)",
		"gameover_new_record_online": "New online record! (%d pts)",
		"gameover_score_sent": "Score submitted. Your online record still stands.",
		"gameover_score_error": "Leaderboard unavailable for now.",
		"gameover_x2_active": "x2 bonus activated!",
		"gameover_x2_body": "Score: %d  |  Time: %ds\nNew local record!\n+%d crystals (+%d bonus) = %d total",
		# Consent screen
		"consent_title": "Advertisements",
		"consent_body": "The game only shows ads when you tap the x2 crystals button\n- never automatically.\nDo you allow ads?\n(You can change this in Settings.)",
		"consent_accept": "Accept",
		"consent_decline": "Decline",
		"ad_waiting": "Watch the ad... %ds",
		"ad_return": "Return to the game to claim your bonus!",
		"ad_continue": "I watched it - Continue",
		"ad_interstitial_prompt": "Interested in an ad? Tap here (or close).",
		# Pause
		"pause_title": "Paused",
		"pause_status": "Score: %d  -  Time: %ds",
		"pause_resume": "Resume",
		"pause_settings": "Settings",
		"pause_quit": "Quit to Menu",
		# Settings (fullscreen)
		"settings_title": "Settings",
		"settings_language": "Language",
		"settings_difficulty": "Difficulty",
		"settings_touch": "Show touch controls",
		"settings_audio": "Audio",
		"settings_sfx": "Sound Effects",
		"settings_music": "Music",
		"settings_vol_music": "Music volume",
		"settings_vol_sfx": "Effects volume",
		"settings_vol_cine": "Cinematic volume",
		"settings_accessibility": "Accessibility",
		"settings_reduce_motion": "Reduce screen shake",
		"settings_high_contrast": "High contrast",
		"settings_progression": "Progression",
		"settings_progress": "%d crystals - %d / %d sets owned - best combo: x%d",
		"settings_open_shop": "Open shop",
		"settings_ads": "Advertisements",
		"settings_ads_toggle": "Allow ads (x2 crystals)",
		"settings_misc": "Other",
		"settings_reset_score": "Reset local record",
		"settings_reset_done": "Done!",
		"settings_replay_tutorial": "Replay tutorial",
		"settings_credits": "Credits",
		"settings_back": "Back",
		# Leaderboard
		"lb_title": "Leaderboard",
		"lb_loading": "Loading...",
		"lb_empty": "No online scores yet (or connection unavailable).",
		"lb_retrying": "Retrying...",
		"lb_header": "Ranked by score/time ratio:",
		"lb_entry": "[b]%d.[/b] %s — score %d in %ds (%.2f pts/s)",
		"lb_back": "Back",
		# Tutorial
		"tutorial_title": "Welcome!",
		"tutorial_step1": "Move your ship with arrow keys/ZQSD, the touch stick, or by holding left click.",
		"tutorial_step2": "Shooting is automatic: focus on dodging and positioning.",
		"tutorial_step3": "Catch yellow stars (score + crystals), avoid meteors and purple/yellow debuffs.",
		"tutorial_step4": "Enemy ships appear: your shots destroy them automatically, or you can dodge them.",
		"tutorial_step5": "Every ~40 seconds, a sector boss arrives with its own health bar and signature attack pattern.",
		"tutorial_step6": "Spend your crystals in the Shop to unlock new hulls, trails, and badges.",
		"tutorial_got_it": "Got it, let's go!",
		# Shop
		"shop_title": "Shop",
		"shop_crystals": "%d crystals",
		"shop_progress": "%d / %d sets owned - equipped: %s",
		"shop_page": "Page %d / %d",
		"shop_sort_asc": "Sort: price ascending",
		"shop_sort_desc": "Sort: price descending",
		"shop_prev": "< Previous",
		"shop_next": "Next >",
		"shop_back": "Back",
		"shop_equip": "Equip",
		"shop_equipped": "Equipped",
		"shop_try": "Preview on my ship",
		"shop_filter_all": "All",
		"shop_filter_common": "Common",
		"shop_filter_rare": "Rare",
		"shop_filter_epic": "Epic",
		"shop_filter_legendary": "Legendary",
		# Credits
		"credits_title": "Credits",
		"credits_studio": "multidevsn",
		"credits_role": "Development, design and code",
		"credits_thanks": "Thanks for playing Astro Harvest!\nEvery run, every crystal collected keeps the game alive.",
		"credits_engine": "Made with Godot Engine",
		"credits_back": "Back",
		# Difficulty labels
		"diff_easy": "Easy",
		"diff_normal": "Normal",
		"diff_hard": "Hard",
		# Misc
		"currency_format": "%d cr.",
		"crystals_format": "%d crystals",
		"hud_score": "Score  %d",
		"hud_lives": "Lives  %d",
		"hud_time": "Time  %ds",
		# Combo HUD
		"combo_label": "COMBO",
		# Power-ups
		"powerup_shield": "Shield !",
		"powerup_speed": "Speed + !",
		# Boss victory
		"boss_victory": "BOSS DEFEATED!",
		"next_sector": "NEXT SECTOR",
		# Stats section
		"settings_stats": "Statistics",
		"stat_games_played": "Games played: %d",
		"stat_best_score": "Best score: %d",
		"stat_best_combo": "Best combo: x%d",
		"stat_crystals_earned": "Crystals earned (total): %d",
		"stat_bosses_defeated": "Bosses defeated: %d",
		"stat_sets_owned": "Sets owned: %d / %d",
		# Achievements
		"achievements_title": "Achievements",
		"ach_first_game": "First flight",
		"ach_first_game_desc": "Play your first game",
		"ach_combo_25": "Crazy combo",
		"ach_combo_25_desc": "Reach x25 combo",
		"ach_combo_50": "Legendary combo",
		"ach_combo_50_desc": "Reach x50 combo",
		"ach_boss_1": "Boss hunter",
		"ach_boss_1_desc": "Defeat 1 boss",
		"ach_boss_10": "Boss slayer",
		"ach_boss_10_desc": "Defeat 10 bosses",
		"ach_score_5000": "Stellar score",
		"ach_score_5000_desc": "Reach 5,000 points",
		"ach_score_10000": "Cosmic score",
		"ach_score_10000_desc": "Reach 10,000 points",
		"ach_sets_50": "Collector",
		"ach_sets_50_desc": "Collect 50 sets",
		"ach_crystals_1000": "Crystal mogul",
		"ach_crystals_1000_desc": "Earn 1,000 crystals (total)",
		# Update notification
		"update_title": "Update available",
		"update_body": "A new version (%s) is available!",
		"update_changelog": "What's new:",
		"update_download": "Download",
		"update_later": "Later",
		"update_check": "Check for updates",
		"update_none": "You're on the latest version!",
		"update_error": "Unable to check right now.",
		# Cinematics
		"cine_welcome": "WELCOME TO SPACE",
		"cine_subtitle": "Get ready...",
		"cine_boss_warning": "WARNING",
		"cine_boss_approach": "A powerful enemy approaches...",
		"cine_prepare": "Prepare for battle!",
		"cine_fly_safe": "Fly safe, pilot.",
		# Story cinematics
		"story_skip": "Skip",
		"cine_nova_name": "NOVA",
		"cine_pilot_name": "CAPTAIN",
		"cine_scourge_name": "THE SCOURGE",
		"cine_line_1a": "Captain! The Belt is calm today. Perfect harvesting conditions.",
		"cine_line_1b": "Every crystal we harvest powers the whole Belt. That's our mission.",
		"cine_line_1c": "But that light... It appears every night. It looks like a signal.",
		"cine_line_2a": "Captain! A distress signal from Sector 4!",
		"cine_line_2b": "It's... it's THE SCOURGE! It devours crystal fields!",
		"cine_line_2c": "It already took three sectors. No one survived.",
		"cine_line_3a": "If it reaches the Heart of the Belt, everything will disappear forever.",
		"cine_line_3b": "Captain... you are the last light. The last harvester.",
		"cine_line_4a": "Then we harvest. We fight. And we protect our home.",
		"cine_title_main": "ASTRO HARVEST",
		"cine_title_sub": "The Last Harvest",
		"cine_tap_hint": "Tap to continue",
		# Zone transitions
		"zone_intro_0": "Blue Belt — The gateway sector",
		"zone_intro_1": "Violet Nebula — Mysteries deepen",		"zone_intro_2": "Amber Belt — Danger intensifies",
			"zone_intro_3": "Crimson Zone — The threshold of glory",
			"zone_intro_4": "Emerald Abyss — The ultimate trial",
	},
}

# -- Persistent settings -------------------------------------------------------

# Multiplicateur applique a la vitesse de montee en difficulte.
const DIFFICULTY_SPEED_MULT: Dictionary = {
	Difficulty.EASY: 0.7,
	Difficulty.NORMAL: 1.0,
	Difficulty.HARD: 1.4,
}

# Plafond de difficulte atteignable.
const DIFFICULTY_MAX: Dictionary = {
	Difficulty.EASY: 6.0,
	Difficulty.NORMAL: 9.0,
	Difficulty.HARD: 12.0,
}

var touch_controls_enabled: bool = true
var difficulty: int = Difficulty.NORMAL
var sfx_enabled: bool = true
var music_enabled: bool = true
var reduce_motion: bool = false
var high_contrast: bool = false
var has_seen_tutorial: bool = false
var story_shown: bool = false
var language: String = ""  # "" = not chosen yet, "fr" or "en"
var music_volume: float = 1.0
var sfx_volume: float = 1.0
var cine_volume: float = 1.0


func _ready() -> void:
	touch_controls_enabled = DisplayServer.is_touchscreen_available()
	_load()


func _load() -> void:
	var config: ConfigFile = ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return
	touch_controls_enabled = config.get_value("settings", "touch_controls_enabled", touch_controls_enabled)
	difficulty = config.get_value("settings", "difficulty", difficulty)
	sfx_enabled = config.get_value("settings", "sfx_enabled", sfx_enabled)
	music_enabled = config.get_value("settings", "music_enabled", music_enabled)
	reduce_motion = config.get_value("settings", "reduce_motion", reduce_motion)
	high_contrast = config.get_value("settings", "high_contrast", high_contrast)
	has_seen_tutorial = config.get_value("settings", "has_seen_tutorial", has_seen_tutorial)
	var lang_val = config.get_value("settings", "language", "")
	language = str(lang_val)
	story_shown = config.get_value("settings", "story_shown", false)
	music_volume = clampf(float(config.get_value("settings", "music_volume", music_volume)), 0.0, 1.0)
	sfx_volume = clampf(float(config.get_value("settings", "sfx_volume", sfx_volume)), 0.0, 1.0)
	cine_volume = clampf(float(config.get_value("settings", "cine_volume", cine_volume)), 0.0, 1.0)


func save() -> void:
	var config: ConfigFile = ConfigFile.new()
	config.set_value("settings", "touch_controls_enabled", touch_controls_enabled)
	config.set_value("settings", "difficulty", difficulty)
	config.set_value("settings", "sfx_enabled", sfx_enabled)
	config.set_value("settings", "music_enabled", music_enabled)
	config.set_value("settings", "reduce_motion", reduce_motion)
	config.set_value("settings", "high_contrast", high_contrast)
	config.set_value("settings", "has_seen_tutorial", has_seen_tutorial)
	config.set_value("settings", "language", language)
	config.set_value("settings", "story_shown", story_shown)
	config.set_value("settings", "music_volume", music_volume)
	config.set_value("settings", "sfx_volume", sfx_volume)
	config.set_value("settings", "cine_volume", cine_volume)
	config.save(SAVE_PATH)


func speed_multiplier() -> float:
	return DIFFICULTY_SPEED_MULT.get(difficulty, 1.0)


func max_difficulty() -> float:
	return DIFFICULTY_MAX.get(difficulty, 9.0)


# -- Localization helper -------------------------------------------------------

## Returns translated string for the current language. Falls back to FR.
func loc(key: String) -> String:
	var lang: String = language if language != "" else "fr"
	var dict: Dictionary = TRANSLATIONS.get(lang, TRANSLATIONS["fr"])
	if dict.has(key):
		return String(dict[key])
	# Fallback to French
	var fr_dict: Dictionary = TRANSLATIONS["fr"]
	return String(fr_dict.get(key, key))


## Returns difficulty label translated for current language.
func difficulty_label() -> String:
	match difficulty:
		Difficulty.EASY:
			return loc("diff_easy")
		Difficulty.NORMAL:
			return loc("diff_normal")
		Difficulty.HARD:
			return loc("diff_hard")
	return loc("diff_normal")


# -- Achievements --------------------------------------------------------------

const ACHIEVEMENTS: Array[Dictionary] = [
	{"id": "first_game", "title_key": "ach_first_game", "desc_key": "ach_first_game_desc", "check": "games_played >= 1"},
	{"id": "combo_25", "title_key": "ach_combo_25", "desc_key": "ach_combo_25_desc", "check": "best_combo >= 25"},
	{"id": "combo_50", "title_key": "ach_combo_50", "desc_key": "ach_combo_50_desc", "check": "best_combo >= 50"},
	{"id": "boss_1", "title_key": "ach_boss_1", "desc_key": "ach_boss_1_desc", "check": "bosses_defeated >= 1"},
	{"id": "boss_10", "title_key": "ach_boss_10", "desc_key": "ach_boss_10_desc", "check": "bosses_defeated >= 10"},
	{"id": "score_5000", "title_key": "ach_score_5000", "desc_key": "ach_score_5000_desc", "check": "best_score >= 5000"},
	{"id": "score_10000", "title_key": "ach_score_10000", "desc_key": "ach_score_10000_desc", "check": "best_score >= 10000"},
	{"id": "sets_50", "title_key": "ach_sets_50", "desc_key": "ach_sets_50_desc", "check": "owned_count >= 50"},
	{"id": "crystals_1000", "title_key": "ach_crystals_1000", "desc_key": "ach_crystals_1000_desc", "check": "total_crystals_earned >= 1000"},
]

## Check which achievements are unlocked based on Shop stats.
## Returns array of dictionaries {"id", "title", "desc", "unlocked"}.
func check_achievements() -> Array[Dictionary]:
	var results: Array[Dictionary] = []
	for ach in ACHIEVEMENTS:
		var unlocked: bool = _eval_achievement(ach.get("check", ""))
		results.append({
			"id": ach.id,
			"title": loc(ach.title_key),
			"desc": loc(ach.desc_key),
			"unlocked": unlocked,
		})
	return results


func _eval_achievement(expr: String) -> bool:
	# Simple expression evaluator for achievement checks.
	# Supports: variable >= value, variable == value
	var parts: PackedStringArray = expr.split(" ")
	if parts.size() != 3:
		return false
	var var_name: String = parts[0]
	var op: String = parts[1]
	var val: int = int(parts[2])
	var actual: int = 0
	match var_name:
		"games_played": actual = Shop.games_played
		"best_combo": actual = Shop.best_combo
		"bosses_defeated": actual = Shop.bosses_defeated
		"best_score": actual = Shop.best_score
		"owned_count": actual = Shop.owned_count()
		"total_crystals_earned": actual = Shop.total_crystals_earned
		_: return false
	match op:
		">=": return actual >= val
		"==": return actual == val
		">": return actual > val
		_: return false
