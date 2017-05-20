Workshop on Data Visualization
================
R Tyler McLaughlin
2017-05-20

**NOTE: this is just a preview of the full documentation. If you wish to view the interactive plots, please navigate to <https://rtylermclaughlin.shinyapps.io/shinyMarkdown/>. GitHub can't render interactive plots (shiny,Rbokeh) within a markdown (.md) file. For full documentation (while hosting lasts), please navigate to <https://rtylermclaughlin.shinyapps.io/shinyMarkdown/> **

Motivation for data visualization
=================================

Anscombe's quartet is a terrific example of the importance of plotting data points rather than reporting average values in bar chart format.
Load necessary packages for plotting and manipulating data:

``` r
# hashtags indicate comments.
# I.e., this line is not executable R code but a comment.
# load ggplot2 and data.table packages  
library("ggplot2")
library("data.table")
source('./code/dataVizUtil/R/functions.R')
```

Import the data set into a data.table:

``` r
anscombe <- data.table(read.csv('./data/anscombe.csv'))
```

What does this numerical data look like? Use this command to view the "head" of the data.table.

``` r
head(anscombe)
```

    ##    X d set  x    y
    ## 1: 1 1   1 10 8.04
    ## 2: 2 1   2 10 9.14
    ## 3: 3 1   3 10 7.46
    ## 4: 4 1   4  8 6.58
    ## 5: 5 2   1  8 6.95
    ## 6: 6 2   2  8 8.14

By plotting, you see that there are four, quite different data sets.
We can plot by running the following ggplot command.

``` r
# aes stands for a e s t h e t i c s.  This is a very important function!
# it tells ggplot what to plot and how to map it 
# to the geom_point() function.
# notice the ~ notation. 
ggplot(anscombe,aes(x=x,y=y) ) + geom_point() + facet_grid(~set)
```

![](githubRenderablePreview_files/figure-markdown_github/unnamed-chunk-4-1.png)

We can use the "color" argument of aes() assist visualization of complex data. Here, it's simply coloring by the number assigned to each data point. This makes it easier to see that each set in the quartet has 11 data points.

``` r
# color by the data point's number !     
ggplot(anscombe,aes(x = x,y = y,color = factor(d)) ) + geom_point() + facet_grid(~set)
```

![](githubRenderablePreview_files/figure-markdown_github/unnamed-chunk-5-1.png)

See what happens if you remove the `geom_point()` or `facet_grid()` terms.

Ok, We have four data sets that look quite different. How about the statistics?

<!-- ```{r} -->
<!-- #  add a linear fit.  "lm"  means "linear model"     -->
<!-- ggplot(anscombe,aes(x=x,y=y) ) + geom_point(aes(color = factor(d))) + geom_smooth(method = "lm") +  facet_grid(~set) -->
<!-- ``` -->
Let's manipulate data.tables, using their so-called "\[i, j, by\]" notation (this is derived from SQL). "i" refers to operations on rows and "j" refers to operations on columns. "by" means calculate "j" grouping by "by"

``` r
# .() means "as data.table"
# Stylistically, R often uses periods as spaces.
# Let's define new variables "my.Average.X" and "my.Average.Y"
anscombe[,.(my.Average.X = mean(x),my.Average.Y = mean(y)), by = "set"  ]
```

    ##    set my.Average.X my.Average.Y
    ## 1:   1            9     7.500909
    ## 2:   2            9     7.500909
    ## 3:   3            9     7.500000
    ## 4:   4            9     7.500909

That yielded the mean for x, which is the same for all sets. The same is also true for the mean for y. This is *not* a bug! Four distinct data sets look very different yet they are exactly the same **on average**.
This is part of what is special about Anscombe's quartet.

How about their standard deviation?

``` r
# The function 'sd' also does exactly what you'd expect
anscombe[,.(my.SD.X = sd(x),my.SD.Y = sd(y)), by = "set"  ]
```

    ##    set  my.SD.X  my.SD.Y
    ## 1:   1 3.316625 2.031568
    ## 2:   2 3.316625 2.031657
    ## 3:   3 3.316625 2.030424
    ## 4:   4 3.316625 2.030579

For nicer notation, you can also write:

``` r
anscombe[,.(my.SD.X = sd(x),my.SD.Y = sd(y)), .(set)  ]
```

Before we move on to another data set, let's compute the Pearson Product-Moment Correlation Coefficient (Pearson's r):

``` r
# the function cor()
anscombe[,.(my.XY.correlation = cor(x,y)), .(set)]
```

    ##    set my.XY.correlation
    ## 1:   1         0.8164205
    ## 2:   2         0.8162365
    ## 3:   3         0.8162867
    ## 4:   4         0.8165214

A Second Example
================

This example teaches several tricks for visualizing data that is more complex than Anscombe's quartet. This data set has a broad range of discrete variables (a pairwise contact map in protein sequence space) and associated continous variables.

The data set was generated with the *Gremlin* tool (<http://gremlin.bakerlab.org>) to predict 3D protein contacts from sequence data alone.
First *Gremlin* searches a protein database and collects homologous protein sequences from many organisms and computes a multiple sequence alignment.
It next uses an information-theoretical algorithm to tabulate how pairs of residues covary across homologs.
Residues with a strong tendency to co-evolve have a high probability of forming a contact in 3-dimensions.
Cool, right? Let's get on to visualizing.

Import your data again by first reading a file then converting it to the ***data.table*** format. This time, we're reading a .txt file, so we can use the function 'read.table'

``` r
dt.grd <- data.table(read.table('./data/gremlinContacts_962-1345.txt',header = TRUE))
head(dt.grd)
```

    ##      i   j  i_id  j_id  r_sco s_sco  prob
    ## 1: 280 291 280_F 291_N 0.1280 3.212 1.000
    ## 2: 103 234 103_G 234_Y 0.1145 2.872 1.000
    ## 3:  87  92  87_N  92_K 0.0907 2.275 0.998
    ## 4: 117 183 117_E 183_K 0.0894 2.243 0.998
    ## 5: 243 261 243_D 261_R 0.0872 2.189 0.997
    ## 6: 267 271 267_I 271_L 0.0760 1.906 0.989

data.tables in R make it *very* easy to manipulate data in numerous kinds of ways. Here we are adjusting the numbering scheme of the amino acid residues by adding the integer 961 to all residue numbers . ":=" translates roughly to "add *this* new column with *this* definition" <!-- FIX NAMING, because of the i,j notation-->

``` r
# fix amino acid numbering
dt.grd[,i := i+961]
dt.grd[,j := j+961]
```

`symmetrize()` is a custom function I built, which adds the mirror image of data along the x = y axis. Functions are called like this:

``` r
dt.grd.sym <- symmetrize(dt.grd)
```

Since this is a custom function, you can see what the function does by examining the code:

``` r
symmetrize
```

    ## function (your.dt) 
    ## {
    ##     inverted.dt <- copy(your.dt)
    ##     inverted.dt[, `:=`(c("j", "i"), .(i, j))]
    ##     inverted.dt[, `:=`(c("j_id", "i_id"), .(i_id, j_id))]
    ##     combined.dt <- rbind(your.dt, inverted.dt)
    ##     combined.dt <- combined.dt[order(-prob)]
    ## }

Many of these lines of code are data.table operations. This is an example of "*data munging*": that is, reshaping the organization of the data without changing the relationships in the data. Munging is a routine task in data analysis and data.tables is the best tool I've found for making this more tractable.

Let's try plotting this data with ggplot().

To avoid overplotting, let's filter the data, and plot the first 300 data points. We are filtering rows, so let's do this in data.table "i". We don't need to write commas if we are just specifying "i".

``` r
last.value <- 300
dt.filtered <- dt.grd.sym[1:last.value]
nrow(dt.filtered)
```

    ## [1] 300

``` r
# Note that in many cases, we can also put the 
# aes() function inside the geom_point()
ggplot(dt.filtered) + geom_point(aes(x = i,y = j,colour = -prob)) 
```

![](githubRenderablePreview_files/figure-markdown_github/unnamed-chunk-15-1.png)

This looks OK, but we can do a lot better. Recall that the figure axes are amino acid numbers. We may want to know the exact residue number, and that is not determinable by eye.

Let's try another package called "Rbokeh" and plot again. With the "hover" argument, it can report properties of the data point when you hover over it with your mouse. The "size" argument changes the size of the data points based on one of its associated values.

``` r
# load Rbokeh
library(rbokeh)
# ly_points function is like the geom_point function.
# we now have a "hover" argument that we can use.
ly_points(figure(),i,j,data = dt.filtered,size = 13*prob, hover = list(i,j))
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-b087d5c2f396c5983f85">{"x":{"elementid":"8a5752f298b1ff9781241ac7ca38a49c","modeltype":"Plot","modelid":"e6889403aee976f82e49144a0de04dbf","docid":"b9fabfeff1902a9b30eb422959b10043","docs_json":{"b9fabfeff1902a9b30eb422959b10043":{"version":"0.12.2","title":"Bokeh Figure","roots":{"root_ids":["e6889403aee976f82e49144a0de04dbf"],"references":[{"type":"Plot","id":"e6889403aee976f82e49144a0de04dbf","attributes":{"id":"e6889403aee976f82e49144a0de04dbf","sizing_mode":"scale_both","x_range":{"type":"Range1d","id":"327ef2bfac6d3f392fa9028a571c3486"},"y_range":{"type":"Range1d","id":"cf62cbbd84b27ae9de251d7d5b5f4d97"},"left":[{"type":"LinearAxis","id":"7c10c7ae8089d3bff08500e585cf5b0c"}],"below":[{"type":"LinearAxis","id":"721d501bf44a0709d8f50aaa0b5c07f2"}],"right":[],"above":[],"renderers":[{"type":"BoxAnnotation","id":"78179313fd700b1896a6bf90cd943aa4"},{"type":"GlyphRenderer","id":"9224634c7d9b0928e46f6dd8c8f3e57d"},{"type":"LinearAxis","id":"721d501bf44a0709d8f50aaa0b5c07f2"},{"type":"Grid","id":"52f8fa5392f7ee8ea4e0b2642221e786"},{"type":"LinearAxis","id":"7c10c7ae8089d3bff08500e585cf5b0c"},{"type":"Grid","id":"2a8d5be87ac69aeb02efe7826fb6da72"}],"extra_y_ranges":{},"extra_x_ranges":{},"tags":[],"min_border_left":4,"min_border_right":4,"min_border_top":4,"min_border_bottom":4,"lod_threshold":null,"toolbar":{"type":"Toolbar","id":"9fa627ec888eaa23d30b78faee7d5f03"},"tool_events":{"type":"ToolEvents","id":"60b1ff9bca0a0bc4720ae8440aae6c79"}},"subtype":"Figure"},{"type":"Toolbar","id":"9fa627ec888eaa23d30b78faee7d5f03","attributes":{"id":"9fa627ec888eaa23d30b78faee7d5f03","tags":[],"active_drag":"auto","active_scroll":"auto","active_tap":"auto","tools":[{"type":"PanTool","id":"080c40f83e6ffa7004a6748a17a38941"},{"type":"WheelZoomTool","id":"14981667f2642c987df95685d7b037de"},{"type":"BoxZoomTool","id":"b1a3b23b0162ab848c514f7ec8cdada6"},{"type":"ResetTool","id":"455f531a2b587f4a53c712419e2a1c8e"},{"type":"SaveTool","id":"cba19c64dc96adde2361afae41ad3584"},{"type":"HelpTool","id":"f8fe18462eb69ef2b1146a37a056102c"},{"type":"HoverTool","id":"73689b246b1577ef392a78052723ca16"}],"logo":null}},{"type":"PanTool","id":"080c40f83e6ffa7004a6748a17a38941","attributes":{"id":"080c40f83e6ffa7004a6748a17a38941","tags":[],"plot":{"type":"Plot","id":"e6889403aee976f82e49144a0de04dbf","subtype":"Figure"},"dimensions":["width","height"]}},{"type":"ToolEvents","id":"60b1ff9bca0a0bc4720ae8440aae6c79","attributes":{"id":"60b1ff9bca0a0bc4720ae8440aae6c79","tags":[]},"geometries":[]},{"type":"WheelZoomTool","id":"14981667f2642c987df95685d7b037de","attributes":{"id":"14981667f2642c987df95685d7b037de","tags":[],"plot":{"type":"Plot","id":"e6889403aee976f82e49144a0de04dbf","subtype":"Figure"},"dimensions":["width","height"]}},{"type":"BoxAnnotation","id":"78179313fd700b1896a6bf90cd943aa4","attributes":{"id":"78179313fd700b1896a6bf90cd943aa4","tags":[],"line_color":{"units":"data","value":"black"},"line_alpha":{"units":"data","value":1},"fill_color":{"units":"data","value":"lightgrey"},"fill_alpha":{"units":"data","value":0.5},"line_dash":[4,4],"line_width":{"units":"data","value":2},"level":"overlay","top_units":"screen","bottom_units":"screen","left_units":"screen","right_units":"screen","render_mode":"css"}},{"type":"BoxZoomTool","id":"b1a3b23b0162ab848c514f7ec8cdada6","attributes":{"id":"b1a3b23b0162ab848c514f7ec8cdada6","tags":[],"plot":{"type":"Plot","id":"e6889403aee976f82e49144a0de04dbf","subtype":"Figure"},"overlay":{"type":"BoxAnnotation","id":"78179313fd700b1896a6bf90cd943aa4"}}},{"type":"ResetTool","id":"455f531a2b587f4a53c712419e2a1c8e","attributes":{"id":"455f531a2b587f4a53c712419e2a1c8e","tags":[],"plot":{"type":"Plot","id":"e6889403aee976f82e49144a0de04dbf","subtype":"Figure"}}},{"type":"SaveTool","id":"cba19c64dc96adde2361afae41ad3584","attributes":{"id":"cba19c64dc96adde2361afae41ad3584","tags":[],"plot":{"type":"Plot","id":"e6889403aee976f82e49144a0de04dbf","subtype":"Figure"}}},{"type":"HelpTool","id":"f8fe18462eb69ef2b1146a37a056102c","attributes":{"id":"f8fe18462eb69ef2b1146a37a056102c","tags":[],"plot":{"type":"Plot","id":"e6889403aee976f82e49144a0de04dbf","subtype":"Figure"},"redirect":"http://hafen.github.io/rbokeh","help_tooltip":"Click to learn more about rbokeh."}},{"type":"HoverTool","id":"73689b246b1577ef392a78052723ca16","attributes":{"id":"73689b246b1577ef392a78052723ca16","tags":[],"plot":{"type":"Plot","id":"e6889403aee976f82e49144a0de04dbf","subtype":"Figure"},"renderers":[{"type":"GlyphRenderer","id":"9224634c7d9b0928e46f6dd8c8f3e57d"}],"names":[],"anchor":"center","attachment":"horizontal","line_policy":"prev","mode":"mouse","point_policy":"snap_to_data","tooltips":[["i","@hover_col_1"],["j","@hover_col_2"]]}},{"type":"ColumnDataSource","id":"40ccd1221e3fbe1f133f9e4729fe6d7d","attributes":{"id":"40ccd1221e3fbe1f133f9e4729fe6d7d","tags":[],"column_names":["x","y","size","hover_col_1","hover_col_2"],"selected":[],"data":{"x":[1241,1064,1252,1195,1048,1078,1053,1144,1204,1222,1228,1232,1325,1328,1254,1258,1242,1247,1046,1230,1245,1248,1237,1244,1199,1088,1203,1223,1076,1196,1142,1254,1075,1145,1328,1331,1198,1203,1233,1237,1223,1227,1285,1288,1145,1228,990,999,1223,1230,1273,980,1277,1017,1203,1225,1199,1236,1194,1233,1227,1245,991,995,1103,1106,1317,1325,1227,1248,1048,1168,994,999,1103,1107,980,985,1189,1237,1233,1236,1242,1252,1138,1067,1225,1152,1143,1254,984,988,1143,1147,1145,1222,1230,1252,1106,1114,1108,1113,1230,1165,1237,1270,1003,1049,1067,1167,1008,1192,1297,1201,1033,1230,1046,1072,1323,1330,1038,1309,1232,1259,1273,1278,1099,1103,971,1142,1154,1090,1327,1093,983,989,1116,1121,1019,1058,1026,1200,1046,1198,1137,1309,1147,1313,1141,1144,1245,1254,986,990,1056,1248,1188,1252,1194,1230,1072,1195,1197,1320,1060,997,1306,1076,1024,1283,1024,1208,1046,1193,1198,1236,1068,1131,1158,1195,1135,1279,1159,1165,1229,1235,1266,1190,1269,1208,1168,1270,1188,1266,980,989,1230,1233,1054,1229,1103,1110,1079,1156,1083,1160,1070,1300,1228,1303,1322,1154,1330,1268,1108,1328,1111,1334,966,1111,1193,1233,976,980,1066,1070,1161,1272,1017,1293,1149,1235,1200,1222,980,1018,990,993,1234,1248,1064,1068,1189,1193,1227,1230,1142,1160,1199,1229,1094,981,1139,1284,1030,1167,969,973,1017,1175,1021,1188,1048,1068,1018,1021,1090,980,1255,1094,1173,1269,965,1325,1118,1331,1098,1112,1048,1236,1011,1058,1015,1286,1015,1298,1146,1188,1193,1012,1234,1019,1193,1244,1258,980,1261,1095,1263,1271],"y":[1252,1195,1241,1064,1053,1144,1048,1078,1222,1204,1232,1228,1328,1325,1258,1254,1247,1242,1230,1046,1248,1245,1244,1237,1203,1223,1199,1088,1196,1076,1254,1142,1145,1075,1331,1328,1203,1198,1237,1233,1227,1223,1288,1285,1228,1145,999,990,1230,1223,1277,1017,1273,980,1225,1203,1236,1199,1233,1194,1245,1227,995,991,1106,1103,1325,1317,1248,1227,1168,1048,999,994,1107,1103,985,980,1237,1189,1236,1233,1252,1242,1225,1152,1138,1067,1254,1143,988,984,1147,1143,1222,1145,1252,1230,1114,1106,1113,1108,1237,1270,1230,1165,1049,1003,1167,1067,1297,1201,1008,1192,1230,1033,1072,1046,1330,1323,1309,1038,1259,1232,1278,1273,1103,1099,1142,971,1327,1093,1154,1090,989,983,1121,1116,1058,1019,1200,1026,1198,1046,1147,1313,1137,1309,1144,1141,1254,1245,990,986,1188,1252,1056,1248,1230,1194,1197,1320,1072,1195,1306,1076,1060,997,1283,1024,1208,1024,1193,1046,1236,1198,1195,1135,1279,1068,1131,1158,1165,1159,1235,1229,1269,1208,1266,1190,1270,1168,1266,1188,989,980,1233,1230,1229,1054,1110,1103,1083,1160,1079,1156,1228,1303,1070,1300,1330,1268,1322,1154,1111,1334,1108,1328,1111,966,1233,1193,980,976,1070,1066,1272,1161,1293,1017,1235,1149,1222,1200,1018,980,993,990,1248,1234,1068,1064,1193,1189,1230,1227,1160,1142,1229,1199,1139,1284,1094,981,1167,1030,973,969,1021,1188,1017,1175,1068,1048,1021,1018,1255,1094,1090,980,1269,1173,1118,1331,965,1325,1112,1098,1236,1048,1058,1011,1286,1015,1298,1015,1188,1146,1234,1019,1193,1012,1244,1193,1261,1095,1258,980,1271,1263],"size":[13,13,13,13,12.974,12.974,12.974,12.974,12.961,12.961,12.857,12.857,12.844,12.844,12.805,12.805,12.636,12.636,12.597,12.597,12.545,12.545,12.428,12.428,12.376,12.376,12.376,12.376,12.285,12.285,12.246,12.246,12.155,12.155,12.09,12.09,11.986,11.986,11.96,11.96,11.934,11.934,11.908,11.908,11.895,11.895,11.882,11.882,11.869,11.869,11.83,11.83,11.83,11.83,11.726,11.726,11.7,11.7,11.687,11.687,11.57,11.57,11.479,11.479,11.453,11.453,11.31,11.31,11.271,11.271,11.245,11.245,11.232,11.232,11.206,11.206,11.193,11.193,11.063,11.063,11.05,11.05,11.037,11.037,11.024,11.024,11.024,11.024,10.985,10.985,10.972,10.972,10.881,10.881,10.868,10.868,10.66,10.66,10.634,10.634,10.621,10.621,10.595,10.595,10.595,10.595,10.569,10.569,10.517,10.517,10.504,10.504,10.504,10.504,10.426,10.426,10.387,10.387,10.335,10.335,10.322,10.322,10.179,10.179,10.166,10.166,10.114,10.114,10.101,10.101,9.984,9.984,9.984,9.984,9.971,9.971,9.958,9.958,9.945,9.945,9.867,9.867,9.854,9.854,9.841,9.841,9.841,9.841,9.828,9.828,9.776,9.776,9.763,9.763,9.75,9.75,9.75,9.75,9.737,9.737,9.711,9.711,9.711,9.711,9.698,9.698,9.698,9.698,9.672,9.672,9.659,9.659,9.633,9.633,9.594,9.594,9.581,9.581,9.581,9.581,9.581,9.581,9.555,9.555,9.529,9.529,9.516,9.516,9.516,9.516,9.503,9.503,9.477,9.477,9.399,9.399,9.386,9.386,9.334,9.334,9.321,9.321,9.295,9.295,9.295,9.295,9.282,9.282,9.282,9.282,9.269,9.269,9.269,9.269,9.256,9.256,9.256,9.256,9.152,9.152,9.139,9.139,9.1,9.1,9.048,9.048,9.035,9.035,8.983,8.983,8.944,8.944,8.905,8.905,8.853,8.853,8.814,8.814,8.788,8.788,8.775,8.775,8.723,8.723,8.671,8.671,8.658,8.658,8.645,8.645,8.606,8.606,8.606,8.606,8.554,8.554,8.528,8.528,8.502,8.502,8.502,8.502,8.463,8.463,8.45,8.45,8.437,8.437,8.437,8.437,8.424,8.424,8.372,8.372,8.372,8.372,8.359,8.359,8.346,8.346,8.333,8.333,8.268,8.268,8.255,8.255,8.242,8.242,8.138,8.138,8.138,8.138,8.125,8.125,8.099,8.099,8.099,8.099,8.086,8.086],"hover_col_1":["1241","1064","1252","1195","1048","1078","1053","1144","1204","1222","1228","1232","1325","1328","1254","1258","1242","1247","1046","1230","1245","1248","1237","1244","1199","1088","1203","1223","1076","1196","1142","1254","1075","1145","1328","1331","1198","1203","1233","1237","1223","1227","1285","1288","1145","1228"," 990"," 999","1223","1230","1273"," 980","1277","1017","1203","1225","1199","1236","1194","1233","1227","1245"," 991"," 995","1103","1106","1317","1325","1227","1248","1048","1168"," 994"," 999","1103","1107"," 980"," 985","1189","1237","1233","1236","1242","1252","1138","1067","1225","1152","1143","1254"," 984"," 988","1143","1147","1145","1222","1230","1252","1106","1114","1108","1113","1230","1165","1237","1270","1003","1049","1067","1167","1008","1192","1297","1201","1033","1230","1046","1072","1323","1330","1038","1309","1232","1259","1273","1278","1099","1103"," 971","1142","1154","1090","1327","1093"," 983"," 989","1116","1121","1019","1058","1026","1200","1046","1198","1137","1309","1147","1313","1141","1144","1245","1254"," 986"," 990","1056","1248","1188","1252","1194","1230","1072","1195","1197","1320","1060"," 997","1306","1076","1024","1283","1024","1208","1046","1193","1198","1236","1068","1131","1158","1195","1135","1279","1159","1165","1229","1235","1266","1190","1269","1208","1168","1270","1188","1266"," 980"," 989","1230","1233","1054","1229","1103","1110","1079","1156","1083","1160","1070","1300","1228","1303","1322","1154","1330","1268","1108","1328","1111","1334"," 966","1111","1193","1233"," 976"," 980","1066","1070","1161","1272","1017","1293","1149","1235","1200","1222"," 980","1018"," 990"," 993","1234","1248","1064","1068","1189","1193","1227","1230","1142","1160","1199","1229","1094"," 981","1139","1284","1030","1167"," 969"," 973","1017","1175","1021","1188","1048","1068","1018","1021","1090"," 980","1255","1094","1173","1269"," 965","1325","1118","1331","1098","1112","1048","1236","1011","1058","1015","1286","1015","1298","1146","1188","1193","1012","1234","1019","1193","1244","1258"," 980","1261","1095","1263","1271"],"hover_col_2":["1252","1195","1241","1064","1053","1144","1048","1078","1222","1204","1232","1228","1328","1325","1258","1254","1247","1242","1230","1046","1248","1245","1244","1237","1203","1223","1199","1088","1196","1076","1254","1142","1145","1075","1331","1328","1203","1198","1237","1233","1227","1223","1288","1285","1228","1145"," 999"," 990","1230","1223","1277","1017","1273"," 980","1225","1203","1236","1199","1233","1194","1245","1227"," 995"," 991","1106","1103","1325","1317","1248","1227","1168","1048"," 999"," 994","1107","1103"," 985"," 980","1237","1189","1236","1233","1252","1242","1225","1152","1138","1067","1254","1143"," 988"," 984","1147","1143","1222","1145","1252","1230","1114","1106","1113","1108","1237","1270","1230","1165","1049","1003","1167","1067","1297","1201","1008","1192","1230","1033","1072","1046","1330","1323","1309","1038","1259","1232","1278","1273","1103","1099","1142"," 971","1327","1093","1154","1090"," 989"," 983","1121","1116","1058","1019","1200","1026","1198","1046","1147","1313","1137","1309","1144","1141","1254","1245"," 990"," 986","1188","1252","1056","1248","1230","1194","1197","1320","1072","1195","1306","1076","1060"," 997","1283","1024","1208","1024","1193","1046","1236","1198","1195","1135","1279","1068","1131","1158","1165","1159","1235","1229","1269","1208","1266","1190","1270","1168","1266","1188"," 989"," 980","1233","1230","1229","1054","1110","1103","1083","1160","1079","1156","1228","1303","1070","1300","1330","1268","1322","1154","1111","1334","1108","1328","1111"," 966","1233","1193"," 980"," 976","1070","1066","1272","1161","1293","1017","1235","1149","1222","1200","1018"," 980"," 993"," 990","1248","1234","1068","1064","1193","1189","1230","1227","1160","1142","1229","1199","1139","1284","1094"," 981","1167","1030"," 973"," 969","1021","1188","1017","1175","1068","1048","1021","1018","1255","1094","1090"," 980","1269","1173","1118","1331"," 965","1325","1112","1098","1236","1048","1058","1011","1286","1015","1298","1015","1188","1146","1234","1019","1193","1012","1244","1193","1261","1095","1258"," 980","1271","1263"]}}},{"type":"Circle","id":"dfa2fcb475c99081ea4b1d1f709ef6d8","attributes":{"id":"dfa2fcb475c99081ea4b1d1f709ef6d8","tags":[],"visible":true,"line_color":{"units":"data","value":"#1F77B4"},"fill_color":{"units":"data","value":"#1F77B4"},"line_alpha":{"units":"data","value":1},"fill_alpha":{"units":"data","value":0.5},"x":{"units":"data","field":"x"},"y":{"units":"data","field":"y"},"size":{"units":"screen","field":"size"}}},{"type":"Circle","id":"46b70cc06162e2348ec42ca6f4b24879","attributes":{"id":"46b70cc06162e2348ec42ca6f4b24879","tags":[],"visible":true,"line_color":{"units":"data","value":"#e1e1e1"},"fill_color":{"units":"data","value":"#e1e1e1"},"line_alpha":{"units":"data","value":1},"fill_alpha":{"units":"data","value":0.5},"x":{"units":"data","field":"x"},"y":{"units":"data","field":"y"},"size":{"units":"screen","field":"size"}}},{"type":"Circle","id":"0e4721b62d848846d07211b139e63a30","attributes":{"id":"0e4721b62d848846d07211b139e63a30","tags":[],"visible":true,"line_color":{"units":"data","value":"#1F77B4"},"fill_color":{"units":"data","value":"#1F77B4"},"line_alpha":{"units":"data","value":1},"fill_alpha":{"units":"data","value":1},"x":{"units":"data","field":"x"},"y":{"units":"data","field":"y"},"size":{"units":"screen","field":"size"}}},{"type":"GlyphRenderer","id":"9224634c7d9b0928e46f6dd8c8f3e57d","attributes":{"id":"9224634c7d9b0928e46f6dd8c8f3e57d","tags":[],"selection_glyph":null,"nonselection_glyph":{"type":"Circle","id":"46b70cc06162e2348ec42ca6f4b24879"},"hover_glyph":{"type":"Circle","id":"0e4721b62d848846d07211b139e63a30"},"name":null,"data_source":{"type":"ColumnDataSource","id":"40ccd1221e3fbe1f133f9e4729fe6d7d"},"glyph":{"type":"Circle","id":"dfa2fcb475c99081ea4b1d1f709ef6d8"}}},{"type":"Range1d","id":"327ef2bfac6d3f392fa9028a571c3486","attributes":{"id":"327ef2bfac6d3f392fa9028a571c3486","tags":[],"start":939.17,"end":1359.83}},{"type":"Range1d","id":"cf62cbbd84b27ae9de251d7d5b5f4d97","attributes":{"id":"cf62cbbd84b27ae9de251d7d5b5f4d97","tags":[],"start":939.17,"end":1359.83}},{"type":"LinearAxis","id":"721d501bf44a0709d8f50aaa0b5c07f2","attributes":{"id":"721d501bf44a0709d8f50aaa0b5c07f2","tags":[],"plot":{"type":"Plot","id":"e6889403aee976f82e49144a0de04dbf","subtype":"Figure"},"axis_label":"i","formatter":{"type":"BasicTickFormatter","id":"af977bb5c9611558c3e098a00606dbbb"},"ticker":{"type":"BasicTicker","id":"3db4de0502d7899209f33cd2d5f34cb2"},"visible":true,"axis_label_text_font_size":"12pt"}},{"type":"BasicTickFormatter","id":"af977bb5c9611558c3e098a00606dbbb","attributes":{"id":"af977bb5c9611558c3e098a00606dbbb","tags":[]}},{"type":"BasicTicker","id":"3db4de0502d7899209f33cd2d5f34cb2","attributes":{"id":"3db4de0502d7899209f33cd2d5f34cb2","tags":[],"num_minor_ticks":5}},{"type":"Grid","id":"52f8fa5392f7ee8ea4e0b2642221e786","attributes":{"id":"52f8fa5392f7ee8ea4e0b2642221e786","tags":[],"dimension":0,"plot":{"type":"Plot","id":"e6889403aee976f82e49144a0de04dbf","subtype":"Figure"},"ticker":{"type":"BasicTicker","id":"3db4de0502d7899209f33cd2d5f34cb2"}}},{"type":"LinearAxis","id":"7c10c7ae8089d3bff08500e585cf5b0c","attributes":{"id":"7c10c7ae8089d3bff08500e585cf5b0c","tags":[],"plot":{"type":"Plot","id":"e6889403aee976f82e49144a0de04dbf","subtype":"Figure"},"axis_label":"j","formatter":{"type":"BasicTickFormatter","id":"ad627ebd9a2a2bf0682b49bcdf97c62f"},"ticker":{"type":"BasicTicker","id":"7a42d12622ca26476e6be68a27bfb51a"},"visible":true,"axis_label_text_font_size":"12pt"}},{"type":"BasicTickFormatter","id":"ad627ebd9a2a2bf0682b49bcdf97c62f","attributes":{"id":"ad627ebd9a2a2bf0682b49bcdf97c62f","tags":[]}},{"type":"BasicTicker","id":"7a42d12622ca26476e6be68a27bfb51a","attributes":{"id":"7a42d12622ca26476e6be68a27bfb51a","tags":[],"num_minor_ticks":5}},{"type":"Grid","id":"2a8d5be87ac69aeb02efe7826fb6da72","attributes":{"id":"2a8d5be87ac69aeb02efe7826fb6da72","tags":[],"dimension":1,"plot":{"type":"Plot","id":"e6889403aee976f82e49144a0de04dbf","subtype":"Figure"},"ticker":{"type":"BasicTicker","id":"7a42d12622ca26476e6be68a27bfb51a"}}}]}}},"debug":false},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
    ## [1] "Rbokeh plots cannot be rendered on github markdown.  To see this plot, please navigate to https://rtylermclaughlin.shinyapps.io/shinyMarkdown/"

The `size`, `hover`, and `color` arguments are great ways of visualizing relatively **high-dimensional data**.

We can color with a **ramp**, aka color gradient, where we generate all the hues between two colors.

Let's first find out how many data points we have...

``` r
nrow(dt.filtered)
```

    ## [1] 300

Recall that we already defined a variable with this value, named `last.value`. It's good programming practice to frequently test that variables are equal before proceding while *assuming* they are equal.

``` r
# check to make sure 'last.value' 
# equals the number of data points, as expected.
#  '==' will always return TRUE or FALSE.  
last.value == nrow(dt.filtered)
```

    ## [1] TRUE

Next let's make a ramp with 300 colors.

``` r
ramp <- colorRampPalette(c("red", "blue"))(last.value)
length(ramp)
```

    ## [1] 300

``` r
# show the first 20 points of ramp
head(ramp,20)
```

    ##  [1] "#FF0000" "#FE0000" "#FD0001" "#FC0002" "#FB0003" "#FA0004" "#F90005"
    ##  [8] "#F90005" "#F80006" "#F70007" "#F60008" "#F50009" "#F4000A" "#F3000B"
    ## [15] "#F3000B" "#F2000C" "#F1000D" "#F0000E" "#EF000F" "#EE0010"

Great. Next, we'll color using our ramp.

We can also use the **pipe** syntax '%&gt;%' from the *magrittr* package to make the code more readable. This lets us pull the function `figure()` outside of the function `ly_points()` and place it upstream,
improving readability without damaging the results.

Pipes are useful when we have functions of functions of functions...

``` r
# illustrates piping and coloring by a ramp.
figure() %>%
  ly_points(i, j, data = dt.filtered,
            color = ramp, size = 13*prob,
            hover = list(i, j)) %>%
      x_range(c(957,1350)) %>%
      y_range(c(1350,957)) %>%
      x_axis(label = "amino acid j") %>%
      y_axis(label = "amino acid i")
```

    ## [1] "Rbokeh plots cannot be rendered on github markdown.  To see this plot, please navigate to https://rtylermclaughlin.shinyapps.io/shinyMarkdown/"

Above, we included axis labels and also flipped the data along the vertical axis by specifying the `x_range()`.

After clicking the mouse icon, try zooming in and out of the RBokeh plot with your mouse's scroll wheel.
Notice how the size of the data points adapts to the extent of the zoom, showcasing one of the many benefits of user interactivity. You could never do this on a TI-83 Plus.

colorRampPalette can take multiple colors as arguments. Try typing

``` r
?colorRampPalette()
```

to learn about the color-perceptual benefits of coloring your data this way.

<!-- # Making Highly Interactive Plots -->
This last section will show you how to make plots that plot different things depending on what you tell it. A great way of sharing your data with your collaborators who may not know R. Playing with a shiny app in browser is far easier even if they are familiar with R.

Every shiny app is made with a user interface and and a server file.

Take a standard R plot and wrap it in a `renderPlot()` function. Wrap an Rbokeh plot in a `renderRbokeh()` function.

The `selectInput()` and `sliderInput()` functions create the drop down menus and the slider input widgets that constitute the user interface and send data to the `renderRbokeh()`.

``` r
inputPanel(
  selectInput("color.1", label = "First color:",
              choices = c("red","orange","yellow",
                          "peachpuff","plum"),selected = "red"),
  selectInput("color.2", label = "Second color:",
              choices = c("blue","powderblue","skyblue4",
                          "turquoise2","snow3","steelblue2"),selected = "blue"),
  sliderInput("data.points", label = "Data points for plotting:",
              min = 50, max = 450, step = 25 , value = 300)
)
```

<!-- ```{r echo=FALSE} -->
<!-- renderRbokeh({dt.plot <- dt.grd.sym[1:input$data.points]  -->
<!--     # we need to define these agin so that  -->
<!--     # they are updated when the input changes -->
<!--     n <- nrow(dt.plot) -->
<!--     ramp <- colorRampPalette(c(input$color.1, input$color.2))(n) -->
<!--     p <- figure() %>% -->
<!--       ly_points(i, j, data = dt.plot, -->
<!--                 color = ramp, size = 13*prob, -->
<!--                 hover = list(i, j)) -->
<!--     p %>% -->
<!--       x_range(c(957,1350)) %>% -->
<!--       y_range(c(1350,957)) %>% -->
<!--       x_axis(label = "amino acid j") %>% -->
<!--       y_axis(label = "amino acid i") -->
<!-- }) -->
<!-- ``` -->
<!-- To get the figure to respond to the sliders, we also needed to code the following: -->
``` r
renderRbokeh({dt.plot <- dt.grd.sym[1:input$data.points]
    # we need to define these agin so that
    # they are updated when the input changes
    n <- nrow(dt.plot)
    ramp <- colorRampPalette(c(input$color.1, input$color.2))(n)
    p <- figure() %>%
      ly_points(i, j, data = dt.plot,
                color = ramp, size = 13*prob,
                hover = list(i, j))
    p %>%
      x_range(c(957,1350)) %>%
      y_range(c(1350,957)) %>%
      x_axis(label = "amino acid j") %>%
      y_axis(label = "amino acid i")


})
```

``` r
print(my.error)
```

    ## [1] "Rbokeh plots cannot be rendered on github markdown.  To see this plot, please navigate to https://rtylermclaughlin.shinyapps.io/shinyMarkdown/"

The major way in which the plotting code changed from before is that `colorRampPalette()` now takes two *variables*,`input$color.1` and `input$color.2` instead of fixed *strings*. We are also now filtering the length of the data.table with the parameter `input$data.points`.

RESUME HERE

Questions? Issues?
==================

send an email to <**rtylermclaughlin@gmail.com*>\*

<!-- ## Embedded Application -->
<!-- It's also possible to embed an entire Shiny application within an R Markdown document using the `shinyAppDir` function. This example embeds a Shiny application located in another directory: -->
<!-- ```{r tabsets, echo=FALSE} -->
<!-- shinyAppDir( -->
<!--   system.file("examples/06_tabsets", package = "shiny"), -->
<!--   options = list( -->
<!--     width = "100%", height = 550 -->
<!--   ) -->
<!-- ) -->
<!-- ``` -->
<!-- Note the use of the `height` parameter to determine how much vertical space the embedded application should occupy. -->
<!-- You can also use the `shinyApp` function to define an application inline rather then in an external directory. -->
<!-- In all of R code chunks above the `echo = FALSE` attribute is used. This is to prevent the R code within the chunk from rendering in the document alongside the Shiny components. -->
