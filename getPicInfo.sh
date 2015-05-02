#!/bin/bash

if [ $# -ne 3 ]; then
  echo "指定された引数は$#個です。" 1>&2
  echo "実行するには3個の引数が必要です。" 1>&2
  echo "引数1：処理対象の画像が保存されているルートパス"
  echo "引数2：縮小した画像を保存する為のルートパス"
  echo "引数3：更新日が何日前以降のデータを処理するかの日数" 
  exit 1
fi

find $1 -iname "*.jpg" -type f -mtime -$3 > targetPaths.txt
ruby Image_processing.rb $2
