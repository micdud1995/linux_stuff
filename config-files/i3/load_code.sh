# Load the layout
# i3-msg 'workspace 0; append_layout /home/qeni/.i3/code.json'
i3-msg 'append_layout /home/qeni/.i3/code.json'

# # Swallow the programs into the containers
# xterm -fa 'Inconsolata' -fs 11 -name vim -e 'vim' &
# # xterm -name code &
# # sleep 1
# # xterm -name mc -e 'mc' &
# xterm -fa 'Inconsolata' -fs 11 -name mc -e 'mc' &
# # sleep 1
# xterm -fa 'Inconsolata' -fs 11 -name term &

# Swallow the programs into the containers
xterm -fa 'Terminus' -fs 9 -name vim -e 'vim' &
# xterm -name code &
# sleep 1
# xterm -name mc -e 'mc' &
xterm -fa 'Terminus' -fs 9 -name mc -e 'mc' &
# sleep 1
xterm -fa 'Terminus' -fs 9 -name term &
