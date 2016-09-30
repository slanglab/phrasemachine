from fabric.api import local

def deploy():
    local("git push --tags origin master")
    local("python setup.py sdist upload -r pypi")