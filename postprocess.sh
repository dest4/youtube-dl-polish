#!/bin/bash
set -x
FILE=$1

ARTIST=`echo "$FILE" | awk -F" - " '{print $1}'`
read -p "Artist ? (default:$ARTIST): " name
ARTIST=${name:-$ARTIST}

TITLE=`echo "$FILE" | awk -F" - " '{print $2}' | rev | cut -d'.' -f2 | rev | cut -d'-' -f1`
read -p "Title ? (default:$TITLE): " title
TITLE=${title:-$TITLE}

YOUTUBE_ID=`echo "$FILE" | awk '{print $NF}' | cut -d'.' -f1 | cut -d'-' -f2`
read -p "Youtube ID ? (default:$YOUTUBE_ID): " ytid
YOUTUBE_ID=${ytid:-$YOUTUBE_ID}

#if [ -z "$ARTIST" ] || [ -z "$TITLE" ]; then
#	print "WARNING: could not parse artist and title"
#	exit 1
#fi


FFPROBE=`ffprobe "$1" 2>&1`
BITRATE=`echo "$FFPROBE" | grep 'bitrate' | awk '{print $6}'`
FORMAT=`echo "$FFPROBE" | grep 'Audio:' | awk '{print $4}' | awk '{gsub(/,$/,""); print}'`
echo "FILE $FILE has bitrate $BITRATE kbps and format |$FORMAT|"
#echo "ARTIST=$ARTIST"
#echo "TITLE=$TITLE"
#echo "YOUTUBE_ID=$YOUTUBE_ID"

mkdir -p "output"

if [ "$FORMAT" == "opus" ]; then
	TARGET_BITRATE="128"
	TARGET_EXTENSION=".mp3"
	if [ "$BITRATE" -ge '128' ]; then
		TARGET_BITRATE="192"
	fi

	echo "target bitrate is "$TARGET_BITRATE"k"
	ffmpeg -hide_banner -loglevel panic -i "$FILE" -vn -codec:a libmp3lame -b:a $TARGET_BITRATE"k" -y "$FILE".mp3
	mp3gain -r "$FILE".mp3
	tagmp3 set "%A:$ARTIST %t:$TITLE %c:$YOUTUBE_ID" "$FILE".mp3
	mv "$FILE".mp3 "output/$ARTIST - $TITLE".mp3


elif [ "$FORMAT" == "aac" ]; then
	cp "$FILE" "$FILE".m4a
	#ffmpeg -hide_banner -loglevel panic -i "$FILE" -vn -c:a copy "$FILE".aac
	aacgain -r "$FILE".m4a
	./wez-atomicparsley/AtomicParsley "$FILE".m4a --artist "$ARTIST" --title "$TITLE" --comment "$YOUTUBE_ID"
	TAGGED_FILE=`ls | grep "$FILE" | grep "\-temp\-"`
	mv "$TAGGED_FILE" "output/$ARTIST - $TITLE".m4a
	echo "final output: output/$ARTIST - $TITLE".m4a


else
	echo "format $FORMAT is not supported"
	exit 1
fi

