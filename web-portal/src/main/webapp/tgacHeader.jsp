<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-gb">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=8"/>
    <title>The Genome Analysis Centre - Grassroots Genomics</title>


    <link rel="stylesheet" href="<c:url value='/styles/tgacstyle.css'/>" type="text/css">


    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>The Genome Analysis Centre | TGAC - Grassroots Genomics</title>
    <meta name="description" content="A world leading research Institute focussed on advancing bioscience by enabling and developing computational and genomics data-driven approaches in biology. National Capability funded by the BBSRC."/>
    <meta name="keywords" content="life science, research, computational biology, genome analysis, dna, genetics, biology, plant science, vertebrate health, genomics, bioinformatics, health genomics, sequencing, genome sequencing, high performance computing, HPC" />
    <meta name="author" content="The Genome Analysis Centre" />
    <link rel="shortcut icon" href="http://www.tgac.ac.uk/newimages/favicon.ico" type="image/x-icon"/>
    <link href="http://www.tgac.ac.uk/newBBSRCbanner/styles/bbsrcbanner.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="http://www.tgac.ac.uk/newBBSRCbanner/styles/tooltip/tooltipscript.js"></script>
    <META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE"/>
    <link href="http://www.tgac.ac.uk/newBBSRCbanner/styles/tooltip/tooltip.css" rel="stylesheet" type="text/css" media="all" />
    <meta property="twitter:account_id" content="4503599629548295" />
    <link rel="alternate" type="application/rss+xml" title="News Feed" href="http://www.tgac.ac.uk/feeds/news.rss
" />

    <script type="text/javascript">
        <!--
        P7_opTTM('id:bbsrcmenu','id:institutes','p7TTM02',4,240,5,0,1,0,5,0,300,0,1,1,1);
        //-->
    </script>

    <style type="text/css">
        @-moz-document url-prefix() {
            .menu_div {
                margin-top: 20px ! important;
            }
        }
    </style>

    <!--[if IE]>
    <style type="text/css">
        .menu_div {
            margin-top: 20px ! important;
        }
    </style>

    <![endif]-->

    <script type="text/javascript" src="http://www.tgac.ac.uk/newnavmenu/p7PMMscripts.js"></script>

    <script type="text/javascript" src="<c:url value='/scripts/scriptaculous/prototype.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/scripts/fluxion-ajax/fluxion-ajax-compiled.js?ts=${timestamp.time}'/>"></script>

    <%--<!-- bootstrap -->--%>
    <%--<script src="<c:url value='/scripts/bootstrap/bootstrap.min.js?ts=${timestamp.time}'/>" type="text/javascript"></script>--%>
    <%--<link href="<c:url value='/scripts/bootstrap/css/bootstrap.min.css'/>" rel="stylesheet" type="text/css">--%>

    <%--<!--Scriptaculous JS scripts below -->--%>
    <%--<script type="text/javascript" src="<c:url value='/scripts/scriptaculous/scriptaculous.js'/>"></script>--%>
    <%--<script type="text/javascript" src="<c:url value='/scripts/scriptaculous/activityInput.js'/>"></script>--%>
    <%--<script type="text/javascript" src="<c:url value='/scripts/scriptaculous/effects.js'/>"></script>--%>
    <%--<script type="text/javascript" src="<c:url value='/scripts/scriptaculous/unittest.js'/>"></script>--%>
    <%--<script type="text/javascript" src="<c:url value='/scripts/scriptaculous/dragdrop.js'/>"></script>--%>
    <%--<script type="text/javascript" src="<c:url value='/scripts/scriptaculous/slider.js'/>"></script>--%>
    <%--<script type="text/javascript" src="<c:url value='/scripts/scriptaculous/builder.js'/>"></script>--%>
    <%--<script type="text/javascript" src="<c:url value='/scripts/scriptaculous/sound.js'/>"></script>--%>
    <%--<script type="text/javascript" src="<c:url value='/scripts/scriptaculous/controls.js'/>"></script>--%>

    <!-- jQuery -->
    <script type="text/javascript" src="<c:url value='/scripts/jquery/js/jquery-1.4.2.min.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/scripts/jquery/js/jquery-ui-1.8.custom.min.js'/>"></script>
    <%--<script type="text/javascript" src="<c:url value='/scripts/jquery/js/jquery.simplyCountable.js'/>"></script>--%>
    <%--<script type="text/javascript" src="<c:url value='/scripts/jquery/js/jquery.tinysort.min.js'/>"></script>--%>
    <%--<script type="text/javascript" src="<c:url value='/scripts/jquery/js/jquery.tablesorter.min.js'/>"></script>--%>
    <%--<script type="text/javascript" src="<c:url value='/scripts/jquery/js/jquery.uitablefilter.js'/>"></script>--%>
    <%--<script type="text/javascript" src="<c:url value='/scripts/jquery/js/jquery.validate.min.js'/>"></script>--%>
    <script type="text/javascript" src="<c:url value='/scripts/jquery/colorbox/jquery.colorbox-min.js'/>"></script>
    <link rel="stylesheet" href="<c:url value='/scripts/jquery/css/smoothness/jquery-ui-1.8.custom.css'/>"
          type="text/css">
    <link rel="stylesheet" href="<c:url value='/scripts/jquery/colorbox/colorbox.css'/>"
          type="text/css">


    <!-- wis -->
    <script type="text/javascript" src="<c:url value='/scripts/wis.js?ts=${timestamp.time}'/>"></script>
    <script type="text/javascript" src="<c:url value='/scripts/external.js?ts=${timestamp.time}'/>"></script>
    <script type="text/javascript" src="<c:url value='/scripts/search.js?ts=${timestamp.time}'/>"></script>
    <script>
        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
        })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

        ga('create', 'UA-21666189-10', 'auto');
        ga('send', 'pageview');

    </script>
</head>
<body>

<div id="BBSRCwrapper">
    <div id="bbsrc_bar"> <a href="http://www.bbsrc.ac.uk" target="_blank"><img src="http://www.tgac.ac.uk/newBBSRCbanner/images/bbsrc-transparent.png" alt="Visit the BBSRC website (opens in a new window)" width="137" height="27" class="img" /></a>
        <p class="tagline">The Genome Analysis Centre receives strategic funding from the BBSRC</p>
    </div>
    <div id="bbsrc_bar_rightside">
        <div id="menu" class="menu">
            <ul>
                <li><a href="http://www.bbsrc.ac.uk/organisation/institutes/institutes-of-bbsrc.aspx" target="_blank" class="tooltip p7TTM_trg" id="bbsrcmenu">BBSRC Institutes</a></li>
            </ul>
        </div>
        <div id="bbsrcrss"><a class="bbsrcrss" href="http://feeds.feedburner.com/bbsrc" target="_blank"><img src="http://www.tgac.ac.uk/newBBSRCbanner/images/bbsrc-news-transparent.png" alt="BBSRC News feed" width="70" height="30" /></a></div>
    </div>
</div>
<div class="all_content">
    <div class="midcontent">

        <a href="http://www.tgac.ac.uk/"><img src="http://www.tgac.ac.uk/v2images/tgac_logo_single.png" class="tgac_logo" border="0"/></a>
        <div class="header">
            <div class="header_right">
                <div class="searchbar">

                    <form id="cntnt01moduleform_1" method="get" action="http://www.tgac.ac.uk/" class="cms_form">
                        <div class="hidden">
                            <input type="hidden" name="mact" value="Search,cntnt01,dosearch,0" />
                            <input type="hidden" name="cntnt01returnid" value="15" />
                        </div>

                        <label for="cntnt01searchinput">Search:&nbsp;</label><input type="text" class="search-input" id="cntnt01searchinput" name="cntnt01searchinput" size="20" maxlength="50" value="Site Search..." onfocus="if(this.value==this.defaultValue) this.value='';" onblur="if(this.value=='') this.value=this.defaultValue;"/>
                        <input class="search-button" name="submit" value="Go" type="submit" />
                        <input type="hidden" id="cntnt01origreturnid" name="cntnt01origreturnid" value="382" />
                    </form>

                </div>
                <div class="social_links">
                    <a href="http://www.linkedin.com/company/558283" target="_blank"><img src="http://www.tgac.ac.uk/newimages/linkedin_logo.jpg" alt="Lindedin" border="0"></a>&nbsp;
                    <a href="https://www.facebook.com/pages/The-Genome-Analysis-Centre/153811441346365" target="_blank"><img src="http://www.tgac.ac.uk/newimages/facebook.jpg" alt="Facebook" border="0"></a>&nbsp;
                    <a href="http://twitter.com/#!/GenomeAnalysis" target="_blank"><img src="http://www.tgac.ac.uk/newimages/twitter.jpg" alt="Twitter" border="0"></a>
                </div>
            </div>
            <div class="header_email">
                Tel: <span class="layer_2">
      +44 1603 450861</span><br/>
                Email <span class="layer_2">
      : <a href="mailto:tgac.enquiries@tgac.ac.uk">tgac.enquiries@tgac.ac.uk</a></span>
            </div>
            <div class = "header_left">
                Building Excellence in <br/>
                Genomics and Computational Bioscience
            </div>
        </div>
        <div class="clearer">
        </div>

        <div class="menu_div">


            <div class="menu_item">
                <a href="http://www.tgac.ac.uk/">Home</a></div>


            <img src="http://www.tgac.ac.uk/v2images/divider_single.png" class="menu_divider"/>
            <div class="menu_item">
                <a href="http://www.tgac.ac.uk/about">About Us</a></div>



            <img src="http://www.tgac.ac.uk/v2images/divider_single.png" class="menu_divider"/>
            <div class="menu_item">
                <a href="http://www.tgac.ac.uk/science-faculty">Science Faculty</a></div>



            <img src="http://www.tgac.ac.uk/v2images/divider_single.png" class="menu_divider"/>
            <div class="menu_item">
                <a href="http://www.tgac.ac.uk/national-capability">National Capability</a></div>



            <img src="http://www.tgac.ac.uk/v2images/divider_single.png" class="menu_divider"/>
            <div class="menu_item">
                <a href="http://www.tgac.ac.uk/projects">Projects</a></div>



            <img src="http://www.tgac.ac.uk/v2images/divider_single.png" class="menu_divider"/>
            <div class="menu_item">
                <a href="http://www.tgac.ac.uk/361_Division">Scientific Training, Education &amp; Learning</a></div>



            <img src="http://www.tgac.ac.uk/v2images/divider_single.png" class="menu_divider"/>
            <div class="menu_item">
                <a href="http://www.tgac.ac.uk/knowledge-exchange">External Relations</a></div>



            <img src="http://www.tgac.ac.uk/v2images/divider_single.png" class="menu_divider"/>
            <div class="menu_item">
                <a href="http://www.tgac.ac.uk/our-organisation">Organisation</a></div>



            <img src="http://www.tgac.ac.uk/v2images/divider_single.png" class="menu_divider"/>
            <div class="menu_item">
                <a href="http://www.tgac.ac.uk/open-access">Open Access</a></div>



            <img src="http://www.tgac.ac.uk/v2images/divider_single.png" class="menu_divider"/>
            <div class="menu_item">
                <a href="http://www.tgac.ac.uk/news">News</a></div>



            <img src="http://www.tgac.ac.uk/v2images/divider_single.png" class="menu_divider"/>
            <div class="menu_item">
                <a href="http://www.tgac.ac.uk/careers">Careers</a></div>



            <img src="http://www.tgac.ac.uk/v2images/divider_single.png" class="menu_divider"/>
            <div class="menu_item">
                <a href="http://www.tgac.ac.uk/contact-us">Contact Us</a></div>

        </div>
        <div class="clearer">
        </div>
        <div class="background_image">
            <div class="layer_123">
                <div class="subpage_strapline">
                    Cereal genomics for sustainable agriculture
                </div>
            </div>

            <img src="http://www.tgac.ac.uk/uploads/images/icons/plants_icon.png" class="bioinformatics_logo"/>	  <div class="clearer">
        </div>
        </div>
        <div class="layer_124">
            <div class="layer_126">

                <div class="work_with_tgac_inverted ui-corner-all" onclick="window.location.href='http://www.tgac.ac.uk/how-we-work'">
                    Project Enquiries
                </div>
                <div class="work_with_tgac ui-corner-all" onclick="window.location.href='http://www.tgac.ac.uk/grassroots-genomics/'">
                    Grassroots Genomics
                </div>
                <div class="work_with_tgac ui-corner-all" onclick="window.location.href='http://www.tgac.ac.uk/fellowship/'">
                    TGAC Fellowships
                </div>
                <div class="ui-corner-all work_with_tgac">
                    <div class="work_with_tgac-title" onclick="window.location.href='http://www.tgac.ac.uk/science-faculty/tgac-science-symposia-2015/'">Science Symposia 2015
                    </div>
                </div>
                <div class="work_with_tgac ui-corner-all" onclick="window.location.href='http://www.tgac.ac.uk/tools-resources/'">Tools & Resources</div>
                <div id="newsletter_trigger" class="work_with_tgac ui-corner-all" onclick="window.location.href='http://www.tgac.ac.uk/newsletter/'">
                    TGAC Newsletter
                </div>
                <div class="twitter">
                    <a class="twitter-timeline" data-dnt="true" href="https://twitter.com/GenomeAnalysis" data-widget-id="347380014754439168">TGAC Tweets</a>



                    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>

                </div>
                <img style="margin: 10px 5px 10px 10px;" src="http://www.tgac.ac.uk/uploads/images/participant-excellence-impact.png"/>

                <img style="margin: 10px 5px 10px 10px;" src="http://www.tgac.ac.uk/uploads/images/GFX/nib-logo.png" alt="National Institutes of Bioscience Logo" />

            </div>
            <img src="http://www.tgac.ac.uk/v2images/vertical_line_single.png" class="vertical_line" style="margin-right:10px;"/>
            <div class="main_content">