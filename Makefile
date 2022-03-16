.PHONY: get put getpts log doc

put:
	rsync -vrt --delete --exclude=.git . /Volumes/Elder\ Scrolls\ Online/live/AddOns/LibMotif

zip:
	-rm -rf published/LibMotif published/LibMotif\ x.x.x.zip
	mkdir -p published/LibMotif
	cp ./LibMotif* published/LibMotif/

	cd published; zip -r LibMotif\ x.x.x.zip LibMotif

	rm -rf published/LibMotif

doc:
	tool/2bbcode_phpbb  <README.md >/tmp/md2bbdoc

	cp /tmp/md2bbdoc doc/README.bbcode
