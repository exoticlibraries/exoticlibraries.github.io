

// Just the top 5 entries only
const LatestBlogPosts = [
    {
        "title": "Installation Scripts",
        "excerpt": `The purpose of the script is to be able to download, build (when needed), and install the library without any hassle at all using remote scripts.
        Currently, the script can only install headers only libraries from github.`,
        "date": "08 February, 2021",
        "link": "/blog/Feb-2021/magic_scripts.html",
        "image": "https://miro.medium.com/max/700/1*U-R58ahr5dtAvtSLGK2wXg.png"
    },
    {
        "title": "Hello World",
        "excerpt": `The first blog under exotic libraries, each blog is writtent in markdown and the webpage 
        is generated with sphinx. The list of all blog post is on the Blog page. 
        
        Each article can contain all markdown supported features plus raw HTML syntax along side the 
        markdown features.`,
        "date": "13 September, 2020",
        "link": "/blog/Sep-2020/hello_world.html",
        "image": "https://raw.githubusercontent.com/Thecarisma/Cronux/main/docs/cronux.png"
    }
];


const LatestReleases = [
    {
        "project": "libcester",
        "version": "v0.3",
        "date": "6 September, 2020",
        "link": "https://github.com/exoticlibraries/libcester/releases/tag/v0.3"
    },
    {
        "project": "libcester",
        "version": "v0.2",
        "date": "20 May, 2020",
        "link": "https://github.com/exoticlibraries/libcester/releases/tag/v0.2"
    }
];

window.addEventListener('load', function () {
    injectBlogSidemenu();
});


function treatLandingVariables() {
    //blog posts
    var count = 0;
    for (var blog of LatestBlogPosts) {
        var blogHTML = `
        <div class="featured-blog">
            <a class="heading" href="${blog.link}">${blog.title}</a>
            <p>
                ${blog.excerpt}
            </p>
            <span class="date">${blog.date}</span>
        </div>
        `;
        
        if (count > 2) { break; }
        document.getElementById("featured-blogs").innerHTML += blogHTML;
        count++;
    }
    
    //new releases
    var count = 0;
    for (var release of LatestReleases) {
        var releaseHTML = `<div> <a class="heading" target="_blank" href="${release.link}">${release.project} ${release.version} - ${release.date}</a></div>`;
        
        if (count > 10) { break; }
        document.getElementById("new-releases").innerHTML += releaseHTML;
        count++;
    }

    if (navigator.platform.indexOf('Win') > -1) {
        let event = {
            currentTarget: document.getElementById("windows-install-button")
        };
        openInstallTab(event, 'windows-install-content');
    }
}

function injectBlogSidemenu() {
    var leftSideBar = document.getElementsByClassName("sidebar-left");
    if (leftSideBar.length === 0) { return; }
    leftSideBar = leftSideBar[0];
    var blogSidebarElement = `<p class="caption"><span class="caption-text">Blog</span></p>
    <ul>`;
    var count = 0;
    for (var blog of LatestBlogPosts) {
        if (count > 9) { break; }
        blogSidebarElement += `<li class="toctree-l1"><a class="reference internal" href="${blog.link}">${blog.title}</a></li>`;
        count++;
    }
    blogSidebarElement += '</ul>';
    

    leftSideBar.innerHTML += blogSidebarElement;
}

function openInstallTab(evt, name) {
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("install-tab-content");
    for (i = 0; i < tabcontent.length; i++) {
      tabcontent[i].style.display = "none";
    }
    tablinks = document.getElementsByClassName("install-tablinks");
    for (i = 0; i < tablinks.length; i++) {
      tablinks[i].className = tablinks[i].className.replace(" active", "");
    }
    document.getElementById(name).style.display = "block";
    evt.currentTarget.className += " active";
}
