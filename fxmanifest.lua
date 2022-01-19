--[[----------------------------------
Creation Date:	16/06/2021
]]------------------------------------
fx_version 'cerulean'
game 'gta5'
author 'Leah#0001'
version '1.0.0'
-- versioncheck 'https://raw.githubusercontent.com/Leah-UK/FiveM-Script-Versioning/main/bixbi_collect.lua'

shared_scripts {
	'@es_extended/imports.lua',
	'config.lua'
}

client_scripts {
	'client.lua'
}

server_scripts {
	'server/server.lua',
	'server/sv_config.lua'
}

dependencies {
	'bixbi_core'
}