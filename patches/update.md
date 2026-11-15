```bash
git fetch upstream
git switch main
git merge --ff-only upstream/main
git push origin main

git switch own/main
git merge upstream/main
git push origin own/main
```