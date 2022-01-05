--[[
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
─██████──────────██████─████████████████──────██████████████───██████─────────██████──██████─██████████████─██████████████─██████████████████─
─██░░██████████████░░██─██░░░░░░░░░░░░██──────██░░░░░░░░░░██───██░░██─────────██░░██──██░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░░░░░██─
─██░░░░░░░░░░░░░░░░░░██─██░░████████░░██──────██░░██████░░██───██░░██─────────██░░██──██░░██─██░░██████████─██░░██████████─████████████░░░░██─
─██░░██████░░██████░░██─██░░██────██░░██──────██░░██──██░░██───██░░██─────────██░░██──██░░██─██░░██─────────██░░██─────────────────████░░████─
─██░░██──██░░██──██░░██─██░░████████░░██──────██░░██████░░████─██░░██─────────██░░██──██░░██─██░░██████████─██░░██████████───────████░░████───
─██░░██──██░░██──██░░██─██░░░░░░░░░░░░██──────██░░░░░░░░░░░░██─██░░██─────────██░░██──██░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─────████░░████─────
─██░░██──██████──██░░██─██░░██████░░████──────██░░████████░░██─██░░██─────────██░░██──██░░██─██░░██████████─██░░██████████───████░░████───────
─██░░██──────────██░░██─██░░██──██░░██────────██░░██────██░░██─██░░██─────────██░░██──██░░██─██░░██─────────██░░██─────────████░░████─────────
─██░░██──────────██░░██─██░░██──██░░██████────██░░████████░░██─██░░██████████─██░░██████░░██─██░░██─────────██░░██─────────██░░░░████████████─
─██░░██──────────██░░██─██░░██──██░░░░░░██────██░░░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░██─────────██░░██─────────██░░░░░░░░░░░░░░██─
─██████──────────██████─██████──██████████────████████████████─██████████████─██████████████─██████─────────██████─────────██████████████████─
────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── 
]] 

-- ####################################################################################
-- #                                   DISCORD:                                       #
-- #                          https://discord.gg/QPPSBncbZn                           #
-- ####################################################################################

fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'Mr Bluffz'
description 'Simple Money Wash re-write'
version '1.0.0'

client_scripts {'Config.lua', '@es_extended/locale.lua', 'Locales/*.lua', 'Client/*.lua'}

server_scripts {'Config.lua', '@es_extended/locale.lua', 'Locales/*.lua', 'Server/*.lua'}

escrow_ignore {'Client/Client.lua', 'Server/Server_Open.lua', 'Locales/*.lua', 'Config.lua', 'WashKeyItem_SQL.sql', 'Readme.md', 'fxmanifest.lua'}

dependencies {'es_extended', 'rprogress', 'fivem-target'}