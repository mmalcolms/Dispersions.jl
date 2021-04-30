using Base.Iterators

# ---------------------------- Auxilliary Functions -------------------------------
# TODO: avoid reshape
cut_mirror(arr::Base.Iterators.ProductIterator) = cut_mirror(collect(arr))
cut_mirror(arr::Array{T, 2}) where T = arr[ceil(Int,size(arr,1)/2):end, ceil(Int,size(arr,2)/2):end]
cut_mirror(arr::Array{T, 3}) where T = arr[ceil(Int,size(arr,1)/2):end, ceil(Int,size(arr,2)/2):end, ceil(Int,size(arr,3)/2):end]
#reverse cut. This is a helper function to avoid reversing the array after fft-convolution trick. assumes reserved input and returns correct array including cut
ifft_cut_mirror(arr::Base.Iterators.ProductIterator) = ifft_cut_mirror(collect(arr))
ifft_cut_mirror(arr::Array{T, 2}) where T = arr[end-1:-1:Int64(size(arr,1)/2-1), 
                                                          end-1:-1:Int64(size(arr,2)/2-1)]
ifft_cut_mirror(arr::Array{T, 3}) where T = arr[end-1:-1:Int64(size(arr,1)/2-1), 
                                                          end-1:-1:Int64(size(arr,2)/2-1), 
                                                          end-1:-1:Int64(size(arr,3)/2-1)]


function test_cut(arr)
    arr2 = copy(arr)
    arr3 = ifft_cut_mirror(arr2)
    ll = floor(Int,size(arr,1)/2 + 1)
    index = (ndims(arr)) == 2 ? [[x,y] for x=1:ll for y=1:x] : [[x,y,z] for x=1:ll for y=1:x for z = 1:y]
    arr4 = Array{eltype(arr)}(undef, length(index))
    for (i,ti) in enumerate(index)
        arr4[i] = arr3[ti...]
    end
    return arr4
end



@testset "2D" begin
    sc_2d_2 = gen_cP_kGrid(2,2,1.3)
    sc_2d_3 = gen_cP_kGrid(4,2,1.3)
    sc_2d_16 = gen_cP_kGrid(16,2,1.4)
    r2 = reduceKGrid(sc_2d_2)
    r3 = reduceKGrid(sc_2d_2)
    r16 = reduceKGrid(sc_2d_16)
    @test Nk(sc_2d_2) == 2^2
    @test all(isapprox.(flatten(collect(gridPoints(sc_2d_2))), flatten([(0,0) (0,π); (π,0) (π,π)])))
    @test_throws ArgumentError expandKArr(r16, [1,2,3,4])
    #@test all(expandKGrid(r2, r2.ϵkGrid)[:] .≈ sc_2d_2.ϵkGrid)
    #@test all(expandKGrid(r3, r3.ϵkGrid)[:] .≈ sc_2d_3.ϵkGrid)
    #@test maximum(abs.(expandKGrid(r16, r16.ϵkGrid)[:] .- sc_2d_16.ϵkGrid)) < 1/10^12
end


@testset "3D" begin
    sc_3d_2 = gen_cP_kGrid(2, 3, 1.2)
    sc_3d_16 = gen_cP_kGrid(4, 3, 1.1)
    r2 = reduceKGrid(sc_3d_2)
    r16 = reduceKGrid(sc_3d_16)
    indTest = reshape([(1, 1, 1) (2, 1, 1) (1, 2, 1) (2, 2, 1) (1, 1, 2) (2, 1, 2) (1, 2, 2) (2, 2, 2)], (2,2,2))
    gridTest = reshape([(0, 0, 0) (π, 0, 0) (0, π, 0) (π, π, 0) (0, 0, π) (π, 0, π) (0, π, π) (π, π, π)], (2,2,2))
    @test Nk(sc_3d_2) == 2^3
    @test all(isapprox.(flatten(collect(gridPoints(sc_3d_2))), flatten(gridTest)))
    @test_throws ArgumentError expandKArr(r16, [1,2,3,4])
end

@testset "reduce_expand" begin
    for NN in 2:16
        gr2 = gen_cP_kGrid(NN,2,1.3)
        gr3 = gen_cP_kGrid(NN,3,1.3)
        gr2_r = reduceKGrid(gr2)
        gr3_r = reduceKGrid(gr3)
        ek2 = reshape(gr2.ϵkGrid, (NN,NN))
        ek3 = reshape(gr3.ϵkGrid, (NN,NN,NN))
        @test all(reduceKArr(gr2_r, ek2) .≈ gr2_r.ϵkGrid)
        @test all(reduceKArr(gr3_r, ek3) .≈ gr3_r.ϵkGrid)
        gr2_cut = cut_mirror(ek2)
        gr3_cut = cut_mirror(ek3)
        @test all(map(x-> x in gr2.ϵkGrid, gr2_cut)) # No data lost
        @test all(map(x-> x in gr3.ϵkGrid, gr3_cut))
        al = ceil(Int,NN/2)
        gr2_pre_exp = zeros(size(ek2))
        gr2_pre_exp[al:end,al:end] = gr2_cut
        gr3_pre_exp = zeros(size(ek3))
        gr3_pre_exp[al:end,al:end,al:end] = gr3_cut
        @test all(abs.(Dispersions.expand_mirror!(gr2_pre_exp) .- ek2) .< 1.0/10^10)
        @test all(abs.(Dispersions.expand_mirror!(gr3_pre_exp) .- ek3) .< 1.0/10^10)
        @test all(abs.(expandKArr(gr2_r, gr2_r.ϵkGrid) .- ek2) .< 1.0/10^10)
        @test all(abs.(expandKArr(gr3_r, gr3_r.ϵkGrid) .- ek3) .< 1.0/10^10)
    end
end


#TODO: this is a placeholder until convolution is ported from lDGA code
@testset "ifft" begin
    for NN in 4:2:6
        gr2 = gen_cP_kGrid(NN,2,1.3)
        gr3 = gen_cP_kGrid(NN,3,1.3)
        arr2 = randn(NN,NN)
        arr3 = randn(NN,NN,NN)
        gr3_r = reduceKGrid(gr3)
        gr2_r = reduceKGrid(gr2)
        r1 = test_cut(arr2)
        r2 = test_cut(arr3)
        r3 = reduceKArr_reverse(gr2_r, arr2)
        r4 = reduceKArr_reverse(gr3_r, arr3)
        @test all(r1 .≈ r3)
        @test all(r2 .≈ r4)
    end
end
