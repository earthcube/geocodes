# Manual Loading with `screen`

If a source has many URLs/records, it suggest that one runs the 
`glcon` \ `gleaner` command in a `screen`


## start a screen
Since this is a long running process, it is suggested that this be done in `screen`
There is also a possibility of using [tmux](https://www.howtogeek.com/671422/how-to-use-tmux-on-linux-and-why-its-better-than-screen/), if a user has experience with it.

But someonee else needs to write that up.

### Notes:
To create a 'named' screen named gleaner

`screen -S gleaner`

to detach from screen, use: `ctl-a-d`

to find running screens: `screen -ls`

```shell 
There are screens on:
	7187.gleaner	(07/28/22 17:43:48)	(Detached)
	6879.pts-3.geocodes-dev	(07/28/22 17:33:25)	(Detached)
2 Sockets in /run/screen/S-ubuntu.
```

to attach to a screen  in this case you use the name

`screen -r gleaner `

or

` screen -r pts-3 `


```shell
screen -S gleaner
ubuntu@geocodes-dev:~/indexing$ screen -ls
There is a screen on:
	7187.gleaner	(07/28/22 17:43:48)   (Attached)
1 Socket in /run/screen/S-ubuntu.
```
