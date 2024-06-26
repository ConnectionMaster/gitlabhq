---
stage: Create
group: Source Code
info: To determine the technical writer assigned to the Stage/Group associated with this page, see https://handbook.gitlab.com/handbook/product/ux/technical-writing/#assignments
description: "Introduction to using Git through the command line."
---

# Command line Git

You can do many Git operations directly in GitLab. However, the command line is required for advanced tasks,
like fixing complex merge conflicts or rolling back commits.

If you're new to Git and want to learn by working in your own project,
[learn how to make your first commit](../tutorials/make_first_git_commit/index.md).

For a quick reference of Git commands, download a [Git Cheat Sheet](https://about.gitlab.com/images/press/git-cheat-sheet.pdf).

Learn how [GitLab became the backbone of the Worldline](https://about.gitlab.com/customers/worldline/) development environment.

To help you visualize what you're doing locally, you can install a
[Git GUI app](https://git-scm.com/downloads/guis).

## Choose a repository

Before you begin, choose the repository you want to work in. You can use any project you have permission to
access on GitLab.com or any other GitLab instance.

To use the repository in the examples on this page:

1. Go to [https://gitlab.com/gitlab-tests/sample-project/](https://gitlab.com/gitlab-tests/sample-project/).
1. In the upper-right corner, select **Fork**.
1. Choose a namespace for your fork.

The project becomes available at `https://gitlab.com/<your-namespace>/sample-project/`.

You can [fork](../user/project/repository/forking_workflow.md#create-a-fork) any project you have access to.

## Clone a repository

When you clone a repository, the files from the remote repository are downloaded to your computer,
and a connection is created.

This connection requires you to add credentials. You can either use SSH or HTTPS. SSH is recommended.

### Clone with SSH

Clone with SSH when you want to authenticate only one time.

1. Authenticate with GitLab by following the instructions in the [SSH documentation](../user/ssh.md).
1. On the left sidebar, select **Search or go to** and find the project you want to clone.
1. On the project's overview page, in the upper-right corner, select **Code**, then copy the URL for **Clone with SSH**.
1. Open a terminal and go to the directory where you want to clone the files.
   Git automatically creates a folder with the repository name and downloads the files there.
1. Run this command:

   ```shell
   git clone git@gitlab.com:gitlab-tests/sample-project.git
   ```

1. To view the files, go to the new directory:

   ```shell
   cd sample-project
   ```

You can also
[clone a repository and open it directly in Visual Studio Code](../user/project/repository/index.md#clone-and-open-in-visual-studio-code).

### Clone with HTTPS

Clone with HTTPS when you want to authenticate each time you perform an operation between your computer and GitLab.
[OAuth credential helpers](../user/profile/account/two_factor_authentication.md#oauth-credential-helpers) can decrease
the number of times you must manually authenticate, making HTTPS a seamless experience.

1. On the left sidebar, select **Search or go to** and find the project you want to clone.
1. On the project's overview page, in the upper-right corner, select **Code**, then copy the URL for **Clone with HTTPS**.
1. Open a terminal and go to the directory where you want to clone the files.
1. Run the following command. Git automatically creates a folder with the repository name and downloads the files there.

   ```shell
   git clone https://gitlab.com/gitlab-tests/sample-project.git
   ```

1. GitLab requests your username and password.

   If you have enabled two-factor authentication (2FA) on your account, you cannot use your account password. Instead, you can do one of the following:

   - [Clone using a token](#clone-using-a-token) with `read_repository` or `write_repository` permissions.
   - Install an [OAuth credential helper](../user/profile/account/two_factor_authentication.md#oauth-credential-helpers).

   If you have not enabled 2FA, use your account password.

1. To view the files, go to the new directory:

   ```shell
   cd sample-project
   ```

NOTE:
On Windows, if you enter your password incorrectly multiple times and an `Access denied` message appears,
add your namespace (username or group) to the path:
`git clone https://namespace@gitlab.com/gitlab-org/gitlab.git`.

#### Clone using a token

Clone with HTTPS using a token if:

- You want to use 2FA.
- You want to have a revocable set of credentials scoped to one or more repositories.

You can use any of these tokens to authenticate when cloning over HTTPS:

- [Personal access tokens](../user/profile/personal_access_tokens.md).
- [Deploy tokens](../user/project/deploy_tokens/index.md).
- [Project access tokens](../user/project/settings/project_access_tokens.md).
- [Group access tokens](../user/group/settings/group_access_tokens.md).

```shell
git clone https://<username>:<token>@gitlab.example.com/tanuki/awesome_project.git
```

### Convert a local directory into a repository

You can initialize a local folder so Git tracks it as a repository.

1. Open the terminal in the directory you'd like to convert.
1. Run this command:

   ```shell
   git init
   ```

   A `.git` folder is created in your directory. This folder contains Git
   records and configuration files. You should not edit these files
   directly.

1. Add the [path to your remote repository](#add-a-remote)
   so Git can upload your files into the correct project.

#### Add a remote

You add a "remote" to tell Git which remote repository in GitLab is tied
to the specific local folder on your computer.
The remote tells Git where to push or pull from.

To add a remote to your local copy:

1. In GitLab, [create a project](../user/project/index.md) to hold your files.
1. Visit this project's homepage, scroll down to **Push an existing folder**, and copy the command that starts with `git remote add`.
1. On your computer, open the terminal in the directory you've initialized, paste the command you copied, and press <kbd>enter</kbd>:

   ```shell
   git remote add origin git@gitlab.com:username/projectpath.git
   ```

After you've done that, you can [stage your files](#add-and-commit-local-changes) and [upload them to GitLab](#send-changes-to-gitlab).

#### View your remote repositories

To view your remote repositories, type:

```shell
git remote -v
```

The `-v` flag stands for verbose.

### Download the latest changes in the project

To work on an up-to-date copy of the project, you `pull` to get all the changes made by users
since the last time you cloned or pulled the project. Replace `<name-of-branch>`
with either:

- The name of your [default branch](../user/project/repository/branches/default.md) to get the main branch code.
- The name of the branch you are working in.

```shell
git pull <REMOTE> <name-of-branch>
```

When you clone a repository, `REMOTE` is typically `origin`. The remote is where the
repository was cloned from, and it indicates the SSH or HTTPS URL of the repository
on the remote server. `<name-of-branch>` is usually the name of your
[default branch](../user/project/repository/branches/default.md), but it may be any
existing branch. You can create additional named remotes and branches as necessary.

You can learn more on how Git manages remote repositories in the
[Git Remote documentation](https://git-scm.com/book/en/v2/Git-Basics-Working-with-Remotes).

## Add another URL to a remote

Add another URL to a remote, so both remotes get updated on each push:

```shell
git remote set-url --add <remote_name> <remote_url>
```

## Display changes to Git references

A Git **reference** is a name that points to a specific commit, or to another reference.
The reference `HEAD` is special. It usually points to a reference which points to the tip
of the current working branch:

```shell
$ git show HEAD
commit ab123c (HEAD -> main, origin/main, origin/HEAD)
```

When a reference is changed in the local repository, Git records the change
in its **reference logs**. You can display the contents of the reference logs
if you need to find the old values of a reference. For example, you might want
to display the changes to `HEAD` to undo a change.

To display the list of changes to `HEAD`:

```shell
git reflog
```

## Check the Git history of a file

The basic command to check the Git history of a file:

```shell
git log <file>
```

If you get this error message:

```plaintext
fatal: ambiguous argument <file_name>: unknown revision or path not in the working tree.
Use '--' to separate paths from revisions, like this:
```

Use this to check the Git history of the file:

```shell
git log -- <file>
```

## Check the content of each change to a file

```shell
gitk <file>
```

## Branches

A **branch** is a copy of the files in the repository at the time you create the branch.
You can work in your branch without affecting other branches. When
you're ready to add your changes to the main codebase, you can merge your branch into
the default branch, for example, `main`.

Use branches when you:

- Want to add code to a project but you're not sure if it works properly.
- Are collaborating on the project with others, and don't want your work to get mixed up.

A new branch is often called **feature branch** to differentiate from the
[default branch](../user/project/repository/branches/default.md).

### Create a branch

To create a feature branch:

```shell
git checkout -b <name-of-branch>
```

GitLab enforces [branch naming rules](../user/project/repository/branches/index.md#name-your-branch)
to prevent problems, and provides
[branch naming patterns](../user/project/repository/branches/index.md#prefix-branch-names-with-issue-numbers)
to streamline merge request creation.

### Switch to a branch

All work in Git is done in a branch.
You can switch between branches to see the state of the files and work in that branch.

To switch to an existing branch:

```shell
git checkout <name-of-branch>
```

For example, to change to the `main` branch:

```shell
git checkout main
```

## Make changes

When you make changes to files in a repository, Git tracks the changes
against the most recent version of the checked out branch. You can use
Git commands to review and commit your changes to the branch, and push
your work to GitLab.

### View repository status

When you add, change, or delete files or folders, Git knows about the
changes. To check which files have been changed:

- From your repository, run `git status`.

The branch name, most recent commit, and any new or changed files are displayed.
New files are displayed in green. Changed files are displayed in red.

### View differences

You can display the difference (or diff) between your local
changes and the most recent version of a branch. View a diff to
understand your local changes before you commit them to the branch.

To view the differences between your local unstaged changes and the
latest version that you cloned or pulled:

- From your repository, run `git diff`.

  To compare your changes against a specific branch, run
  `git diff <branch>`.

The diff is displayed:

- Lines with additions begin with a plus (`+`) and are displayed in green.
- Lines with removals or changes begin with a minus (`-`) and are displayed in red.

If the diff is large, by default only a portion of the diff is
displayed. You can advance the diff with <kbd>Enter</kbd>, and quit
back to your terminal with <kbd>Q</kbd>.

### Add and commit local changes

When you're ready to write your changes to the branch, you can commit
them. A commit includes a comment that records information about the
changes, and usually becomes the new tip of the branch.

Git doesn't automatically include any files you move, change, or
delete in a commit. This prevents you from accidentally including a
change or file, like a temporary directory. To include changes in a
commit, stage them with `git add`.

To stage and commit your changes:

1. From your repository, for each file or directory you want to add, run `git add <file name or path>`.

   To stage all files in the current working directory, run `git add .`.

1. Confirm that the files have been added to staging:

   ```shell
   git status
   ```

   The files are displayed in green.

1. To commit the staged files:

   ```shell
   git commit -m "<comment that describes the changes>"
   ```

The changes are committed to the branch.

### Commit all changes

You can stage all your changes and commit them with one command:

```shell
git commit -a -m "<comment that describes the changes>"
```

Be careful your commit doesn't include files you don't want to record
to the remote repository. As a rule, always check the status of your
local repository before you commit changes.

### Send changes to GitLab

To push all local changes to the remote repository:

```shell
git push <remote> <name-of-branch>
```

For example, to push your local commits to the `main` branch of the `origin` remote:

```shell
git push origin main
```

Sometimes Git does not allow you to push to a repository. Instead,
you must [force an update](../topics/git/git_rebase.md#force-pushing).

## Delete changes

If want to undo your changes, you can use Git commands to go back to an earlier version of a repository.

Deleting changes is often an irreversible, destructive action. If
possible, you should add additional commits instead of reverting old
ones.

### Overwrite uncommitted changes

You can use `git checkout` as a shortcut to discard tracked,
uncommitted changes.

To discard all changes to tracked files:

```shell
git checkout .
```

Your changes are overwritten by the most recent commit in the branch.
Untracked files are not affected.

### Reset changes and commits

WARNING:
Do not reset a commit if you already pushed it to the remote
repository.

If you stage a change with `git add` and then decide not to commit it,
you might want to unstage the changes. To unstage a change:

- From your repository, run `git reset`.

If your changes have been committed (but not pushed to the remote
repository), you can reset your commits:

```shell
git reset HEAD~<number>
```

Here, `<number>` is the number of commits to undo.
For example, if you want to undo only the latest commit:

```shell
git rest HEAD~1
```

The commit is reset and any changes remain in the local repository.

To learn more about the different ways to undo changes, see the
[Git Undoing Things documentation](https://git-scm.com/book/en/v2/Git-Basics-Undoing-Things).

## Merge a branch with default branch

When you are ready to add your changes to
the default branch, you merge the feature branch into it:

```shell
git checkout <default-branch>
git merge <feature-branch>
```

In GitLab, you typically use a [merge request](../user/project/merge_requests/index.md) to merge your changes, instead of using the command line.

To create a merge request from a fork to an upstream repository, see the
[forking workflow](../user/project/repository/forking_workflow.md).

## Synchronize changes in a forked repository with the upstream

To create a copy of a repository in your namespace, you [fork it](../user/project/repository/forking_workflow.md).
Changes made to your copy of the repository are not automatically synchronized with the original.
To keep the project in sync with the original project, you need to `pull` from the original repository.

You must [create a link to the remote repository](#add-a-remote) to pull
changes from the original repository. It is common to call this remote repository the `upstream`.

You can now use the `upstream` as a [`<remote>` to `pull` new updates](#download-the-latest-changes-in-the-project)
from the original repository, and use the `origin`
to [push local changes](#send-changes-to-gitlab) and create merge requests.

## Related topics

- [Git rebase and force push](../topics/git/git_rebase.md)
