from time import time, sleep
import os
from colorama import init, Fore, Back, Style
from datetime import datetime

init(convert=True)


while True:
    vandaag = datetime.now()
    datum = vandaag.strftime("%d-%m-%Y - %H:%M")
    print(Back.YELLOW + Fore.BLACK + "\n\n\n==========[ Start van sync: "+ datum +" ]==========\n")
    print(Style.RESET_ALL)
    os.system('cmd /c "git fetch --all"')
    os.system('cmd /c "git pull"')
    vandaag = datetime.now()
    datum = vandaag.strftime("%d-%m-%Y - %H:%M")
    print(Back.YELLOW + Fore.BLACK + "\nGithub Sync voltooid op "+ datum)
    sleep(3600 - time() % 60)