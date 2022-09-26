client_scripts {
    "client/client.lua",
    "config.lua",
}

server_scripts {
    "server/server.lua",
    "config.lua",
}

files {
    "html/*.html",
    "html/js/*.js",
    "html/css/*.css",
    "html/images/versie1/*.png",
    "html/images/versie2/*.png",
    "html/images/verpakken/*.png",
    "html/*.mp3",
    "stream/int3232302352.gfx",
}

data_file "SCALEFORM_DLC_FILE" "stream/int3232302352.gfx"

ui_page {
    "html/index.html"
}
client_script '@fortis-guard/03923.lua'