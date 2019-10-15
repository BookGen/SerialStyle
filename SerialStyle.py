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
		include_after = metadata.blocks(doc, 'include-after')
		include_after.extend(footer(doc))
		doc.metadata['include-after'] = MetaBlocks(*include_after)


def main(doc=None):
	return run_filter(action, doc=doc, prepare=prepare, finalize=finalize)

if __name__ == '__main__':
	main()