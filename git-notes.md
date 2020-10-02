## Git and GitHub to track and share versions

### Creating new repository

For example, we want to create a new repository called `STAT679` under `Desktop` folder.

```shell
cd ~/Desktop/STAT679
git status
git init
git add readme.md
echo "STAT679 folder" >> readme.md
cat readme.md
git status # readme.md file should be tracked
```

Then commit

```shell
git commit -m "initial commit, main readme only"
```



### pushing to GitHub to work with others

```shell
git remote -v
git remote add origin git@github.com:ElenaXu98/STAT679CourseNotes.git
git remote -v
git branch
git push -u origin master
```

### Pulling from github

#### Clone from remote repo

```shell
git clone git@github.com:ElenaXu98/STAT679CourseNotes.git
cd STAT679CourseNotes
git remote -v
```

#### Update your repo

```shell
echo "Samples expected from sequencing facility 2020-09-30" >> readme.md
git commit -a -m "added information about samples"
git push origin master # or just "git push" if my branch "master" knows what it's tracking
git log --pretty=oneline --abbrev-commit
gl # this is my own alias for "git log" with particular options
type gl
git log --abbrev-commit --graph --pretty=oneline --all --decorate
```

#### Comments

- **Do pull often!!!**

- Commit your changes before pulling.



### Resolving conflicts and merge commits

```shell
# collaborator does this:
echo -e ", downloaded 2020-09-26 from\nhttp://maizegdb.org into /share/data/refgen3/." >> readme.md
git commit -a -m "added download info"
git push origin master

# myself does this:
git commit -a -m "added genome download date"
git push origin master # Ahh, problem!!
git pull origin master
git status # find out what're the conflicts
```

Then resolve the conflict manually. After doing that, push them again.

```
git add readme.md
git status
git commit -a -m "resolved merge conflict in readme.md"
git status
git log --abbrev-commit --pretty=oneline --graph
git push origin master
```

#### comments

- merge commits have 2 parents, unlike usual commits.
- Read `git status`!!! It gives a lot information.
- if you feel overwhelmed during a merge, do `git merge --abort` and start the various merge steps from scratch.





