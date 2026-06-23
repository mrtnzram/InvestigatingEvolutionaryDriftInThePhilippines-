from lingpy import *
from segments.tokenizer import Tokenizer

wl = Wordlist('lingpy_input_larger.tsv')
op = Tokenizer('lingpy_created_profile.tsv')
wl.add_entries('tokens', "ipa", op, column='IPA')
wl.output('tsv', filename='lingpy_foranalysis', ignore='all',
    prettify=False)
for idx, doculect, form, tokens in wl.iter_rows('doculet', 'ipa', 'tokens'):
    if form != tokens.replace(' ', ''):
        print('{0:10} {1:10} {2:15}'.format(doculect, form, tokens))
