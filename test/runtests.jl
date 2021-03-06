## Copyright (c) 2013 Miguel Bazdresch
##
## This file is distributed under the 2-clause BSD License.

# Gaston test framework
#
# There are two kinds of tests:
#   - Tests that should error -- things that Gaston should not allow, such as
#     building a figure with an invalid plotstyle.
#   - Tests that should succeed -- things that should work without producing
#     an error.

using Gaston, Test

@testset "Figure and set commands" begin
    closeall()
    set(reset=true)
    set(mode="null")
    # figures
    @test figure() == 1
    @test figure() == 2
    @test figure(4) == 4
    @test closefigure(4) == 2
    @test closefigure() == 1
    @test closeall() == 1
    @test begin
        closeall()
        figure()
        figure()
        figure(4);
        closefigure(1,2)
    end == 4
    @test begin
        closeall()
        figure()
        figure()
        figure(4);
        closefigure(4)
    end == 2
    @test begin
        closeall()
        figure()
        figure()
        figure(4);
        closefigure(1,2,3,4,5)
    end== nothing
    @test begin
        closeall()
        figure(3)
        figure(3)
    end== 3
    @test set(plotstyle="linespoints") == nothing
    @test set(linecolor="red") == nothing
    @test set(pointtype="ecircle") == nothing
    @test set(linewidth="3") == nothing
    @test set(pointsize="3") == nothing
    @test set(palette="gray") == nothing
    @test set(fillstyle="solid") == nothing
    @test set(grid="on") == nothing
    if !Sys.iswindows()
        @test set(terminal="x11") == nothing # This test does not pass in Windows
    end
    @test set(terminal="x11") == nothing
    @test set(termopts="noenhanced") == nothing
    @test set(output="A") == nothing
    @test set(print_font="A") == nothing
    @test set(print_linewidth="3") == nothing
    @test set(print_size="10,10") == nothing
    @test set(debug=true) == nothing
    @test set(debug=false) == nothing
end

@testset "2-D plots" begin
    closeall()
    set(reset=true)
    set(mode="null")
    @test closeall() == 0
    @test begin
        plot(1:10)
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        plot(1:10,handle=2)
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        plot(1:10,handle=4) == 4
        Gaston.gnuplot_state.gp_error
    end == false
    @test closeall() == 3
    @test begin
        plot(1:10,cos)
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        plot!(1:10,cos)
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        stem(1:10,cos)
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        set(termopts="feed noenhanced ansi")
        plot(sin.(-3:0.01:3),
             legend = "sine",
             title = "test plot 1",
             xlabel = "x",
             ylabel = "y",
             plotstyle = "lines",
             linecolor = "blue",
             linewidth = "2",
             linestyle = "-.-",
             pointtype = "ecircle",
             pointsize = "1.1",
             fillstyle = "",
             keyoptions = "inside horizontal left top",
             axis ="loglog",
             xrange = "[2:3]",
             yrange = "[2:3]",
             xzeroaxis = "",
             yzeroaxis = "",
             font = "Arial, 12",
             size = "79,24",
             background = "",
             gpcom = ""
            )
        Gaston.gnuplot_state.gp_error
    end == false
    set(termopts="")
    @test begin
        plot!(cos.(-3:0.01:3),
              legend = "cos",
              plotstyle = "linespoints",
              linecolor = "red",
              linewidth = "2",
              linestyle = ".",
              pointtype = "fcircle",
              pointsize = "1"
             )
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        plot!(cos.(-3:0.01:3),
              legend = "cos",
              ps = :linespoints,
              lc = :red,
              lw = 2,
              ls = :.,
              pt = :fcircle,
              pz = :1
             )
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        plot(1:10,xrange = "[:3.4]")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        plot(1:10,xrange = "[3.4:]")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        plot(1:10,xrange = "[3.4:*]")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        plot(1:10,xrange = "[*:3.4]")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        plot(3,4,plotstyle="points",pointsize="3",xrange="[2.95:3.05]",
             yrange="[3.95:4.045]")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        plot(rand(10).+im.*rand(10))
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        plot(3+4im,plotstyle="points",pointsize="3",xrange="[2.95:3.05]",
             yrange="[3.95:4.045]")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        err = Gaston.ErrorCoords(rand(40))
        plot(1:40,err=err,plotstyle="errorbars")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        err = Gaston.ErrorCoords(rand(40))
        plot!(1:40,err=err,plotstyle="errorbars")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        err = Gaston.ErrorCoords(rand(40))
        plot(1:40,err=err,plotstyle="errorlines")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        err = Gaston.ErrorCoords(rand(40))
        plot!(1:40,err=err,plotstyle="errorlines")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        err = Gaston.ErrorCoords(rand(40),rand(40))
        plot(1:40,err=err,plotstyle="errorbars")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        err = Gaston.ErrorCoords(rand(40),rand(40))
        plot!(1:40,err=err,plotstyle="errorbars")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        err = Gaston.ErrorCoords(rand(40),rand(40))
        plot(1:40,err=err,plotstyle="errorlines")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        err = Gaston.ErrorCoords(rand(40),rand(40))
        plot!(1:40,err=err,plotstyle="errorlines")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        fin = Gaston.FinancialCoords(0.1*rand(10),0.1*rand(10),
                                     0.1*rand(10),0.1*rand(10))
        plot(1:10,financial=fin,plotstyle="financebars")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        fin = Gaston.FinancialCoords(0.1*rand(10),0.1*rand(10),
                                     0.1*rand(10),0.1*rand(10))
        plot!(1:10,financial=fin,plotstyle="financebars")
        Gaston.gnuplot_state.gp_error
    end == false
    # This test is cool, but it fails way too often due to slight
    # OS, configuration, and gnuplot version differences. Disabled for now.
    if false
    #if occursin("5.2",read(`gnuplot --version`, String))
        @test begin
            set(reset=true)
            set(terminal="dumb", size="27,13")
            x="\f                           \n  11 +-----------------+   \n  10 |-+ + + + + + + +*|   \n   9 |-+          ****-|   \n   7 |-+        **   +-|   \n   6 |-+      **     +-|   \n   5 |-+    **       +-|   \n   4 |-+  **         +-|   \n   3 |****           +-|   \n   1 |-+ + + + + + + +-|   \n   0 +-----------------+   \n     1 2 3 4 5 6 7 8 9 10  \n                           \n"
            a=repr("text/plain", plot(1:10))
            a == x
        end == true
    end
    @test begin
        set(reset=true)
        stem(rand(10))
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        stem(rand(10),onlyimpulses=true)
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        scatter(rand(10),rand(10))
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        scatter(randn(10), randn(10), pointtype="λ")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        scatter(complex.(rand(10), rand(10)))
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        scatter(complex.(rand(10), rand(10)),linecolor="green")
        scatter!(complex.(rand(10), rand(10)),linecolor="blue")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        scatter(rand(10), rand(10),pointtype="ecircle")
        scatter!(rand(10), rand(10),pointtype="fcircle")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        t = -2:0.06:2
        plot(t, sin.(2π*t), plotstyle="fillsteps", fillstyle="solid 0.5", title="Fillsteps plot")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        set(reset=true)
        set(mode="ijulia")
        a = repr("text/plain", plot(1:10))
        a[1:29] == "<?xml version=\"1.0\" encoding="
    end == true
    @test begin
        set(reset=true)
        set(mode="ijulia")
        a = repr("text/plain", plot(1:10))
        findlast("</svg>",a)
    end != nothing
    # matrix plotting
    @test begin
        ps=["points","linespoints"];lc=["blue","red","green"]
        pt=["ecircle","fcircle"];l=["1","2","3","4"]
        M = rand(10,5)
        plot(M,plotstyle=ps,linecolor=lc,pointtype=pt,legend=l)
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        ps=["points","linespoints"];lc=["blue","red","green"]
        pt=["ecircle","fcircle"];l=["1","2","3","4"]
        M = rand(10,5)
        plot(22:31,M,plotstyle=ps,linecolor=lc,pointtype=pt,legend=l)
        Gaston.gnuplot_state.gp_error
    end == false
    # build a multiple-plot figure manually
    closeall()
    set(mode="null")
    @test begin
        ac = Gaston.AxesConf(title="T")
        x1, exp_pdf = Gaston.hist(randn(10000),25)
        exp_pdf .= exp_pdf./(step(x1)*sum(exp_pdf))
        exp_cconf = Gaston.CurveConf(plotstyle="boxes",
                                     linecolor="blue",
                                     legend="E")
        exp_curve = Gaston.Curve(x=x1,y=exp_pdf,conf=exp_cconf)
        x2 = -5:0.05:5
        theo_pdf = @. 1/sqrt(2π)*exp((-x2^2)/2)
        theo_cconf = Gaston.CurveConf(linecolor="black",legend="T")
        theo_curve = Gaston.Curve(x=x2,y=theo_pdf,conf=theo_cconf)
        figure(1)
        Gaston.push_figure!(1,ac,exp_curve,theo_curve)
        figure(1,redraw=false)
    end == 1
end

@testset "Histograms" begin
    closeall()
    set(reset=true)
    set(mode="null")
    @test begin
        histogram(rand(1000))
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        histogram(randn(1000),
                  bins = 100,
                  norm = 1,
                  title = "test histogram",
                  xlabel = "x",
                  ylabel = "y",
                  linecolor = "blue",
                  linewidth = "2",
                  fillstyle = "solid",
                  keyoptions = "inside horizontal left top",
                  xrange = "[*:*]",
                  yrange = "[*:*]",
                  font = "Arial, 12",
                  size = "79,24",
                  background = "red"
                 )
        Gaston.gnuplot_state.gp_error
    end == false
end

@testset "Images" begin
    closeall()
    set(reset=true)
    set(mode="null")
    z = rand(5,6)
    @test begin
        imagesc(z,
                title = "test imagesc 1",
                xlabel = "xx",
                ylabel = "yy",
                font = "Arial, 12",
                size = "79,24"
               )
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        imagesc(1:6,1:5,z,title="test imagesc 3",xlabel="xx",ylabel="yy")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        R = [x+y for x=0:5:120, y=0:5:120]
        G = [x+y for x=0:5:120, y=120:-5:0]
        B = [x+y for x=120:-5:0, y=0:5:120]
        Z = zeros(25,25,3)
        Z[:,:,1] = R
        Z[:,:,2] = G
        Z[:,:,3] = B
        imagesc(Z,title="RGB Image",clim=[10,200])
        Gaston.gnuplot_state.gp_error
    end == false
end

@testset "3-D plots" begin
    closeall()
    set(reset=true)
    set(mode="null")
    @test begin
        surf(rand(10,10))
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        x=[0,1,2,3]; y=[0,1,2]; Z=[10 10 10; 10 5 10;10 1 10; 10 0 10]
        surf(x, y, Z,
             legend = :test,
             ps = :lines,
             lc = :black,
             pt = :ecircle,
             title = :test,
             xlabel = :x,
             ylabel = :y,
             zlabel = :z,
             ko = "inside horizontal left top",
             xrange = "",
             yrange = "",
             zrange = "",
             xzeroaxis = :on,
             yzeroaxis = :on,
             zzeroaxis = :on,
             font = "Arial, 12",
             size = "79,24",
             gpcom = "set view 90,60"
            )
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        x=[0,1,2,3]; y=[0,1,2]; Z=[10 10 10; 10 5 10;10 1 10; 10 0 10]
        surf(x, y, Z,
             legend = "test",
             plotstyle = "lines",
             linecolor = "black",
             pointtype = "ecircle",
             title = "test",
             xlabel = "x",
             ylabel = "y",
             zlabel = "z",
             keyoptions = "inside horizontal left top",
             xrange = "",
             yrange = "",
             zrange = "",
             xzeroaxis = "on",
             yzeroaxis = "on",
             zzeroaxis = "on",
             font = "Arial, 12",
             size = "79,24",
             gpcom = "set view 90,60"
            )
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        surf(0:9,2:11,(x,y)->x*y)
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        surf(0:9,2:11,(x,y)->x*y,
             legend = "test",
             plotstyle="pm3d",
             title="test",
            )
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        surf(0:9,2:11,(x,y)->x*y)
        surf!(0:9,2:11,(x,y)->x/y)
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        scatter3(rand(10),rand(10),rand(10),pointtype="fcircle",linecolor="red")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        scatter3(rand(10),rand(10),rand(10))
        scatter3(rand(8),rand(8),rand(8),lc=:black)
        Gaston.gnuplot_state.gp_error
    end == false
end

@testset "Saving plots" begin
    closeall()
    set(reset=true)
    set(mode="null")
    set(output=tempname())
    plot(1:10)
    @test begin
        printfigure()
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        printfigure(handle=1,term="png")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        printfigure(term="eps")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        printfigure(term="pdf",
                    font = "Arial, 12",
                    size = "5,3",
                    linewidth = "3"
                   )
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        set(print_size="640,480")
        printfigure(term="svg")
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        set(print_size="640,480")
        printfigure(term="gif")
        Gaston.gnuplot_state.gp_error
    end == false
end

@testset "Linestyle tests" begin
    closeall()
    set(reset=true)
    set(mode="null")
    @test begin
        plot(1:10) # solid
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        plot(1:10, linestyle="") # solid
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        plot(1:10, linestyle="-") # dashed
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        plot(1:10, linestyle=".") # dotted
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        plot(1:10, linestyle="_") # em-dashed
        Gaston.gnuplot_state.gp_error
    end == false
    @test begin
        plot(1:10, linestyle="- ._. ") # complex pattern
        Gaston.gnuplot_state.gp_error
    end == false
    @test_throws DomainError plot(1:10, linestyle=" ") # only spaces not allowed
    @test_throws DomainError plot(1:10, linestyle="-=") # = is not allowed in pattern
    closeall()
end

@testset "async_reader" begin
    # Simplest way to test async_reader would be to use plain pipes,
    # but there seems to be no way to create them in Julia, so we pipe
    # data through an external process. The advantage of this approach
    # is that it corresponds to how Gaston communicates with gnuplot.
    # This testset is only enabled on Unix-like systems.
    if Sys.isunix()
        pin = Pipe()
        pout = Pipe()
        proc = try
            run(pipeline(`cat`, stdin = pin, stdout = pout),
                wait = false)
        catch err
            @warn "Skipping async_reader tests"
            return
        end
        close(pout.in)
        close(pin.out)

        @test begin
            ch = Gaston.async_reader(pout, 1)
            write(pin, "GastonBegin\ncontent\nGastonDone\n")
            take!(ch)
        end == "content\n"

        @test begin
            ch = Gaston.async_reader(pout, 0.001)
            write(pin, "GastonBegin\nmissing end pointtype\n")
            take!(ch)
        end === :timeout

        @test begin
            ch = Gaston.async_reader(pout, 1)
            write(pin, "no begin pointtype\nGastonDone\n")
            take!(ch)
        end == "no begin pointtype\n"

        @test begin
            ch = Gaston.async_reader(pout, 1)
            kill(proc)
            take!(ch)
        end === :eof
    end
end

@testset "Tests that should fail" begin
    closeall()
    set(reset=true)
    set(mode="null")
    # figure-related
    @test_throws MethodError figure("invalid")
    @test_throws MethodError figure(1.0)
    @test_throws MethodError figure(1:2)
    @test_throws DomainError closefigure(-1)
    @test_throws MethodError closefigure("invalid")
    @test_throws MethodError closefigure(1.0)
    @test_throws MethodError closefigure(1:2)
    # plot
    @test_throws DimensionMismatch plot(0:10,0:11)
    @test_throws DimensionMismatch surf([1,2],[3,4],[5,6,7])
    @test_throws DimensionMismatch surf([1,2,3],[3,4],[5,6,7])
    @test_throws DomainError plot(0:10,plotstyle="invalid")
    @test_throws DomainError plot(0:10,pointtype="invalid")
    @test_throws DomainError plot(0:10,pointtype="ab")
    @test_throws DomainError plot(0:10,linewidth=im)
    @test_throws DomainError plot(0:10,linewidth=-3)
    @test_throws DomainError plot(0:10,pointsize=im)
    @test_throws DomainError plot(0:10,pointsize=-3)
    @test_throws DomainError plot(0:10,axis="invalid")
    @test_throws DomainError plot(1:10,xrange = "2:3")
    @test_throws DomainError plot(1:10,yrange = "ab")
    @test_throws MethodError surf([1,2,3],[3,4],"a")
    @test_throws DomainError surf(0:10,0:10,0:10,plotstyle="invalid")
    @test_throws DomainError surf(0:10,0:10,0:10,pointtype="invalid")
    @test_throws DomainError surf(0:10,0:10,0:10,pointtype="ab")
    @test_throws DomainError surf(0:10,0:10,0:10,linewidth=im)
    @test_throws DomainError surf(0:10,0:10,0:10,linewidth=-3)
    @test_throws DomainError surf(0:10,0:10,0:10,pointsize=im)
    @test_throws DomainError surf(0:10,0:10,0:10,pointsize=-3)
    @test_throws DomainError surf(0:10,0:10,0:10,axis="invalid")
    @test_throws DomainError surf(1:10,0:10,0:10,xrange = "2:3")
    @test_throws DomainError surf(1:10,0:10,0:10,yrange = "ab")
    @test_throws DomainError surf(1:10,0:10,0:10,zrange = "ab")
    f = Gaston.FinancialCoords([1,2],[1,2],[1,2],[1,2])
    @test_throws DimensionMismatch plot(1:10,financial=f)
    er = Gaston.ErrorCoords([0.1,0.1])
    @test_throws DimensionMismatch plot(1:10,err=er)
    # plot!
    closeall()
    @test_throws ErrorException plot!(0:10)
    # imagesc
    z = rand(5,6)
    @test_throws DimensionMismatch imagesc(1:5,1:7,z)
    # histogram
    @test_throws MethodError histogram(0:10+im*0:10)
    # printfigure
    @test_throws DomainError begin
        printfigure(handle=2,term="png")
        Gaston.gnuplot_state.gp_error
    end
    @test_throws DomainError begin
        printfigure(term="xyz")
        Gaston.gnuplot_state.gp_error
    end
    @test_throws ErrorException plot!(rand(10),handle=10)
    # set
    set(mode="normal")
    @test_throws DomainError set(plotstyle="A")
    @test_throws DomainError set(pointtype="xyz")
    @test_throws DomainError set(terminal="x12")
    @test_throws ArgumentError set(color=3)
    @test_throws ArgumentError set(title=3)
    @test_throws ArgumentError set(xlabel=3)
    @test_throws ArgumentError set(ylabel=3)
    @test_throws ArgumentError set(zlabel=3)
    @test_throws ArgumentError set(print_color=3)
    @test_throws DomainError set(debug="oo")
    closeall()
end
