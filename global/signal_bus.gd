extends Node


signal interaction_started()
signal interacting()
signal interaction_stopped()
signal interaction_complete()
signal add_to_inventory(item)
signal weapon_action(muzzle)
signal weapon_swapping()
signal weapon_swapping_end()

signal level_change(destination)

signal open_secret()
signal secret_entered()

signal options_menu()
signal about_menu()

signal player_ready()

signal update_stat_display()

signal prep_ui()
signal bye_ui()

signal idied(dead_spot)
