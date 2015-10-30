# i3-msg 'workspace 5: IRC; append_layout /home/michal/.i3/workspace_5.json'
# (lxterminal -e weechat &)

# sleep 3

i3-msg "workspace 3: Code; append_layout /home/michal/.i3/workspace_3.json"
(lxterminal -e vim &)

sleep 3

i3-msg "workspace 1: Desktop; append_layout /home/michal/.i3/workspace_1.json"
(xterm -e htop -C &)
(xterm -e "sh -c 'export TERM="screen-256color" && ranger'" &)
(xterm -e mocp &)
(xterm &)
# (lxterminal -e mocp &)
# (lxterminal -e htop &)
# (lxterminal -e "sh -c 'export TERM="screen-256color" && ranger'" &)
# (lxterminal -e &)
