var documenterSearchIndex = {"docs":
[{"location":"interface/#Interface","page":"Interface","title":"Interface","text":"","category":"section"},{"location":"interface/","page":"Interface","title":"Interface","text":"All grid types need to have a certain structure and implement a set of functions which will be discussed here.","category":"page"},{"location":"interface/#Overview","page":"Interface","title":"Overview","text":"","category":"section"},{"location":"interface/","page":"Interface","title":"Interface","text":"The interface is divided into common functions which do not need to be implemented for subtypes, since they rely on struct fields all subtypes need to have, and functions which need to be overloaded.","category":"page"},{"location":"interface/#Common-Types","page":"Interface","title":"Common Types","text":"","category":"section"},{"location":"interface/","page":"Interface","title":"Interface","text":"All actual k-grids are supposed to by abstract subtypes of GridType.  For example abstract type cP_2D <: GridType end (TODO: ref SC doc).  Each k-grid of type T <: GridType should than implement a NewKGrid <: FullKGrid{T} and NewReducedKGrid <: ReducedKGrid{T} <: structs. Both full and reduced k-grid types are subtypes of KGrid{T}. This hierarchy ensures a set of comon functionalities, that external modules can rely on. ","category":"page"},{"location":"interface/#Required-Fieds","page":"Interface","title":"Required Fieds","text":"","category":"section"},{"location":"interface/","page":"Interface","title":"Interface","text":"Internally, the structs also need to have at least the following fields:","category":"page"},{"location":"interface/","page":"Interface","title":"Interface","text":"** Full K-Grid   : **     - Nk::Int that sepcifies the number of k-points, which will be accessed by [gridPoints(@ref)     - kGrid::T where isGridPoints(kG::T) = IsGridPoints{T} needs to be defined for trait based dispatch to work properly. Generally it should be sufficient to use the predefined const GridPoints2D = Array{Tuple{Float64,Float64}} and respective 3D version.     - ϵkGrid::Array{Float64, 1} Array of dispersion relation epsilon_k.","category":"page"},{"location":"interface/","page":"Interface","title":"Interface","text":"** Reduced K-Grid: **      - Both fields from the full k-grid need to be present.     - kMult::Array{Float64} specifying the weight of each k point in th reduced grid     - kInd::T  where isGridInd(kG::T) = IsGridInd{T} needs to be defined for trait based dispatch to work properly. Generally it should be sufficient to use the predefined const GridInd2D = Array{Tuple{Int,Int}} and respective 3D version.","category":"page"},{"location":"interface/#Common-Functions","page":"Interface","title":"Common Functions","text":"","category":"section"},{"location":"interface/","page":"Interface","title":"Interface","text":"The following functions are available for all grids, due to the common struct fields defined above.","category":"page"},{"location":"interface/","page":"Interface","title":"Interface","text":"Nk(kG::T) where T <: KGrid\ngridPoints(kG::T) where T <: KGrid","category":"page"},{"location":"interface/#Interface-Functions","page":"Interface","title":"Interface Functions","text":"","category":"section"},{"location":"#Dispersions.jl","page":"Home","title":"Dispersions.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This project contains ","category":"page"},{"location":"#Description","page":"Home","title":"Description","text":"","category":"section"},{"location":"#Common-Functions","page":"Home","title":"Common Functions","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The following functions are available for all grids.","category":"page"},{"location":"#Basic-access-functions","page":"Home","title":"Basic access functions","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Convenience functions to access fields of k grid structs.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Nk(kG::T) where T <: KGrid\n\ngridPoints(kG::T) where T <: KGrid","category":"page"},{"location":"#Dispersions.Nk-Tuple{T} where T<:KGrid","page":"Home","title":"Dispersions.Nk","text":"Nk(kG::T) where T <: KGrid\n\nTotal number of k points (length of kGrid.kGrid for full grids). \n\n\n\n\n\n","category":"method"},{"location":"#Dispersions.gridPoints-Tuple{T} where T<:KGrid","page":"Home","title":"Dispersions.gridPoints","text":"gridPoints(kG::T)::Int where T <: KGrid\n\nNumber of grid points as integer value. Nk needs to be accessible for all implemented  full and reduced k grids.\n\n\n\n\n\n","category":"method"}]
}
