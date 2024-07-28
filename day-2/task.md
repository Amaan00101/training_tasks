### Git project
#### Install Git: Ensure Git is installed on your system. Verify with git --version.
#### Set Up Git: Configure your Git username and email:

```
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

#### Create a GitHub Repository:
+ Go to GitHub and create a new repository named website-project.
+ Clone the repository to your local machine:
```
git clone https://github.com/your-username/website-project.git
```

#### Initialize the Project:
+ Navigate to the project directory:

Create initial project structure:

![alt text](<images-1/Screenshot from 2024-07-10 11-38-09.png>)

+ making directory and adding index.html
```
mkdir src
touch src/index.html
echo "<!DOCTYPE html><html><head><title>My Website</title></head><body><h1>Welcome to my website!</h1></body></html>" > src/index.html
```

![alt text](<images-1/Screenshot from 2024-07-10 11-41-32.png>)

#### Commit and push the initial project structure:
```
git add .
git commit -m "Initial commit: Added project structure and index.html"
git push origin main
```

![alt text](<images-1/Screenshot from 2024-07-10 11-51-09.png>)


#### Exercise 1: Branching and Basic Operations (10 minutes)

+ Create a New Branch:
```
git checkout -b feature/add-about-page
```

+ Add a New Page:
    - Create about.html:
```
touch src/about.html
echo "<!DOCTYPE html><html><head><title>About Us</title></head><body><h1>About Us</h1></body></html>" > src/about.html
```

+ Commit and push changes:
```
git add src/about.html
git commit -m "Added about page"
git push origin feature/add-about-page
```

![alt text](<images-1/Screenshot from 2024-07-10 12-07-24.png>)


#### Exercise 2: Merging and Handling Merge Conflicts (15 minutes)
+ Create Another Branch:
```
git checkout main
git checkout -b feature/update-homepage
```

+ Update the Homepage:
    - Modify index.html:
```
echo "<p>Updated homepage content</p>" >> src/index.html
```

+ Commit and push changes:
```
git add src/index.html
git commit -m "Updated homepage content"
git push origin feature/update-homepage
```

![alt text](<images-1/Screenshot from 2024-07-10 12-09-39.png>)


+ Create a Merge Conflict:
    - Modify index.html on the feature/add-about-page branch:
```
git checkout feature/add-about-page
echo "<p>Conflict content</p>" >> src/index.html
git add src/index.html
git commit -m "Added conflicting content to homepage"
git push origin feature/add-about-page
```

+ Merge and Resolve Conflict:
    - Attempt to merge feature/add-about-page into main:
```
git checkout main
git merge feature/add-about-page
```

+ Resolve the conflict in src/index.html, then:
```
git add src/index.html
git commit -m "Resolved merge conflict in homepage"
git push origin main
```

![alt text](<images-1/Screenshot from 2024-07-10 12-17-48.png>)

#### Exercise 3: Rebasing 
+ Rebase a Branch:
    - Rebase feature/update-homepage onto main:
```
git checkout feature/update-homepage
git rebase main
```

+ Push the Rebased Branch:
```
git push -f origin feature/update-homepage
```

![alt text](<images-1/Screenshot from 2024-07-10 23-05-58.png>)


#### Exercise 4: Pulling and Collaboration

+ Pull Changes from Remote:
    - Ensure the main branch is up-to-date:
```
git checkout main
git pull origin main
```

+ Simulate a Collaborator's Change:
- Make a change on GitHub directly (e.g., edit index.html).

+ Pull Collaborator's Changes:
- Pull the changes made by the collaborator:
```
git pull origin main
```

![alt text](<images-1/Screenshot from 2024-07-10 23-09-05.png>)


#### Exercise 5: Versioning and Rollback

+ Tagging a Version:
- Tag the current commit as v1.0:
```
git tag -a v1.0 -m "Version 1.0: Initial release"
git push origin v1.0
```

![alt text](<images-1/Screenshot from 2024-07-10 23-10-16.png>)


+ Make a Change that Needs Reversion:
- Modify index.html:
```
echo "<p>Incorrect update</p>" >> src/index.html
git add src/index.html
git commit -m "Incorrect update"
git push origin main
```

![alt text](<images-1/Screenshot from 2024-07-10 23-12-01.png>)


+ Revert to a Previous Version:
- Use git revert to undo the last commit:
```
git revert HEAD
git push origin main
```
   
+ Alternatively, reset to a specific commit (use with caution): sh Copy code
```
git reset --hard v1.0
git push -f origin main
```

![alt text](<images-1/Screenshot from 2024-07-10 23-13-05.png>)


#### Extra Activities 

+ Stashing Changes:
- Make some local changes without committing:
```
echo "<p>Uncommitted changes</p>" >> src/index.html
```

+ Stash the changes:
```
git stash
```

+ Apply the stashed changes:
```
git stash apply
```

+ Viewing Commit History:
- Use git log to view commit history:
git log –oneline

![alt text](<images-1/Screenshot from 2024-07-10 23-22-01.png>)

+ Cherry-Picking Commits:
- Create a new branch and cherry-pick a commit from another branch:
```
git checkout -b feature/cherry-pick
git cherry-pick <commit-hash>
git push origin feature/cherry-pick
```

+ Interactive Rebase:
- Use interactive rebase to squash commits:
```
git checkout main
git rebase -i HEAD~3
```

![alt text](<images-1/Screenshot from 2024-07-10 23-28-45.png>)