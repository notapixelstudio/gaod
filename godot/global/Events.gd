extends Node

signal card_picked(card)
signal card_dropped(card)
signal card_destroyed(card)
signal card_played(card)

signal mortal_turn_start()
signal mortal_about_to_move(steps)

signal preview_card_effect()

signal mortal_move_start()
signal mortal_moved()
signal mortal_turn_end()

signal new_cards_obtained(new_cards)
signal leveled_up()

signal game_over()

signal draw_effect_activated()
signal tile_activated(tile)
