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

#change the name of the file in each run as "x" and for the output names, program does not allow for looping
x <- "p01ft.off"

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
vcgOffWrite(remesh, filename = "data3d/p07lr")
#export as ascii PLY to ply folder
vcgPlyWrite(remesh, filename = "ply/p07lr", ascii = TRUE)

#decimate mesh
decimated<-vcgQEdecim(remesh, percent = 0.5)
#number of vertices and triangular faces after remesh
meshInfo(decimated)
#export as OFF to lowres file
vcgOffWrite(decimated, filename = "data3d/lowres/p07lr")
#end of script



#auto3dgm for Perdiz points from Toyah sites
library(Matrix)
library(clue)
library(linprog)
library(igraph)
library(MASS)

#rm(list=ls())
library(auto3dgm)
setwd(getwd())
Data_dir = "data3d"
Output_dir = "clean"

Levels=c(75,150)
Ids = c('p01ft', 'p02ft', 'p03ft', 'p04ft', 'p05ft', 'p07ft', 'p08ft', 'p01lr', 'p02lr', 
        'p03lr', 'p04lr', 'p05lr', 'p06lr', 'p07lr')  
Names = c('p01ft', 'p02ft', 'p03ft', 'p04ft', 'p05ft', 'p07ft', 'p08ft', 'p01lr', 'p02lr', 
          'p03lr', 'p04lr', 'p05lr', 'p06lr', 'p07lr')


#vcgPlyRead to import ascii PLY Files
#newmesh = Rvcg::vcgPlyRead("", updateNormals = TRUE, clean = TRUE)

#vcguniformremesh to resample a mesh uniformly
#resample <- Rvcg::vcgUniformRemesh(newmesh, voxelSize = NULL, offset = 0, discretize = FALSE, multiSample = FALSE, mergeClost = FALSE, silent = FALSE)


#create loop
 x <- c ('p01ft', 'p02ft', 'p03ft', 'p04ft', 'p05ft', 'p07ft', 'p08ft', 'p01lr', 'p02lr', 
        'p03lr', 'p04lr', 'p05lr', 'p06lr', 'p07lr')

 #c <- ("ply/p01ft.ply","ply/p02ft.ply", "ply/p03ft.ply", "ply/p04ft.ply", "ply/p05ft.ply", "ply/p07ft.ply", "ply/p08ft.ply",
#    "ply/p01lr.ply","ply/p02lr.ply", "ply/p03lr.ply", "ply/p04lr.ply", "ply/p05lr.ply", "ply/p06lr.ply", "ply/p07lr.ply")
for (val in x) {
  # importname = paste("ply/",val,".ply",sep="")
  mesh <- vcgPlyRead( x , updateNormals = TRUE, clean = TRUE)
  resample <- vcgUniformRemesh(mesh, voxelSize = NULL, offset = 0, discretize = FALSE, multiSample = FALSE, mergeClost = FALSE, silent = FALSE)
  offloadname = paste("clean/",val,sep="")
  require(rgl)
  shade3d(resample, col=1)
  Rvcg::vcgOffWrite (resample, filename = offloadname)
 # Rvcg::decimated <-vcgQEdecim (remesh, percent = 0.5)
 # Rvcg:: meshInfo(decimated)
 # Rvcg:: vcgOffWrite(decimated, filename = val, sep="")
}


Clean_dir = "clean"

#FULL is a list of 3 returned elements.  User gets to specify what is returned.
FULL = align_shapes(Clean_dir, Output_dir, Levels, Ids, Names)


ds = FULL[[1]]  #the whole shape dataset.
ga_full=FULL[[2]]  #the global alignment 
pa=FULL[[3]] #the pairwise alignments.  

#Each of these three returned items is useful in identifying and fixing 
#misaligned shapes. 
