-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
require("menu")
require("screens")
require("awful.autofocus")
-- local revelation = require("revelation")


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/raf/.config/awesome/themes/solarized/dark/theme.lua")
-- revelation.init()

-- This is used later as the default terminal and editor to run.
terminal = "urxvtr"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,        --  1
    awful.layout.suit.tile,            --  2
    awful.layout.suit.tile.top,        --  3
    awful.layout.suit.tile.left,       --  4
    awful.layout.suit.tile.bottom,     --  5
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define tags table.
tags_names  = {"scr","cod","file","web","gra","doc","med","tor"}
tag_keys = {"u","i","o","p","7","8","9","0"}

-- Copy tags_names array key-value pair to tag_bindings array as value-key, so we only have to specify 
-- tag names once and we can use it to call the tag number without a lookup function.
tag_bindings = {}
for k,v in pairs(tags_names) do
     tag_bindings[v] = k
end

tags_layout = {
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.bottom, 
        awful.layout.suit.tile.bottom, 
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.bottom 
} 
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags_names, s, layouts[5])
end
-- }}}


-- {{{ Menu
-- Create a laucher widget and a main menu

mymainmenu = awful.menu({ items = { { "applications", xdgmenu },
                                    { "open terminal", terminal },
                                    { "manual", terminal .. " -e man awesome" },
                                    { "edit config", editor_cmd .. " " .. awesome.conffile },
                                    { "restart", awesome.restart },
                                    { "quit", awesome.quit }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}


-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    --left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({                   }, "XF86Display", xrandr),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey,           }, "Left", awful.tag.viewprev  ),
    awful.key({ modkey,           }, "Right", awful.tag.viewnext  ),
--    TODO: get current tag, or movetonexttag function. How??
--    awful.key({ modkey, "Shift"   }, "Left", 
--                  function ()
--                      local screen = mouse.screen
--                      if client.focus and tags[client.focus.screen][i] then
--                          awful.client.movetotag(tags[client.focus.screen][i])
--                          awful.tag.viewnext()
--                      end
--                  end),
--    awful.key({ modkey, "Shift"   }, "Right",
--                  function ()
--                      local screen = mouse.screen
--                      if client.focus and tags[client.focus.screen][i] then
--                          awful.client.movetotag(tags[client.focus.screen][i])
--                          awful.tag.viewnext()
--                      end
--                  end),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    ---------------------------
    --Right hand custom commands
    ---------------------------
    
    --tag programs
    awful.key({ modkey, "Mod1"   	  }, tag_keys[tag_bindings['file']], function () awful.util.spawn('pcmanfm') end),
    awful.key({ modkey, "Mod1", "Control" }, tag_keys[tag_bindings['file']], function () awful.util.spawn_with_shell('urxvtr -e sudo pcmanfm') end),
    awful.key({ modkey, "Mod1"   	  }, tag_keys[tag_bindings['web']], function () awful.util.spawn('google-chrome-stable') end),
    awful.key({ modkey, "Mod1"   	  }, tag_keys[tag_bindings['gra']], function () awful.util.spawn('geeqie') end),
    awful.key({ modkey, "Mod1"   	  }, tag_keys[tag_bindings['doc']], function () awful.util.spawn('libreoffice --writer') end),
    awful.key({ modkey, "Mod1", "Control" }, tag_keys[tag_bindings['doc']], function () awful.util.spawn('libreoffice --calc') end),
    awful.key({ modkey, "Mod1"   	  }, tag_keys[tag_bindings['med']], function () awful.util.spawn('vlc') end),
    awful.key({ modkey, "Mod1"   	  }, tag_keys[tag_bindings['tor']], function () awful.util.spawn('transmission-gtk') end),
    awful.key({ modkey, "Mod1", "Control"  }, tag_keys[tag_bindings['tor']], function () awful.util.spawn('skype') end),
    --other programs
    awful.key({ modkey, "Mod1"   }, "-", function () awful.util.spawn('gcolor2') end),
    awful.key({ modkey, "Mod1"   }, "=", function () awful.util.spawn('gnome-calculator') end),
    --ncurses apps and shell script
    awful.key({ modkey, "Mod1",  }, "h", function () awful.util.spawn_with_shell('urxvtr -hold -e cal -3') end),
    awful.key({ modkey, "Mod1"   }, "j", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Mod1"   }, "k", function () awful.util.spawn_with_shell('urxvtr -title vim -e vim') end),
    awful.key({ modkey, "Mod1", "Control",   }, "k", function () awful.util.spawn_with_shell('urxvtr -title sudo_vim -e sudo vim') end),
    awful.key({ modkey, "Mod1",  }, "l", function () awful.util.spawn_with_shell('urxvtr -title ranger -e vranger') end),
    awful.key({ modkey, "Mod1", "Control" }, "l", function () awful.util.spawn_with_shell('urxvtr -title sudo_ranger -e sudo vranger') end),
    awful.key({ modkey, "Mod1",  }, ";", function () awful.util.spawn_with_shell('wicd-gtk -n') end),
    awful.key({ modkey, "Mod1",  }, "'", function () awful.util.spawn_with_shell('urxvtr -e htop') end),
    --config
    awful.key({ modkey, "Mod1"   }, "n", function () awful.util.spawn_with_shell('urxvtr -e vim ~/.config/awesome/rc.lua') end),
    awful.key({ modkey, "Mod1"   }, "m", function () awful.util.spawn_with_shell('urxvtr -e vim ~/.bashrc') end),
    awful.key({ modkey, "Mod1"   }, ",", function () awful.util.spawn_with_shell('urxvtr -e vim ~/.vim_runtime/my_configs.vim') end),
    awful.key({ modkey, "Mod1"   }, ".", function () awful.util.spawn_with_shell('urxvtr -e vim ~/.config/ranger/rc.conf') end),
    awful.key({ modkey, "Mod1"   }, "/", function () awful.util.spawn_with_shell('urxvtr -e vim ~/.Xdefaults') end),
    --lampp and solr
    awful.key({ modkey, "Mod1"   }, "[", function () awful.util.spawn_with_shell('urxvtr -title bitnami -e sudo /opt/bitnami/ctlscript.sh restart') end),
    awful.key({ modkey, "Mod1"   }, "]", function () awful.util.spawn_with_shell('drush cc all --root=/opt/bitnami/apps/drupal/htdocs/') end),
    awful.key({ modkey, "Mod1"   }, "\\", function () awful.util.spawn_with_shell('urxvtr -e xrandr --output VGA --mode 1280x1024 --right-of LVDS') end),
--    awful.key({ modkey, "Mod1"   },j"]", function () awful.util.spawn_with_shell('urxvtr -e /home/raf/bin/solr') end),

        
    ---------------------------
    --Left hand custom commands
    ---------------------------
   
    --drush commands
    -- Prompt
    awful.key({ modkey },           "r",     function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey, "Mod1"   }, "s", function () awful.util.spawn_with_shell('urxvtr -title bitnami -e ssh "bitnami@ec2-54-235-161-194.compute-1.amazonaws.com"') end),
    awful.key({ modkey, "Mod1"   }, "d", function () awful.util.spawn_with_shell('urxvtr -cd /opt/bitnami/apps/drupal/htdocs') end), 
    awful.key({ modkey, "Mod1"   }, "x", function () awful.util.spawn_with_shell('xdg_menu --format awesome  >>~/.config/awesome/menu.lua') end), 
    --drupal links
--    awful.key({ modkey, "Mod1"   }, "a", function () awful.util.spawn_with_shell('chromium example.dev') end),
--    awful.key({ modkey, "Mod1"   }, "s", function () awful.util.spawn_with_shell('chromium example.dev/import/import_xls') end),
--    awful.key({ modkey, "Mod1"   }, "f", function () awful.util.spawn_with_shell('chromium example.dev/node/add/plant') end),
--    awful.key({ modkey, "Mod1"   }, "d", function () awful.util.spawn_with_shell('chromium example.dev/user/1/edit-plants') end),
--    awful.key({ modkey, "Mod1"   }, "g", function () awful.util.spawn_with_shell('chromium example.dev/user/1') end),
--    awful.key({ modkey, "Mod1"   }, "z", function () awful.util.spawn_with_shell('chromium localhost/phpmyadmin') end),
--    awful.key({ modkey, "Mod1"   }, "x", function () awful.util.spawn_with_shell('chromium example.dev/admin/structure/views') end),
--    awful.key({ modkey, "Mod1"   }, "c", function () awful.util.spawn_with_shell('chromium example.dev/admin/modules') end),
--    awful.key({ modkey, "Mod1"   }, "v", function () awful.util.spawn_with_shell('chromium example.dev/admin/config/search/search_api/') end),

    --web links
--    awful.key({ modkey, "Mod1"   }, "q", function () awful.util.spawn_with_shell('google-chrome www.gmail.com') end),
--    awful.key({ modkey, "Mod1"   }, "w", function () awful.util.spawn_with_shell('google-chrome www.facebook.com') end),
--    awful.key({ modkey, "Mod1"   }, "e", function () awful.util.spawn_with_shell('google-chrome www.google.com/reader') end),
--    awful.key({ modkey, "Mod1"   }, "r", function () awful.util.spawn_with_shell('google-chrome drive.google.com') end),
--
--    awful.key({ modkey, "Mod1"   }, "1", function () awful.util.spawn_with_shell("google-chrome 'http://weatherspark.com/#!graphs;a=Australia/VIC/Melbourne'") end),
--    awful.key({ modkey, "Mod1"   }, "2", function () awful.util.spawn_with_shell('google-chrome "www.bom.gov.au/vic/forecasts/melbourne.shtml"') end),
--    awful.key({ modkey, "Mod1"   }, "3", function () awful.util.spawn_with_shell('google-chrome magicseaweed.com/Victoria-Surf-Forecast/46/ ') end),
--
--    --drupal links
--    awful.key({ modkey, "Mod1"   }, "a", function () awful.util.spawn_with_shell('google-chrome example.dev') end),
--    awful.key({ modkey, "Mod1"   }, "s", function () awful.util.spawn_with_shell('google-chrome example.dev/import/import_xls') end),
--    awful.key({ modkey, "Mod1"   }, "f", function () awful.util.spawn_with_shell('google-chrome example.dev/node/add/plant') end),
--    awful.key({ modkey, "Mod1"   }, "d", function () awful.util.spawn_with_shell('google-chrome example.dev/user/1/edit-plants') end),
--    awful.key({ modkey, "Mod1"   }, "g", function () awful.util.spawn_with_shell('google-chrome example.dev/user/1') end),
--    awful.key({ modkey, "Mod1"   }, "z", function () awful.util.spawn_with_shell('google-chrome localhost/phpmyadmin') end),
--    awful.key({ modkey, "Mod1"   }, "x", function () awful.util.spawn_with_shell('google-chrome example.dev/admin/structure/views') end),
--    awful.key({ modkey, "Mod1"   }, "c", function () awful.util.spawn_with_shell('google-chrome example.dev/admin/modules') end),
--    awful.key({ modkey, "Mod1"   }, "v", function () awful.util.spawn_with_shell('google-chrome example.dev/admin/config/search/search_api/') end),
--   
    awful.key({ modkey, "Control" }, "r",     awesome.restart),
    awful.key({ modkey, "Shift"   }, "q",     awesome.quit),
    --tag navigation
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ modkey, "Control" }, "n", awful.client.restore)
)


clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.


for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, tag_keys[i],
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, tag_keys[i],
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, tag_keys[i],
                  function ()
                      local screen = mouse.screen
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                          awful.tag.viewonly(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, tag_keys[i],
                  function ()
                      local screen = mouse.screen
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                          awful.tag.viewonly(tags[screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     size_hints_honor = false,
                     keys = clientkeys,
                     buttons = clientbuttons } },
	--tag programs
     { rule = { class = "Google-chrome-stable" },
       properties = { tag = tags[1][tag_bindings['web']],switchtotag = true } },
     { rule = { class = "Pcmanfm" },
       properties = { tag = tags[1][tag_bindings['file']],switchtotag = true } },
     { rule = { class = "Thunar" },
       properties = { tag = tags[1][tag_bindings['file']],switchtotag = true } },
     { rule = { name = "Transmission" },
       properties = { tag = tags[1][tag_bindings['tor']],switchtotag = true } },
     { rule = { name = "Torrent Options" },
       properties = { tag = tags[1][tag_bindings['tor']],switchtotag = true } },
     { rule = { class = "Vlc" },
       properties = { tag = tags[1][tag_bindings['med']],switchtotag = true  } },
     { rule = { name = "LibreOffice" },
       properties = { tag = tags[1][tag_bindings['doc']],switchtotag = true } },
     { rule = { name = "Geeqie" },
       properties = { tag = tags[1][tag_bindings['gra']],switchtotag = true } },
	 --programs that borrow a tag
     { rule = { name = "NetBeans IDE 7.2.1" },
       properties = { tag = tags[1][tag_bindings['cod']],} },
     { rule = { name = "Starting NetBeans IDE" },
       properties = { tag = tags[1][tag_bindings['cod']],} },
     { rule = { class = "Deadbeef" },
       properties = { tag = tags[1][tag_bindings['med']],switchtotag = true } },
     { rule = { name = "GNU Image Manipulation Program" },
       properties = { tag = tags[1][tag_bindings['gra']],switchtotag = true } },
     { rule = { role = "gimp-toolbox" },
       properties = { floating = true, ontop = true}, },
     { rule = { role = "gimp-dock" },
       properties = { floating = true, ontop = true}, },
     { rule = { class = "Skype" },
       properties = { tag = tags[1][tag_bindings['tor']],switchtotag = true },
       callback = awful.client.setslave  },
     --programs that load on current tag
     { rule = { name = "File Operation Progress" },
       callback = awful.client.setslave  },
     { rule = { class = "URxvt" },
       callback = awful.client.setslave  },
     { rule = { instance = "Download" },
       properties = { floating = true }, },
     { rule = { instance = "GtkFileChooserDialog" },
       properties = { floating = true }, },       
     { rule = { name = "Find Files" },
       callback = awful.client.setslave  },
     --programs that load on every tag
     { rule = { instance = "avant-window-navigator" },
       properties = { border_width = 0 }, },       
     { rule = { instance = "weather.py" },
       properties = { border_width = 0 }, },
     { rule = { instance = "cairo-dock" },
--     type = "dock",
       properties = {
               floating = true,
               ontop = true, 
               focus = false } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    --c:connect_signal("mouse::enter", function(c)
    --    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    --        and awful.client.focus.filter(c) then
    --        client.focus = c
    --    end
    --end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- {{{ Startup Programs

-- Cut/copy history
awful.util.spawn_with_shell('/home/raf/bin/run-once clipit -n')
-- Touchpad monitor - disables when typing
--awful.util.spawn_with_shell('/home/raf/bin/run-once syndaemon -t -k -i 2 -d &')
-- Battery monitor
awful.util.spawn_with_shell('/home/raf/bin/run-once slimebattery')
-- Fix for virtualbox
awful.util.spawn_with_shell('/home/raf/bin/vboxmodprobes.sh')
