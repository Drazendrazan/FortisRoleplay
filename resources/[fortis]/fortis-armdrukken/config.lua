globalConfig = {

  language = 'en', --change with 'en' for english, 'fr' for french, 'cz' for czech, 'de' for german




      --Set up new line to add a table, xyz are the coordinate, model is the props used as table. The 3 tables for armwrestling are 

                                                    -- 'prop_arm_wrestle_01' --
                                              -- 'bkr_prop_clubhouse_arm_wrestle_01a' --
                                              -- 'bkr_prop_clubhouse_arm_wrestle_02a' --

  props = { 
    {x = 753.92, y = -767.92, z = 26.33, model = 'prop_arm_wrestle_01'},
    {x = 343.92, y = -924.92, z = 29.33, model = 'prop_arm_wrestle_01'},
    {x = 328.74, y = -909.20, z = 29.33, model = 'prop_arm_wrestle_01'},
    {x = 0, y =0, z = 0, model = 'bkr_prop_clubhouse_arm_wrestle_01a'},
    {x = 0, y = 0, z = 0, model = 'bkr_prop_clubhouse_arm_wrestle_02a'},
  },

  showBlipOnMap = false, -- Set to true to show blip for each table

  blip = { --Blip info

    title="Arm wrestle",  
    colour=0, -- 
    id=1 

  }

}

text = {  
  ['en'] = {
    ['win'] = "Je hebt gewonnen !",
    ['lose'] = "Je hebt verloren!",
    ['full'] = "Er is al een wedstrijd bezig!",
    ['tuto'] = "Om te winnen druk snel ",
    ['wait'] = "Wachten op een tegenstander",
  },
  ['fr'] = {
    ['win'] = "Vous avez gagné !",
    ['lose'] = "Vous avez perdu",
    ['full'] = "Un bras de fer est déjà en cours",
    ['tuto'] = "Pour gagner, appuyez rapidement sur ",
    ['wait'] = "En attente d'un adversaire",
  },
  ['cz'] = {
    ['win'] = "Vyhrál jsi !",
    ['lose'] = "Prohrál jsi",
    ['full'] = "Zápasový zápas již probíhá",
    ['tuto'] = "Chcete-li vyhrát, rychle stiskněte ",
    ['wait'] = "Čekání na protivníka",
  },
  ['de'] = {
    ['win'] = "Du hast gewinnen !",
    ['lose'] = "Du hast verloren",
    ['full'] = "Ein Wrestling Match ist bereits im Gange",
    ['tuto'] = "Um zu gewinnen, drücken Sie schnell ",
    ['wait'] = "Warten auf einen Gegner",
  },

}