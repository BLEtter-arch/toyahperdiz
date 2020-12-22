#Robert Z. Selden, Jr.,HRC/SFASU, and Bonnie Etter, SMU
#processing workflow for Toyah Perdiz points
#output Rmd for each Perdiz point and include contextual/qualitative attributes
require(devtools)
#install_github("zarquon42b/Rvcg", local=FALSE)
library(Rvcg)
library(rgl)
#set working directory
setwd(getwd())
#load data
#processing (file)

dir.create("newply")
dir.create("data3D/lowres", recursive = TRUE)

processmesh <- function(x){

#import mesh
mesh<-vcgImport(x, updateNormals = TRUE, readcolor = FALSE, clean = TRUE, silent = FALSE)
meshname <- gsub (".ply", "", basename(x))

#check for existence and validity of verities, faces and vertex normal
meshintegrity(mesh, facecheck = TRUE, normcheck = TRUE)
#compute surface area of mesh
vcgArea(mesh, perface = FALSE)
#identify resolution of mesh for use as voxelSize in remesh
mres<-vcgMeshres(mesh)
#uniform remesh - use mesh resolution as voxelSize
remesh<-vcgUniformRemesh(mesh, voxelSize = mres$res)

#export as OFF to data3d folder
vcgOffWrite(mesh, filename = paste0("data3d/", x))
#export as ascii PLY to ply folder
vcgPlyWrite(remesh, filename = "newply/", x , ascii = TRUE)
}

#batch loop assuming all ply files are stored in a folder called ply
rePLYs <- list.files ("ply", pattern = ".ply", full.names = TRUE)
runall <- lapply (rePLYs, processmesh)

#decimate mesh (not needed right now)
#decimated<-vcgQEdecim(remesh, percent = 0.5)
#number of vertices and triangular faces after remesh
#meshInfo(decimated)
#export as OFF to lowres file
#vcgOffWrite(decimated, filename = "data3d/lowres/p07lr")
#end of script

