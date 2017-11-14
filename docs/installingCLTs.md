# Installing Your Command Line Tool
Now that you've built your Command Line Tool, it's time to install it so that you can execute it while in any directory in a Terminal shell.

First, we'll need to build a binary of your Command Line Tool using `swift build`. Execute the following command in your project directory:

``` shell
$ swift build -c release -Xswiftc -static-stdlib
```

Lastly, we need to copy a version of your compiled tool into your `.../bin/` directory. Here we will put the tool in your local user bin, but this can be put in a UNIX bin directory of your choosing.

``` shell
$ cd .build/release
$ cp -f YourCommandLineTool /usr/local/bin/yourcommandlinetool
```
