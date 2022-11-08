mkdir repos
cd repos
#download new repos
curl -s https://api.github.com/users/s22f5/repos\?per_page\=100 | jq '.[].html_url' | xargs -n 1 git clone
#update existing repos
curl -s https://api.github.com/users/s22f5/repos\?per_page\=100 | jq '.[].html_url' | xargs -n 1 git fetch
#edit description file

cd ..



rm -Rvf htmldir/
mkdir htmldir
cd htmldir
#generate stagit
for d in `ls ../repos`	; do
    mkdir "$d"
    cp ../style.css $d/
    cp ../logo.png $d/
    cd "$d"
    curl -s https://api.github.com/search/repositories?q=$d+user:s22f5 | jq .[] | jq '.[].description' > ../../repos/$d/.git/description
    echo $PWD
    stagit ../../repos/$d
    cd ..
done
cp ../style.css ../htmldir/
cp ../logo.png ../htmldir/
stagit-index ../repos/* > ../htmldir/index.html
