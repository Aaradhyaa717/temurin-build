#!/bin/bash
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

git clone https://github.com/frej/fast-export.git
<<<<<<< HEAD
git clone https://github.com/breadbin/openjdk-jdk8u.git
cd openjdk-jdk8u
# get latest github tag
gitTag=`git describe --abbrev=0 --tags`

cd $WORKSPACE
rm -rf openjdk-jdk8u

hg clone http://hg.openjdk.java.net/jdk8u/jdk8u/ openjdk_hg
=======
hg clone http://hg.openjdk.java.net/jdk8u/jdk8u/ openjdk_hg

>>>>>>> 4a0eb33bcca15eb3d0516858bbe6b52e8cfc8d49
cd openjdk_hg
# get latest mercurial tag
hgTag=`hg log -r "." --template "{latesttag}\n"`

<<<<<<< HEAD
# compare git tag and hg tag
if [ "$gitTag" != "$hgTag" ]; then
	echo "Up to date"
    exit
fi

=======
>>>>>>> 4a0eb33bcca15eb3d0516858bbe6b52e8cfc8d49
bash ./get_source.sh
for i in corba jaxp jaxws langtools jdk hotspot nashorn; do
   echo "cleaning up $i"
   # removes the mercurial stuff from the additional repos
   cd $i
   rm -rf .hg .hgignore .hgtags
   cd -
done
cd $WORKSPACE

mkdir openjdk_git
cd openjdk_git
git init
# convert mercurial to github
$WORKSPACE/fast-export/hg-fast-export.sh -r $WORKSPACE/openjdk_hg
for i in corba jaxp jaxws langtools jdk hotspot nashorn; do
	# copy the additional repos in
	cp -r $WORKSPACE/openjdk_hg/$i $i
done
git checkout
# remove remaining mercurial stuff
rm -rf .hg .hgignore .hgtags README-builds.html README get_source.sh
# create new README
cp $WORKSPACE/openjdk-build/git-hg/README.md .
<<<<<<< HEAD
git add .
git commit -m "update source"
git remote add releases git@github.com:AdoptOpenJDK/openjdk-jdk8u.git
git fetch --all
git diff releases/master
=======
echo "/build" > .gitignore
git add .
git commit -m "merge sources"
git remote add releases git@github.com:AdoptOpenJDK/openjdk-jdk8u.git
git fetch --all
# check if git diff is the same
if [ `git diff releases/master | wc -l` -gt 0 ]; then
	git rebase releases/master
	git log
	#git push --set-upstream releases master
else
	echo "already up to date"
fi
>>>>>>> 4a0eb33bcca15eb3d0516858bbe6b52e8cfc8d49
