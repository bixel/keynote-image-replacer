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
		repeat with replacements in replacementList
			set slideNum to (slide number of the current slide)
			tell the current slide
				repeat with n from 1 to count of images
					set placeholderImage to (item n of images)
					set file name of placeholderImage to alias (item n of replacements)
				end repeat
			end tell
			set the current slide to slide ((slide number of the current slide) + 1)
		end repeat
	end tell
end tell
