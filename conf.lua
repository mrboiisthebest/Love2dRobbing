function love.conf(t)
    t.identity = "rapio_game_folder"       -- Name of the save directory
    t.version = "11.5"                  -- LÖVE version targeted for this game

    -- Window configuration
    t.window.title = "Rapio"     
    t.window.width = 1280               
    t.window.height = 720
    t.window.minwidth = 800
    t.window.minheight = 450
    t.window.fullscreen = false         
    t.window.vsync = 1                 -- Vertical sync (1 to enable, 0 to disable)
    t.window.resizable = true
    t.window.highdpi = true 
    t.window.usedpiscale = true

    t.console = true
end