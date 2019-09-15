#Robert Z. Selden, Jr. - HRC/SFASU
#processing workflow for Caddo and Toyah Perdiz points
#output Rmd for each Perdiz point and include contextual/qualitative attributes
require(devtools)
install_github("zarquon42b/Rvcg", local=FALSE)
library(Rvcg)
library(rgl)
#set working directory
setwd(getwd())
#load data
#processing (file)
#change the name of the file in each run as "x" and for the output names
x<-"stl/41HO166-Lot32.stl"
#import mesh
mesh<-vcgImport(x, updateNormals = TRUE, readcolor = FALSE, clean = TRUE, silent = FALSE)
#descriptive characteristics of mesh
#number of vertices and triangular faces
meshInfo(mesh)
#check for existance and validity of vertices, faces and vertex normals
meshintegrity(mesh, facecheck = TRUE, normcheck = TRUE)
#compute surface area of mesh
vcgArea(mesh, perface = FALSE)
#identify resolution of mesh for use as voxelSize in remesh
mres<-vcgMeshres(mesh)
#uniform remesh - use mesh resolution as voxelSize
remesh<-vcgUniformRemesh(mesh, voxelSize = mres$res)
#number of vertices and triangular faces after remesh
meshInfo(remesh)
#export as OFF to data3d folder
vcgOffWrite(remesh, filename = "data3d/41HO166-Lot32")
#export as ascii PLY to ply folder
vcgPlyWrite(remesh, filename = "ply/41HO166-Lot32", ascii = TRUE)
#decimate mesh
decimated<-vcgQEdecim(remesh, percent = 0.5)
#number of vertices and triangular faces after remesh
meshInfo(decimated)
#export as OFF to lowres file
vcgOffWrite(decimated, filename = "data3d/lowres/41HO166-Lot32")
#end of script