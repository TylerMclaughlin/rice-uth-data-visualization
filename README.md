# Workshop on Data Visualization 
@ UTHealth's Graduate School of Biomedical Science, June 02, 2017.
------------------------------------------------

Here is Tyler's code repository for the Workshop on Data Visualization at UTH Graduate School of Biomedical Sciences.

## Where to start?

If you want to preview the content covered in the workshop, see the file `lessonPreview.md`.  That file is a port of a more interactive version, hosted on shinyapps.io (https://rtylermclaughlin.shinyapps.io/shinyMarkdown/).

## Installation and Setup

This tutorial assumes you have the newest version of RStudio.  If you don't have it, get it here: https://www.rstudio.com

### Getting materials
 To run through the tutorial, first clone this repository (click the green button that says `Clone or download` then click `Download zip`).  Next, unzip the directory (non-Mac OS X users only.  Mac OS X unzips automatically.) 
 
 ### Setting up RStudio

 Open the file within the folder you just cloned called `startHere.R` in RStudio and begin writing code in this file while following along with the lesson (via `lessonPreview.md` or the shinyapp.io page). 
 
Make sure to set the working directory to this file's location by clicking the dropdown menus at the top of Rstudio:
 `Session > Set Working Directory > To Source File Location`    
 
  ### Installing dependencies: data visualization packages
 
 This part of the tutorial was where R beginners were most likely to struggle.
 
 Make sure you install all of the data visualization packages covered in this tutorial *first* by running the lines of code `install.packages('package.name.here')`.    This code is included in `startHere.R`, but you will need to delete the hashtags (#).  
 
 Pro tip:  Use Command + Enter to execute (run) a single line of code or highlighted stretches of code in RStudio.  
 
 You only need to run these lines of code *once ever* to install the packages, so feel free to re-comment them out with a `#` or simply delete them.  If your installation worked, you should be able to run the following without an error:
 
 ``` r
 library('ggplot2')
library('data.table')
library('Rbokeh')
```
At this point, configuration for a data visualization pipeline is finished and you are ready begin the tutorial.
 
## How was this tutorial made?

All code was written in RStudio.

`lessonPreview.md` was generated with the **Rmarkdown** file `codeForLessonPreview.Rmd` and the package **knitr**, for "elegant, flexible and fast dynamic report generation." (https://yihui.name/knitr/)

The interactive **Shiny Markdown** file (hosted on shinyapps.io) was made with **Shiny** and RStudio, and the code for its generation is in `shinyMarkdown.Rmd`.
