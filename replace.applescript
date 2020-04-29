set replacementList to {¬
	[% for images in slides -%]
	{¬
		[% for image in images -%]
			"[[ image ]]"[% if not loop.last %],[% endif %]¬
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
					set imageFile to (item n of replacements) as POSIX file
					set file name of placeholderImage to imageFile
				end repeat
			end tell
			set the current slide to slide ((slide number of the current slide) + 1)
		end repeat
	end tell
end tell
