from fabric.api import local

# TODO: automate this part
# http://peterdowns.com/posts/first-time-with-pypi.html
# git tag 0.0.23 -m 0.0.23
# git push --tags origin master
# update setup.py in 2 places

def deploy():
    local("git push --tags origin master")
    local("python setup.py sdist")
    local("twine upload dist/phrasemachine-1.0.3.tar.gz")
