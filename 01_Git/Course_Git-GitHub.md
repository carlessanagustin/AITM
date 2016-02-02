# Course: Git + GitHub

## Index

1. Theory - What is VCS? (01-git_course-VCS)
2. Theory - Git (02-git_course-Git)
3. **Exercise - Teams of One (individuals)**
4. Theory - GitHub (03-git_course-GitHub)
5. **Exercise - Teams of More than One (collaboration)**
6. Q&A

---

## 1. Theory - What is VCS?

pdf slides (01-git_course-VCS)

## 2. Theory - Git

pdf slides (02-git_course-Git))

## 3. Exercise - Teams of One (individuals)

### Environment setup

* Install Git: http://git-scm.com
* Install Git GUI Client: https://www.sourcetreeapp.com

### 0. Setup
(Levels: --system, --global & --local)

	$ git config --local user.name "name surname"
	$ git config --local user.email email@example.com
	$ git config --local color.ui auto
	$ git config --list
	$ git help config
	$ git

### Advanced Setup
(Optional)

	$ git config --local core.editor "atom --wait"
	$ vim .git/config
	$ git config --global user.name "name surname global"
	$ vim ~/.gitconfig
	$ git config --list

### 1. First steps

	$ mkdir ~/git-exercise
	$ cd ~/git-exercise
	$ git init
	$ git status
	(create a file)
	$ git status
	$ git add [filename]
	$ git status
	$ git reset [filename]
	$ git status
	$ git add .
	$ git status
	$ git commit -am "your message here"
	(change file)

	$ git diff
	Output: @@@ [from-file-range] [to-file-range] @@@

	(create a file)
	$ git commit -am "your message here"
	$ git status

### Status commands

	$ git status
	$ git log
	$ git log [file]
	$ git log -n [limit]
	$ git log --oneline
	$ git log --author="author name"
	$ git log --grep="my pattern"
	$ git log --graph --decorate --oneline
	$ git show

	$ git diff
	Diff at commit level

	$ git diff --staged
	Diff at stage level

	$ git reflog
	Display log in a diferent way

### 2. Ignoring files

	(create a file)
	$ git status
	$ vim .gitignore
	$ git add .gitignore
    $ git commit -am "Adding list of files to be ignored = gitignore."
    $ git status

#### Advanced

    $ cat .git/info/exclude
    $ vim a_folder/.gitignore

### Rewriting history

	$ git checkout [commit]
	$ git checkout [commit] [file]
	$ git checkout [branch]
	Checkout = restore.

	$ git revert [commit]
	Revert some existing commits

If "git revert" is a “safe” way to undo changes, you can think of "git reset" as the dangerous method.

	$ git reset [file]
	$ git reset --hard [commit]
	Reset current HEAD to the specified state

1. --soft: The staged snapshot and working directory are not altered in any way but resets the head to [commit]
2. --mixed: The staged snapshot is updated to match the specified commit, but the working directory is not affected. This is the default option.
3. --hard: The staged snapshot and the working directory are both updated to match the specified commit.

	$ git reset --hard && git clean -f

Running both of them will make your working directory match the most recent commit, giving you a clean slate to work with.

	$ git commit --amend
	(optional)$ git config --global core.editor $(whereis vim)

	$ git rebase [object]
	Forward-port local commits to the updated upstream head

#### Rebase workflow

	$ git checkout -b devel
	(make changes to working tree)
	$ git rebase master
	(make changes to working tree)
	$ git checkout master
	$ git merge devel

	$ git rebase -i [object]
	Running git rebase with the -i flag begins an interactive rebasing session.

### Merge

	$ git merge [branch]
	Merge == Join in

### Reset, Checkout and Revert

Command | Scope | Common use cases
------------ | -------------| -------------
git reset | Commit-level | Discard commits in a branch or throw away uncommited changes
git reset | File-level | Unstage a file
git checkout | Commit-level | Switch between branches or inspect old snapshots
git checkout | File-level | Discard changes in the working directory
git revert | Commit-level | Undo commits in a public branch
git revert | File-level | (N/A)

### Branches

	$ git branch
	Show branches

	$ git branch [new-branch]
	Create branch

	$ git branch -r
	Show only remote branches

	$ git branch -d [branch]
	Delete branch

	$ git branch -m [branch]
	Rename branch

### Branch selection
(checkout == restore)

	$ git checkout [destination-branch]
	Move to branch

	$ git checkout -b [new-branch]
	Create and move to branch (== git branch [new-branch] + git checkout [branch])

	$ git checkout -b [new-branch] [from-branch]
	Create [new-branch] from [from-branch] and move to [new-branch]

### Continue project

	$ git clone [URL] [destination-folder]

### HEAD pointer

	HEAD: present branch
	HEAD^: father of HEAD
	HEAD-4: 4 steps before HEAD
	$ cat .git/HEAD

## 4. Theory - GitHub

pdf slides (03-git_course-GitHub)

## 5. Exercise - Teams of More than One (collaboration)

### Collaboration commands

#### Setup remote

	$ git remote -v
	$ git remote add origin [URL]
	$ git remote rm origin
	$ git remote rename origin origin-new

#### Download changes

	$ git fetch origin
	$ git fetch origin [branch]

	$ git pull origin
	Is the same as:
		$ git fetch origin && git merge origin/[current-branch]

	$ git pull --rebase origin
	Is the same as:
		$ git fetch origin && git merge rebase/[current-branch]

#### Upload changes

	$ git push origin <branch>
	$ git push origin --all
	$ git push origin --tags

#### Tagging

    $ git tag
    $ git tag -a [version] -m "your message here"
    $ git tag -l "[pattern]*"
    $ git tag -a [version] [HASH]
    
    $ git push origin [version]
    $ git push origin --tags
    
    $ git checkout -b [branchname] [tagname]

### Temporal saving

    $ git stash
    $ git stash list
    $ git stash pop
    $ git stash drop

### Create Your Own SSH Keys

	$ ls -al ~/.ssh
	$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
	$ eval "$(ssh-agent -s)"
	$ ssh-add ~/.ssh/id_rsa
	$ ssh-add -l
	$ cat ~/.ssh/id_rsa.pub
	(optional)$ pbcopy < ~/.ssh/id_rsa.pub

* Go to your GitHub repository setup page
Settings > SSH keys > Add SSH key > Title: "my computer 1" > Key: paste > Add key

[detail](https://help.github.com/articles/generating-ssh-keys/)

## 6. Q&A

Thank you.

carlessanagustin.com
