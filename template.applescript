set replacementList to {¬
	[% for images in slides -%]
	{¬
		[% for image in images -%]
			"Macintosh HD[[ image|replace('/', ':') ]]"[% if not loop.last %],[% endif %]¬
		[% endfor -%]
	}[% if not loop.last %],[% endif %]¬
	[% endfor -%]
}
tell application "Keynote"
	activate
	tell the front document
		set baseSlide to (get the current slide)
		repeat with replacements in replacementList
			duplicate baseSlide
			tell the current slide
				repeat with n from 1 to count of images
					set placeholderImage to (item n of images)
					set file name of placeholderImage to alias (item n of replacements)
				end repeat
			end tell
		end repeat
	end tell
end tell
