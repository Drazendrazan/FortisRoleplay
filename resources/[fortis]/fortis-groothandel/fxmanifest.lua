-- Resource Metadata
fx_version "cerulean"
games { "gta5" }

author "Iris & Finn"
description "Fortis groothandel script door Iris & Finn"
version "1.0.0"

client_scripts {
    "config.lua",
    "client/client.lua"
}

server_scripts {
    "config.lua",
    "server/server.lua"
}

files {
    "html/*.html",
    "html/assets/css/*.css",
    "html/assets/images/*.*",
    "html/assets/images/icons/*.*",
    "html/assets/images/voertuigen/*.*",
    "html/assets/scripts/*.*",

    "stream/shellpropsv3.ytyp",
	"stream/shellpropsv4.ytyp",
	"stream/shellpropv2s.ytyp",
	"stream/shellpropsv5.ytyp",
	"stream/shellprops.ytyp"
}

ui_page "html/index.html"


data_file 'DLC_ITYP_REQUEST' 'shellprops.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv5.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv2.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv4.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv3.ytyp'