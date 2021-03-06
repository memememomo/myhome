# GNU screen title
function _set_screen_tabline() {
    if test "$TERM" != "screen"; then
        return
    fi

    emulate -L zsh
    local -a cmd; cmd=(${(z)2})
    case $cmd[1] in
        fg)
            if (($#cmd == 1)); then
                cmd=(builtin jobs -l %+)
            else
                cmd=(builtin jobs -l $cmd[2])
            fi
            ;;
        %*) 
            cmd=(builtin jobs -l $cmd[1])
            ;;
        (gnu|g|)ls|gvim(.sh|))
            return
            ;; 
        cd)
            if (($#cmd == 2)); then
                cmd[1]=$cmd[2]:t
            else
                cmd[1]="~"
            fi
            _change_hardstatus $cmd[1]
            return
            ;;
        vi(m|))
            if (($#cmd == 2)); then
                cmd[1]="v:$cmd[2]:t"
            fi
            _change_hardstatus $cmd[1]
            return
            ;;
        *)
            _change_hardstatus $cmd[1]:t
            return
            ;;
    esac

    local -A jt; jt=(${(kv)jobtexts})

    $cmd >>(
        read num rest
        cmd=(${(z)${(e):-\$jt$num}})
        echo -n "k$cmd[1]:t\\"
    ) 2>/dev/null
}

function _change_hardstatus() {
    echo -n "k$1\\"
}

