fx_version 'adamant'

game 'gta5'

ui_page('html/index.html')

files {
    'html/utils/*.png',
    'html/js/index.js',
    'html/css/style.css',
    'html/index.html',
}

client_scripts {
	--'@es_extended/locale.lua',
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",

    "src/components/*.lua",

    "src/menu/elements/*.lua",

    "src/menu/items/*.lua",

    "src/menu/panels/*.lua",

    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",

	'config.lua',
	'client/game.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	--'@es_extended/locale.lua',
	'config.lua',
	'server/server.lua'
}