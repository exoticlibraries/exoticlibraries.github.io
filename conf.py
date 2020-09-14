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
    'css_files': ['_static/css/exoticlibraries.css']
}
html_js_files = [
    'js/exoticlibraries.js',
]

extensions = ['m2r2', ]
source_suffix = ['.rst', '.md']

html_theme_options = {
    'navbar_links': [
        ('Projects', 'pages/projects'),
        ('Blog', 'blog/index'),
        ('Style Guide', 'pages/style_guide'),
        ('Github', 'https://github.com/exoticlibraries/'),
        ('Support', '#')
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
        'pages/projects'
    ],
    "source_root": "https://github.com/exoticlibraries/exoticlibraries.github.io/blob/gh-pages/",
    "document_font_size": "15px",
    'header_background_color': '#0f6091',
    'menu_item_color': 'white',
    'highlight_color': '#8da6b5',
    'body_link_highlight_color': '#0f6091'
}
