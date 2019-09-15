3D processing and export for Perdiz arrow points
================
Robert Z. Selden, Jr.
September 15, 2019

## Data collection and load Rvcg

Scans were collected at the Heritage Research Center at Stephen F.
Austin State University using a NextEngineHD running ScanStudioPRO in
Summer 2019. Meshes were trimmed, aligned, merged, and polished in
ScanStudioPRO prior to export. Additional processing steps enlist the
Rvcg package, and are detailed below.

All unprocessed 3D data used in this project are available for download
on the Open Science Framework (OSF). Processed 3D data were uploaded to
Zenodo, and links to each processed scan are included on the OSF page.
Citations are included in the article for OSF and Zenodo content.

``` r
#mesh processing prior to analysis
require(devtools)
```

    ## Loading required package: devtools

    ## Loading required package: usethis

``` r
install_github("zarquon42b/Rvcg")
```

    ## Skipping install of 'Rvcg' from a github remote, the SHA1 (93ebf0a6) has not changed since last install.
    ##   Use `force = TRUE` to force installation

``` r
library(Rvcg)
library(rgl)
#set working directory
setwd(getwd())
```

## Processing and export for Perdiz point

Load data to R

``` r
#processing (file)
x<-"stl/41HO166-Lot32.stl"
#import mesh
mesh<-vcgImport(x, updateNormals = TRUE, readcolor = FALSE, clean = TRUE, silent = FALSE)
```

    ## Removed 2324854 duplicate 0 unreferenced vertices and 0 duplicate faces

Identify mesh attributes

``` r
#descriptive characteristics of mesh
#number of vertices and triangular faces
meshInfo(mesh)
```

    ## mesh has 464,948 vertices and 929,892 triangular faces

``` r
#check for existance and validity of vertices, faces and vertex normals
meshintegrity(mesh, facecheck = TRUE, normcheck = TRUE)
```

    ##  mesh3d object with 464948 vertices, 929892 triangles and 0 quads.

``` r
#compute surface area of mesh
vcgArea(mesh, perface = FALSE)
```

    ## [1] 915.7612

Identify mesh resolution

``` r
#identify resolution of mesh for use as voxelSize in remesh
mres<-vcgMeshres(mesh)
#histogram of average edge length
hist(mres$edgelength)
#visualize average edge length on graph
points(mres$res, 1000, pch=20, col=2, cex=2)
```

![](procperdiz_files/figure-gfm/resolution-1.png)<!-- -->

Perform uniform remesh using mesh resolution as voxel size

``` r
#uniform remesh
remesh<-vcgUniformRemesh(mesh, voxelSize = mres$res)
```

    ##      Resampling mesh using a volume of 418 x 777 x 420
    ##      VoxelSize is 0.048741, offset is 0.000000
    ##      Mesh Box is 13.181245 30.698952 13.312244

Identify mesh attributes and export OFF and PLY

``` r
#number of vertices and triangular faces after remesh
meshInfo(remesh)
```

    ## mesh has 550,540 vertices and 1,101,076 triangular faces

``` r
#export as OFF to data3d folder for use with auto3dgm
vcgOffWrite(remesh, filename = "data3d/41HO166-Lot32")
#export as PLY to ply folder for use with landmark geometric morphometrics
vcgPlyWrite(remesh, filename = "ply/41HO166-Lot32", ascii = TRUE)
```

Decimate, identify mesh attributes, and export lowres OFF

``` r
#decimate mesh
decimated<-vcgQEdecim(remesh, percent = 0.25)
```

    ## reducing it to 275269 faces
    ## Initial Heap Size 1651497
    ## Result: 137636 vertices and 275268 faces.
    ## Estimated error: 3.33345e-12

``` r
#number of vertices and triangular faces after remesh
meshInfo(decimated)
```

    ## mesh has 137,636 vertices and 275,268 triangular faces

``` r
#export as OFF to lowres file for use with auto3dgm
vcgOffWrite(decimated, filename = "data3d/lowres/41HO166-Lot32")
#end of script
```
