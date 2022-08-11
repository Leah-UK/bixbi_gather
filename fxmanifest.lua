--[[----------------------------------
Creation Date:	16/06/2021
]]------------------------------------
fx_version 'cerulean'
game 'gta5'
author 'leah_uk'
version '1.1.2'
versioncheck 'https://raw.githubusercontent.com/Leah-UK/bixbi_gather/main/fxmanifest.lua'
lua54 'yes'

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
