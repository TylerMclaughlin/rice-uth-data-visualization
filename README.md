# Workshop on Data Visualization 
@ UTHealth's Graduate School of Biomedical Science, June 02, 2017.
------------------------------------------------

Here is Tyler's code repository for the Workshop on Data Visualization at UTH Graduate School of Biomedical Sciences.

## Where to start?

If you want to preview the content covered in the workshop, see the file `lessonPreview.md`.  That file is a port of a more interactive version, hosted on shinyapps.io (https://rtylermclaughlin.shinyapps.io/shinyMarkdown/).

 If you're running through the tutorial, first clone this repository, then open `startHere.R` and begin writing code in this file while following along with the lesson.  This way, you won't have to modify the `source()` command because all folders will be in the correct place.  Later in the tutorial, you'll be asked to open a new .R file and Shiny app.

## How were these files made?

All code was written in RStudio.

`lessonPreview.md` was generated with the **Rmarkdown** file `codeForLessonPreview.Rmd` and the package **knitr**, for "elegant, flexible and fast dynamic report generation." (https://yihui.name/knitr/)

The interactive **Shiny Markdown** file (hosted on shinyapps.io) was made with **Shiny** and RStudio, and the code for its generation is in `shinyMarkdown.Rmd`.
