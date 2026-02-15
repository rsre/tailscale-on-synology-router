#!/bin/sh

DAEMON="/usr/local/bin/tailscaled"
CLI="/usr/local/bin/tailscale"
PIDFILE="/var/run/tailscaled.pid"
LOGFILE="/var/log/tailscale.log"

start() {
    echo "Starting Tailscale..."

    # Start daemon
    $DAEMON --tun=userspace-networking > $LOGFILE 2>&1 &
    echo $! > $PIDFILE

    # Wait for daemon to initialize
    sleep 5

    # Bring interface up
    $CLI up --advertise-exit-node --advertise-routes=192.168.1.0/24 --reset >> $LOGFILE 2>&1
}

stop() {
    echo "Stopping Tailscale..."
    if [ -f "$PIDFILE" ]; then
        kill $(cat $PIDFILE)
        rm -f $PIDFILE
    fi
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        sleep 2
        start
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
        ;;
esac

exit 0
