#!/usr/bin/env fish
function mp3-to-opus
	for file in *.mp3
		if [ ! $albumsaved ]
			echo -n extracting album art...
			ffmpeg -loglevel 24 -i "$file" album.jpg
			set albumsaved "true"
			echo done
		end

		set album (mp3info -p "%l" "$file")
		set artist (mp3info -p "%a" "$file")
		set title (mp3info -p "%t" "$file")
		set track (mp3info -p "%n" "$file")
		set genre (mp3info -p "%g" "$file")
		set outfile (basename "$file" .mp3).opus
		echo -n encoding $file :
		ffmpeg -loglevel 24 -i "$file" -f wav - | opusenc --quiet --title "$title" --artist "$artist" --album "$album" --picture "|image/jpeg|||album.jpg" --comment "TRACKNUMBER=$track" --comment "GENRE=$genre" - "$outfile"
	end
end
