from distutils.core import setup
setup(
  name = 'phrasemachine',
  packages = ['phrasemachine', 'phrasemachine.data'], # this must be the same as the name above
  version = '0.0.24',
  description = 'Gets phrases from text using part-of-speech tags',
  author = 'slanglab, University of Massachusetts, Amherst',
  author_email = 'abram.handler@gmail.com',
  url = 'https://github.com/slanglab/phrasemachine', # use the URL to the github repo
  download_url = 'https://github.com/slanglab/phrasemachine/tarball/0.0.24',
  keywords = ['nlp', 'nlproc'], # arbitrary keywords
  install_requires=['nltk'],
  classifiers = [],
  package_data={'phrasemachine.data': ['averaged_perceptron_tagger.pickle', 'punkt.english.pickle']},
)