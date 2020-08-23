# `softwareabstractions`: Notes + Code for "Software Abstractions: Logic, Language, and Analysis", by Daniel Jackson et. al.

## Running X11 GUIs within Docker

Alloy 4.x runs primarily through a Java GUI and the book examples reference the
GUI throughout. Therefore, it is extremely important to ensure X11 works through
Docker. I tried Vagrant (full VM orchestration for development purposes) but the
setup was far less mature and parts of the toolchain are closed-source (e.g.
`vagrant-share`).

1.  Make sure that `xauth` is installed on the host machine. `xauth` is a tool
    in order to generate authentication cookies to establish trust between the
    guest and host machines for X11 forwarding. You can install `xauth` by
    running:

    ```bash
    sudo apt-get install xauth
    ```

2.  Make sure that the environment variable `$XAUTHORITY` is configured to point
    to filepath `${HOME}/.Xauthority`. This environment variable points to the
    specific `.Xauthority` file that later `xauth` commands will write to. Set
    variable by running:

    ```bash
    export XAUTHORITY=${HOME}/.Xauthority
    ```

    The current repository setup references `${HOME}/.Xauthority` as a hardcoded
    path, so make sure that the user used on the host machine is the same user
    that runs the `make` commands that call `docker run` so that `${HOME}`
    points to the same directory.

    If there are issues with file permissions with `${HOME}/.Xauthority`, run on
    the host machine:

    ```bash
    setfacl -m user:1000:r ${HOME}/.Xauthority
    ```

3.  Generate the `xauth` cookies and write them to `${HOME}/.Xauthority`:

    ```bash
    xauth generate ${DISPLAY} . trusted

    xauth add ${HOST}${DISPLAY} . $(xxd -l 16 -p /dev/urandom)
    ```

    Where ${DISPLAY} should be `:0` or `:1` or something like that.

    Taken from [this Stack Overflow answer](https://superuser.com/a/941244).

4.  Configure `xhost` permissions in order to enable sharing to local root
    users:

    ```bash
    xhost local:root
    ```

    Taken from [this Stack Overflow
    answer](https://stackoverflow.com/a/34586732/1497211).

5.  Within the Docker container, run:

    ```bash
    export DISPLAY=unix:1
    ```

    If $DISPLAY is not configured properly already.

Now, you should be able to run `make docker-alloy` and have the GUI stand up
properly.
