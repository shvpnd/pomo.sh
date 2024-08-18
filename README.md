## pomo.sh - 集中 

<img src="./assets/bgs.jpg" width="720px">

a pomodoro timer in bash. work in focused bursts followed by short breaks to boost productivity.

### features

- 25-minute work sessions followed by 5-minute breaks.
- repeats for up to 4 cycles.
- displays a countdown timer in the terminal.
- play alarm sound at the end of each session.

### usage

1. clone the repo:
```bash
$ git clone https://github.com/shvpnd/pomo.sh
$ cd pomo.sh
$ ./pomo.sh
```
2. customization:
- you can replace the `alarm.mp3` file with your own version. 
- similary u can change the image (make sure u match the image ratio with the bash script - see line 10)
```bash
function display_image {
    convert img.png -resize 80x45 - | chafa -
} #here 80x45 for 16:9 img
```

### demo

behold, looks like this:

<img src="./assets/demo.png">