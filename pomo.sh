#!/bin/bash

function clear_screen {
    clear
    echo -e "\033[1;35m==============================\033[0m"
    echo -e "\033[1;35m         pomo.sh - 集中        \033[0m"
    echo -e "\033[1;35m==============================\033[0m"
}

function display_image {
    convert img.png -resize 80x45 - | chafa -
}

function display_timer {
    local total_seconds=$1
    local color=$2

    while [ $total_seconds -gt 0 ]; do
        minutes=$((total_seconds / 60))
        seconds=$((total_seconds % 60))

        # format time as mm:ss
        printf "\r\033[${color}m%02d:%02d\033[0m" $minutes $seconds
        sleep 1
        ((total_seconds--))
    done
}

function play_alarm {
    mpg123 alarm.mp3 &>/dev/null &
}

# main loop
while true; do
    clear_screen
    display_image
    echo -e "\033[1;33mtype ':p' to start the pomodoro timer...\033[0m"
    read -r user_input
    if [[ "$user_input" == ":p" ]]; then
        for cycle in {1..4}; do
            clear_screen
            display_image
            echo -e "\033[1;32mget to work u lousy bum (25 min)\033[0m"
            play_alarm
            display_timer 1500 32
            echo -e "\n\033[1;31mtake a break\033[0m"
            sleep 2

            clear_screen
            display_image
            echo -e "\033[1;32mbreak time (5 min)\033[0m"
            play_alarm
            display_timer 300 31
            play_alarm
            echo -e "\n\033[1;31mbreak's over. get back to work\033[0m"
            sleep 2
        done
    else
        echo -e "\033[1;31minvalid input. please type ':p' to start.\033[0m"
        sleep 2
    fi
done
