#!/usr/bin/env bash

MIME=$(file --mime-type --brief "$1")
#echo "$MIME"

case "$MIME" in
    # .pdf
    *application/pdf*)
        pdftotext "$1" -
        ;;
    # .7z
    *application/x-7z-compressed*)
        7z l "$1"
        ;;
    # .tar .tar.Z
    *application/x-tar*)
        tar -tvf "$1"
        ;;
    # .tar.*
    *application/x-compressed-tar*|*application/x-*-compressed-tar*)
        tar -tvf "$1"
        ;;
    # .rar
    *application/vnd.rar*)
        unrar l "$1"
        ;;
    # .zip
    *application/zip*)
        unzip -l "$1"
        ;;
    # any plain text file that doesn't have a specific handler
    # *text/plain*|*text/x-shellscript*|*text/x-c++*|*text/x-c*|*application/javascript*)
    *text/plain*\
    |*text/x-*\
    |*application/*\
    |*text/x-shellscript*\
    |*text/x-c++*\
    |*text/x-c*\
    |*application/javascript*\
    |*text/x-java)
        # return false to always repaint, in case terminal size changes
        bat --force-colorization --paging=never --style=changes,numbers \
            --terminal-width $(($2 - 3)) "$1" && false
        ;;
    *)
        echo "unknown format: $MIME"
        ;;
esac