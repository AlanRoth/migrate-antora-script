#!/bin/bash

#Put the location of the directory here
dir="/home/alanroth/Workspace/Payara-Server-Documentation/"
#The version of the Branch e.g. 5.201, 5.194, 5.191
version="5.194"

#Setup
cd $dir
rm -rf docs/

#Prepare directory structure
cd $dir
mkdir -p docs/modules/ROOT/pages
cd docs/modules/ROOT/
mkdir partials
mkdir -p assets/images
cd $dir

#Make antora.yml
cd docs/
touch antora.yml

#Append to antora.yml
echo "name: payara-server-documentation" >> antora.yml
echo "title: Payara Server Documentation" >> antora.yml
echo "version: $version" >> antora.yml
echo "start_page: ROOT:README.adoc" >> antora.yml
echo "nav:" >> antora.yml
echo "- modules/ROOT/nav.adoc" >> antora.yml

#Rename and move SUMMARY.adoc to nav.adoc
cd $dir
mv SUMMARY.adoc nav.adoc
mv nav.adoc docs/modules/ROOT/

#Convert SUMMARY.adoc to nav.adoc
cd $dir
cd docs/modules/ROOT/
sed -i 's/link:/xref:/' nav.adoc
#Remove summary
sed -i 's/\[\[summary\]\]//' nav.adoc
sed -i 's/= Summary//' nav.adoc
#Replace heading format
sed -i 's/\[\[.*//' nav.adoc
sed -i 's/== /\./' nav.adoc
#Remove whitespace between heading and its content
sed -i '/^$/d' nav.adoc
#Add whitespace between new heading and end of last content
sed -i '/^\./i \\n' nav.adoc

#Move text documentation
cd $dir
mv documentation docs/modules/ROOT/pages/
mv build-instructions docs/modules/ROOT/pages/
mv general-info docs/modules/ROOT/pages/
mv getting-started docs/modules/ROOT/pages/
mv jakartaee-certification docs/modules/ROOT/pages/
mv release-notes docs/modules/ROOT/pages/
mv schemas docs/modules/ROOT/pages/
mv security docs/modules/ROOT/pages/

#Move README
cd $dir
mv README.adoc docs/modules/ROOT/pages/

#Move images to assets folder
cd $dir
mv images docs/modules/ROOT/assets/

#Replace directory for referenced images to where Antora expects them
cd $dir
cd docs/modules/ROOT/
find . -type f -name "*.adoc" -print0 | xargs -0 sed -i'' -e 's/\/images\///g'

#Move fragments to partials
cd $dir
mv fragments/* docs/modules/ROOT/partials/

#Update tech-preview usage instructions
cd $dir
cd docs/modules/ROOT/partials/
sed -i 's/fragment/partial page/g' tech-preview.adoc
sed -i 's/set previewVersion = \"4.1.2.XXX\"/:previewVersion: "4.1.2.XXX"/g' tech-preview.adoc
sed -i 's/include "\/fragments\/tech-preview\.adoc"/include::partial$tech-preview.adoc\[\]/g' tech-preview.adoc

#Replace gitbooks attributes to antora attributes
cd $dir
cd docs/modules/ROOT/
find . -type f -name "*.adoc" -print0 | xargs -0 sed -i'' -e 's/{ book.//g'
find . -type f -name "*.adoc" -print0 | xargs -0 sed -i'' -e 's/ }//g'
find . -type f -name "*.adoc" -print0 | xargs -0 sed -i'' -e 's/book.//g'

#Replace gitbook(s) to Antora
cd $dir
cd docs/modules/ROOT/
find . -type f -name "*.adoc" -print0 | xargs -0 sed -i'' -e 's/gitbook/Antora/gi'
find . -type f -name "*.adoc" -print0 | xargs -0 sed -i'' -e 's/gitbooks/Antora/gi'

#If partials has certain conditional statements replace them with preprocessor condtional directives
cd $dir
cd docs/modules/ROOT/partials/
find . -type f -name "*.adoc" -print0 | xargs -0 sed -i'' -e 's/{% if currentVersion == previewVersion %}/ifeval::[{currentVersion} == {previewVersion}]/g'
find . -type f -name "*.adoc" -print0 | xargs -0 sed -i'' -e 's/{% endif %}/endif::\[\]/g'

#Replace other common conditional statements
cd $dir
cd docs/modules/ROOT/pages/
find . -type f -name "*.adoc" -print0 | xargs -0 sed -i'' -e 's/{% if currentVersion == "4.1.2.181" %}/:previewVersion: 4.1.2.181/g'
find . -type f -name "*.adoc" -print0 | xargs -0 sed -r -i'' -e 's/WARNING: The \(secrets\) directory.*/include::partial$tech-preview.adoc\[\]/g'
find . -type f -name "*.adoc" -print0 | xargs -0 sed -i'' -e 's/{% endif %}//g'

find . -type f -name "*.adoc" -print0 | xargs -0 sed -i'' -e 's/{% set previewVersion = "4.1.2.181" %}/:previewVersion: 4.1.2.181/g'
find . -type f -name "*.adoc" -print0 | xargs -0 sed -i'' -e 's/{% include "\/fragments\/tech-preview.adoc" %}/include::partial$tech-preview.adoc\[\]/g'

find . -type f -name "*.adoc" -print0 | xargs -0 sed -i'' -e 's/{% set previewVersion = currentVersion %}/:previewVersion: {currentVersion}/g'
find . -type f -name "*.adoc" -print0 | xargs -0 sed -i'' -e 's/{% include "\/fragments\/tech-preview.adoc" %}/include::partial$tech-preview.adoc\[\]/g'

find . -type f -name "*.adoc" -print0 | xargs -0 sed -i'' -e 's/{% if currentVersion == "5.181" %}/:previewVersion: 5.181/g'
find . -type f -name "*.adoc" -print0 | xargs -0 sed -r -i'' -e 's/WARNING: This feature is released in.*/include::partial$tech-preview.adoc\[\]/g'
find . -type f -name "*.adoc" -print0 | xargs -0 sed -i'' -e 's/{% endif %}//g'

#Change page links to xref
cd $dir
cd docs/modules/ROOT/
find . -type f -name "*.adoc" -print0 | xargs -0 sed -i'' -e 's/link/xref/g'

#Remove xref from external page links
cd $dir
cd docs/modules/ROOT/pages
find . -type f -name "*.adoc" -print0 | xargs -0 sed -i'' -e 's/xref:http/http/g'

#Fix release notes links
cd $dir
cd docs/modules/ROOT/pages/release-notes
sed -i 's/xref:/xref:release-notes\//g'

#Clean up
cd $dir
rm -rfv styles
rm -rfv book.json
rm -rfv fragments

echo "Head back to the documentation to see what you need to do next..."





