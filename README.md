# Eventbot

eventbot is an XMPP bot for generating and interacting with event streams.

## Concepts

### Runlets

`runlets` are a simple command language for generating, filtering and
performing flow control on a stream of events:

    <source> | <filter> | <sink>

Commands are chained together using the pipe operator (`|`).

A `source` command generates an event stream, usually by connecting to
an external service. A `source` typically will not terminate.

`filters` perform operations on the stream of events. Examples of filters
are selecting events or controlling the rate of events. For example,
the flow control filter discards events based on the rate. Zero or more
filters can be chained together.

A `sink` outputs the event stream. The default sink displays the results
of a stream in the channel where the request was made. Support for other
sinks is experimental.

### Processes

Each `runlet` runs in an isolated process. A job control language is
used to interact with the runlet.

## Installing a Release

  1. Download the release for your platform.

  2. Extract the tarball to /usr/local/lib/eventbot:

>      mkdir -p /usr/local/lib/eventbot
>      cd /usr/local/lib/eventbot
>      tar zxf /path/to/eventbot.tar.gz

  3. Create the eventbot user:

>      useradd -r -c "event bot pseudo-user" -s /bin/false eventbot

  4. Create the chroot and state directories.

    By default, the directories will be created and symlink'ed
    under /usr/local/lib/eventbot so state is not lost if eventbot is
    re-installed. The directories can be manually created if you want
    to put them somewhere else.

    It is safe to re-run the postinstall script.

>      cd /usr/local/lib/eventbot
>      lib/eventbot-0.1.0/priv/bin/postinstall

  5. command line: run the bot.

    The bot is configured using environment variables. See `Configuration`
    for details.

    The bot will run as a daemon and be restarted on exit. See `Booting`
    for other options.

>      sudo -u eventbot \
>        EVENTBOT_USERNAME="botname" \
>        EVENTBOT_PASSWORD="botpassword" \
>        EVENTBOT_JID="botname@example.com" \
>        EVENTBOT_ALIAS="^" \
>        EVENTBOT_ROOMS="test@conference.example.com:alert@conference.example.com" \
>        /usr/local/lib/eventbot/bin/eventbot start

  6. systemd: run the bot as a systemd service.

     Copy the systemd service file (`priv/bin/eventbot.service`) to
     `/etc/systemd/system/eventbot.service`.

>       cp priv/bin/eventbot.service /etc/systemd/system/eventbot.service

     Copy the example environment file and edit:

>       mkdir /etc/eventbot
>       cp priv/bin/eventbot.env /etc/eventbot
>       chown root:root /etc/eventbot/eventbot.env
>       chmod 640 /etc/eventbot/eventbot.env
>       vi /etc/eventbot/eventbot.env

     Enable the service:

>       systemctl daemon-reload
>       systemctl start eventbot
>       systemctl status eventbot

  7. Stopping the bot.

>      systemctl stop eventbot

## Configuration

EVENTBOT_USERNAME
: bot displayed name

EVENTBOT_PASSWORD
: bot XMPP password

EVENTBOT_JID
: fully qualified XMPP username

EVENTBOT_ALIAS
: The bot can be reference either by the name (EVENTBOT_USERNAME) or by a
  short form alias. For example, if the name of the bot is "foo" and the
  short form is "^", the following are equivalent:

        foo: runtime
        ^runtime

EVENTBOT_ROOMS
: A list of ":"-separated conference rooms (MUCs):

        muc1@conference.example.com
        muc1@conference.example.com:muc2@conference.example.com:muc3.conference.example.com

  Default: no conference rooms

EVENTBOT_RIEMANN_HOST
: IP address/hostname of Riemann service

  Default: localhost

EVENTBOT_RIEMANN_PORT
: Port of riemann HTML5 SSE web service

  Default: 8080

EVENTBOT_TLS_SNI
: Hostname in TLS certificate of XMPP server.

  Default: none (Mandatory: must be set)

EVENTBOT_RIEMANN_URL
: Query URL for Riemann

  Default: /event/index?query=

EVENTBOT_PRX_ROOTDIR
: chroot directory for containerized Unix processes

  Default: priv/root

EVENTBOT_PRX_EXEC
: Command to grant eventbot privileges to create a container. By default,
  eventbot uses a setuid binary. To use `sudo`:

        visudo -f /etc/sudoers.d/99_eventbot
        eventbot ALL = NOPASSWD: /usr/local/lib/eventbot/lib/prx-0.1.0/priv/prx
        EVENTBOT_PRX_EXEC="sudo -n"

  Default: ""

## Installation

  1. Add `eventbot` to your list of dependencies in `mix.exs`:

>      def deps do
>        [{:eventbot, github: "msantos/eventbot"}]
>      end

  2. Ensure `eventbot` is started before your application:

>      def application do
>        [applications: [:eventbot]]
>      end

## Building a Release

  1. Install dependencies:

     sudo apt install build-essential automake autoconf git
     sudo apt install libssl-dev libncurses5-dev libexpat1-dev

  2. Install the [asdf](https://github.com/asdf-vm/asdf) language
     runtime manager

     See: https://asdf-vm.com/#/core-manage-asdf-vm

     git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.3
     echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.profile
     echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.profile
     . ~/.profile

  3. Install the `erlang` compiler and runtime

    asdf list-all erlang
    asdf install erlang <version>
    asdf global erlang <version>

  4. Install the `elixir` compiler and runtime

    asdf list-all elixir
    asdf install elixir <version>
    asdf global elixir <version>


  5. Clone the eventbot repository:

    ```
    git clone https://github.com/msantos/eventbot.git
    ```

  6. Build the release:

    ```
    # development
    mix do deps.get, deps.compile, release

    # prod
    MIX_ENV=prod mix do deps.get, deps.compile, release
    ```

  7. Create the tarball:

    ```
    #!/bin/bash

    set -o errexit
    set -o nounset
    set -o pipefail

    VERSION=$(grep "version:" mix.exs | grep -E -o "[0-9]+.[0-9]+.[0-9]+")
    RELEASE=${RELEASE-_build/prod/rel/eventbot/}
    ARCHIVE="eventbot-$VERSION+$(uname -m).tar.gz"

    echo "Creating release archive"

    (cd "$RELEASE" && tar zcvf - .) > "$ARCHIVE"
    ```
