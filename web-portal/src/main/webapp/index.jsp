<%@ include file="header.jsp" %>

<link href="<c:url value='/styles/clusterpies.css'/>" rel="stylesheet" type="text/css">

<h2>Yellow Rust Map</h2>

<div class="post-entry">
    <div id="map"></div>

    <br/>

    <div class="row">
        <div class="col-md-4">

            <div class="input-group">
               <span class="input-group-btn">

                   <button type="button" class="btn btn-default"
                           onclick="location.href='yellowrust-map/phenotype';">Phenotype Data
                   </button>
                <button type="button" class="btn btn-default"
                        onclick="genotype_view();">Genotype View
                </button>
                <button type="button" class="btn btn-default"
                        onclick="normal_view();">Normal View
                </button>
               </span>
            </div>
        </div>
        <div class="col-md-4">
            <div id="slider" style="margin-left:10px;margin-right:10px;z-index: 1000;"></div>
            <%--<div class="input-group">--%>
            <%--<input type="text" id="min" name="min" class="form-control" placeholder="Start Date" value=""/>--%>
            <%--<span class="input-group-btn" style="width:0px;"></span>--%>
            <%--<input type="text" id="max" name="max" class="form-control" placeholder="End Date" value=""--%>
            <%--style="margin-left:-1px"/>--%>
            <%--</div>--%>
        </div>

        <div class="col-md-4">

            <div class="input-group">
                <div id="yrselect"></div>
                <span class="input-group-btn ">
                <button type="button" class="btn btn-default"
                        onclick="ukcpvs_only();">UKCPVS Only
                </button>
                <button type="button" class="btn btn-default"
                        onclick="ukcpvs_and_all();">ALL
                </button>
                </span>
            </div>
        </div>
    </div>
    <br/>

    <div id="tableWrapper">
        <table id="resultTable"></table>
    </div>

    <div id="legend"></div>
    <div id="zoom">
        <div class="input-group">
               <span class="input-group-btn">
        <button type="button" class="btn btn-default"
                onclick="mapFitBounds([[49.781264,-7.910156],[61.100789, -0.571289]]);">Zoom UK
        </button>
        <button type="button" class="btn btn-default"
                onclick="mapFitBounds([[36.738884,-14.765625],[56.656226, 32.34375]]);">Zoom Europe
        </button>
               </span>
        </div>
    </div>
</div>

<script type="text/javascript">
    var pie_view = false;
    var yrtable;
    jQuery(document).ready(function () {
        $("#slider").dateRangeSlider({
            bounds: {
                min: new Date(2013, 0, 1),
                max: new Date(2014, 11, 31)
            },
            defaultValues: {
                min: new Date(2013, 0, 1),
                max: new Date(2014, 11, 31)
            }
        });
        displayYRLocations(sample_list_all);
        yrtable = $('#resultTable').DataTable({
            data: sample_list_all,
            "columns": [
                {data: "ID", title: "ID"},
                {data: "Country", title: "Country", "sDefaultContent": ""},
                {
                    title: "UKCPVS ID",
                    "render": function (data, type, full, meta) {
                        return phenotype_html_ukid(full['UKCPVS ID'], full['phenotype']);
                    }
                },
                {data: "Rust (YR/SR/LR)", title: "Rust Type", "sDefaultContent": "Unknown"},
                {data: "Name/Collector", title: "Collector", "sDefaultContent": ""},
                {data: "Date collected", title: "Date", "sDefaultContent": ""},
                {data: "Host", title: "Host", "sDefaultContent": ""},
                {data: "RNA-seq? (Selected/In progress/Completed/Failed)", title: "RNA-seq", "sDefaultContent": ""},
                {
                    title: "Phenotype",
                    "render": function (data, type, full, meta) {
                        return phenotype_html(full['UKCPVS ID'], full['phenotype']);
                    }
                },
                {
                    title: "Genotype",
                    "render": function (data, type, full, meta) {
                        if (full['genotype'] != undefined && full['genotype'] != "undefined") {
                            return full['genotype']['Genetic group'];
                        }
                        else {
                            return '';
                        }
                    }
                },
                {data: "Variety", title: "Variety", "sDefaultContent": ""},
                {data: "Company", title: "Company", "sDefaultContent": ""},
//                {data: "Town", title: "Town", "sDefaultContent": ""},
                {
                    title: "Location info",
                    "render": function (data, type, full, meta) {
                        return ((full["Further Location information"] == 'undefined' || full["Further Location information"] == undefined) ? '' : full["Further Location information"])
                               + ' '
                               + ((full["Postal code"] == 'undefined') || full["Postal code"] == undefined ? '' : full["Postal code"]);
                    }
                }
            ]
            ,
            initComplete: function () {
                var column = this.api().column(3);
                var select = $('<select class="form-control"><option value="">Select Rust Type</option></select>')
                        .appendTo($('#yrselect').empty())
                        .on('change', function () {
                                var val = $.fn.dataTable.util.escapeRegex(
                                        $(this).val()
                                );

                                column
                                        .search(val ? '^' + val + '$' : '', true, false)
                                        .draw();
                            });

                column.data().unique().sort().each(function (d, j) {
                    select.append('<option value="' + d + '">' + d + '</option>')
                });
            }

        });

        jQuery('#resultTable').on('search.dt', function () {
            removePointers();
            var filteredData = yrtable.rows({filter: 'applied'}).data().toArray();
            displayYRLocations(filteredData);
        });


        $("#slider").bind("valuesChanging", function (e, data) {
            datemin = Date.parse(data.values.min);
            datemax = Date.parse(data.values.max);

            yrtable.draw();
        });

//
//        $('#min, #max').datepicker({dateFormat: 'yy-mm-dd'});
//
//        $('#min').change(function () {
//            yrtable.draw();
//        });
//        $('#max').change(function () {
//            yrtable.draw();
//        });

        ukcpvs_only();
        mapFitBounds([[49.781264, -7.910156], [61.100789, -0.571289]]);
        renderLegend();

    });

    var datemin = 0;
    var datemax = 0;

    $.fn.dataTableExt.afnFiltering.push(
            function (oSettings, aData, iDataIndex) {
                var dateStart = datemin;
                var dateEnd = datemax;
//                    console.log(dateStart + " " + dateEnd);

                var evalDate = Date.parse(aData[5]);
//                    console.log(evalDate);

                    if (((evalDate >= dateStart && evalDate <= dateEnd) || (evalDate >= dateStart && dateEnd == 0)
                        || (evalDate >= dateEnd && dateStart == 0)) || (dateStart == 0 && dateEnd == 0)) {
//                if ((evalDate >= dateStart && evalDate <= dateEnd)) {
                    return true;
                }
                else {
                    return false;
                }

            });

    function ukcpvs_only() {
        var column = yrtable.column(2);
        column.search('^((?!Unknown).)*$', true, false).draw();
    }

    function ukcpvs_and_all() {
        var column = yrtable.column(2);
        column.search('').draw();
    }

    function genotype_view() {
        pie_view = true;
        renderLegend();
        var column = yrtable.column(9);
        column.search('^\\d$', true, false).draw();
    }

    function normal_view() {
        pie_view = false;
        renderLegend();
        var column = yrtable.column(9);
        column.search('').draw();
    }


    var markers = new Array();


    var markersGroup = new L.MarkerClusterGroup({
//        maxClusterRadius: 2 * 30,
//        iconCreateFunction: defineClusterIcon
    });

    var map = L.map('map').setView([52.621615, 10.219470], 5);

    L.tileLayer('http://otile1.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.jpg', {
        attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>',
        maxZoom: 18
    }).addTo(map);

    function displayYRLocations(array) {
        for (i = 0; i < array.length; i++) {
            var la = array[i]['location']['latitude'];
            var lo = array[i]['location']['longitude'];
            var geno = '';

            if (array[i]['genotype'] != undefined && array[i]['genotype'] != "undefined") {
                geno = array[i]['genotype']['Genetic group'];
            }

            var note = '<b>ID: </b>' + array[i]['ID'] + '<br/>'
                       + '<b>Country: </b>' + array[i]['Country'] + '<br/>'
                       + '<b>UKCPVS ID: </b>' + phenotype_html_ukid(array[i]['UKCPVS ID'], array[i]['phenotype']) + '<br/>'
                       + '<b>Rust Type: </b>' + array[i]['Rust (YR/SR/LR)'] + '<br/>'
                       + '<b>Collector: </b>' + array[i]['Name/Collector'] + '<br/>'
                       + '<b>Date collected: </b>' + array[i]['Date collected'] + '<br/>'
                       + '<b>Host: </b>' + array[i]['Host'] + '<br/>'
                       + '<b>RNA-seq: </b>' + array[i]['RNA-seq? (Selected/In progress/Completed/Failed)'] + '<br/>'
                       + '<b>Phenotype: </b>' + phenotype_html(array[i]['UKCPVS ID'], array[i]['phenotype']) + '<br/>'
                       + '<b>Genotype: </b>' + geno + '<br/>'
                       + '<b>Company: </b>' + array[i]['Company'] + '<br/>'
                       + '<b>Town: </b>' + array[i]['Town'] + '<br/>'
                       + '<b>Postal code: </b>' + array[i]['Postal code'] + '<br/>'
                       + '<b>Further Location info: </b>' + array[i]['Further Location information'];
            addPointer(la, lo, geno, note);
        }
    }

    function phenotype_html_ukid(id, phenotype) {
        if (id != undefined) {
            if (phenotype != undefined) {
                return '<u onclick="phenotype_colorbox(\'' + id + '\');" style="cursor: pointer;">' + id + '</u>';
            }
            else {
                return id;
            }
        }
        else {
            return "Unknown";
        }
    }

    function phenotype_html(id, phenotype) {
        if (id != undefined) {
            if (phenotype != undefined) {
                return '<u onclick="phenotype_colorbox(\'' + id + '\');" style="cursor: pointer;">' + id + '</u>';
            }
            else {
//                return "N/A";
                return "";
            }
        }
        else {
//            return "N/A";
            return "";
        }
    }

    function phenotype_colorbox(id) {
        var phynotype_data = phenotype(id);
        jQuery.colorbox({width: "80%", html: phynotype_data});
//        jQuery('#'+id).DataTable({
//            "fnDrawCallback": function() {
//                $(this).show();
//            }
//        });
    }

    function phenotype(id) {
        var phynotype_data = "";
        for (i = 0; i < sample_list_all.length; i++) {
            if (id == sample_list_all[i]['UKCPVS ID']) {
                phynotype_data = '<div style="margin:20px;">'
                                 + '<table id="' + id + '">'
                                 + '<thead><tr><th></th><th></th></tr></thead>'
                                 + '<tbody>'
                                 + '<tr><td>Batch: </td><td>' + sample_list_all[i]['phenotype']['Batch'] + '</td></tr>'
                                 + '<tr><td>No of isols tested: </td><td>' + sample_list_all[i]['phenotype']['No of isols tested'] + '</td></tr>'
                                 + '<tr><td>Isolate: </td><td>' + sample_list_all[i]['phenotype']['Isolate'] + '</td></tr>'
                                 + '<tr><td>Host: </td><td>' + sample_list_all[i]['phenotype']['Host'] + '</td></tr>'
                                 + '<tr><td>Chinese 166 Gene:1: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Chinese 166']) + '</tr>'
                                 + '<tr><td>Kalyansona Gene:2: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Kalyansona']) + '</tr>'
                                 + '<tr><td>Vilmorin 23 Gene:3a+: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Vilmorin 23']) + '</tr>'
                                 + '<tr><td>Nord Desprez Gene:3a+: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Nord Desprez']) + '</tr>'
                                 + '<tr><td>Hybrid 46 Gene:(3b)4b: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Hybrid 46']) + '</tr>'
                                 + '<tr><td>Heines Kolben Gene:2,6: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Heines Kolben']) + '</tr>'
                                 + '<tr><td>Heines Peko Gene:2,6: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Heines Peko']) + '</tr>'
                                 + '<tr><td>Lee Gene:7: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Lee']) + '</tr>'
                                 + '<tr><td>Av x Yr7 NIL Gene:7: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Av x Yr7 NIL']) + '</tr>'
                                 + '<tr><td>Compair Gene:8: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Compair']) + '</tr>'
                                 + '<tr><td>Kavkaz x 4 Fed Gene:9: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Kavkaz x 4 Fed']) + '</tr>'
                                 + '<tr><td>Clement Gene:9: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Clement']) + '</tr>'
                                 + '<tr><td>AVS x Yr 15 Gene:15: </td>' + divbgcolor(sample_list_all[i]['phenotype']['AVS x Yr 15']) + '</tr>'
                                 + '<tr><td>VPM 1 Gene:17: </td>' + divbgcolor(sample_list_all[i]['phenotype']['VPM 1']) + '</tr>'
                                 + '<tr><td>Rendezvous Gene:17: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Rendezvous']) + '</tr>'
                                 + '<tr><td>Av x Yr17 Gene:17: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Av x Yr17']) + '</tr>'
                                 + '<tr><td>Carstens V Gene:32: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Carstens V']) + '</tr>'
                                 + '<tr><td>Talon Gene:32: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Talon']) + '</tr>'
                                 + '<tr><td>Av x Yr32 Gene:32: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Av x Yr32']) + '</tr>'
                                 + '<tr><td>Spaldings Prolific Gene:sp: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Spaldings Prolific']) + '</tr>'
                                 + '<tr><td>Robigus Gene:Rob\': </td>' + divbgcolor(sample_list_all[i]['phenotype']['Robigus']) + '</tr>'
                                 + '<tr><td>Solstice Gene:\'Sol\': </td>' + divbgcolor(sample_list_all[i]['phenotype']['Solstice']) + '</tr>'
                                 + '<tr><td>Timber Gene:\'Tim\': </td>' + divbgcolor(sample_list_all[i]['phenotype']['Timber']) + '</tr>'
                                 + '<tr><td>Warrior Gene:War\': </td>' + divbgcolor(sample_list_all[i]['phenotype']['Warrior']) + '</tr>'
                                 + '<tr><td>KWS-Sterling Gene:Ste\': </td>' + divbgcolor(sample_list_all[i]['phenotype']['KWS-Sterling']) + '</tr>'
                                 + '<tr><td>Cadenza Gene:6 7: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Cadenza']) + '</tr>'
                                 + '<tr><td>Claire Gene:Claire: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Claire']) + '</tr>'
                                 + '<tr><td>Crusoe Gene:Crusoe: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Crusoe']) + '</tr>'
                                 + '<tr><td>Ambition Gene:Amb\': </td>' + divbgcolor(sample_list_all[i]['phenotype']['Ambition']) + '</tr>'
                                 + '<tr><td>Heines VII Gene:Yr2 Yr25+: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Heines VII']) + '</tr>'
                                 + '<tr><td>Suwon Omar Gene:Yr(Su): </td>' + divbgcolor(sample_list_all[i]['phenotype']['Suwon Omar']) + '</tr>'
                                 + '<tr><td>Avocet Yr5 Gene:Yr5: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Avocet Yr5']) + '</tr>'
                                 + '<tr><td>Avocet Yr6 Gene:Yr6: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Avocet Yr6']) + '</tr>'
                                 + '<tr><td>Moro Gene:Yr10: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Moro']) + '</tr>'
                                 + '<tr><td>Avocet Yr24 Gene:Yr24: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Avocet Yr24']) + '</tr>'
                                 + '<tr><td>Opata Gene:Yr27+: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Opata']) + '</tr>'
                                 + '<tr><td>Strubes Dickkopf Gene:YrSd Yr25: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Strubes Dickkopf']) + '</tr>'
                                 + '<tr><td>Avocet Yr27 Gene:Yr27: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Avocet Yr27']) + '</tr>'
                                 + '<tr><td>Apache Gene:7 17: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Apache']) + '</tr>'
                                 + '<tr><td>Vuka: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Vuka']) + '</tr>'
                                 + '<tr><td>Grenado: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Grenado']) + '</tr>'
                                 + '<tr><td>Benetto: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Benetto']) + '</tr>'
                                 + '<tr><td>Tradiro: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Tradiro']) + '</tr>'
                                 + '<tr><td>Tribeca: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Tribeca']) + '</tr>'
                                 + '<tr><td>Tulus: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Tulus']) + '</tr>'
                                 + '<tr><td>Dublet: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Dublet']) + '</tr>'
                                 + '<tr><td>KWS Fido: </td>' + divbgcolor(sample_list_all[i]['phenotype']['KWS Fido']) + '</tr>'
                                 + '<tr><td>Brigadier: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Brigadier']) + '</tr>'
                                 + '<tr><td>Stigg: </td>' + divbgcolor(sample_list_all[i]['phenotype']['Stigg']) + '</tr>'
                                 + '</tbody>'
                                 + '</table>'
                                 + '</div>';

            }
        }
        return phynotype_data;
    }

    //    function json_table(json) {
    //        var tr;
    //        for (var i = 0; i < json.length; i++) {
    //            tr = $('<tr/>');
    //            tr.append("<td>" + json[i].User_Name + "</td>");
    //            tr.append("<td>" + json[i].score + "</td>");
    //            tr.append("<td>" + json[i].team + "</td>");
    //            $('table').append(tr);
    //
    //        }
    //    }

    function makeTable() {
        makeYRJSON();
    }

    function divbgcolor(value) {
        if (parseFloat(value) < 1) {
            return "<td class='pheno_1 in_box'>" + value + "</td>";
        }
        if (parseFloat(value) >= 1 && parseFloat(value) < 2) {
            return "<td class='pheno_12 in_box'>" + value + "</td>";
        }
        if (parseFloat(value) >= 2 && parseFloat(value) < 3) {
            return "<td class='pheno_23 in_box'>" + value + "</td>";
        }
        if (parseFloat(value) >= 3) {
            return "<td class='pheno_3 in_box'>" + value + "</td>";
        }
        else {
            return "<td >" + value + "</td>";
        }
    }

    function addRandomPointer() {
        var la = randomNumberFromInterval(45, 60);
        var lo = randomNumberFromInterval(0, 25);

        addPointer(la, lo, "Hey, random! la: " + la + " lo: " + lo);
    }

    function addPointer(la, lo, geno, note) {
        var myClass = 'marker category-' + geno;
        var myIcon = L.divIcon({
            className: myClass,
            iconSize: null
        });
        var markerLayer;
        if (pie_view) {
            markerLayer = L.marker([la, lo], {title: geno, icon: myIcon}).bindPopup(note);
        }
        else {
            markerLayer = L.marker([la, lo], {title: geno}).bindPopup(note);
        }
        markers.push(markerLayer);
        markersGroup.addLayer(markerLayer);
        map.addLayer(markersGroup);
    }

    function removePointers() {
        map.removeLayer(markersGroup);
        if (pie_view) {
            markersGroup = new L.MarkerClusterGroup({
                maxClusterRadius: 2 * 30,
                iconCreateFunction: defineClusterIcon
            });
        }
        else {
            markersGroup = new L.MarkerClusterGroup();
        }
    }

    function removeTable() {
        jQuery('#resultTable').dataTable().fnDestroy();
        jQuery('#tableWrapper').html('<table id="resultTable"></table>');
    }

    function popup(msg) {
        L.popup()
                .setLatLng([52.621615, 8.219])
                .setContent(msg)
                .openOn(map);
    }

    function mapFitBounds(list) {
        map.fitBounds(list);
    }

    function randomNumberFromInterval(min, max) {
        return Math.random() * (max - min + 1) + min;
    }

    var rmax = 30;

    function defineClusterIcon(cluster) {
        var children = cluster.getAllChildMarkers(),
                n = children.length, //Get number of markers in cluster
                strokeWidth = 1, //Set clusterpie stroke width
                r = rmax - 2 * strokeWidth - (n < 10 ? 12 : n < 100 ? 8 : n < 1000 ? 4 : 0), //Calculate clusterpie radius...
                iconDim = (r + strokeWidth) * 2, //...and divIcon dimensions (leaflet really want to know the size)
                data = d3.nest() //Build a dataset for the pie chart
                        .key(function (d) {
                                 return d.options.title;
                             })
                        .entries(children, d3.map),
        //bake some svg markup
                html = bakeThePie({
                    data: data,
                    valueFunc: function (d) {
                        return d.values.length;
                    },
                    strokeWidth: 1,
                    outerRadius: r,
                    innerRadius: r - 10,
                    pieClass: 'cluster-pie',
                    pieLabel: n,
                    pieLabelClass: 'marker-cluster-pie-label',
                    pathClassFunc: function (d) {
                        return "category-" + d.data.key;
                    }
//                    ,
//                    pathTitleFunc: function (d) {
//                        return "path title";
//                    }
                }),
        //Create a new divIcon and assign the svg markup to the html property
                myIcon = new L.DivIcon({
                    html: html,
                    className: 'marker-cluster',
                    iconSize: new L.Point(iconDim, iconDim)
                });
        return myIcon;
    }

    function bakeThePie(options) {
        var data = options.data,
                valueFunc = options.valueFunc,
                r = options.outerRadius ? options.outerRadius : 28, //Default outer radius = 28px
                rInner = options.innerRadius ? options.innerRadius : r - 10, //Default inner radius = r-10
                strokeWidth = options.strokeWidth ? options.strokeWidth : 1, //Default stroke is 1
                pathClassFunc = options.pathClassFunc ? options.pathClassFunc : function () {
                    return '';
                }, //Class for each path
//                pathTitleFunc = options.pathTitleFunc ? options.pathTitleFunc : function () {
//                    return '';
//                }, //Title for each path
                pieClass = options.pieClass ? options.pieClass : 'marker-cluster-pie', //Class for the whole pie
                pieLabel = options.pieLabel ? options.pieLabel : d3.sum(data, valueFunc), //Label for the whole pie
                pieLabelClass = options.pieLabelClass ? options.pieLabelClass : 'marker-cluster-pie-label',//Class for the pie label

                origo = (r + strokeWidth), //Center coordinate
                w = origo * 2, //width and height of the svg element
                h = w,
                donut = d3.layout.pie(),
                arc = d3.svg.arc().innerRadius(rInner).outerRadius(r);

        //Create an svg element
        var svg = document.createElementNS(d3.ns.prefix.svg, 'svg');
        //Create the pie chart
        var vis = d3.select(svg)
                .data([data])
                .attr('class', pieClass)
                .attr('width', w)
                .attr('height', h);

        var arcs = vis.selectAll('g.arc')
                .data(donut.value(valueFunc))
                .enter().append('svg:g')
                .attr('class', 'arc')
                .attr('transform', 'translate(' + origo + ',' + origo + ')');

        arcs.append('svg:path')
                .attr('class', pathClassFunc)
                .attr('stroke-width', strokeWidth)
                .attr('d', arc)
//                .append('svg:title')
//                .text(pathTitleFunc)
        ;
        vis.append('text')
                .attr('x', origo)
                .attr('y', origo)
                .attr('class', pieLabelClass)
                .attr('text-anchor', 'middle')
                .attr('dy', '.3em')
                .text(pieLabel);
        return serializeXmlNode(svg);
    }

    function serializeXmlNode(xmlNode) {
        if (typeof window.XMLSerializer != "undefined") {
            return (new window.XMLSerializer()).serializeToString(xmlNode);
        }
        else if (typeof xmlNode.xml != "undefined") {
            return xmlNode.xml;
        }
        return "";
    }

    function renderLegend() {
        $('#legend').html('');
        if (pie_view) {
            var metajson = {
                "lookup": {
                    "1": "Genetic group 1",
                    "2": "Genetic group 2",
                    "3": "Genetic group 3",
                    "4": "Genetic group 4",
                    "5": "Genetic group 5"
//            ,
//            " ": "No Genotype"
                }
            };

            var data = d3.entries(metajson.lookup),
                    legenddiv = d3.select('#legend');

            var heading = legenddiv.append('div')
                    .classed('legendheading', true)
                    .text("Genotype");

            var legenditems = legenddiv.selectAll('.legenditem')
                    .data(data);

            legenditems
                    .enter()
                    .append('div')
                    .attr('class', function (d) {
                              return 'category-' + d.key;
                          })
                    .classed({'legenditem': true})
                    .text(function (d) {
                              return d.value;
                          });
        }
    }
</script>

<%@ include file="footer.jsp" %>