from fabric.api import local

# TODO: automate this part
# instructions here
# https://web.archive.org/web/20170301004430/http://peterdowns.com/posts/first-time-with-pypi.html
# 1. get the latest tag => git tag -l | tail -1
# 2. increment => git tag 0.0.23 -m 0.0.23
# 3. git push --tags origin master
# 4. update setup.py in 2 places => download_url and version
# 5. manually update the version in deploy below
# 6. $fab deploy

def test():
    local("pytest tests/")


def deploy():
    local("git push --tags origin master")
    local("python setup.py sdist")
    local("twine upload dist/phrasemachine-1.0.4.tar.gz")
