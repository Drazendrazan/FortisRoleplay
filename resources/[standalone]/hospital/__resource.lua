resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description 'Hospital'

ui_page "html/index.html"

client_scripts {
	'config.lua',
	'client/main.lua',
	'client/wounding.lua',
	'client/job.lua',
	'client/dead.lua',
	'client/gui.lua',
}

server_scripts {
	'config.lua',
	'server/main.lua',
}

data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxies.meta'

files {

'interiorproxies.meta'
}
 
exports {
    'getinjuredtable'
} 

files {
    'html/*',
    'html/img/*',
}

client_script '@zb-guard/03923.lua'