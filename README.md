
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
            & $([scriptblock]::Create((New-Object Net.WebClient).DownloadString("https://exoticlibraries.github.io/magic/install.ps1"))) --All
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

# <span style="display:table;margin:0 auto;margin-top:0px;">Featured Libraries</span>

<div class="all-projects" style="_justify-content: center;">
<div class="project main-project">
    <img class="logo" style="max-width: 100px;max-height: 100px;" src="https://raw.githubusercontent.com/exoticlibraries/libxtd/main/docs/libxtd.png" alt="libxtd logo">
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

<div class="all-projects" style="_justify-content: center;">
<div class="project main-project">
	<img class="logo" src="https://raw.githubusercontent.com/exoticlibraries/exotic-action/main/exotic-action.png" alt="Exotic Action logo">
	<br/><span class="title">Exotic Action</span>
	<hr class="project-rule"/>
	<p class="description">
		Download exotic libraries into your C/C++ GitHub Action environment. Also, run regression testing on your project.
	</p>
	<div class="bottomer">
		<span class="tech-used">JavaScript</span><br>
		<div class="links">
			<a target="_blank" href="https://github.com/exoticlibraries/exotic-action">Github <i class="fas fa-external-link-alt"></i></a> 
			<a target="_blank" href="https://github.com/marketplace/actions/exotic-action">Website <i class="fas fa-external-link-alt"></i></i></a> 
		</div>
	</div>
</div>
<div class="project main-project">
	<img class="logo" src="https://raw.githubusercontent.com/Thecarisma/Cronux/main/docs/cronux.png" alt="Exotic libraries logo">
	<br/><span class="title">Installation Scripts</span>
	<hr class="project-rule"/>
	<p class="description">
		Download exotic libraries or any headers only libraries hosted on github without any prerequisite using remote bash and powershell scripts.
	</p>
	<div class="bottomer">
		<span class="tech-used">Bash, Powershell</span><br>
		<div class="links">
			<a target="_blank" href="https://github.com/exoticlibraries/exoticlibraries.github.io/tree/main/magic">Github <i class="fas fa-external-link-alt"></i></a> 
			<a href="https://exoticlibraries.github.io/blog/Feb-2022/magic_scripts.html">Website <i class="fas fa-external-link-alt"></i></i></a> 
		</div>
	</div>
</div>
</div>

<a class="reference navigator" style="display:table;margin:0 auto;padding:10px 40px 10px 40px;" href="./pages/programs.html"> View All Programs </a>

<!--<div class="two-sided">
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
</div>-->

<div>
	<h3 class="title">From the blog</h3>
	<br/>
	<div id="featured-blogs">
	</div>
</div>

<script>treatLandingVariables();</script>