#!/usr/bin/env python3

from panflute import *
from helper import *

def defines(doc):
	result = [RawInline('% SerialStyle Metadata %', format='latex')]
	for name, command in [
		('SerialStyle.publicationdetails', 'publicationdetailsinfo'),
	]:
		value = []
		data = doc.get_metadata(name, builtin=False)
		if isinstance(data, MetaList):
			for item in data:
				value.extend(content.inlines(item, doc))
		else:
			value.extend(content.inlines(data, doc))
		result.extend([
			RawInline('\n\\renewcommand{\\' + command + '}', format='latex'),
			Span(*value)
		])
	return result

'''
def nav(doc):
	links = []
	for path, name in [
		('index', metadata.inlines(doc, 'localization-type-index', 'Contents')),
		('first', metadata.inlines(doc, 'SerialStyle.localization-nav-first', 'First Chapter')),
		('last', metadata.inlines(doc, 'SerialStyle.localization-nav-last', 'Latest Chapter')),
		('biblio', metadata.inlines(doc, 'localization-type-biblio', 'Bibliography')),
		('repository', metadata.inlines(doc, 'SerialStyle.localization-nav-repository', 'Source'))
	]:
		value = metadata.text(doc, path)
		if value:
			links.append(Link(
				*name,
				url=value + '#BookGen.main' if value[0] == '.' else value,
				identifier='SerialStyle.nav.' + path
			))
	value = metadata.text(doc, 'download')
	if value:
		links.append(Link(
			*metadata.inlines(doc, 'SerialStyle.localization-nav-download', 'Download'),
			url=doc.get_metadata('download'),
			attributes={'download': 'download'},
			identifier='SerialStyle.nav.download'
		))
	return [
		RawBlock('<nav id="SerialStyle.nav">', format='html'),
		BulletList(*map(lambda link: ListItem(Plain(link)), links)),
		RawBlock('</nav>', format='html')
	]
'''

def header(doc):
	header = [RawBlock('<header id="SerialStyle.header">', format='html')]
	for path, proc in [
		('series', lambda n: [RawBlock('<p id="SerialStyle.series">', format='html'), Plain(*n), RawBlock('</p>', format='html')]),
		('title', lambda n: [RawBlock('<p id="SerialStyle.title"><cite>', format='html'), Plain(Link(*n, url=metadata.text(doc, 'homepage'))) if doc.get_metadata('homepage') else Plain(*n), RawBlock('</cite></p>', format='html')]),
		('author', lambda n: [RawBlock('<p id="SerialStyle.author">', format='html'), Plain(Link(*n, url=metadata.text(doc, 'profile'))) if doc.get_metadata('profile') else Plain(*n), RawBlock('</p>', format='html')])
		]:
			value = metadata.inlines(doc, path)
			if value:
				header.extend(proc(value))
	header.append(RawBlock('</header>', format='html'))
	return header

def footer(doc):
	result = [RawBlock('<footer id="SerialStyle.footer">', format='html')]
	result.extend(metadata.blocks(doc, 'SerialStyle.publicationdetails'))
	result.extend([
		Para(
			Str('Book design by '),
			Link(Str('KIBI Gô'), url='https://go.KIBI.family/'),
			Str('.')
		),
		Para(
			Str('This work was generated with '),
			Link(Str('SerialStyle'), url='https://github.com/marrus-sh/SerialStyle'),
			Str('+'),
			Link(Str('BookGen'), url='https://github.com/marrus-sh/BookGen'),
			Str('.')
		)
	])
	result.append(RawBlock('</footer>', format='html'))
	return result

def style_vars(doc):
	result = ''
	for name, varname in [
		('SerialStyle.colour.white', '--SerialStyle-Colour-White'),
		('SerialStyle.colour.bright', '--SerialStyle-Colour-Bright'),
		('SerialStyle.colour.light', '--SerialStyle-Colour-Light'),
		('SerialStyle.colour.regular', '--SerialStyle-Colour-Regular'),
		('SerialStyle.colour.medium', '--SerialStyle-Colour-Medium'),
		('SerialStyle.colour.dark', '--SerialStyle-Colour-Dark'),
		('SerialStyle.colour.dim', '--SerialStyle-Colour-Dim'),
		('SerialStyle.colour.black', '--SerialStyle-Colour-Black')
	]:
		value = metadata.text(doc, name)
		if value:
			result += varname + ': ' + value + '; '
	return result

def prepare(doc):
	pass

def action(elem, doc):
	pass

def finalize(doc):
	doc.metadata['style'] = MetaString('Serial ' + metadata.text(doc, 'style'))
	if doc.format == 'latex':
		header_includes = metadata.blocks(doc, 'header-includes')
		header_includes.append(Plain(*defines(doc)))
		doc.metadata['header-includes'] = MetaBlocks(*header_includes)
	elif doc.format in ['html', 'html5']:
		value = metadata.text(doc, 'next')
		if (value):
			doc.content.append(Plain(Link(
				*metadata.inlines(doc, 'SerialStyle.localization-next', [Str('Next Chapter.')]),
				url=value + '#BookGen.main' if value[0] == '.' else value,
				identifier='SerialStyle.main.next'
			)))
		doc.content = [
			RawBlock('\n<!-- BEGIN BODY -->\n<article>', format='html'),
			Div(*doc.content, identifier='SerialStyle.main'),
			RawBlock('</article>\n<!-- END BODY -->\n', format='html')
		]
		header_includes = metadata.blocks(doc, 'header-includes')
		header_includes.append(RawBlock('<style>html { ' + style_vars(doc) + '}</style>', format='html'))
		doc.metadata['header-includes'] = MetaBlocks(*header_includes)
		if metadata.text(doc, 'type') == 'index':
			include_before = metadata.blocks(doc, 'include-before')
			include_before.extend(header(doc))
			doc.metadata['include-before'] = MetaBlocks(*include_before)
		include_after = metadata.blocks(doc, 'include-after')
		include_after.extend(footer(doc))
		doc.metadata['include-after'] = MetaBlocks(*include_after)


def main(doc=None):
	return run_filter(action, doc=doc, prepare=prepare, finalize=finalize)

if __name__ == '__main__':
	main()