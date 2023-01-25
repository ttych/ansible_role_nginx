#!/bin/sh

NGINX=nginx
NGINX_CONF="{{ nginx_conf }}"
NGINX_WORK_DIR="{{ nginx_work_dir }}"
NGINX_PIDFILE="{{ nginx_pidfile }}"

start()
{
    start_fg &
}

start_fg()
{
    validate &&
        exec $NGINX -c "$NGINX_CONF" -p "$NGINX_WORK_DIR"
}

validate()
{
    $NGINX -c "$NGINX_CONF" -p "$NGINX_WORK_DIR" -t
}

stop()
{
    $NGINX -c "$NGINX_CONF" -p "$NGINX_WORK_DIR" -s stop
}

restart()
{
    stop &&
        sleep 1 &&
        start
}

reload()
{
    validate &&
        $NGINX -c "$NGINX_CONF" -p "$NGINX_WORK_DIR" -s reload
}

status()
{
    pgrep -F "$NGINX_PIDFILE" || retrun 1
}


run()
{
    case $1 in
        start|start_fg|stop|restart|reload|status|validate)
            action="$1"
            shift
            $action "$@"
            ;;
        *)
            echo >&2 "unsupported \"$1\" action"
            ;;
    esac
}


run "$@"
