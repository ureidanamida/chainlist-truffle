rsync -r src/ docs/
rsync build/contracts/Chainlist.json docs/
git add .
git commit -m "adding frontend files to Github pages"
git push
