from fabric.api import local

# TODO: automate this part
# http://peterdowns.com/posts/first-time-with-pypi.html
# git tag 0.0.23 -m 0.0.23
# git push --tags origin master

def deploy():
    local("git push --tags origin master")
    local("python setup.py sdist upload -r pypi")