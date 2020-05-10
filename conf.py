import themata

project = 'Exotic Libraries'
copyright = '2020, Adewale Azeez, The Unlicense'
author = 'Adewale Azeez'

html_theme_path = [themata.get_html_theme_path()]
html_theme = 'sugar'
html_favicon = 'exoticlibs.png'
html_static_path = ['_static']
html_context = {
    'css_files': ['_static/css/exoticlibraries.css'],
}

html_theme_options = {
    'navbar_links': [
        ('Twitter', 'https://twitter.com/exoticlibs'),
        ('Contribute on Github', 'https://github.com/exoticlibraries/')
    ],
    'navbar_sec_links': [
        ('Home', './index.html'),
        ('Projects', './projects.html'),
        ('Licenses', './licenses.html')
    ],
    'has_left_sidebar': False,
    'has_right_sidebar': False,
    'show_navigators': False,
    'social_icons': [
        ('fab fa-twitter', 'https://twitter.com/exoticlibs'),
        ('fab fa-github', 'https://github.com/exoticlibraries/')
    ],
    #"github_source_root": "...",
    # the styles
    #"font_size": "16px",
    "text_color": "#4a4a4a"
}