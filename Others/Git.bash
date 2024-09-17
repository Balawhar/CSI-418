### Git --- Uploading to GitHub --------------------------------------

# Navigate to your files (repository)
cd path/to/your/local/repository

# Initialize as local Repository
git init


# Check Existing Remotes / If no remotes are listed, it means you haven't added any yet.
git remote -v

# Add Remote Repository / This command adds a remote named 'origin' with the specified URL
git remote add origin https://github.com/Balawhar/General_Repo.git

# Set Remote URL / This command updates the URL of the existing remote named 'origin
git remote set-url origin https://github.com/Balawhar/General_Repo.git

# Check Existing Remotes again / Verify the remote URL
git remote -v


# Specify files to upload

# One file
git add <filename>

# All Files
git add .


# Initial Commit with a message
git commit -m "Initial commit"

# Pushing to Remote: To push your local changes to the remote repository
git push -u origin master

# Commit the changes with a message
git commit -m "Updated files"

#==============================================================================
-- Remove latest remote
git remote remove origin

-- Fetching from latest Remote
git fetch origin

