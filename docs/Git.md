# git

## How do I stop a Git commit when VI is on the screen waiting for a commit message?

Have the editor exit with a non-zero exit code. In Vim, you can use :cq (quit
with an error code).

http://stackoverflow.com/a/4323790/288089
