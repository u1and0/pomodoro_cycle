#!/bin/bash

# ポモドーロタイマー設定（デフォルト値）
_POMO_WORK_TIME=25m
_POMO_BREAK_TIME=5m
_POMO_LONG_BREAK_TIME=15m
_POMO_ALERT_TIME=30
_POMO_SLEEP_TIME=2
_POMO_CYCLES=4
# カラー表示フラグ (0: false, 1: true)
_POMO_COLOR=0

# notify-sendが使えるか確認する関数
_notify() {
    if command -v notify-send &> /dev/null; then
        notify-send -u Warning "$1" "$2"
    else
        echo "$1: $2"
    fi
}

# 汎用的なポモドーロタイマー関数
_pomo_timer() {
    local notify_message="$1"
    local duration="$2"

    if [[ "$_POMO_COLOR" -eq 1 ]] && command -v lolcat &> /dev/null; then
      # カラー表示
      termdown -b -c $_POMO_ALERT_TIME -t "$notify_message" $duration | lolcat
    else
      termdown -b -c $_POMO_ALERT_TIME -t "$notify_message" $duration
    fi
    _notify "Pomodoro" "$notify_message"
}

pomodoro_cycle() {
    # オプション引数の処理
    while [[ $# -gt 0 ]]; do
        case $1 in
            --work|-w)
                _POMO_WORK_TIME="$2"
                shift 2
                ;;
            --short|-s)
                _POMO_BREAK_TIME="$2"
                shift 2
                ;;
            --long|-l)
                _POMO_LONG_BREAK_TIME="$2"
                shift 2
                ;;
            --cycles|-c)
                _POMO_CYCLES="$2"
                shift 2
                ;;
            --alert|-a)
                _POMO_ALERT_TIME="$2"
                shift 2
                ;;
            --sleep|-z)
                _POMO_SLEEP_TIME="$2"
                shift 2
                ;;
            --color|-C)
                _POMO_COLOR=1
                shift
                ;;
            --help|-h)
                echo "使用方法: pomodoro_cycle [オプション]"
                echo "オプション:"
                echo "  -w, --work TIME    作業時間を設定 (デフォルト: 25m)"
                echo "  -s, --short TIME   短い休憩時間を設定 (デフォルト: 5m)"
                echo "  -l, --long TIME    長い休憩時間を設定 (デフォルト: 15m)"
                echo "  -c, --cycles NUM   サイクル数を設定 (デフォルト: 4)"
                echo "  -a, --alert NUM    アラート時間を設定 (デフォルト: 30秒)"
                echo "  -z, --sleep NUM    通知間の待機時間を設定 (デフォルト: 2秒)"
                echo "  -C, --color        カラー表示(lolcatがインストールされている場合)"
                echo "  -h, --help         このヘルプメッセージを表示"
                echo ""
                echo "例: pomodoro_cycle -w 45m -s 10m -l 30m -c 3"
                echo "例: pomodoro_cycle --work 45m --short 10m --long 30m --cycles 3"
                echo "例: pomodoro_cycle -C"
                return 0
                ;;
            *)
                echo "不明なオプション: $1"
                echo "ヘルプを表示するには: pomodoro_cycle -h"
                return 1
                ;;
        esac
    done

    echo "🍅 ポモドーロタイマー開始: $_POMO_CYCLES サイクル"
    echo "⏱️ 作業時間: $_POMO_WORK_TIME | 短い休憩: $_POMO_BREAK_TIME | 長い休憩: $_POMO_LONG_BR
EAK_TIME"

    for i in $(seq 1 $_POMO_CYCLES); do
        echo "⏰ サイクル $i/$_POMO_CYCLES: 作業時間 開始"
        sleep $_POMO_SLEEP_TIME
        _pomo_timer "Work time done" $_POMO_WORK_TIME

        if [ $i -lt $_POMO_CYCLES ]; then
            echo "☕ サイクル $i/$_POMO_CYCLES: 短い休憩時間 開始"
            sleep $_POMO_SLEEP_TIME
            _pomo_timer "Short break done" $_POMO_BREAK_TIME
        else
            echo "🌴 サイクル $i/$_POMO_CYCLES: 長い休憩時間 開始"
            sleep $_POMO_SLEEP_TIME
            _pomo_timer "Long break done" $_POMO_LONG_BREAK_TIME
        fi
    done

    echo "✅ ポモドーロタイマー完了！🎉"
}
