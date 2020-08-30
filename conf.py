import themata

project = 'Exotic Libraries'
copyright = '2020, Adewale Azeez, The Unlicense'
author = 'Adewale Azeez'

html_theme_path = [themata.get_html_theme_path()]
html_theme = 'sugar'
master_doc = 'index'
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
        ('Why', './why.html'),
        ('Projects', './projects.html')
    ],
    'has_left_sidebar': False,
    'has_right_sidebar': False,
    'show_navigators': False,
    'social_icons': [
        ('fab fa-twitter', 'https://twitter.com/exoticlibs'),
        ('fab fa-github', 'https://github.com/exoticlibraries/')
    ],
    "source_root": "https://github.com/exoticlibraries/exoticlibraries.github.io/",
    "document_font_size": "17px",
    "text_color": "rgb(205,202,194)",
    "link_color": "rgb(205,202,194)",
    "highlight_color": "rgb(15,110,157)",
    "header_background_color": "rgb(52,55,58)",
    "background_color": "rgb(24,26,27)",
    "pre_background_color": "rgb(24,26,27)",
    "pre_border_color": "rgb(84,91,98)"
}
