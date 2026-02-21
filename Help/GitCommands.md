# 1. Update the existing 'origin' to point to your correct GitHub link
git remote set-url origin https://github.com/kumar603/DevOps_CICDRandD.git

# 2. Ensure all files are staged
git add .

# 3. Commit with the correct flag (-m for message)
git commit -m "Initial Code check in for testing CICD"

# 4. Ensure your branch is named 'main'
git branch -M main

# 5. Push your code to GitHub
git push -u origin main



# 1. Stage the changes (prepare them)
git add .

# 2. Commit the changes (save them with a message)
git commit -m "Updated API message to test CI/CD pipeline"

# 3. Push to GitHub (this triggers the automation)
git push
