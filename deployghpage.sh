
mkdir -p dist
ls
cd dist/
git clone -b gh-pages https://github.com/exoticlibraries/exoticlibraries.github.io.git
cd exoticlibraries.github.io/
ls ../
cp -r ../build/html/* ./
git config --local user.email "azeezadewale98@gmail.com"
git config --local user.name "travis-ci.org"
git add .; git commit -m "Travis build=${TRAVIS_BUILD_NUMBER}. Update Documentation from Travis CI"
git push https://Thecarisma:${GITHUB_TOKEN}@github.com/exoticlibraries/exoticlibraries.github.io.git HEAD:master;
cd ../