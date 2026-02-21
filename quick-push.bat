@echo off
REM Helper script to quick-push changes to GitHub

echo ---------------------------------------------------
echo 🚀 QUICK PUSH: Staging, Committing, and Pushing...
echo ---------------------------------------------------

git add .
git commit -m "Auto-update from Quick Push script"
git push

echo.
echo ✅ Done! GitHub Actions has been triggered.