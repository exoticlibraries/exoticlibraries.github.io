
# Home

<div class="header">
    <img src="https://avatars1.githubusercontent.com/u/57629577" alt="libcester logo"><br/><br/>
    <span class="title">Exotic Libraries</span><br/>
    <p class="brief">
        A collection of cross-platform C and C++ libraries.
    </p>
    <div class="install-section">
        <div class="install-tab">
            <button class="install-tablinks border-radius-top-left active" onclick="openInstallTab(event, 'unix-install-content')">Linux, MAC and Unix</button>
            <button class="install-tablinks" id="windows-install-button" onclick="openInstallTab(event, 'windows-install-content')">Windows</button>
            <button class="install-tablinks border-radius-top-right" onclick="openInstallTab(event, 'vcpkg-install-content')">vcpkg</button>
        </div>
        <div class="install-tab-content" id="unix-install-content">
            bash <(curl -s https://exoticlibraries.github.io/magic/install.sh) --all
        </div>
        <div class="install-tab-content display-none" id="windows-install-content">
            Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://exoticlibraries.github.io/magic/install.ps1')) --All
        </div>
        <div class="install-tab-content display-none" id="vcpkg-install-content">
            ./vcpkg libcester libxtd libmetaref
        </div>
    </div>
    <div class="linksdiv">
        <a class="link" href="./pages/support.html">Support</a>
        <a class="link" href="./pages/contribute.html">Contribute</a>
        <a class="link" href="./pages/style_guide.html">Style Guide</a>
    </div>
</div>
<div style="margin-top:520px;"></div>

<div class="two-sided">
    <div class="left-side">
        <h3 class="title">New Releases</h3>
        <br/>
        <div id="new-releases">
        </div>
    </div>
    <div class="right-side">
        <h3 class="title">From the blog</h3>
        <br/>
        <div id="featured-blogs">
        </div>
    </div>
</div>

# <span style="display:table;margin:0 auto;margin-top:100px;">Featured Libraries</span>

<div class="all-projects" style="justify-content: center;">
<div class="project main-project">
    <img class="logo" style="max-width: 100px;max-height: 100px;" src="https://avatars1.githubusercontent.com/u/57629577" alt="libxtd logo">
    <br/><span class="title">libxtd</span>
    <hr class="project-rule"/>
    <p class="description">
        Collection of generic data structures and algorithms for C.
    </p>
    <div class="bottomer">
        <span class="tech-used">ANSI C</span><br>
        <div class="links">
            <a target="_blank" href="https://github.com/exoticlibraries/libxtd">Github <i class="fas fa-external-link-alt"></i></a> 
            <a target="_blank" href="https://exoticlibraries.github.io/libxtd">Website <i class="fas fa-external-link-alt"></i></a> 
        </div>
    </div>
</div>

<div class="project main-project">
    <img class="logo" style="max-width: 100px;max-height: 100px;" src="https://raw.githubusercontent.com/exoticlibraries/libcester/main/docs/libcester.png" alt="libcester logo">
    <br/><span class="title">libcester</span>
    <hr class="project-rule"/>
    <p class="description">
        A robust header only unit testing framework for C and C++ programming language. Support function mocking, memory leak detection, crash report.
    </p>
    <div class="bottomer">
        <span class="tech-used">ANSI C</span><br>
        <div class="links">
            <a target="_blank" href="https://github.com/exoticlibraries/libcester">Github <i class="fas fa-external-link-alt"></i></a> 
            <a target="_blank" href="https://exoticlibraries.github.io/libcester">Website <i class="fas fa-external-link-alt"></i></i></a> 
        </div>
    </div>
</div>

<div class="project main-project">
    <img class="logo" style="max-width: 100px;max-height: 100px;" src="https://raw.githubusercontent.com/exoticlibraries/libmetaref/main/docs/libmetaref.png" alt="libmetaref logo">
    <br/><span class="title">libmetaref</span>
    <hr class="project-rule"/>
    <p class="description">
        Reflection for C Struct. Runtime introspection and intercession for struct fields, supports struct and field annotation.
    </p>
    <div class="bottomer">
        <span class="tech-used">C99</span><br>
        <div class="links">
            <a target="_blank" href="https://github.com/exoticlibraries/libmetaref">Github <i class="fas fa-external-link-alt"></i></a> 
            <a target="_blank" href="https://exoticlibraries.github.io/libmetaref">Website <i class="fas fa-external-link-alt"></i></i></a> 
        </div>
    </div>
</div>
</div>

<a class="reference navigator" style="display:table;margin:0 auto;padding:10px 40px 10px 40px;" href="./pages/libraries.html"> View All Libraries </a>

# <span style="display:table;margin:0 auto;margin-top:100px;">Featured Applications</span>

<div class="all-projects" style="justify-content: center;">

</div>

<a class="reference navigator" style="display:table;margin:0 auto;padding:10px 40px 10px 40px;" href="./pages/libraries.html"> View All Libraries </a>
<script>treatLandingVariables();</script>