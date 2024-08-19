#!/bin/bash

TODO_FILE="$HOME/todolist.txt"
IMG_PATH="/usr/local/bin/img.png"
ALARM_PATH="/usr/local/bin/alarm.mp3"

if [[ ! -f $TODO_FILE ]]; then
    touch "$TODO_FILE"
    echo "created new to-do list file at $TODO_FILE"
fi

function clear_screen {
    clear
    echo -e "\033[1;35m==============================\033[0m"
    echo -e "\033[1;35m         pomo.sh - 集中        \033[0m"
    echo -e "\033[1;35m==============================\033[0m"
}

function display_image {
    echo "$IMG_PATH"
    convert "$IMG_PATH" -resize 80x45 - | chafa -
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
    mpg123 "$ALARM_PATH" &>/dev/null || echo "failed to play alarm"
}

function display_todo {
    echo -e "\n\033[1;34mto-do list:\033[0m"
    if [[ -f $TODO_FILE ]]; then
        if [[ -s $TODO_FILE ]]; then
            nl -w2 -s'. ' $TODO_FILE
        else
            echo -e "\033[1;31mno tasks found.\033[0m"
        fi
    else
        echo -e "\033[1;31mno tasks found.\033[0m"
    fi
}

function add_task {
    echo "$1" >> $TODO_FILE
    echo "debug: added task '$1' to $TODO_FILE"
}

function complete_task {
    local task_number=$1
    task=$(sed -n "${task_number}p" "$TODO_FILE")
    if [[ -n $task ]]; then
        sed -i "${task_number}d" "$TODO_FILE"
        echo -e "\033[1;32mtask completed: $task\033[0m"
    else
        echo -e "\033[1;31minvalid task number.\033[0m"
    fi
}

# main loop
while true; do
    clear_screen
    display_image
    display_todo
    echo -e "\033[1;33m"
    echo -e "Commands:"
    echo -e "  \033[1;32m:p\033[0m - start pomodoro"
    echo -e "  \033[1;32m:a <task>\033[0m - add task"
    echo -e "  \033[1;32m:c <task_number>\033[0m - complete task"
    echo -e "  \033[1;32m:e\033[0m - exit"
    echo -e "\033[0m"
    read -r user_input

    if [[ "$user_input" == ":p" ]]; then
        for cycle in {1..4}; do
            clear_screen
            display_image
            display_todo
            echo -e "\033[1;32mget to work u lousy bum [25 min]\033[0m"
            play_alarm
            display_timer 1500 32
            echo -e "\n\033[1;31mtake a break\033[0m"
            sleep 2

            clear_screen
            display_image
            display_todo
            echo -e "\033[1;32mbreak time [5 min]\033[0m"
            play_alarm
            display_timer 300 31
            play_alarm
            echo -e "\n\033[1;31mbreak's over. get back to work\033[0m"
            sleep 2
        done
    elif [[ "$user_input" == :a* ]]; then
        task="${user_input:3}"
        add_task "$task"
        echo -e "\033[1;32mTask added: $task\033[0m"
        sleep 2
    elif [[ "$user_input" == :c* ]]; then
        task_number=$(echo "${user_input:3}" | xargs)  # trim leading spaces
        if [[ $task_number =~ ^[0-9]+$ ]]; then
            total_tasks=$(wc -l < "$TODO_FILE")
            if [[ $task_number -gt 0 && $task_number -le $total_tasks ]]; then
                complete_task "$task_number"
            else
                echo -e "\033[1;31mtask number out of range.\033[0m"
                sleep 2
            fi
        else
            echo -e "\033[1;31mplease provide a valid task number.\033[0m"
            sleep 2
        fi
    elif [[ "$user_input" == ":e" ]]; then
        echo -e "\033[1;32mexiting the program. cyaaa!\033[0m"
        break
    else
        echo -e "\033[1;31minvalid input. please type ':p' for pomodoro, ':a <task>' to add a task, ':c <task_number>' to complete a task, or ':e' to exit.\033[0m"
        sleep 2
    fi
done
