import themata

project = 'Exotic Libraries'
copyright = '2020, Adewale Azeez, The Unlicense'
author = 'Adewale Azeez'

html_theme_path = [themata.get_html_theme_path()]
html_theme = 'water'
master_doc = 'index'
html_favicon = 'assets/images/libcester/exoticlibs.png'
html_static_path = ['_static']
html_context = {
    'css_files': ['_static/css/exoticlibraries.css'],
}

extensions = ['recommonmark']
source_suffix = {
    '.rst': 'restructuredtext',
    '.txt': 'markdown',
    '.md': 'markdown',
}

html_theme_options = {
    'navbar_links': [
        ('Why', '/pages/why'),
        ('Projects', '/pages/projects'),
        ('Style Guide', '/pages/style_guide'),
        ('Contribute on Github', 'https://github.com/exoticlibraries/'),
        ('Sponsor', '#')
    ],
    'has_left_sidebar': True,
    'show_navigators': True,
    'collapsible_sidebar': False,
    'social_icons': [
        ('fab fa-twitter', 'https://twitter.com/exoticlibs'),
        ('fab fa-github', 'https://github.com/exoticlibraries/')
    ],
    "source_root": "https://github.com/exoticlibraries/exoticlibraries.github.io/",
    "document_font_size": "17px",
    'header_background_color': '#728aa1',
    'menu_item_color': 'white'
}
