import themata

project = 'Exotic Libraries'
copyright = '2020, Exotic Libraries - MIT License'
author = 'Exotic Libraries Contributors'

html_theme_path = [themata.get_html_theme_path()]
html_theme = 'water'
master_doc = 'index'
html_favicon = 'assets/images/libcester/exoticlibs.png'
html_static_path = ['_static']
html_context = {
    'css_files': ['_static/css/exoticlibraries.css']
}
html_js_files = [
    'js/exoticlibraries.js',
]

extensions = ['m2r2', ]
source_suffix = ['.rst', '.md']

html_theme_options = {
    'navbar_links': [
        ('Libraries', 'pages/libraries'),
        ('Programs', 'pages/programs'),
        ('Blog', 'blog/index'),
        ('Style Guide', 'pages/style_guide'),
        ('Github', 'https://github.com/exoticlibraries/'),
        ('Support', 'pages/support')
    ],
    'has_left_sidebar': True,
    'show_navigators': True,
    'collapsible_sidebar_display': 'block',
    'collapsible_sidebar': True,
    'social_icons': [
        ('fab fa-twitter', 'https://twitter.com/exoticlibs'),
        ('fab fa-github', 'https://github.com/exoticlibraries/')
    ],
    'no_sidebar': [
        'pages/libraries',
        'pages/programs'
    ],
    "source_root": "https://github.com/exoticlibraries/exoticlibraries.github.io/edit/gh-pages/",
    "document_font_size": "15px",
    'header_background_color': '#0f6091',
    'menu_item_color': 'white',
    'highlight_color': '#8da6b5',
    'body_link_highlight_color': '#0f6091',
    "metadata": {
        "enable": True,
        "url": "https://exoticlibraries.github.io/",
        "type": "website",
        "title": "Exotic Libraries",
        "description": "A collection of cross-platform C and C++ libraries with guaranteed functionalities across various",
        "image": "https://avatars1.githubusercontent.com/u/57629577",
        "keywords": "thecarisma, c, cpp, c++, framework, exoticlibraries, exotic, libraries, networking",
        "author": "Adewale Azeez"
    },
    "twitter_metadata": {
        "enable": True,
        "card": "summary",
        "site": "@exoticlibs",
        "creator": "@iamthecarisma",
        "title": "Exotic Libraries",
        "description": "A collection of cross-platform C and C++ libraries with guaranteed functionalities across various",
        "image": "https://avatars1.githubusercontent.com/u/57629577",
    }
}
