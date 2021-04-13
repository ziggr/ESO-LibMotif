.PHONY: get put getpts log doc

put:
	rsync -vrt --delete --exclude=.git . /Volumes/Elder\ Scrolls\ Online/live/AddOns/LibMotif

get:
	cp -f /Volumes/Elder\ Scrolls\ Online/live/SavedVariables/LibMotif.lua data/
	-cp -f /Volumes/Elder\ Scrolls\ Online/live/SavedVariables/LibDebugLogger.lua data/

getpts:
	cp -f /Volumes/Elder\ Scrolls\ Online/pts/SavedVariables/LibMotif.lua data/
	-cp -f /Volumes/Elder\ Scrolls\ Online/pts/SavedVariables/LibDebugLogger.lua data/

log:
	lua tool/log_to_text.lua > data/log.txt

zip:
	-rm -rf published/LibMotif published/LibMotif\ x.x.x.zip
	mkdir -p published/LibMotif
	cp ./LibMotif* published/LibMotif/

	cd published; zip -r LibMotif\ x.x.x.zip LibMotif

	rm -rf published/LibMotif

doc:
	tool/2bbcode_phpbb  <README.md >/tmp/md2bbdoc

	cp /tmp/md2bbdoc doc/README.bbcode
